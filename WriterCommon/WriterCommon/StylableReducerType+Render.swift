//
//  StylableRducerType+Render.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-02.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Igloo
import os

extension StylableReducerType {

    func renderSource<S: StylableStoreType>(store: S, elements: ContiguousArray<Element>, deletedNodes: ContiguousArray<Node>?, document: Document, renderingType: RenderingType, stringChange: SourceStringChangeDescription? = nil, filterContext: FilterContext) -> RenderingProcessingResult? {

        let resourceComputedStyle = store.resourceComputedStyle
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Processing document: %@", log: Log.WriterCommon.all, type: .info, %%HTMLSerializer.createDefault().serializeHTMLFragment(document))
        #endif
        
        let renderingContext = RenderingContext(contentString: store.stylableString, stringChangeDescription: stringChange, focusType: nil, renderingType: renderingType, filterContext: filterContext)
        
        let renderer = getNewRenderer(resourceComputedStyle: resourceComputedStyle, renderingContext: renderingContext, document: document as! Self.DocumentType)
        
        return renderer.process(elements: elements, deletedNodes: deletedNodes)
    }
    
    func renderFocus<S: StylableStoreType>(store: S, elements: ContiguousArray<Element>, deletedNodes: ContiguousArray<Node>?, document: Document, renderingType: RenderingType, stringChange: SourceStringChangeDescription? = nil, isFirstResponder: Bool, selectedRange: NSRange?) -> RenderingProcessingResult? {
        
        guard let focusAttributesString = store.focusAttributesString else {
            return nil
        }

        let resourceComputedStyle = store.resourceComputedStyle
        
        let filterContext = FilterContext(highlightSelectors: store.highlightSelectors, defaultPseudoClassesOptions: .fade, focusMode: store.focusMode.value)
        
        assert(store.focusMode.value != .disabled)
        let renderingContext = RenderingContext(contentString: focusAttributesString, stringChangeDescription: stringChange, focusType: store.focusMode.value.focusType, renderingType: renderingType, selectionRange: selectedRange, filterContext: filterContext, isFirstResponder: isFirstResponder)
        let renderer = getNewRenderer(resourceComputedStyle: resourceComputedStyle, renderingContext: renderingContext, document: document as! Self.DocumentType)
        return renderer.process(elements: elements, deletedNodes: deletedNodes)
    }
    
}
