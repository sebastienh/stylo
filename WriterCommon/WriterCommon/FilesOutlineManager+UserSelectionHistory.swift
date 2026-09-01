//
//  FilesOutlineManager+UserSelectionHistory.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-01-15.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import os
import Common

extension FilesOutlineManager {
    
    public func resetHistoryToLastValue() {
        
        try? dispatcher?.online(store: self.filesOutlineStore, action: FilesOutlineAction.resetHistoryToLastValue)
        self.documentManager.document?.updateChangeCount(.changeUndone)
    }
    
    public func moveForward() {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
        
        do {
            try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.moveForward)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            guard let sourceSetManager = self.documentManager._sourceSetManager.value else {
                assertionFailure("Error: self.documentManager._sourceSetManager is nil")
                return
            }
            
            os_log("moveForward() start -----------", log: Log.WriterCommon.all, type: .info)
            os_log("current number of historicStates: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.historicStates.count)
            os_log("current historic index: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.historyIndex.value)
            os_log("current user selected items:", log: Log.WriterCommon.all, type: .info)
            for userSelectedItem in filesOutlineStore.historicStates.values[safe: filesOutlineStore.historyIndex.value]!.userSelectedItems {
                os_log("userSelectedItem %@", log: Log.WriterCommon.all, type: .info, %%userSelectedItem)
                
                guard let item = sourceSetManager.directoryItemManager(withId: userSelectedItem) else {
                    assertionFailure("Error: item with id: \(userSelectedItem) is nil")
                    continue
                }
                
                os_log("item path: %@", log: Log.WriterCommon.all, type: .info, %%item.path)
            }
            os_log(" -----------", log: Log.WriterCommon.all, type: .info)
            #endif
            
        } catch let error {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error: exception in moveForward: %@", log: Log.WriterCommon.all, type: .error, %%error)
            #endif
        }
    }
    
    public func moveBackward() {
        
        guard let dispatcher = self.dispatcher else {
            assertionFailure("Error: self.dispatcher is nil")
            return
        }
            
        if self.filesOutlineStore.historyIndex.value > 0 {
            
            do {
                try dispatcher.online(store: self.filesOutlineStore, action: FilesOutlineAction.moveBack)
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                guard let sourceSetManager = self.documentManager._sourceSetManager.value else {
                    assertionFailure("Error: self.documentManager._sourceSetManager is nil")
                    return
                }
                
                os_log("moveBackward() start -----------", log: Log.WriterCommon.all, type: .info)
                os_log("current number of historicStates: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.historicStates.count)
                os_log("current historic index: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.historyIndex.value)
                os_log("current user selected items:", log: Log.WriterCommon.all, type: .info)
                for userSelectedItem in filesOutlineStore.historicStates.values[safe: filesOutlineStore.historyIndex.value]!.userSelectedItems {
                    os_log("userSelectedItem %@", log: Log.WriterCommon.all, type: .info, %%userSelectedItem)
                    
                    guard let item = sourceSetManager.directoryItemManager(withId: userSelectedItem) else {
                        assertionFailure("Error: item with id: \(userSelectedItem) is nil")
                        continue
                    }
                    
                    os_log("item path: %@", log: Log.WriterCommon.all, type: .info, %%item.path)
                }
                os_log(" -----------", log: Log.WriterCommon.all, type: .info)
                #endif
                
            } catch let error {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Error: exception in moveBack: %@", log: Log.WriterCommon.all, type: .error, %%error)
                #endif
            }
        }
    }
    
    func handleHistoricStateChange(_ historicState: HistoricState?) {
        
        guard let sourceSetManager = self.documentManager._sourceSetManager.value else {
            assertionFailure("Error: self.documentManager._sourceSetManager is nil")
            return
        }
        
        if let historicState = historicState {
            
            // filter the unexisting user selected items
            let existingUserSelectedItems = historicState.userSelectedItems.filter { (itemId) -> Bool in
                return sourceSetManager.directoryItemManagerExists(withId: itemId)
            }
            
            let updatedHistoricState = HistoricState(userSelectedItems: existingUserSelectedItems, expandedItems: historicState.expandedItems)
            
            self.currentHistoricState.setValue(updatedHistoricState)
        }
        else {
            self.currentHistoricState.setValue(nil)
        }
    }
}
