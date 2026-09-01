//
//  FilesOutlineReducer.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import PromiseKit
import Common
import os

enum FilesOutlineAction: ActionType {
    
    case applyUserSelectedItemsEdits(edits: [ArrayEdit<String>], destinationArray: [String])
    case userSelectedItemAppended(id: String)
    case insertItemInUserSelection(id: String, index: Int)
    case itemExpanded(id: String)
    case itemCollapsed(id: String)
    case replaceUserSelection(id: String)
    case removeItems(itemIds: [String])
    case removeAllUserSelectedItems(itemIds: [String])
    case removeUserSelectedItem(itemId: String)
    case editorCollapsed(id: String)
    case editorUncollapsed(id: String)
    case removeExpandedItems(itemIds: [String])
    case insertItemInUserSelectionAfter(id: String, previous: String)
    case moveBack
    case moveForward
    case resetHistoryToLastValue
    case rename(name: String)
}

enum FilesOutlineActionResult: ActionResult {
    
    
}

enum FilesOutlineError: Error {
    
    case movingBackBeforeStartOfHistory
    case movingForwardBeyondEndOfHistory
    case emptyStates
}

class FilesOutlineReducer: Reducer {
    
    @discardableResult
    func online<S>(store: S, action: ActionType) throws -> ActionResult? where S : Store {
        
        guard let projectContextAction = action as? FilesOutlineAction else {
            assert(false, "Error: unsupported action type: \(action)")
            return nil
        }
        
        guard let filesOutlineStore = store as? FilesOutlineStore else {
            assert(false, "Error: store is not FilesOutlineStore")
            return nil
        }
        
        switch projectContextAction {
        case .insertItemInUserSelection(let id, let index):
            filesOutlineStore.userSelectedItems.insert(id, at: index, sameExecutionStack: true)
            // validate we dont have duplicates
            assert(Set<String>(filesOutlineStore.userSelectedItems.values).count == filesOutlineStore.userSelectedItems.values.count)
            self.insertCurrentStateInHistory(in: filesOutlineStore)
        case .insertItemInUserSelectionAfter(let id, let previous):
            
            guard let previousIndex = filesOutlineStore.userSelectedItems.values.firstIndex(of: previous) else {
                assertionFailure("Error: no index for item with id: \(previous)")
                return nil
            }
            
            filesOutlineStore.userSelectedItems.insert(id, at: previousIndex+1, sameExecutionStack: true, withStartAndEndEvents: true)
            // validate we dont have duplicates
            assert(Set<String>(filesOutlineStore.userSelectedItems.values).count == filesOutlineStore.userSelectedItems.values.count)
            self.insertCurrentStateInHistory(in: filesOutlineStore)
        case .itemCollapsed(let id):
            filesOutlineStore.expandedItems.remove(id, sameExecutionStack: true)
        case .itemExpanded(let id):
            filesOutlineStore.expandedItems.insert(id, sameExecutionStack: true)
        case .userSelectedItemAppended(let id):
            filesOutlineStore.userSelectedItems.append(id, sameExecutionStack: true, withStartAndEndEvents: true)
            // validate we dont have duplicates
            assert(Set<String>(filesOutlineStore.userSelectedItems.values).count == filesOutlineStore.userSelectedItems.values.count)
            self.insertCurrentStateInHistory(in: filesOutlineStore)
        case .replaceUserSelection(let id):
            filesOutlineStore.userSelectedItems.replaceAll(withItem: id, sameExecutionStack: true, withStartAndEndEvents: true)
            // validate we dont have duplicates
            assert(Set<String>(filesOutlineStore.userSelectedItems.values).count == filesOutlineStore.userSelectedItems.values.count)
            self.insertCurrentStateInHistory(in: filesOutlineStore)
        case .removeUserSelectedItem(let itemId):
            guard let index = filesOutlineStore.userSelectedItems.values.firstIndex(of: itemId) else {
                assertionFailure("Error: index is nil")
                return nil
            }
            filesOutlineStore.userSelectedItems.remove(atIndex: index)
            // validate we dont have duplicates
            assert(Set<String>(filesOutlineStore.userSelectedItems.values).count == filesOutlineStore.userSelectedItems.values.count)
            self.insertCurrentStateInHistory(in: filesOutlineStore)
        case .removeExpandedItems(let itemIds):
            filesOutlineStore.expandedItems.remove(itemIds)
        case .removeAllUserSelectedItems(let itemIds):
            filesOutlineStore.expandedItems.remove(itemIds)
            filesOutlineStore.userSelectedItems.removeAll(withStartAndEndEvents: true)
            
            // validate we dont have duplicates
            assert(Set<String>(filesOutlineStore.userSelectedItems.values).count == filesOutlineStore.userSelectedItems.values.count)
            self.insertCurrentStateInHistory(in: filesOutlineStore)
        case .removeItems(let itemIds):
            
            filesOutlineStore.expandedItems.remove(itemIds)
            for itemId in itemIds {
                guard let index = filesOutlineStore.userSelectedItems.values.firstIndex(of: itemId) else {
                    assertionFailure("Error: index is nil")
                    continue
                }
                filesOutlineStore.userSelectedItems.remove(atIndex: index)
            }

            // validate we dont have duplicates
            assert(Set<String>(filesOutlineStore.userSelectedItems.values).count == filesOutlineStore.userSelectedItems.values.count)
            
            self.insertCurrentStateInHistory(in: filesOutlineStore)
            
        case .applyUserSelectedItemsEdits(let edits, let destinationArray):
            
            filesOutlineStore.userSelectedItems.applyArrayEdits(edits, to: OrderedSet<String>(destinationArray), sameExecutionStack: true)
            
            assert(Set<String>(filesOutlineStore.userSelectedItems.values).count == filesOutlineStore.userSelectedItems.values.count)
            self.insertCurrentStateInHistory(in: filesOutlineStore)
        case .editorCollapsed(let id):
            filesOutlineStore.collapsedEditorItems.insert(id, sameExecutionStack: true)
        case .editorUncollapsed(let id):
            if filesOutlineStore.collapsedEditorItems.contains(id) {
                filesOutlineStore.collapsedEditorItems.remove(id, sameExecutionStack: true)
            }
        case .moveBack:
            try moveBack(in: filesOutlineStore)
            self.updateHistoryBackEnabledValue(in: filesOutlineStore)
            self.updateHistoryForwardEnabledValue(in: filesOutlineStore)
        case .moveForward:
            try moveForward(in: filesOutlineStore)
            self.updateHistoryBackEnabledValue(in: filesOutlineStore)
            self.updateHistoryForwardEnabledValue(in: filesOutlineStore)
        case .resetHistoryToLastValue:
            try self.resetHistoryToLastValue(in: filesOutlineStore)
        case .rename(let name):
            filesOutlineStore.name.setValue(name)
        }
        return nil
    }
    
