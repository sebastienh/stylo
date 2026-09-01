//
//  JsonStyleReducer.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-18.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import PromiseKit
import Common
import os

public class JsonStyleReducer: Reducer {
    
    public var serialQueue: DispatchQueue {
        return serialCompilationQueue
    }
    
    let serialCompilationQueue: DispatchQueue
    
    let documentConcurrentQueue: DispatchQueue
    
    let attributesStoreConcurrentQueue: DispatchQueue
    
    let attributesCompilationSerialQueue: DispatchQueue
    
    let htmlPreviewConcurrentQueue: DispatchQueue
    
    init(storeIdentifier: String) {
        
        self.serialCompilationQueue = DispatchQueue(label: Constants.Queues.JsonStyleCompilationQueueNamePrefix + storeIdentifier, qos: DispatchQoS.userInteractive)
        
        self.documentConcurrentQueue = DispatchQueue(label: Constants.Queues.DocumentStoreDocumentQueueNamePrefix + storeIdentifier, qos: DispatchQoS.userInteractive, attributes: .concurrent)
        
        self.attributesStoreConcurrentQueue = DispatchQueue(label: Constants.Queues.DocumentStoreAttributesStoreQueueNamePrefix + storeIdentifier, qos: DispatchQoS.userInteractive, attributes: .concurrent)
        
        self.attributesCompilationSerialQueue = DispatchQueue(label: Constants.Queues.DocumentStoreAttributesCompilationSerialQueueNamePrefix + storeIdentifier, qos: DispatchQoS.userInteractive)
        
        self.htmlPreviewConcurrentQueue = DispatchQueue(label: Constants.Queues.HtmlPreviewQueueNamePrefix + storeIdentifier, qos: DispatchQoS.userInteractive, attributes: .concurrent)
    }
    
    public func sync<S>(store: S, action: SyncAction) -> ActionResult? where S : Store {
        
        fatalError("missing implementation")
        
//        var result: ActionResult?
//
//        guard let stylesheetStyleStore = store as? StylesheetStyleStore else {
//            assertionFailure("Error: store is not StylesheetStyleStore")
//            return nil
//        }
//
//        guard let stylableStoreAction = action.type as? StylableStoreAction else {
//            assertionFailure("Error: action is not StylableStoreAction")
//            return nil
//        }
//
//        switch stylableStoreAction {
//        case .computeAttributes(let phase):
//            result = self.computeAttributesSync(store: stylesheetStyleStore, renderingType: phase)
//        }
//        return result
    }
    
    public func async<S>(store: S, action: AsyncAction) -> Promise<ActionResult?> where S : Store {
        
        return Promise<ActionResult?> { fulfill, reject in
  
            fatalError("missing implementation")
//            guard let stylesheetStyleStore = store as? JsonStyleStore else {
//                assertionFailure("Error: store is not StylesheetStyleStore")
//                reject(NWError.custom(message: "Error: store is nil"))
//                return
//            }
//
//            guard let stylableStoreAction = action.type as? StylableStoreAction else {
//                assertionFailure("Error: action is not StylableStoreAction")
//                reject(NWError.custom(message: "Error: action is not StylableStoreAction"))
//                return
//            }
//
//            firstly {
//                self.handleStylableStoreAction(store: stylesheetStyleStore, action: stylableStoreAction)
//            }.then { actionResult -> Void in
//                fulfill(actionResult)
//            }.catch { error in
//                debugPrint("Error: \(error)")
//                reject(error)
//            }
        }
    }
    
    public func online<S>(store: S, action: ActionType) throws -> ActionResult? where S : Store {
        
        fatalError("missing implementation")
        return nil
    }
    
    
    
}
