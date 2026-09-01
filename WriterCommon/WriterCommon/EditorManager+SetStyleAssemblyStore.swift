//
//  EditorManager+SetStyleAssembly.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-08-02.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web
import os

extension EditorManager {
    
    func updateStyledStoreManagerAsync(fromStyleAssemblyStore styleAssemblyStore: StyleAssemblyStore, document: Document, withDescriptor descriptor: StyleAssemblyDescriptor, visibleTopElements: ContiguousArray<Element>?) -> Promise<Void> {
        
        guard self.currentStyleAssemblyIdentifier != styleAssemblyStore.identifier else {
            return Promise(value: ())
        }
            
        self.currentStyleAssemblyIdentifier = styleAssemblyStore.identifier
        
        guard let resourceComputedStyle = styleAssemblyStore.resourceComputedStyle else {
            assertionFailure("Error: resourceComputedStyle is nil")
            return Promise(error: NWError.custom(message: "Error: resourceComputedStyle is nil"))
        }
        
        
        // here we need to create a StylableStore which will be responsible
        // for computing the text attributes using a style
        let styledStore = StylableStore(string: self.string, focusMode: FocusMode.disabled, resourceComputedStyle: resourceComputedStyle, highlightSelectors: self.styledStoreManager.highlightSelectors)
        
        return Promise<Void> { fulfill, reject in
            firstly { () -> Promise<ActionResult?> in
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("updateStyledStoreManagerAsync -> computeInitialAttributes", log: Log.WriterCommon.all, type: .info)
                #endif
                
                self.clearPreviousFocusStateIfNecessary()
                
                let computeInitialAttributesAction = StylableStoreAction.computeInitialAttributes(visibleTopElements: visibleTopElements, document: document, isFirstResponder: false, selectedRange: nil).asyncAction
                return self.dispatcher.async(store: styledStore, action: computeInitialAttributesAction)
            }.then { result -> Promise<(StyledStoreManager<StylableStore>, StylableActionResult)> in
                
                return Promise<(StyledStoreManager<StylableStore>, StylableActionResult)> { fulfill, reject in
                    
                    guard let stylableActionResult = result as? StylableActionResult else {
                        let errorText = "Error: result is not StylableActionResult"
                        assertionFailure(errorText)
                        reject(NWError.custom(message: errorText))
                        return
                    }
                    
                    let styledStoreManager = StyledStoreManager<StylableStore>(styleAssemblyDescriptor: descriptor, styledStore: styledStore, styleAssemblyStore: styleAssemblyStore, dispatcher: self.dispatcher)
                    styledStoreManager.updateDocumentAttributes(stylableActionResult.documentAttributes)
                    styledStoreManager.updateStylePreviewSync()
                    self.styledStoreManager = styledStoreManager
                    fulfill((styledStoreManager, stylableActionResult))
                }
            }.then { value -> Void in
                let (styledStoreManager, stylableActionResult) = value
                styledStoreManager.precomputeFadeStyles(document: document)
                self.applyStringAttributes(fromStylableActionResult: stylableActionResult, originStringAction: StringAction.changeStyle)
                self.applyGlobalAttributes()
                
                self.setApplicationFocusType()
                self.updateCompilationUnit(withChange: nil, result: stylableActionResult)
                fulfill(())
            }.catch { error in
                reject(error)
            }
        }
    }
    
    func updateStyledStoreManager(fromStyleAssemblyStore styleAssemblyStore: StyleAssemblyStore, document: Document, withDescriptor descriptor: StyleAssemblyDescriptor, visibleTopElements: ContiguousArray<Element>?) throws {
        
        guard self.currentStyleAssemblyIdentifier != styleAssemblyStore.identifier else {
            assertionFailure("Error: trying to apply already applied style")
            return
        }
        
        self.currentStyleAssemblyIdentifier = styleAssemblyStore.identifier
        
        guard let resourceComputedStyle = styleAssemblyStore.resourceComputedStyle else {
            assertionFailure("Error: resourceComputedStyle is nil")
            return
        }
        
        self.clearPreviousFocusStateIfNecessary()
        
        // here we need to create a StylableStore which will be responsible
        // for computing the text attributes using a style
        let styledStore = StylableStore(string: self.string, focusMode: FocusMode.disabled, resourceComputedStyle: resourceComputedStyle, highlightSelectors: self.styledStoreManager.highlightSelectors)
        
        let styledStoreManager = StyledStoreManager<StylableStore>(styleAssemblyDescriptor: descriptor, styledStore: styledStore, styleAssemblyStore: styleAssemblyStore, dispatcher: self.dispatcher)
        
        guard let stylableActionResult = try styledStoreManager.compileInitialAttributes(visibleTopElements: visibleTopElements, document: document, isFirstResponder: false, selectedRange: nil) else {
            assertionFailure("Error: stylableActionResult is nil")
            return
        }
        
        styledStoreManager.updateStylePreviewSync()
        styledStoreManager.subscribeToStylePreviewChange()
        self.styledStoreManager = styledStoreManager
        
        guard let documentAttributes = stylableActionResult.documentAttributes else {
            assertionFailure("Error: stylableActionResult.documentAttributes is nil")
            return
        }
        
        styledStoreManager.updateDocumentAttributes(documentAttributes)
        styledStoreManager.precomputeFadeStyles(document: document)
        self.applyStringAttributes(fromStylableActionResult: stylableActionResult, originStringAction: StringAction.changeStyle)
        self.applyGlobalAttributes()
        self.setApplicationFocusType()
        
        self.updateCompilationUnit(withChange: nil, result: stylableActionResult)
    }
    

}
