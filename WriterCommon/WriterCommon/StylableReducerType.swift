//
//  StylableReducerType.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-01.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import Igloo
import PromiseKit
import os

enum StylableStoreAction: ActionType {
    
    case updateSelectorHighlightString(string: String)
    case clearSelectorHighlightString
    
    case computeInitialAttributes(visibleTopElements: ContiguousArray<Element>?, document: Document, isFirstResponder: Bool, selectedRange: NSRange?)
    
    case updateAttributedString(change: SourceStringChangeDescription)
    case applySourceStringChange(change: SourceStringChangeDescription, documentResults: [UpdateDocumentResult], visibleTopElements: ContiguousArray<Element>?, document: Document, isFirstResponder: Bool)
    
    case precomputeFadeStyles(document: Document)
    case changeFocusMode(focusMode: FocusMode)
    
    case changeSelection(selectionRange: NSRange?, visibleTopElements: ContiguousArray<Element>, document: Document)
    
    case clearFocusedAttributes(focusMode: FocusMode)
    
    // this is usefull for the highlight style assembly where we want to focus
    // on specific elements. These two actions are specific to highlight mode. 
    case flash(topElements: ContiguousArray<Element>, range: NSRange, document: Document)
}

public enum StylableActionResult: ActionResult {
    
    case renderedAttributesRanges(renderingProcessingResult: [RenderingProcessingResult])
    case serializedDocumentString(string: String)
    case styleRootElementRange(range: NSRange?)
    case numberOfRootChildren(value: Int?)
    case pendingStyleChanges(value: Bool)
    
    var containsFocusAttributes: Bool {
        guard let renderingProcessingResults = self.renderingProcessingResults else {
            assertionFailure("Error: renderingProcessingResults is nil")
            return false
        }
        
        for renderingProcessingResult in renderingProcessingResults {
            if renderingProcessingResult.isFocused {
                return true
            }
        }
        return false
    }
    
    var renderedTopElements: ContiguousArray<Element>? {
        if let renderingProcessingResults = self.renderingProcessingResults {
            var res = ContiguousArray<Element>()
            renderingProcessingResults.forEach { (renderingProcessingResult) in
                if let renderedTopElements = renderingProcessingResult.renderedTopElements {
                    res.append(contentsOf: renderedTopElements)
                }
            }
            return res
        }
        return nil
    }
    
    var renderingProcessingResults: [RenderingProcessingResult]? {
        switch self {
        case .renderedAttributesRanges(let renderingProcessingResult):
            return renderingProcessingResult
        default:
            return nil
        }
    }
    
    var attributes: [RenderingProcessingResult.AttributeAction: [AttributesRange]]? {
        
        switch self {
        case .renderedAttributesRanges(let renderingProcessingResult):
            
            var attributes: [RenderingProcessingResult.AttributeAction: [AttributesRange]] = [
                .add: [],
                .delete: [],
                .set: [],
            ]
            
            for renderingProcessingResultInstance in renderingProcessingResult {
                
                if let addedAttributes = renderingProcessingResultInstance.attributes[.add] {
                    attributes[.add]?.append(contentsOf: addedAttributes)
                }
                if let setAttributes = renderingProcessingResultInstance.attributes[.set] {
                    attributes[.set]?.append(contentsOf: setAttributes)
                }
                if let deletedAttributes = renderingProcessingResultInstance.attributes[.delete] {
                    attributes[.delete]?.append(contentsOf: deletedAttributes)
                }
            }
            
            return attributes
        default:
            assertionFailure("Error: permanentAttributes is not a valid request for \(self)")
            return nil
        }
    }
    
    public var pendingStyleChangesValue: Bool? {
        
        switch self {
        case .pendingStyleChanges(let value):
            return value
        default:
            return nil
        }
    }
    
    public var numberOfRootChildrenValue: Int? {
        
        switch self {
        case .numberOfRootChildren(let value):
            return value
        default:
            return nil
        }
    }
    
    public var styleRootElementRangeValue: NSRange? {
        
        switch self {
        case .styleRootElementRange(let range):
            return range
        default:
            return nil
        }
    }

    #if DEBUG
    public var targetString: String? {
        
        switch self {
        case .renderedAttributesRanges(let renderingProcessingResults):
            return renderingProcessingResults.first?.targetString
        default:
            return nil
        }
    }
    #endif
    
    public var deletedAttributesRanges: [AttributesRange]? {
        
        switch self {
        case .renderedAttributesRanges(let renderingProcessingResults):
            return renderingProcessingResults.flatMap{$0.attributes[.delete]!}
        default:
            return nil
        }
    }
    
    public var addedAttributesRanges: [AttributesRange]? {
        
        switch self {
        case .renderedAttributesRanges(let renderingProcessingResults):
            return renderingProcessingResults.flatMap{$0.attributes[.add]!}
        default:
            return nil
        }
    }
    
    public var setAttributesRanges: [AttributesRange]? {
        
        switch self {
        case .renderedAttributesRanges(let renderingProcessingResults):
            return renderingProcessingResults.flatMap{$0.attributes[.set]!}
        default:
            return nil
        }
    }
    
    public var documentAttributes: DocumentAttributes? {
    
        switch self {
        case .renderedAttributesRanges(let renderingProcessingResult):
            return renderingProcessingResult.first?.documentAttributes
        default:
            return nil
        }
    }
    
    public var documentString: String? {
        
        switch self {
        case .serializedDocumentString(let string):
            return string
        default:
            return nil
        }
    }
    
    public func updatedAttributesRanges(with pendingRequests: Queue<SourceStringChangeDescription>) -> StylableActionResult {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updatedAttributesRanges(with: %@)", log: Log.WriterCommon.all, type: .info, %%pendingRequests)
        #endif
        
        switch self {
        case .renderedAttributesRanges(let renderingProcessingResults):
        
            if !pendingRequests.isEmpty {
            
                var updatedRenderingProcessingResults = [RenderingProcessingResult]()
                
                for var renderingProcessingResult in renderingProcessingResults {
                
                    renderingProcessingResult.updateWithPendingRequests(pendingRequests)
                    updatedRenderingProcessingResults.append(renderingProcessingResult)
                }
                
                return StylableActionResult.renderedAttributesRanges(renderingProcessingResult: updatedRenderingProcessingResults)
            }
            else {
                return self
            }
            
        default:
            return self
        }
    }
    
    func update(attributesRanges: [AttributesRange], with pendingRequests: Queue<SourceStringChangeDescription>) -> [AttributesRange] {
        
        var updatedRanges = attributesRanges

        // we update the ranges with the requests
        pendingRequests.execute { request in
            updatedRanges = updateAttributesRanges(updatedRanges, with: request)
        }
        return updatedRanges
    }

    private func updateAttributesRanges(_ attributesRanges: [AttributesRange], with request: SourceStringChangeDescription) -> [AttributesRange] {
        
        var result = [AttributesRange]()
        
        for attributesRange in attributesRanges {
            
            let _ranges = attributesRange.range.update(with: request)
            if let _ranges = _ranges {
                for _range in _ranges {
                    result.append(AttributesRange(attributesRange.attributes, _range, attributesRange.originNodeName))
                }
            }
        }
        return result
    }
    
}

protocol StylableReducerType: class {
    
    associatedtype DocumentType: Document
    
    associatedtype RendererType: Renderer
    
    var serialCompilationQueue: DispatchQueue { get }
    
    func getNewRenderer(resourceComputedStyle: ResourceComputedStyle, renderingContext: RenderingContext, document: DocumentType) -> RendererType
    
}

