//
//  StyloDocumentReducer.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-28.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Igloo
import os

enum DocumentAction: ActionType {
    
    case incrementLoadingPercent(value: CGFloat)
    case nameChanged(newName: String)
    case writingSessionHiddenChanged(newValue: Bool)
    case globalStyleChanged(styleId: String)
}

public struct StyloDocumentReducer: Reducer, StatisticallyAnalysableReducerType {
    
    let textStatisticsQueue: DispatchQueue
    
    init(storeIdentifier: String) {
    
        self.textStatisticsQueue = DispatchQueue(label: Constants.Queues.TextStatisticsQueueNamePrefix + storeIdentifier, qos: DispatchQoS.userInteractive, attributes: .concurrent)
    }
    
    @discardableResult
    public func online<S: Store>(store: S, action: ActionType) throws -> ActionResult? {
        
        guard let styloDocumentStore = store as? StyloDocumentStore else {
            assert(false)
            return nil
        }
        
        guard let documentAction = action as? DocumentAction else {
            assert(false)
            return nil
        }
        
        switch documentAction {
            
        case .incrementLoadingPercent(let value):
            
            let total: CGFloat = styloDocumentStore.loadingPercent.value + value
            styloDocumentStore.loadingPercent.setValue(total)
            
        case .nameChanged(let newName):
            styloDocumentStore.name.setValue(newName)
            
        case .writingSessionHiddenChanged(let newValue):
            styloDocumentStore.writingSessionHidden.setValue(newValue)
        case .globalStyleChanged(let styleId):
            styloDocumentStore.globalStyleID.setValue(styleId)
        }
        
        return nil
    }
    
    public func sync<S: Store>(store: S, action: SyncAction) -> ActionResult? {
        
        var result: ActionResult?
        
        if let styloDocumentStore = store as? StyloDocumentStore {
            
            switch action.type {
                
            case let documentAction as DocumentAction:
                
                switch documentAction {
                    
                case .incrementLoadingPercent(let value):
                    let total: CGFloat = styloDocumentStore.loadingPercent.value + value
                    styloDocumentStore.loadingPercent.setValue(total)
                case .nameChanged(let newName):
                    styloDocumentStore.name.setValue(newName)
                case .writingSessionHiddenChanged(let newValue):
                    styloDocumentStore.writingSessionHidden.setValue(newValue)
                case .globalStyleChanged(let styleId):
                    styloDocumentStore.globalStyleID.setValue(styleId)
                }
                
            default:
                
                let error = NWError.unhandledActionType(actionType: action.type)
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                #endif
            }
        }
        else {
            let error = NWError.unhandledStoreType(storeId: String(describing: store))
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error: %@", log: Log.WriterCommon.all, type: .error, %%error)
            #endif
        }
        
        return result
    }
    
    public func async<S: Store>(store: S, action: AsyncAction) -> Promise<ActionResult?> {
        
        return Promise<ActionResult?> { fulfill, reject in
            
            if let styloDocumentStore = store as? StyloDocumentStore {
                
                switch action.type {
                    
                case let documentAction as DocumentAction:
                    
                    switch documentAction {
                        
                    case .incrementLoadingPercent(let value):
                        
                        let total: CGFloat = styloDocumentStore.loadingPercent.value + value
                        styloDocumentStore.loadingPercent.setValue(total)
                        fulfill(nil)
                    case .nameChanged(let newName):
                        styloDocumentStore.name.setValue(newName)
                        fulfill(nil)
                    case .writingSessionHiddenChanged(let newValue):
                        styloDocumentStore.writingSessionHidden.setValue(newValue)
                        fulfill(nil)
                    case .globalStyleChanged(let styleId):
                        styloDocumentStore.globalStyleID.setValue(styleId)
                        fulfill(nil)
                    }
                    
                default:
                    
                    let error = NWError.unhandledActionType(actionType: action.type)
                    assertionFailure("Error: \(error)")
                    reject(error)
                }
            }
            else {
                let error = NWError.unhandledStoreType(storeId: String(describing: store))
                assertionFailure("Error: \(error)")
                reject(error)
            }
        }
    }
}