    @discardableResult
    func sync<S>(store: S, action: SyncAction) -> ActionResult? where S : Store {
        fatalError("missing implementation")
    }
    
    @discardableResult
    func async<S>(store: S, action: AsyncAction) -> Promise<ActionResult?> where S : Store {
        fatalError("missing implementation")
    }
    
    /// This method takes the last value of the histori states and makes
    /// it the only historical state.
    private func resetHistoryToLastValue(in filesOutlineStore: FilesOutlineStore) throws {
        
        guard let lastHistoricState = filesOutlineStore.historicStates.top else {
            assertionFailure("Error: filesOutlineStore.historicStates.values.last is nil")
            throw FilesOutlineError.emptyStates
        }
        
        filesOutlineStore.historicStates.clear()
        filesOutlineStore.historyIndex.setValue(0)
        filesOutlineStore.historicStates.push(lastHistoricState)
        filesOutlineStore.currentHistoricState.setValue(nil)
        self.updateHistoryBackEnabledValue(in: filesOutlineStore)
        self.updateHistoryForwardEnabledValue(in: filesOutlineStore)
    }
    
    private func insertCurrentStateInHistory(in filesOutlineStore: FilesOutlineStore) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("insertCurrentStateInHistory", log: Log.WriterCommon.all, type: .info)
        os_log("state before", log: Log.WriterCommon.all, type: .info)
        #endif
        
