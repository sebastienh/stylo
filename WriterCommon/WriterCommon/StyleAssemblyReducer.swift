//
//  StyleReducer.swift
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

enum StyleAssemblyAction: ActionType {
    
    case createElementTemporaryStyle(baseStyle: CSSStyle, elementId: String)
    case createStyleWithStylesheets(stylesheets: [CSSStyleSheet], styleId: String)
    case updateStylePreview
}

public enum StyleDocumentResult: ActionResult {
    
    case completedStyleStoreCreation(styleAssemblyStore: StyleAssemblyStore)
    
    case stylePreview(stylePreview: StylePreview)
    
    var stylePreview: StylePreview? {
        switch self {
        case .stylePreview(let stylePreview):
            return stylePreview
        case .completedStyleStoreCreation(let styleAssemblyStore):
            return nil
        }
    }
    
    var styleAssemblyStore: StyleAssemblyStore? {
        switch self {
        case .stylePreview:
            return nil
        case .completedStyleStoreCreation(let styleAssemblyStore):
            return styleAssemblyStore
        }
    }
    
}

public struct StyleAssemblyReducer: Reducer, SerialReducer {

    // strongly referenced by the StyleStore
    public let serialQueue: DispatchQueue
    
    init(storeIdentifier: String) {
        
        self.serialQueue = DispatchQueue(label: Constants.Queues.StyleAssemblyStoreQueueNamePrefix + storeIdentifier)
    }
    
    public func handleAction<S>(store: S, action: ActionType) throws -> ActionResult? where S : Store {
        
        var result: ActionResult?
        
        guard let styleAssemblyStore = store as? StyleAssemblyStore else {
            assertionFailure("Error: styleAssemblyStore is nil")
            return result
        }
        
        switch action {
            
        case let styleAction as StyleAssemblyAction:
        
            switch styleAction {
                
            case .createElementTemporaryStyle(let baseStyle, let elementId):
                    
                var temporarySingleElementStyle = CSSStyle(id: elementId, temporary: true, styleAssemblyIdentifier: styleAssemblyStore.id)
                
                if let userAgentStyleSheet = baseStyle.userAgentStyleSheet {
                    temporarySingleElementStyle.addStyleSheet(userAgentStyleSheet)
                }
                
                for authorStyleSheet in baseStyle.authorStyleSheets {
                    
//                        let authorStyleSheetClone = authorStyleSheet.clone()
                    self.updateElementIdAttributeSelectorValue(authorStyleSheet, withElementId: elementId)
                    temporarySingleElementStyle.addStyleSheet(authorStyleSheet)
                }
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Setting style value in styleAssemblyStore with identifier: %@", log: Log.WriterCommon.all, type: .info, %%styleAssemblyStore.identifier)
                #endif
                styleAssemblyStore.style.setValue(temporarySingleElementStyle)
                
            case .createStyleWithStylesheets(let stylesheets, let styleId):
                
                var style: CSSStyle = CSSStyle(id: styleId, styleAssemblyIdentifier: styleAssemblyStore.id)
                for stylesheet in stylesheets {
                    style.addStyleSheet(stylesheet)
                }
                result = StyleDocumentResult.completedStyleStoreCreation(styleAssemblyStore: styleAssemblyStore)
                styleAssemblyStore.style.setValue(style)
                
            case .updateStylePreview:
                
                // we do (flags: .barrier) because reading operations
                // can be concurrent, we don't want that, this value should be written
                // by one at a time.
                
                self.createStylePreview(in: styleAssemblyStore)
                
                guard let stylePreview = styleAssemblyStore.stylePreview.value else {
                    assertionFailure("Error: styleAssemblyStore.stylePreview.value is nil")
                    return result
                }
                
                result = StyleDocumentResult.stylePreview(stylePreview: stylePreview)
            }
            
        default:
            
            assertionFailure("Not handling action: \(action)")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Not handling action: %@", log: Log.WriterCommon.all, type: .error, %%action)
            #endif
            break
        }

        return result
    }
    
    private func updateElementIdAttributeSelectorValue(_ styleSheet: CSSStyleSheet, withElementId elementId: String) {
        
        let singleErrorStyleRule = styleSheet.cssRules.last as! CSSStyleRule
        let complexSelector = singleErrorStyleRule.selectorList?[0]
        
        assert(complexSelector != nil)
        if let complexSelector = complexSelector {
        
            let compoundSelector = complexSelector.compoundSelectorList[0]
            let attribSelector = compoundSelector[0] as! AttribSelector
            assert(attribSelector.attribName!.stringValue! == §DomAttributeString.ElementId)
            attribSelector.changeAttributeValueWith(elementId)
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("complexSelector is nil in updateElementIdAttributeSelectorValue.", log: Log.WriterCommon.all, type: .error)
            #endif
        }
    }
    
}
