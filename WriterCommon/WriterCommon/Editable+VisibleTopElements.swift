//
//  Editable+VisibleTopElements.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-08-04.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web
import os

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif


extension Editable {
    
    func visibleTopElementsIfNecessary(inVisibleRange visibleRange: NSRange?) -> ContiguousArray<Element>? {
        
        guard self is TextManager else {
            return nil
        }
        
        guard let visibleRange = visibleRange else {
            return nil
        }
        
        switch StyloApplication.shared.focusMode.value {
        case .disabled:
            return nil
        case .enabled:
            return visibleTopElements(inVisibleRange: visibleRange)
        }
    }

    func visibleTopElementsIfNecessaryAsync(forEditorWithId editorId: EditorId) -> Promise<ContiguousArray<Element>?> {
        
        guard self is TextManager else {
            return Promise<ContiguousArray<Element>?>(value: nil)
        }
        
        switch StyloApplication.shared.focusMode.value {
        case .disabled:
            return Promise<ContiguousArray<Element>?>(value: nil)
        case .enabled:
            return visibleTopElementsAsync(forEditorWithId: editorId)
        }
    }
    
    func visibleTopElements(inVisibleRange visibleRange: NSRange?) -> ContiguousArray<Element>? {
        
        guard self is TextManager else {
            return nil
        }
        
        guard let visibleRange = visibleRange else {
            return nil
        }
        
        guard let actionResult: ActionResult = dispatcher.sync(store: self.editableStore, action: DocumentStoreAction.topElementsAroundRange(range: visibleRange).syncAction) else {
            assertionFailure("Error: actionResult is nil")
            return nil
        }
        
        guard let documentStoreActionResult: DocumentStoreActionResult = actionResult as? DocumentStoreActionResult else {
            assertionFailure("Error: documentStoreActionResult is nil")
            return nil
        }
        
        guard let topElementsAroundRange: ContiguousArray<Element> = documentStoreActionResult.topElementsAroundRange else {
            assertionFailure("Error: topElementsAroundRange is nil")
            return nil
        }
        
        return topElementsAroundRange
    }
    
    func visibleTopElementsAsync(forEditorWithId editorId: EditorId) -> Promise<ContiguousArray<Element>?> {
        
        guard let editorManager = self.editorManagers.values[editorId] else {
            let errorString = "Error: editorManager is nil"
            assertionFailure(errorString)
            return Promise(error: NWError.custom(message: errorString))
        }
        
        return Promise<ContiguousArray<Element>?> { fulfill, reject in
            
            firstly {
                return editorManager.visibleRangeAsync
            }.then { visibleRange -> Promise<ActionResult?> in
                
                guard let visibleRange = visibleRange else {
                    let errorString = "Error: visibleRange is nil"
                    assertionFailure(errorString)
                    return Promise(error: NWError.custom(message: errorString))
                }
                
                return self.dispatcher.async(store: self.editableStore, action: DocumentStoreAction.topElementsAroundRange(range: visibleRange).asyncAction)
            }.then { result -> Promise<ContiguousArray<Element>?> in
                
                return Promise<ContiguousArray<Element>?> { fulfill, reject in
                    guard let documentStoreActionResult: DocumentStoreActionResult = result as? DocumentStoreActionResult else {
                        let errorString = "Error: documentStoreActionResult is nil"
                        assertionFailure(errorString)
                        return reject(NWError.custom(message: errorString))
                    }
                    guard let topElementsAroundRange: ContiguousArray<Element> = documentStoreActionResult.topElementsAroundRange else {
                        let errorString = "Error: topElementsAroundRange is nil"
                        assertionFailure(errorString)
                        return reject(NWError.custom(message: errorString))
                    }
                    fulfill(topElementsAroundRange)
                }
                
            }.then { topElementsAroundRange -> Void in
                fulfill(topElementsAroundRange)
            }.catch { error in
                reject(error)
            }
        }
    }
    
}
