//
//  MarkdownDocumentReducer+EditableReducer.swift
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

extension MarkdownDocumentReducer: EditableReducerType {

//    func handleEditableAction(markdownDocumentStore: MarkdownDocumentStore, action: EditableStoreAction) -> Promise<ActionResult?> {
//        
//        return Promise<ActionResult?> { fulfill, reject in
//            
//            switch action {
//                
//            case .sourceStringChanged(let description):
//                
//                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
//                os_log("sourceStringChanged action handling with description: %@", log: Log.WriterCommon.all, type: .debug, %%description)
//                #endif
//                
//                markdownDocumentStore.sourceString.value?.update(withSourceStringChangeDescription: description)
//                
//                // We always compute the attributes even if:
//                // description.changeLength == 0 && description.stringReplacement.length == 0
//                // because we want to compute the document attributes even in the case a document
//                // is empty.
//                self.saveEditingChange(description: description, in: markdownDocumentStore)
//
//                firstly {
//                    // this metod returns
//                    self.updateDocumentAsync(store: markdownDocumentStore, description: description)
//                }.then { updates -> Void in
//                    self.serialQueue.async(flags: .barrier) {
//                        markdownDocumentStore.htmlPreviewString.setValue(nil)
//                    }
//                    
//                    let documentStoreActionResult = DocumentStoreActionResult.updated(updates: updates)
//                    fulfill(documentStoreActionResult)
//                    
//                }.catch { error in
//                    debugPrint("Error: \(error)")
//                    reject(error)
//                }
//                
//            // only load the sourceString into the store
//            case .loadString(let url):
//                
//                firstly {
//                    load(url: url)
//                }.then { content -> Void in
//                    markdownDocumentStore.sourceString.setValue(content)
//                    fulfill(EditableActionResult.loadedString(string: content))
//                }.catch { error in
//                    reject(error )
//                }
//                
//            case .setString(let string):
//                
//                markdownDocumentStore.sourceString.setValue(string)
//                self.saveEditingChange(string: string, in: markdownDocumentStore)
//                fulfill(nil)
//                
//            case .resetPendingChanges:
//                assert(false)
//                let error = NWError.custom(message: "Not handling action: resetPendingChanges")
//                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
//                #endif
//                reject(error)
//            }
//        }
//    }
}
