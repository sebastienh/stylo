//
//  MarkdownStyleReducer+Focus.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-07-22.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import PromiseKit
import Common
import Web
import os

extension MarkdownStyleReducer {
    
    ///
    /// Method that apply the focus attributes when the selection change.
    /// @param selectionRange the cursor range. Can be nil if the editor is not edited
    ///
    @discardableResult
    func applySelectionChange(toTopElements topElements: ContiguousArray<Element>, document: Document, selectionRange: NSRange?, in store: MarkdownStyleStore) -> RenderingProcessingResult? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applySelectionChange(toTopElements: %@, selectionRange: %@, visibleRange: %@, store: %@)", log: Log.WriterCommon.all, type: .info, %%topElements, %%selectionRange, %%visibleRange, %%store)
        #endif
        
        guard let htmlDocument = document as? HtmlDocument else {
            assertionFailure("Error: ")
            return nil
        }
        
        guard let focusType = store.focusMode.value.focusType else {
            assertionFailure("Error: no focus type is defined in the style store")
            return nil
        }
        
        let filterContext = FilterContext(highlightSelectors: store.highlightSelectors, defaultPseudoClassesOptions: .fade, focusMode: store.focusMode.value)
        
        let resourceComputedStyle = store.resourceComputedStyle
        guard let focusAttributesString = store.focusAttributesString else {
            assertionFailure("Error: focusAttributesString is nil")
            return nil
        }
        
        let renderingContext = RenderingContext(contentString: focusAttributesString, focusType: focusType, renderingType: .selection, selectionRange: selectionRange, filterContext: filterContext, isFirstResponder: true)
        let renderer = getNewRenderer(resourceComputedStyle: resourceComputedStyle, renderingContext: renderingContext, document: htmlDocument)
        return renderer.process(elements: topElements, deletedNodes: nil)
    }
    
    func removeFlash(store: MarkdownStyleStore, topElements: ContiguousArray<Element>, htmlDocument: HtmlDocument) -> RenderingProcessingResult? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("removeFlash(store: %@)", log: Log.WriterCommon.all, type: .info, %%store.identifier)
        #endif
        
        var topElements = topElements

        topElements.insert(htmlDocument.styleRoot, at: 0)
        
        let resourceComputedStyle = store.resourceComputedStyle
        let stylableString = store.stylableString
        
        let filterContext = FilterContext(highlightSelectors: store.highlightSelectors, defaultPseudoClassesOptions: .fade, focusMode: store.focusMode.value)
        
        let renderingContext = RenderingContext(contentString: stylableString, focusType: nil, renderingType: .flash, filterContext: filterContext)
        let renderer = getNewRenderer(resourceComputedStyle: resourceComputedStyle, renderingContext: renderingContext, document: htmlDocument)
        return renderer.process(elements: topElements, deletedNodes: nil)
    }
    
    func applyFlash(store: MarkdownStyleStore, toTopElements topElements: ContiguousArray<Element>, htmlDocument: HtmlDocument, inRange range: NSRange) -> RenderingProcessingResult? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applyFocus(store: %@, toTopElements: %@, inRange: %@)", log: Log.WriterCommon.all, type: .info, %%store, %%topElements, %%range)
        #endif
        
        guard !topElements.isEmpty else {
            assertionFailure("Error: topElements is empty")
            return nil
        }
    
        let resourceComputedStyle = store.resourceComputedStyle
        let stylableString = store.stylableString
        
        let filterContext = FilterContext(highlightSelectors: store.highlightSelectors, defaultPseudoClassesOptions: .fade, focusMode: store.focusMode.value)
        
        #if CONCURENT_RENDERING
        let attributesRecorder = AttributedStringChangeRecorder(string: stylableString.string)
        #else
        let attributesRecorder = AttributedStringChangeRecorder(string: stylableString.string)
        #endif
        
        let focusType = FocusType.flash(flashedRange: range)
        let renderingContext = RenderingContext(contentString: attributesRecorder, focusType: focusType, renderingType: .flash, filterContext: filterContext)
//        let elements = populateElements(forRootElements: topElements, document: htmlDocument)
        let renderer = getNewRenderer(resourceComputedStyle: resourceComputedStyle, renderingContext: renderingContext, document: htmlDocument)
        return renderer.process(elements: topElements, deletedNodes: nil)
    }
    
    private func populateElements(forRootElements elements: ContiguousArray<Element>, document: HtmlDocument) -> ContiguousArray<Element> {
        
        var combinedElements = ContiguousArray<Element>(document.styleRoots)
        
        // add empty entries for added elements
        for element in elements {
            
            combinedElements.append(element)
            
            // create empty entries for all present elements
            for nodeToCastAsElement in element.descendantElements {
                
                guard let descendantElement = nodeToCastAsElement as? Element else {
                    assertionFailure("Error: nodeToCastAsElement is not Element")
                    continue
                }
                combinedElements.append(descendantElement)
            }
        }
        
        return combinedElements
    }
    
}
