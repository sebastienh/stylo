//
//  StylableReducerType+RenderStyle.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-02.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import PromiseKit
import Common
import os

extension Promise {
    static var void: Promise<Void> {
        return Promise<Void>(value: ())
    }
}

extension StylableReducerType {
    
    @discardableResult
    func evaluateStyle<S: StylableStoreType>(store: S, forRootElements elements: ContiguousArray<Element>? = nil, document: Document, forceStyleComputation: Bool = false, filterContext: FilterContext) -> ContiguousArray<Element>? {
        
        if let elements = elements {

            return self.evaluateStyle(forRootElments: elements, document: document, filterContext: filterContext, resourceComputedStyle: store.resourceComputedStyle, forceStyleComputation: forceStyleComputation)
        }
        else {
            
            // if we don't have a document we should not call compute attributes...
            return self.evaluateDocumentStyle(resourceComputedStyle: store.resourceComputedStyle, document: document, filterContext: filterContext)
        }
    }
    
    private func evaluateStyle(forRootElments elements: ContiguousArray<Element>, document: Document, filterContext: FilterContext, resourceComputedStyle: ResourceComputedStyle, forceStyleComputation: Bool = false) -> ContiguousArray<Element> {
        
        return resourceComputedStyle.computeElementsStyles(forRootElements: elements, document: document, filterContext: filterContext, forceStyleComputation: forceStyleComputation)
    }
    
    private func evaluateDocumentStyle(resourceComputedStyle: ResourceComputedStyle, document: Document, filterContext: FilterContext) -> ContiguousArray<Element> {
        
        return resourceComputedStyle.computeElementsStyles(document: document, filterContext: filterContext)
    }
    
    /// Validate that all elements have a computed style
    private func debugValidateAllElementsHaveAStyle(document: Document, resourceComputedStyle: ResourceComputedStyle) {
        
        let descendantsElements = document.getElementsByTagName("*")
        
        for element in descendantsElements {
            
            let _element = element as! Element
            let _style = resourceComputedStyle.computedStyle(forElement:_element)
            
            if _style == nil {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("No computed style for element: %@ with object id: %@", log: Log.WriterCommon.all, type: .error, %%_element.localName, %%ObjectIdentifier(_element))
                #endif
                assert(false)
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Computed style for element: %@ with object id: %@", log: Log.WriterCommon.all, type: .error, %%_element.localName, %%ObjectIdentifier(_element))
                #endif
            }
        }
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("All elements have their style computed.", log: Log.WriterCommon.all, type: .debug)
        #endif
    }
    
}
