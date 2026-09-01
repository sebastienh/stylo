//
//  StylableReducerType+Attributes.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-06.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Igloo
import os
import Markdown

extension StylableReducerType {
    
    @discardableResult
    func computeInitialAttributes<S: Store & StylableStoreType>(store: S, visibleTopElements: ContiguousArray<Element>?, document: Document, isFirstResponder: Bool, selectedRange: NSRange?) -> [RenderingProcessingResult] {
        
        var result: [RenderingProcessingResult] = []
        
        let filterContext: FilterContext = {
            
            guard let htmlDocument = document as? HtmlDocument else {
                return FilterContext()
            }
            
            guard let highlightSelectors = store.highlightSelectors else {
                return FilterContext()
            }
                
            let context = FilterContext(highlightSelectors: highlightSelectors, defaultPseudoClassesOptions: .fade, focusMode: store.focusMode.value)
            
            // this is for highlight mode
            context.updatePseudoClassesOptions(forElement: htmlDocument.documentElement, with: [])
            context.updatePseudoClassesOptions(forElement: htmlDocument.body, with: .highlight)
            return context
        }()
        
        self.evaluateStyle(store: store, document: document, filterContext: filterContext)
        let renderingProcessingResult = self.renderSource(store: store, elements: document.styleRoots, deletedNodes: nil, document: document, renderingType: .complete, filterContext: filterContext)
            
        if let renderingProcessingResult = renderingProcessingResult {
            result.append(renderingProcessingResult)
        }
        
        guard store.focusAttributesString != nil else {
            return result
        }
        
        guard let visibleTopElements = visibleTopElements else {
            // at initialisation time visibleTopElements can be nil
            return result
        }
        
        guard let renderingProcessingResults = self.renderFocus(store: store, elements: visibleTopElements, deletedNodes: nil, document: document, renderingType: .selection, isFirstResponder: isFirstResponder, selectedRange: selectedRange) else {
            assertionFailure("Error: renderingProcessingResults is nil")
            return result
        }
        
        result.append(renderingProcessingResults)
        return result
    }
    
    private func increaseRootsElementsUntilEnd(from elements: ContiguousArray<Element>) -> ContiguousArray<Element> {
        
        var increasedList = elements
        
        if let last: Node = elements.last {
            
            #if DEBUG
            assert(last.parentElement!.localName == "body")
            #endif
            var current: Node? = last.nextSibling
            
            while let _current = current {
                
                if let element = _current as? Element {
                    
                    assert(element.parentElement!.localName == "body")
                    increasedList.append(element)
                }
                current = _current.nextSibling
            }
        }
        return increasedList
    }
    
    private func increaseRootsElementsUntilNext(from elements: ContiguousArray<Element>) -> ContiguousArray<Element> {
        
        var increasedList = elements
        var addedElement = false
        
        if let last: Node = elements.last {
            
            var current: Node? = last.nextSibling
            
            while let _current = current, !addedElement {
                
                if let element = _current as? Element {
                    
                    assert(element.parentElement!.localName == "body")
                    increasedList.append(element)
                    addedElement = true
                }
                current = _current.nextSibling
            }
        }
        return increasedList
    }
    
    /// increase the root elements for which to compute style
    /// when there has been a change in the attributes blocs inside
    /// the document.
    private func handleAttributesBlocs<S: StylableStoreType>(store: S, forRootElements elements: ContiguousArray<Element>, attributesBlocsChange: AttributesBlocsChange?) -> ContiguousArray<Element> {
        
        var elements = elements
        
        if let attributesBlocsChange = attributesBlocsChange {
           
            switch attributesBlocsChange {
            case .all:
                elements = increaseRootsElementsUntilEnd(from: elements)
            case .modified(let attributes):
                
                // if the style contains a following sibling selector with
                // the modified attributes then we need to increase the roots elements
                // until the end
                let resourceComputedStyle = store.resourceComputedStyle
                
                if resourceComputedStyle.containSiblingSelectors {
                    
                    let style = resourceComputedStyle.styleDefinition
                    
                    let attributesMap: [String: Set<String>] = attributes.convertToAttributesMap()
                    let containsSiblingSelectorResult = style.areAttributesImpliedInSiblingSelector(attributesMap: attributesMap)
                        
                    switch containsSiblingSelectorResult {
                    case .none:
                        break
                    case .next:
                        elements = increaseRootsElementsUntilNext(from: elements)
                    case .both: fallthrough
                    case .following:
                        elements = increaseRootsElementsUntilEnd(from: elements)
                    }
                }
                
            case .none:
                break
            }
        }
        return elements
    }
    
    func computeAndRenderAttributes<S: StylableStoreType>(store: S, forRootElements elements: ContiguousArray<Element>, deletedNodes: ContiguousArray<Node>?, document: Document, stringChange: SourceStringChangeDescription, attributesBlocsChange: AttributesBlocsChange? = nil) -> RenderingProcessingResult? {
        
        /// increase the root elements for which to compute style
        /// when there has been a change in the attributes blocs inside
        /// the document.
        let increasedElements = handleAttributesBlocs(store: store, forRootElements: elements, attributesBlocsChange: attributesBlocsChange)
        
        let increased = increasedElements.count > elements.count
        
        let filterContext = FilterContext(highlightSelectors: store.highlightSelectors, focusMode: store.focusMode.value)
        
        /// Compute the style for the elements and making sure that the style
        /// cache is erased for the elements for  which we want to recompute the style.
        self.evaluateStyle(store: store, forRootElements: increasedElements, document: document, forceStyleComputation: increased, filterContext: filterContext)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("attributed string before: %@", log: Log.WriterCommon.all, type: .info, %%store.attributesStore.permanentAttributesString)
        #endif
        
        if let attributes = self.renderSource(store: store, elements: increasedElements, deletedNodes: deletedNodes, document: document, renderingType: .edit, stringChange: stringChange, filterContext: filterContext) {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            let compiledAttributes = store.attributesStore.permanentAttributesString
            compiledAttributes.enumerateAttributes(in: NSMakeRange(0, compiledAttributes.length), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (attributes, range, stop) in
                
                os_log("attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .info, %%attributes, %%range)
            }
            os_log("attributed string after: %@", log: Log.WriterCommon.all, type: .info, %%store.attributesStore.permanentAttributesString)
            #endif
            return attributes
        }
        return nil
    }
}

