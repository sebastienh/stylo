//
//  SourceSetManager+OutlineMove.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-08-13.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os

extension SourceSetManager {
    
    public func movesItems(withIds itemIds: [String], proposedParent: DirectoryManager, proposedInsertionIndex: Int) throws {
        
        #if DEBUG
        var lastIndex: Int = -1
        for itemId in itemIds {
            
            guard let globalIndex = self.globalIndex(ofDirectoryItemManagerWithId: itemId) else {
                assertionFailure("Error: globalIndex is nil")
                continue
            }
            assert(globalIndex > lastIndex)
            lastIndex = globalIndex
        }
        #endif
        
        var insertionIndex = proposedInsertionIndex
        for itemId in itemIds {
        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("move at index: %@ in parent: %@", log: Log.WriterCommon.all, type: .info, %%proposedInsertionIndex, %%proposedParentId)
            #endif
        
        
            guard let outlineMoves = self.moves(from: [itemId], proposedParentId: proposedParent.id, insertionIndex: insertionIndex) else {
                assertionFailure("Error: not able to compute outline moves ")
                throw NWError.custom(message: "Error moving item.")
            }
            
            try self.execute(moves: outlineMoves, execute: false)
            insertionIndex += 1
        }
        
        insertionIndex = proposedInsertionIndex
        for itemId in itemIds {
        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("move at index: %@ in parent: %@", log: Log.WriterCommon.all, type: .info, %%proposedInsertionIndex, %%proposedParentId)
            #endif
        
        
            guard let outlineMoves = self.moves(from: [itemId], proposedParentId: proposedParent.id, insertionIndex: insertionIndex) else {
                assertionFailure("Error: not able to compute outline moves ")
                throw NWError.custom(message: "Error moving item.")
            }
            
            try self.execute(moves: outlineMoves, execute: true)
            
            guard let index = proposedParent.indexOfChild(whithId: itemId) else {
                assertionFailure("Error: index is nil")
                continue
            }
            
            insertionIndex = index+1
        }
        
        // Note: we can not update the text managers
        // here because we do not support moves in two
        // directions which the user can do... So we
        // need to apply the changes to text managers after each moves.
        //
        // It is different for updateDirectoryItemManagers() since nobody
        // is listening to it.
//        updateDirectoryItemManagers()
    }
    
    private func moves(from itemIds: [String], proposedParentId: String, insertionIndex: Int) -> [OutlineMove]? {

        var moves = [OutlineMove]()
        var proposedItemIndex = insertionIndex
        
        // to avoid moving items that are inside other items that
        // are moved: we ignore them as the parent element
        // will be moved.
        let topElementsIds = computeTopItems(for: itemIds)
        
        for itemId in topElementsIds {
            
            guard let directoryItemManager = self.directoryItemManager(withId: itemId) else {
                assertionFailure("Error: no item with id: \(itemId)")
                return nil
            }
            
            guard let oldIndex = indexOf(itemId: itemId, in: directoryItemManager.parentID.value) else {
                assertionFailure("Error: returned index for element in parent is nil")
                return nil
            }
        
            let move: OutlineMove = {
                if directoryItemManager.parentID.value == proposedParentId {
                    return OutlineMove.horizontal(id: itemId, oldIndex: oldIndex, newIndex: proposedItemIndex)
                }
                else {
                    return OutlineMove.vertical(id: itemId, oldIndex: oldIndex, oldParent: directoryItemManager.parentID.value, newIndex: proposedItemIndex, newParent: proposedParentId)
                    
                }
            }()
            moves.append(move)
            proposedItemIndex += 1
        }
        
        return moves
    }
    
    private func execute(moves: [OutlineMove], execute: Bool) throws {
        
        var executedMoved = [OutlineMove]()
        for move in moves {
            do {
                try self.execute(move: move, execute: execute)
                executedMoved.append(move)
            }
            catch let error {
                do {
                    try revertMoves(moves: executedMoved)
                }
                catch let reverseError {
                    assertionFailure("Error: reversing move exception: \(reverseError)")
                }
                throw error
            }
        }
    }
    
    ///
    /// Returns the items that are not child of another item
    /// inside the items passed in parameter.
    ///
    func computeTopItems<C>(for items: C) -> OrderedSet<String> where C: Collection, C.Element == String {
        
        let itemsIdsSet = Set<String>(items)
        var topElementsArray = OrderedSet<String>()
        
        for itemId in items {
            if !isChildOfAnotherItem(itemId, in: itemsIdsSet) {
                topElementsArray.append(itemId)
            }
        }
        return topElementsArray
    }
    
