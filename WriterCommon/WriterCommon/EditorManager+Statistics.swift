//
//  EditorManager+Statistics.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-09-15.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import Igloo
import os
import Common

extension EditorManager {
    
    public func updateSelectionStatistics() -> Promise<Void> {

        guard let selectedRange = self.selectedRange else {
            self.selectionStatistics.setValue(nil)
            return Promise<Void>(value: ())
        }
        
        let action = StatisticsAction.selectionStatistics(selectionRange: selectedRange)
        let store = self.styledStoreManager.styledStore
        
        return Promise<Void> { fulfill, reject in

            firstly { () -> Promise<ActionResult?> in
                return self.dispatcher.async(store: store, action: action.asyncAction)
            }.then { result -> Promise<StatisticsResult> in
                
                guard let statisticsResult = result as? StatisticsResult else {
                    let errorText = "Error: result is not StatisticsResult"
                    assertionFailure(errorText)
                    return Promise<StatisticsResult>(error: NWError.custom(message: errorText))
                }
                
                return Promise<StatisticsResult>(value: statisticsResult)
            }.then { statisticsResult -> Void in
                self.selectionStatistics.setValue(statisticsResult.statistics)
                fulfill(())
            }.catch { error in
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Error in updateStatistics(): %@", log: Log.WriterCommon.all, type: .error, %%error)
                #endif
                assert(false)
                reject(error)
            }
        }
    }
    
}
