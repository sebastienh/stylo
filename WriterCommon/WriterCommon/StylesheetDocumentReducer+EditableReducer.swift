//
//  StylesheetDocumentReducer+EditableReducer.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-13.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import PromiseKit
import Common
import Web
import os

extension StylesheetDocumentReducer: EditableReducerType {

    func handleEditableAction(stylesheetDocumentStore: StylesheetDocumentStore, action: EditableStoreAction) -> Promise<ActionResult?> {
        
        return Promise<ActionResult?> { fulfill, reject in
            
            switch action {
                
            case .sourceStringChanged(let description):
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("sourceStringChanged action handling with description: %@", log: Log.WriterCommon.all, type: .debug, %%description)
                #endif
                
                stylesheetDocumentStore.sourceString.value?.update(withSourceStringChangeDescription: description)
                
                // We always compute the attributes even if:
                // description.changeLength == 0 && description.stringReplacement.length == 0
                // because we want to compute the document attributes even in the case a document
                // is empty.
                self.saveEditingChange(description: description, in: stylesheetDocumentStore)

                firstly {
                    // this metod returns
                    self.updateDocumentAsync(store: stylesheetDocumentStore, description: description)
                }.then { updates -> Void in
                    if let updates = updates {
                        fulfill(DocumentStoreActionResult.updated(updates: updates))
                    }
                    else {
                        reject(NWError.nilDocumentUpdateResult)
                    }
                }.catch { error in
                    debugPrint("Error: \(error)")
                    reject(error)
                }
                
            // only load the sourceString into the store
            case .loadString(_):
                
                assertionFailure("loadString action is not async action")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("loadString action is not async action", log: Log.WriterCommon.all, type: .error)
                #endif
                reject(NWError.custom(message: "loadString action is not async action"))
                break
                
            case .setString(_):
                
                assertionFailure("setString action is not async action")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("setString action is not async action", log: Log.WriterCommon.all, type: .error)
                #endif
                reject(NWError.custom(message: "setString action is not async action"))
                break
                
            case .resetPendingChanges:
                
                self.serialCompilationQueue.async {
                    stylesheetDocumentStore.hasPendingChanges.setValue(false)
                    self.updateLastAppliedStylesheet(stylesheetDocumentStore)
                    fulfill(nil)
                }
            }
        }
    }
}