    private func isChildOfAnotherItem(_ id: String, in itemsIdsSet: Set<String>) -> Bool {
        
        // could be nil since we have history handling now
        guard let directoryItemManager = self.directoryItemManager(withId: id) else {
            return false
        }
        
        // look at the parents to see if they contain
        for parent in directoryItemManager.parentIds {
            if itemsIdsSet.contains(parent) {
                return true
            }
        }
        return false
    }
    
    private func revertMoves(moves: [OutlineMove]) throws {
        
        for move in moves.reversed() {
            try execute(move: move.reversed, execute: true)
        }
    }
    
    private func execute(move: OutlineMove, execute: Bool) throws {
    
        // for the moment we don't use the old index which is
        // stored in both move cases, it should be used when
        // implementing the undo for the outline
        switch move {
        case .horizontal(let id, _, let newIndex):
            
            guard let movedDirectoryItemManager = self.directoryItemManager(withId: id) else {
                assertionFailure("Error: element with id: \(id) does not exists.")
                throw OutlineMoveError.criticalError
            }
            
            // try it
            try moveItemHorizontally(movedDirectoryItemManager, to: newIndex, execute: false)
            
            if execute {
            
                // now we do it
                try moveItemHorizontally(movedDirectoryItemManager, to: newIndex)
            }
            
        case .vertical(let id, _, _, let newIndex, let newParent):
            
            guard let movedDirectoryItemManager = self.directoryItemManager(withId: id) else {
                assertionFailure("Error: element with id: \(id) does not exists.")
                throw OutlineMoveError.criticalError
            }
            
            // try
            try moveItemVertically(movedDirectoryItemManager, to: newIndex, newParent: newParent, execute: false)
            
            if execute {
                
                // now we do it
                try moveItemVertically(movedDirectoryItemManager, to: newIndex, newParent: newParent)
            }
        }
    }
    
    public func directoryItemManagerId(from item: Any?) -> String? {
        
        if let projectOutlineItem = item as? DirectoryItemManager {
            return projectOutlineItem.id
        }
        else {
            assert(item == nil)
            return self.documentId
        }
    }
    
    private func insertItem(with id: String, at index: Int, in newParentId: String, execute: Bool = true, validateSameName: Bool = true) throws {
        
        guard let destinationDirectoryManager = self.directoryItemManager(withId: newParentId) as? DirectoryManager else {
            throw OutlineMoveError.destinationDoesNotExist
        }
        
        if destinationDirectoryManager.parentIds.contains(id) {
            throw OutlineMoveError.canNotMoveDirectoryUnderItself
        }
        
        
        guard let directoryItemManager = self.directoryItemManager(withId: id) else {
            // no assert because the user can actually try to do it
            throw OutlineMoveError.destinationDoesNotExist
        }
        
        // validate there not an item with the same name
        if validateSameName {
            for existingDirectoryItemManager in destinationDirectoryManager.directoryItems {
                
                if existingDirectoryItemManager.name.value.lowercased() == directoryItemManager.name.value.lowercased() {
                    throw OutlineMoveError.itemWithSameNameAlreadyExist(name: existingDirectoryItemManager.name.value)
                }
            }
        }
        
        if execute {
            
            // set the new parent in the item itself
            let insertInParentAction: DirectoryAction = {
                if index != -1 {
                    return DirectoryAction.addItem(id: id, index: index)
                }
                else {
                    // insert at the end
                    return DirectoryAction.addItem(id: id, index: destinationDirectoryManager.directoryItemsIds.count)
                }
            }()
            
            try dispatcher?.online(store: destinationDirectoryManager.directoryStore, action: insertInParentAction)
        }
    }
    
    private func updateItemParent(with id: String, to newParentId: String, execute: Bool = true) throws {
        
        guard let documentId = self.documentId else {
            assertionFailure("Error: document id is nil")
            throw OutlineMoveError.criticalError
        }
        
        if newParentId == documentId {
            
            guard let movedDirectoryManager = self.directoryItemManager(withId: id) as? DirectoryManager else {
                throw OutlineMoveError.onlyDirectoryCanBecomeGroup
            }
            
            if execute {
                try movedDirectoryManager.setParent(to: newParentId)
                assert(movedDirectoryManager.parentID.value == newParentId)
            }
        }
        else {
        
            guard let movedDirectoryItemManager = self.directoryItemManager(withId: id) else {
                throw OutlineMoveError.onlyDirectoryCanBecomeGroup
            }
            
            if execute {
                
                do {
                    try movedDirectoryItemManager.setParent(to: newParentId)
                    assert(movedDirectoryItemManager.parentID.value == newParentId)
                }
                catch {
                    assertionFailure("Error: unsupported element type: \(type(of: self))")
                    throw OutlineMoveError.criticalError
                }
            }
        }
    }
 
