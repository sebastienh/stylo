//
//  JsonStore.swift
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

public final class JsonStore: Store, IdentifiableStoreType, FailableStoreType, EditableStoreType, DocumentStoreType {
    
    var serialCompilationQueue: DispatchQueue
    
    var documentConcurrentQueue: DispatchQueue
    
    var attributesStoreConcurrentQueue: DispatchQueue
    
    var attributesCompilationSerialQueue: DispatchQueue
    
    public var reducer: JsonReducer
    
    public typealias ReducerType = JsonReducer
    
    public var jsonString: Dynamic<String?> = Dynamic<String?>(nil)
    
    public var templateContext: Dynamic<[String : Any]?> = Dynamic<[String : Any]?>(nil)
    
    public var environment: Dynamic<Environment?> = Dynamic<Environment?>(nil)
    
    public var jsonConcurrentQueue: DispatchQueue {
        
        return reducer.jsonConcurrentQueue
    }
    
    /// Unique identifier
    public let identifier: String = UUID().uuidString
    
    init() {
        
        self.serialCompilationQueue = DispatchQueue(label: Constants.Queues.JsonStoreDocumentQueueNamePrefix + identifier, qos: DispatchQoS.userInteractive)
        
        self.documentConcurrentQueue = DispatchQueue(label: Constants.Queues.JsonStoreDocumentQueueNamePrefix + identifier, qos: DispatchQoS.userInteractive, attributes: .concurrent)
        
        self.attributesStoreConcurrentQueue = DispatchQueue(label: Constants.Queues.JsonStoreDocumentQueueNamePrefix + identifier, qos: DispatchQoS.userInteractive, attributes: .concurrent)
        
        self.attributesCompilationSerialQueue = DispatchQueue(label: Constants.Queues.JsonStoreDocumentQueueNamePrefix + identifier, qos: DispatchQoS.userInteractive)
        
        self.reducer = JsonReducer(storeIdentifier: identifier)
//        self.styleId = Dynamic<String?>(nil)
//        self.sourceString = Dynamic<String?>(nil)
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: DocumentStoreType protocol implementation
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    public let document = Dynamic<Document?>(nil)
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: FailableStoreType protocol implementation
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    public let errorMessages = DynamicArray<Message>()
    
    public let storeState = Dynamic<FailableStoreState>(FailableStoreState.source)
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EditableStoreType protocol implementation
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var sourceString: Dynamic<String?> = Dynamic<String?>(nil)
    
    public var editingChanges = DynamicArray<SourceStringChangeDescription>()
       
}