        displayHistoricalState(from: filesOutlineStore)
        
        let currentHistoricState = HistoricState(filesOutlineStore: filesOutlineStore)

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("current number of historicStates: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.historicStates.count)
        os_log("current historic index: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.historyIndex.value)
        #endif
        
        if filesOutlineStore.historicStates.isEmpty {
            filesOutlineStore.historicStates.push(currentHistoricState)
        }
        else if filesOutlineStore.historyIndex.value == filesOutlineStore.maxHistory.value-1 {
            filesOutlineStore.historicStates.popFront()
            filesOutlineStore.historicStates.push(currentHistoricState)
        }
        else {
            if filesOutlineStore.historyIndex.value+1<filesOutlineStore.historicStates.count {
                while filesOutlineStore.historicStates.count-1 > filesOutlineStore.historyIndex.value {
                    filesOutlineStore.historicStates.pop()
                }
            }
            filesOutlineStore.historicStates.push(currentHistoricState)
            filesOutlineStore.historyIndex.setValue(filesOutlineStore.historyIndex.value+1)
        }
        
        filesOutlineStore.currentHistoricState.setValue(nil)
        
        self.updateHistoryBackEnabledValue(in: filesOutlineStore)
        self.updateHistoryForwardEnabledValue(in: filesOutlineStore)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("state after", log: Log.WriterCommon.all, type: .info)
        displayHistoricalState(from: filesOutlineStore)
        #endif
    }
    
    private func updateHistoryForwardEnabledValue(in filesOutlineStore: FilesOutlineStore) {
        
        if filesOutlineStore.historicStates.count > 0 && filesOutlineStore.historyIndex.value < filesOutlineStore.historicStates.count-1 {
            filesOutlineStore.historyForwardEnabled.setValueIfDifferent(true)
        }
        else {
            filesOutlineStore.historyForwardEnabled.setValueIfDifferent(false)
        }
    }
    
    private func updateHistoryBackEnabledValue(in filesOutlineStore: FilesOutlineStore) {
        
        if filesOutlineStore.historyIndex.value > 0 {
            filesOutlineStore.historyBackEnabled.setValueIfDifferent(true, sameExecutionStack: true)
        }
        else {
            filesOutlineStore.historyBackEnabled.setValueIfDifferent(false, sameExecutionStack: true)
        }
    }
    
    private func moveBack(in filesOutlineStore: FilesOutlineStore) throws {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("moveBack start -----------", log: Log.WriterCommon.all, type: .info)
        os_log("current number of historicStates: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.historicStates.count)
        os_log("current historic index: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.historyIndex.value)
        os_log("current user selected items:", log: Log.WriterCommon.all, type: .info)
        for userSelectedItem in filesOutlineStore.historicStates.values[safe: filesOutlineStore.historyIndex.value]!.userSelectedItems {
            os_log("userSelectedItem %@", log: Log.WriterCommon.all, type: .info, %%userSelectedItem)
        }
        
        displayHistoricalState(from: filesOutlineStore)
        os_log(" -----------", log: Log.WriterCommon.all, type: .info)
        #endif
        
        guard filesOutlineStore.historyIndex.value > 0 else {
            throw FilesOutlineError.movingBackBeforeStartOfHistory
        }
        
        let newHistoryIndex = filesOutlineStore.historyIndex.value-1
        
        guard let previousHistoricState = filesOutlineStore.historicStates[safe: newHistoryIndex] else {
            throw FilesOutlineError.movingBackBeforeStartOfHistory
        }
        let previousUserSelectedItemsIds = previousHistoricState.userSelectedItems

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("restoring user selected items: %@ in editors in table", log: Log.WriterCommon.all, type: .info, %%previousUserSelectedItemsIds)
        os_log("from currently user selected items: %@ in editors in table", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.userSelectedItems.values)
        #endif
        
        let edits = filesOutlineStore.userSelectedItems.values.editOperations(to: OrderedSet<String>( previousUserSelectedItemsIds))
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("with array edits: %@", log: Log.WriterCommon.all, type: .info, %%edits)
        #endif
        
        filesOutlineStore.userSelectedItems.applyArrayEdits(edits, to: OrderedSet<String>(previousUserSelectedItemsIds), sameExecutionStack: true)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
         os_log("new user selected items: %@ in editors in table after applying edits", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.userSelectedItems.values)
        #endif
        
        filesOutlineStore.historyIndex.setValue(newHistoryIndex)
        filesOutlineStore.currentHistoricState.setValue(previousHistoricState)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("moveBack end -----------", log: Log.WriterCommon.all, type: .info)
        os_log("current number of historicStates: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.historicStates.count)
        os_log("current historic index: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.historyIndex.value)
        os_log("current user selected items:", log: Log.WriterCommon.all, type: .info)
        for userSelectedItem in filesOutlineStore.historicStates.values[safe: filesOutlineStore.historyIndex.value]!.userSelectedItems {
            os_log("userSelectedItem %@", log: Log.WriterCommon.all, type: .info, %%userSelectedItem)
        }
        displayHistoricalState(from: filesOutlineStore)
        os_log(" -----------", log: Log.WriterCommon.all, type: .info)
        #endif
    }
    
    private func moveForward(in filesOutlineStore: FilesOutlineStore) throws {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("moveForward start -------", log: Log.WriterCommon.all, type: .info)
        os_log("current number of historicStates: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.historicStates.count)
        os_log("current historic index: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.historyIndex.value)
        os_log("current user selected items:", log: Log.WriterCommon.all, type: .info)
        for userSelectedItem in filesOutlineStore.historicStates.values[safe: filesOutlineStore.historyIndex.value]!.userSelectedItems {
            os_log("userSelectedItem %@", log: Log.WriterCommon.all, type: .info, %%userSelectedItem)
        }
        os_log(" -----------", log: Log.WriterCommon.all, type: .info)
        #endif
        
        guard filesOutlineStore.historyIndex.value < filesOutlineStore.historicStates.count-1 else {
            throw FilesOutlineError.movingForwardBeyondEndOfHistory
        }
        
        let newHistoryIndex = filesOutlineStore.historyIndex.value+1
        guard let nextHistoricState = filesOutlineStore.historicStates.values[safe: newHistoryIndex] else {
            throw FilesOutlineError.movingForwardBeyondEndOfHistory
        }
        let nextUserSelectedItemsIds = nextHistoricState.userSelectedItems
        let edits = filesOutlineStore.userSelectedItems.values.editOperations(to: nextUserSelectedItemsIds)
        filesOutlineStore.userSelectedItems.applyArrayEdits(edits, to: OrderedSet<String>(nextUserSelectedItemsIds), sameExecutionStack: true)
        filesOutlineStore.historyIndex.setValue(newHistoryIndex)
        filesOutlineStore.currentHistoricState.setValue(nextHistoricState)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("moveForward end ----------", log: Log.WriterCommon.all, type: .info)
        os_log("current number of historicStates: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.historicStates.count)
        os_log("current historic index: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.historyIndex.value)
        os_log("current user selected items:", log: Log.WriterCommon.all, type: .info)
        for userSelectedItem in filesOutlineStore.historicStates.values[safe: filesOutlineStore.historyIndex.value]!.userSelectedItems {
            os_log("userSelectedItem %@", log: Log.WriterCommon.all, type: .info, %%userSelectedItem)
        }
        os_log(" -----------", log: Log.WriterCommon.all, type: .info)
        #endif
    }
    
    private func displayHistoricalState(from filesOutlineStore: FilesOutlineStore) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Complete historical state", log: Log.WriterCommon.all, type: .info)
        os_log("Number of historicStates: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.historicStates.count)
        os_log("Current historic index: %@", log: Log.WriterCommon.all, type: .info, %%filesOutlineStore.historyIndex.value)
        
        for (index, historicState) in filesOutlineStore.historicStates.items.enumerated() {
            os_log("historicState %@: %@", log: Log.WriterCommon.all, type: .info, %%index, %%historicState)
        }
        #endif
    }
    
}