    private func removeItem(with id: String, from actualParentId: String, execute: Bool = true) throws {
        
        if execute {
            
            guard let previousParentManager = self.directoryItemManager(withId: actualParentId) else {
                assertionFailure("Error: actual parent with id: \(actualParentId) is nil")
                return
            }
            
            guard let previousDirectoryManager = previousParentManager as? DirectoryManager else {
                assertionFailure("Error: actual parent is not a directory.")
                return
            }
            
            // remove the item from the old parent directory
            try dispatcher?.online(store: previousDirectoryManager.directoryStore, action: DirectoryAction.removeItem(id: id))
        }
    }
    
    private func moveItemVertically(_ item: DirectoryItemManager, to targetIndexInsideNewParent: Int, newParent: String, execute: Bool = true) throws {
     
        guard newParent != item.id else {
            throw OutlineMoveError.canNotMoveDirectoryUnderItself
        }
        
        // try
        try removeItem(with: item.id, from: item.parentID.value, execute: execute)
        try insertItem(with: item.id, at: targetIndexInsideNewParent, in: newParent, execute: execute)
        try updateItemParent(with: item.id, to: newParent, execute: execute)
        
        if execute {
            
            #if DEBUG
            guard let directoryItemManager = self.directoryItemManager(withId: item.id) else {
                assertionFailure("Error: no directoryItemManager with id: \(item.id)")
                throw OutlineMoveError.destinationDoesNotExist
            }
            assert(directoryItemManager.parentID.value == newParent)
            #endif
            
            updateTextManagersArray()
            updateDirectoryItemManagers()
        }
    }
    
    private func moveItemHorizontally(_ item: DirectoryItemManager, to targetIndexInsideParent: Int, execute: Bool = true) throws {
        
        let parentId = item.parentID.value
        
        guard let directoryItemManager = self.directoryItemManager(withId: parentId) else {
            assertionFailure("Error: no directoryItemManager with id: \(parentId)")
            throw OutlineMoveError.destinationDoesNotExist
        }
        
        guard let directoryManager = directoryItemManager as? DirectoryManager else {
            assertionFailure("Error: no directoryItemManager is not a DirectoryManager")
            throw OutlineMoveError.destinationDoesNotExist
        }
        
        guard let currentIndexInsideParent = directoryManager.indexOfChild(whithId: item.id) else {
            assertionFailure("Error: cannot move an item horizontally if it has no index inside the actual parent")
            throw OutlineMoveError.destinationDoesNotExist
        }

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("original array : %@", log: Log.WriterCommon.all, type: .info, %%self.textManagersIdsArray)
        #endif
        
        try removeItem(with: item.id, from: parentId, execute: execute)
        let adjustedTargetIndexInsideParent = targetIndexInsideParent > currentIndexInsideParent ? targetIndexInsideParent-1 : targetIndexInsideParent
        try insertItem(with: item.id, at: adjustedTargetIndexInsideParent, in: parentId, execute: execute, validateSameName: false)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("original array : %@", log: Log.WriterCommon.all, type: .info, %%self.textManagersIdsArray)
        #endif
        
        if execute {
            updateTextManagersArray()
            updateDirectoryItemManagers()
        }
    }
    
    private func updateTextManagersArray() {
        
        let destinationArray = self.textManagersIdsArray
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("original array : %@", log: Log.WriterCommon.all, type: .info, %%_textManagers.values)
        #endif
        
        let moves = _textManagers.values.movesOperations(to: destinationArray)

        // it's possible for move count to be greater than one
        // when we are moving a directory which contains multiple files
        // but this case is supported as long only one "root" is move at
        // a time.
        // assert(moves.count <= 1, "For the moment we do not support more than one move.")
        for move in moves {
            self._textManagers.move(elementAt: move.source, to: move.destination)
        }

        assert(destinationArray == _textManagers.values, "Expected: \(destinationArray) received: \(_textManagers.values)")
    }
    
    private func updateDirectoryItemManagers() {
        
        let actualDirectoryItemsManagers = self.actualDirectoryItemsManagers
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("original array : %@", log: Log.WriterCommon.all, type: .info, %%_textManagers.values)
        #endif
        
        self.directoryItemManagers.applyMoves(to: actualDirectoryItemsManagers)
    }
    
}
