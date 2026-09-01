//
//  StatisticallyAnalysableReducerType.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2018-11-17.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import PromiseKit

protocol StatisticallyAnalysableReducerType {
    
    func handleLoad<S: Store & StatisticallyAnalysableStore>(writingSessions: WritingSessionsMetadata, in store: S)
    
    func updateStatistics<S: Store & StatisticallyAnalysableStore & StylableStoreType & EditableStoreType>(in store: S) -> Promise<Void>
    
    func handleCreateWritingSession<S: Store & StatisticallyAnalysableStore>(in store: S) -> Promise<Void>
    
    func handleShow<S: Store & StatisticallyAnalysableStore>(in store: S) -> Promise<Void>
    
    func handleHide<S: Store & StatisticallyAnalysableStore>(in store: S) -> Promise<Void>
    
    func hanleGetWritingSessionsMetadata<S: Store & StatisticallyAnalysableStore>(in store: S) -> ActionResult?
    
}


extension StatisticallyAnalysableReducerType {
    
    func handleLoad<S: Store & StatisticallyAnalysableStore>(writingSessions: WritingSessionsMetadata, in store: S) {
        
        store.textStatisticsQueue.sync {
         
            store.writingSessionHidden.setValue(writingSessions.isHidden)
            
            for session in writingSessions.sessions {
                
                let writingSession = WritingSession(session: session)
                store.writingSessions.value.append(writingSession)
            }
            
            if let lastSession = writingSessions.sessions.last {
                
                store.sessionStartDate.setValue(lastSession.startDate.date)
            }
        }
    }
    
    @discardableResult
    func updateStatistics<S: Store & StatisticallyAnalysableStore & EditableStoreType>(in store: S) -> Promise<Void> {
     
        return Promise<Void> { fulfill, reject in
            store.textStatisticsQueue.async {
                guard let string = store.sourceString.value else {
                    assertionFailure("Error: store.sourceString.value is nil")
                    self.updateStatistics(from: "", in: store)
                    reject(NWError.custom(message: "Error: store.sourceString.value is nil"))
                    return
                }
                
                self.updateStatistics(from: string, in: store)
                fulfill(())
            }
        }
    }
    
    @discardableResult
    func handleCreateWritingSession<S: Store & StatisticallyAnalysableStore>(in store: S) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            store.textStatisticsQueue.async {
                
                let totalStatistics = store.totalStatistics.value
                
                assert(totalStatistics != nil)
                if let totalStatistics = totalStatistics {
                
                    let date = Date()
                    let writingSession = WritingSession(startDate: date, textStatistics: totalStatistics)
                    store.writingSessions.value.append(writingSession)
                    store.sessionStartDate.setValue(date)
                    fulfill(())
                }
                else {
                    
                    assert(false)
                    reject(NWError.custom(message: "totalStatistics is nil in handleCreateWritingSession."))
                }
            }
        }
    }
    
    @discardableResult
    func handleShow<S: Store & StatisticallyAnalysableStore>(in store: S) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
        
            store.textStatisticsQueue.async {
        
                store.writingSessionHidden.setValue(false)
                fulfill(())
            }
        }
    }
    
    @discardableResult
    func handleHide<S: Store & StatisticallyAnalysableStore>(in store: S)  -> Promise<Void>{
        
        return Promise<Void> { fulfill, reject in
            
            store.textStatisticsQueue.async {
            
                store.writingSessionHidden.setValue(true)
                fulfill(())
            }
        }
    }
    
    func hanleGetWritingSessionsMetadata<S: Store & StatisticallyAnalysableStore>(in store: S) -> ActionResult? {
        
        return store.textStatisticsQueue.sync {
            
            var writingSessionsMetadata = WritingSessionsMetadata()
            
            if let isHidden = store.writingSessionHidden.value {
                writingSessionsMetadata.isHidden = isHidden
            }
            
            for session in store.writingSessions.value {
                writingSessionsMetadata.sessions.append(session.writingSessionMetadata)
            }
            return StatisticsResult.writingSessionsMetadata(writingSessions: writingSessionsMetadata)
        }
    }
    
    private func updateStatistics<S: Store & StatisticallyAnalysableStore>(from string: String, in store: S) {
        
        let textStatistics = TextStatistics.from(string)
        store.totalStatistics.setValue(textStatistics)
        
        if let lastEntry = store.writingSessions.value.last {
            
            let sessionStatistics = textStatistics - lastEntry.textStatistics
            store.sessionStatistics.setValue(sessionStatistics)
        }
    }
    
}
