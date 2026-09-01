//
//  StylableReducerType+AttributesStore.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-10-06.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Web
import Igloo
import os
import Markdown

extension StylableReducerType {
  
    func updateStoreAttributedString<S: Store & StylableStoreType>(in store: S, withChange changeDescription: SourceStringChangeDescription) {
        store.updateAttributesString(withChange: changeDescription)

        assert(store.attributesStore.attributedString.string == changeDescription.targetString.string)
        assert(store.attributesStore.string == changeDescription.targetString.string)
    }
    
    func updateStoreAttributes<S: Store & StylableStoreType>(store: S, description: SourceStringChangeDescription, updateDocumentResults: [UpdateDocumentResult], visibleTopElements: ContiguousArray<Element>?, document: Document, isFirstResponder: Bool, selectedRange: NSRange?) -> [RenderingProcessingResult]  {
        
        self.updateStoreAttributedString(in: store, withChange: description)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Attributes store length before update %@", log: Log.WriterCommon.all, type: .debug, %%store.attributesStore.length)
        os_log("Updating attributesStore %@ with %@", log: Log.WriterCommon.all, type: .debug, %%store.attributesStore, %%description)
        #endif
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Attributes store length after update %@", log: Log.WriterCommon.all, type: .debug, %%store.attributesStore.length)
        #endif
        
        var result: [RenderingProcessingResult] = []
        
        for updateDocumentResult in updateDocumentResults {
        
            assert(updateDocumentResult.rootElements != nil)
            if let rootElements = updateDocumentResult.rootElements {
                
                if let renderingProcessingResults = self.computeAndRenderAttributes(store: store, forRootElements: rootElements, deletedNodes: updateDocumentResult.deletedNodes, document: document, stringChange: description, attributesBlocsChange: updateDocumentResult.attributesBlocsChange) {
                    
                    // remove delete element from computedStyleElements
                    // we need to do this after we have computed the attributes
                    // since we may need erase some nodes
                    result.append(renderingProcessingResults)
                }
            }
        }
        
        guard store.focusAttributesString != nil else {
            return result
        }
        
        guard let visibleTopElements = visibleTopElements else {
            // it could be nil if the user is editing a stylesheet
            return result
        }
        
        guard let renderingProcessingResults = self.renderFocus(store: store, elements: visibleTopElements, deletedNodes: nil, document: document, renderingType: .selection, stringChange: description, isFirstResponder: isFirstResponder, selectedRange: selectedRange) else {
            assertionFailure("Error: renderingProcessingResults is nil")
            return result
        }
        
        result.append(renderingProcessingResults)
        return result
    }
    
    /// compute
    private func computeCssSurvivingDeletedNodes<S: Store & StylableStoreType>(store: S, topDeletedNodes: ContiguousArray<Node>, description: SourceStringChangeDescription) -> ContiguousArray<Node>? {
        
        if store is StylesheetDocumentStore {

            var survivingUpdatedDeletedNodes = ContiguousArray<Node>()
            
            for i in 0..<topDeletedNodes.count {
            
                let deletedNode = topDeletedNodes[i]
                
                if let element = deletedNode as? Element {
                
                    let descendants = element.inclusiveDescendants()
                    
                    for y in 0..<descendants.length {
                    
                        if var descendantElement = descendants[y] as? Element {
                        
                            func isValidRange(_ range: NSRange) -> Bool {
                                
                                if range.location < 0 {
                                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                    os_log("range.location: %@", log: Log.WriterCommon.all, type: .info, %%range.location)
                                    #endif
                                    assert(false)
                                    return false
                                }
                                return true
                            }
                            
                            #if DEBUG
                            if let ranges = descendantElement.sourceStringFragment?.ranges {
                                for range in ranges {
                                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                                    os_log("Before: range to validate %@ in element named: %@ with classes: %@", log: Log.WriterCommon.all, type: .info, %%NSStringFromRange(range), %%descendantElement, descendantElement.classListString)
                                    #endif
                                    assert(isValidRange(range))
                                }
                            }
                            #endif
                            descendantElement.applyStringChange(with: description)
                            #if DEBUG
                            if let ranges = descendantElement.sourceStringFragment?.ranges {
                                for range in ranges {
                                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                                    os_log("After: range to validate %@ in element named: %@ with classes: %@", log: Log.WriterCommon.all, type: .info, %%NSStringFromRange(range), %%descendantElement, %%descendantElement.classListString)
                                    #endif
                                    assert(isValidRange(range))
                                }
                            }
                            #endif
                            if descendantElement.sourceStringFragment != nil {
                                survivingUpdatedDeletedNodes.append(descendantElement)
                            }
                        }
                    }
                }
            }
            return survivingUpdatedDeletedNodes
        }
        return nil
    }
}
