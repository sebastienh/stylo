//
//  JsonReducer.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-09.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web
import Stencil
import os

enum JsonAction: ActionType {
    
    case makeEmptyString
    case makeTemplateContext
}

enum JsonActionResult: ActionResult {
    
    case updatedContext(context: [String: Any]?)
}

struct JsonActionFactory: ActionsFactory {
    
    static func createEmptyJsonStringSyncAction() -> SyncAction {
        
        let actionType = JsonAction.makeEmptyString
        return SyncAction(type: actionType)
    }
        
    static func createMakeTemplateContextAsyncAction() -> AsyncAction {
        
        let actionType = JsonAction.makeTemplateContext
        return AsyncAction(type: actionType)
    }
    
    static func createMakeTemplateContextSyncAction() -> SyncAction {
        
        let actionType = JsonAction.makeTemplateContext
        return SyncAction(type: actionType)
    }
}

public struct JsonReducer: Reducer {
    
    let jsonConcurrentQueue: DispatchQueue
    
    init(storeIdentifier: String) {
        
        self.jsonConcurrentQueue = DispatchQueue(label: Constants.Queues.JsonStoreQueueNamePrefix + storeIdentifier, attributes: .concurrent)
    }
    
    @discardableResult
    public func online<S: Store>(store: S, action: ActionType) throws -> ActionResult? {
        fatalError("missing implementation")
    }
    
    @discardableResult
    public func sync<S>(store: S, action: SyncAction) -> ActionResult? where S : Store {
        
        var result: JsonActionResult?
        
        let jsonStore = store as? JsonStore
        
        assert(jsonStore != nil)
        if let jsonStore = jsonStore {
            
            switch action.type {
            
            case let jsonAction as JsonAction:
         
                switch jsonAction {
                    
                case .makeTemplateContext:
                    
                    self.jsonConcurrentQueue.sync(flags: .barrier) {
                        
                        do {
                            let context = try makeContext(store: jsonStore)
                            jsonStore.templateContext.setValue(context)
                            result = JsonActionResult.updatedContext(context: context)
                        }
                        catch let error {
                            let error = NWError.custom(message: "Error: \(error)")
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                            #endif
                        }
                    }

                case .makeEmptyString:
                    
                    self.jsonConcurrentQueue.sync(flags: .barrier) {
                        jsonStore.jsonString.setValue("")
                    }
                }
                
            case let editableAction as EditableStoreAction:
                
                switch editableAction {
                    
                case .setString(let string):
                    
                    self.saveEditingChange(string: string, in: jsonStore)
                    self.jsonConcurrentQueue.sync(flags: .barrier) {
                        
                        jsonStore.jsonString.setValue(string)
                        
                        
                    }
                    
                case .sourceStringChanged(let description):
                    
                    jsonStore.sourceString.value?.update(withSourceStringChangeDescription: description)
                    self.saveEditingChange(description: description, in: jsonStore)
                    self.jsonConcurrentQueue.sync(flags: .barrier) {
                        
                         jsonStore.jsonString.setValue(description.targetString.string)
                    }
                    
                case .loadString(let url):
                    
                    self.jsonConcurrentQueue.sync(flags: .barrier) {
                        
                        do {
                            
                            let string = try self.loadString(from: url)
                            jsonStore.jsonString.setValue(string)
                        }
                        catch let error {
                            
                            let error = NWError.custom(message: "Error: \(error)")
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                            #endif
                        }
                    }
                case .resetPendingChanges:
                    assert(false)
                    let error = NWError.custom(message: "Not handling action: \(action.type)")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                    #endif
                }
                
            default:
                
                let error = NWError.custom(message: "Not handling action: \(action.type)")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                #endif
            }
        }
        else {
            let error = NWError.unhandledStoreType(storeId: String(describing: store))
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
            #endif
        }
        return result 
    }
    
    public func async<S>(store: S, action: AsyncAction) -> Promise<ActionResult?> where S : Store {
        
        return Promise<ActionResult?> { fulfill, reject in
            
            let jsonStore = store as? JsonStore
            
            assert(jsonStore != nil)
            if let jsonStore = jsonStore {
                
                switch action.type {
                
                case let jsonAction as JsonAction:
                    
                    switch jsonAction {
                        
                    case .makeTemplateContext:
                        
                        self.jsonConcurrentQueue.async(flags: .barrier) {
                        
                            do {
                                let context = try self.makeContext(store: jsonStore)
                                jsonStore.templateContext.setValue(context)
                                let result = JsonActionResult.updatedContext(context: context)
                                fulfill(result)
                            }
                            catch let error {
                                let error = NWError.custom(message: "Error: \(error)")
                                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                                os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                                #endif
                                reject(error)
                            }
                        }
                        
                    case .makeEmptyString:
                        
                        self.jsonConcurrentQueue.async(flags: .barrier) {
                            jsonStore.jsonString.setValue("")
                        }
                    }
                    
                case let editableAction as EditableStoreAction:
                    
                    self.jsonConcurrentQueue.async(flags: .barrier) {
                    
                        firstly {
                            self.handleEditableAction(jsonStore: jsonStore, action: editableAction)
                        }.then { result in
                            fulfill(result)
                        }.catch { error in
                            let error = NWError.custom(message: "Error: \(error)")
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                            #endif
                            reject(error)
                        }
                    }
                    
                default:
                    
                    let error = NWError.custom(message: "Not handling action: \(action.type)")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                    #endif
                    reject(error)
                }
            }
            else {
                let error = NWError.unhandledStoreType(storeId: String(describing: store))
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                #endif
                reject(error)
            }
        }
    }
    
    private func makeContext(store: JsonStore) throws -> [String: Any] {
        
        do {
            
            if let jsonString = store.jsonString.value {
            
                let data = jsonString.data(using: String.Encoding.utf8)
            
                assert(data != nil)
                if let data = data {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]    else {
                        throw NWError.custom(message: "Invalid json structure.")
                    }
                    return json
                }
                else {
                    throw NWError.custom(message: "Nil data in JsonStore")
                }
            }
            else {
                throw NWError.custom(message: "Nil jsonString in JsonStore")
            }
        } catch let error {
            throw NWError.custom(message: "Invalid file: \(error.localizedDescription)")
        }
    }
    
    func loadString(from url: URL) throws -> String {
        
        // We use this action when the stylesheet is not loaded
        // from the UI, meaning this is a background load, for user agent
        // stylesheets for example.
        do {
            
            return try String(contentsOf: url)
        }
        catch {
            throw NWError.unableToLoad(url: url)
        }
    }
}
