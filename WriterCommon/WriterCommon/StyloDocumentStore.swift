//
//  StyloDocumentStore.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-25.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Markdown
import Common
import PromiseKit
import Igloo

final public class StyloDocumentStore: Store, IdentifiableStoreType, StatisticallyAnalysableStore {
    
    public typealias ReducerType = StyloDocumentReducer
    
    /// Unique identifier
    public let identifier: String
    
    // this number goes from 0.0 to 1.0. 
    public let loadingPercent: Dynamic<CGFloat> = Dynamic<CGFloat>(0)
    
    /// Reference to the associated reducer
    public let reducer: StyloDocumentReducer
    
    let styloDocumentConcurrentQueue: DispatchQueue
    
    let name: Dynamic<String>
    
    let globalStyleID: Dynamic<String?>
    
    convenience init(documentMetadata: DocumentMetadata) {
    
        self.init(id: documentMetadata.id, name: documentMetadata.name, globalStyleID: documentMetadata.globalStyleID)
    }
    
    init(id: String, name: String, globalStyleID: String?) {
        
        self.identifier = id
        self.name = Dynamic<String>(name)
        self.globalStyleID = Dynamic<String?>(globalStyleID)
        self.styloDocumentConcurrentQueue = DispatchQueue(label: Constants.Queues.StyloDocumentStoreStyloDocumentQueueNamePrefix + identifier, attributes: .concurrent)
        
        self.reducer = StyloDocumentReducer(storeIdentifier: id)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: StatisticallyAnalysableStore protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var totalStatistics: Dynamic<TextStatistics?> = Dynamic<TextStatistics?>(nil)
    
    var selectionStatistics: Dynamic<TextStatistics?> = Dynamic<TextStatistics?>(nil)
    
    var sessionStatistics: Dynamic<TextStatistics?> = Dynamic<TextStatistics?>(nil)
    
    var sessionStartDate: Dynamic<Date?> = Dynamic<Date?>(nil)
    
    var writingSessions: Dynamic<Array<WritingSession>> = Dynamic<Array<WritingSession>>([])
    
    var writingSessionHidden: Dynamic<Bool?> = Dynamic<Bool?>(nil)
    
    var textStatisticsQueue: DispatchQueue {
        
        return reducer.textStatisticsQueue
    }
}
