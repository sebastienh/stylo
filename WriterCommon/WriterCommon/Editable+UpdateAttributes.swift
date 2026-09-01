//
//  Editable+UpdateAllAttributes.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-24.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web
import os


extension Editable {
    
    func updateDifferentAttributesForAllRenderers(_ stylableResults: [EditorId: StylableActionResult], change: SourceStringChangeDescription, pendingRequests: Queue<SourceStringChangeDescription>) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateDifferentAttributesForAllRenderers(%@, change: %@, pendingRequests: %@)", log: Log.WriterCommon.all, type: .info, %%stylableResults, %%change, %%pendingRequests)
        #endif
        
        assert(Thread.isMainThread)
        let updatedStylableActionResults = self.updateStylableResultsWithPendingResquest(stylableResults, pendingRequests: pendingRequests)
        
        for (_, editorManager) in self.editorManagers.values {
            editorManager.applyDifferentAttributes(stylableActionResults: updatedStylableActionResults, fromOriginStringAction: StringAction.edit(change: change))
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Sending notification: didCompleteAttributesRendering", log: Log.WriterCommon.all, type: .info)
            #endif
            WriterNotification.didCompleteAttributesRendering.sendNotification(editorManager.renderer)
        }
    }
    
    func updateAllAttributesForAllRenderers(_ stylableResults: [EditorId: StylableActionResult], change: SourceStringChangeDescription, pendingRequests: Queue<SourceStringChangeDescription>) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateAllAttributesForAllRenderers(%@, change: %@, pendingRequests: %@)", log: Log.WriterCommon.all, type: .info, %%stylableResults, %%change, %%pendingRequests)
        #endif
        
        assert(Thread.isMainThread)
        let updatedStylableActionResults = self.updateStylableResultsWithPendingResquest(stylableResults, pendingRequests: pendingRequests)
        
        // update all the
        for (_, editorManager) in self.editorManagers.values {
            editorManager.applyDifferentAttributes(stylableActionResults: updatedStylableActionResults, fromOriginStringAction: StringAction.edit(change: change))
        }
    }
    
    private func updateAttributesRangesWithPendingRequests(_ attributesRanges: [([NSAttributedString.Key: Any], NSRange)]) -> [([NSAttributedString.Key: Any], NSRange)] {
        
        assert(Thread.isMainThread)
        var updatedRanges = attributesRanges

        // we update the ranges with the requests
        pendingRequests.execute { request in
            updatedRanges = updateAttributesRanges(updatedRanges, with: request)
        }
        return updatedRanges
    }
    
    private func updateAttributesRanges(_ attributesRanges: [([NSAttributedString.Key: Any], NSRange)], with request: SourceStringChangeDescription) -> [([NSAttributedString.Key: Any], NSRange)] {

        assert(Thread.isMainThread)
        var result = [([NSAttributedString.Key: Any], NSRange)]()
        for (values, range) in attributesRanges {
            
            let ranges = range.update(with: request)
            if let ranges = ranges {
                for range in ranges {
                    result.append((values, range))
                }
            }
        }
        return result
    }
    
    
    
}
