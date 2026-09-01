//
//  JsonReducer+EditableReducer.swift
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

extension JsonReducer: EditableReducerType {
    
    func handleEditableAction(jsonStore: JsonStore, action: EditableStoreAction) -> Promise<ActionResult?> {

        return Promise<ActionResult?> { fulfill, reject in
            
            switch action {
                
            case .setString(let string):
                
                self.saveEditingChange(string: string, in: jsonStore)
                self.jsonConcurrentQueue.async(flags: .barrier) {
                    
                    jsonStore.jsonString.setValue(string)
                    fulfill(nil)
                }
                
            case .sourceStringChanged(let description):
         
                jsonStore.sourceString.value?.update(withSourceStringChangeDescription: description)
                self.saveEditingChange(description: description, in: jsonStore)
                self.jsonConcurrentQueue.async(flags: .barrier) {
                
                    jsonStore.jsonString.setValue(description.targetString.string)
                    fulfill(EditableActionResult.sourceStringChanged)
                }
                
            case .loadString(let url):
                
                self.jsonConcurrentQueue.async(flags: .barrier) {
                    
                    do {
                        
                        let string = try self.loadString(from: url)
                        jsonStore.jsonString.setValue(string)
                    }
                    catch let error {
                        
                        let error = NWError.custom(message: "Error: \(error)")
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                        #endif
                        reject(error)
                    }
                }
            case .resetPendingChanges:
                assert(false)
                let error = NWError.custom(message: "Not handling action: resetPendingChanges")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                #endif
                reject(error)
            }
        }
    }
}
