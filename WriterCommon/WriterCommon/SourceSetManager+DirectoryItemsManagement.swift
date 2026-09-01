//
//  SourceSetManager+DirectoryItemsManagement.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-26.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os

extension SourceSetManager {
    
    var actualDirectoryItemsManagers: OrderedDictionary<String, DirectoryItemManager> {
        
        var directoryItemsManagers = OrderedDictionary<String, DirectoryItemManager>()
        loadRootDirectoryItems(in: &directoryItemsManagers)
        return directoryItemsManagers
    }
    
    func loadRootDirectoryItems(in directoryItemsManagers: inout OrderedDictionary<String, DirectoryItemManager>) {
        
        guard let topDirectory = self.topDirectory else {
            assertionFailure("Error: self.topDirectory is nil")
            return
        }
        
        loadDirectoryItems(topDirectory, in: &directoryItemsManagers)
    }
    
    private func loadDirectoryItems(_ directoryManager: DirectoryManager, in directoryItemsManagers: inout OrderedDictionary<String, DirectoryItemManager>) {
        
        for directoryItem in directoryManager.directoryItems {
            switch directoryItem {
            case let directoryManager as DirectoryManager:
                directoryItemsManagers.append((directoryManager.id, directoryManager))
                loadDirectoryItems(directoryManager, in: &directoryItemsManagers)
            case let textManager as TextManager:
                directoryItemsManagers.append((textManager.id, textManager))
            default:
                assertionFailure("Error: unhandled directory item type: \(type(of: directoryItem))")
                continue
            }
        }
    }
    
    public func putItem(_ item: DirectoryItemManager, afterItemWithId itemId: String, inParentWithId parentId: String) throws {
        
        #if DEBUG
        if item is TextManager {
            assert(self._textManagers.values.firstIndex(of: item.id) == nil)
        }
        
        let previousItemIndex = self.directoryItemManagers.values.index(forKey: itemId)!
        
        debugPrint("previous item index: \(previousItemIndex)")
        
        #endif
        
        guard let parentManager = self.directoryItemManager(withId: parentId) else {
            throw NWError.custom(message: "Error: No directory item manager for id: \(parentId).")
        }
        
        guard let parentDirectoryManager = parentManager as? DirectoryManager else {
            throw NWError.custom(message: "Error: parent manager is not a DirectoryManager.")
        }
        
        #if DEBUG
        guard let previousManager = self.directoryItemManager(withId: itemId) else {
            throw NWError.custom(message: "Error: No directory item manager for id: \(itemId).")
        }
        assert(previousManager.id == itemId)
        #endif
        
        // if the item is moved somewhere else
        assert(item.parentID.value == parentId, "we do a putItem, we should not move using this method.")
        if item.parentID.value != parentId {
            try item.removeFromActualParent()
            try item.setParent(to: parentId)
        }
        
        if let textManager = item as? TextManager {
            
            guard let itemIndex = _textManagers.values.firstIndex(of: itemId) else {
                assertionFailure("Error: item with id: \(itemId) is not in the _textManagers")
                return
            }
            
            _textManagers.insert(textManager.id, at: itemIndex+1)
        }
        
        // add the item to the parent directory
        assert(self.dispatcher != nil)
        try dispatcher?.online(store: parentDirectoryManager.directoryStore, action: DirectoryAction.addItemAfter(addedItemId: item.id, existingItemId: itemId))
        assert(item.parentID.value == parentId)
        
        #if DEBUG
        let itemInsertionIndex = self.directoryItemManagers.values.index(forKey: item.id)!
        assert(previousItemIndex+1 == itemInsertionIndex)
        #endif 
        
        try item.updatePathComponents()
    }
    
    public func putItemAtStart(_ item: DirectoryItemManager, ofParentWithId parentId: String) throws {
    
        #if DEBUG
        if item is TextManager {
            assert(self._textManagers.values.firstIndex(of: item.id) == nil)
        }
        #endif
        
        guard let parentManager = self.directoryItemManager(withId: parentId) else {
            throw NWError.custom(message: "Error: No directory item manager for id: \(parentId).")
        }
        
        guard let directoryManager = parentManager as? DirectoryManager else {
            throw NWError.custom(message: "Error: parent manager is not a DirectoryManager.")
        }
        
        // if the item is moved somewhere else
        try item.setParent(to: parentId)
        
        if let textManager = item as? TextManager {
            
            guard let startOfDirectoryTextIndex = self.startOfDirectoryTextIndex(parentId) else {
                assertionFailure("Error: startOfDirectoryTextIndex(..) returned nil")
                return
            }
            
            _textManagers.insert(textManager.id, at: startOfDirectoryTextIndex)
            #if DEBUG
            assert(self.textManagersIdsArray == _textManagers.values, "Expected \(self.textManagersIdsArray) received: \(_textManagers.values)")
            #endif
        }
        
        // add the item to the parent directory
        assert(self.dispatcher != nil)
        try dispatcher?.online(store: directoryManager.directoryStore, action: DirectoryAction.addItem(id: item.id, index: 0))
        
        assert(item.parentID.value == parentId)
        
        try item.updatePathComponents()
    }
        
    public func moveItemAtStart(_ item: DirectoryItemManager, ofParentWithId parentId: String) throws {
        
        #if DEBUG
        if item is TextManager {
            assert(self._textManagers.values.firstIndex(of: item.id) != nil)
        }
        #endif
        
        guard let parentManager = self.directoryItemManager(withId: parentId) else {
            throw NWError.custom(message: "Error: No directory item manager for id: \(parentId).")
        }
        
        guard let directoryManager = parentManager as? DirectoryManager else {
            throw NWError.custom(message: "Error: parent manager is not a DirectoryManager.")
        }
        
        // if the item is moved somewhere else
        if item.parentID.value != parentId {
            try item.removeFromActualParent()
            try item.setParent(to: parentId)
        }
        
        if let textManager = item as? TextManager {
            
            guard let itemCurrentIndex = _textManagers.values.firstIndex(of: textManager.id) else {
                assertionFailure("Error: item with id: \(textManager.id) not existing in _textManagers.")
                return
            }

            guard let directoryStartIndex = self.startOfDirectoryTextIndex(parentId) else {
                assertionFailure("Error: startOfDirectoryTextIndex returned nil")
                return
            }
            
            _textManagers.move(elementAt: itemCurrentIndex, to: directoryStartIndex)
            #if DEBUG
            assert(self.textManagersIdsArray == _textManagers.values, "Expected \(self.textManagersIdsArray) received: \(_textManagers.values)")
            #endif
        }
        
        // add the item to the parent directory
        assert(self.dispatcher != nil)
        try dispatcher?.online(store: directoryManager.directoryStore, action: DirectoryAction.addItem(id: item.id, index: 0))
        
        assert(item.parentID.value == parentId)
        
        try item.updatePathComponents()
    }
    
    // the item is not already in the orderedTextManager (in case item is TextManager)
    public func putItemAtEnd(_ item: DirectoryItemManager, ofParentWithId parentId: String) throws {
        
        #if DEBUG
        if item is TextManager {
            assert(self._textManagers.values.firstIndex(of: item.id) == nil)
        }
        #endif
        
        guard let parentManager = self.directoryItemManager(withId: parentId) else {
            throw NWError.custom(message: "Error: No directory item manager for id: \(parentId).")
        }
        
        guard let directoryManager = parentManager as? DirectoryManager else {
            throw NWError.custom(message: "Error: parent manager is not a DirectoryManager.")
        }
        
        try item.setParent(to: parentId)
        
        if let textManager = item as? TextManager {
            
            guard let endOfDirectoryTextIndex = self.endOfDirectoryTextIndex(parentId) else {
                assertionFailure("Error: endOfDirectoryTextIndex(..) returned nil")
                return
            }
            
            _textManagers.insert(textManager.id, at: endOfDirectoryTextIndex)
        }
        
        // add the item to the parent directory
        assert(self.dispatcher != nil)
        try dispatcher?.online(store: directoryManager.directoryStore, action: DirectoryAction.appendItem(id: item.id))
        
        assert(item.parentID.value == parentId)
        
        try item.updatePathComponents()
        
    }
    
    public func moveItemAtEnd(_ item: DirectoryItemManager, ofParentWithId parentId: String) throws {
        
        #if DEBUG
        if item is TextManager {
            assert(self._textManagers.values.firstIndex(of: item.id) != nil)
        }
        #endif
        
        guard let parentManager = self.directoryItemManager(withId: parentId) else {
            throw NWError.custom(message: "Error: No directory item manager for id: \(parentId).")
        }
        
        guard let directoryManager = parentManager as? DirectoryManager else {
            throw NWError.custom(message: "Error: parent manager is not a DirectoryManager.")
        }
        
        // if the item is moved somewhere else
        if item.parentID.value != parentId {
            try item.removeFromActualParent()
            try item.setParent(to: parentId)
        }
        
        if let textManager = item as? TextManager {
            
            guard let itemCurrentIndex = _textManagers.values.firstIndex(of: textManager.id) else {
                assertionFailure("Error: item with id: \(textManager.id) not existing in _textManagers.")
                return
            }

            guard let endOfDirectoryTextIndex = self.endOfDirectoryTextIndex(parentId) else {
                assertionFailure("Error: endOfDirectoryTextIndex(..) returned nil")
                return
            }
            
            _textManagers.move(elementAt: itemCurrentIndex, to: endOfDirectoryTextIndex)
            #if DEBUG
            assert(self.textManagersIdsArray == _textManagers.values, "Expected \(self.textManagersIdsArray) received: \(_textManagers.values)")
            #endif
        }
        
        // add the item to the parent directory
        assert(self.dispatcher != nil)
        try dispatcher?.online(store: directoryManager.directoryStore, action: DirectoryAction.appendItem(id: item.id))
        
        assert(item.parentID.value == parentId)
        
        try item.updatePathComponents()
    }
    
    private func startOfDirectoryTextIndex(_ directoryId: String) -> Int? {
        
        guard let containingDirectoryItem = self.directoryItemManager(withId: directoryId) else {
            assertionFailure("Error: directoryItemManager with id: \(directoryId) is nil.")
            return nil
        }
        
        guard let containingDirectory = containingDirectoryItem as? DirectoryManager else {
            assertionFailure("Error: containingDirectoryItem is not a DirectoryManager.")
            return nil
        }
        
        guard let topDirectory = self.topDirectory else {
            assertionFailure("Error: self.topDirectory is nil")
            return nil
        }
        
        if !containingDirectory.isEmpty {
            
            // we take the first item and we insert after
            guard let firstItemId = containingDirectory.firstItemId else {
                assertionFailure("Error: lastItemId is nil, not possible since directory is not empty.")
                return nil
            }
            
            guard let nextItemIndex = _textManagers.values.firstIndex(of: firstItemId) else {
                assertionFailure("Error: item with id: \(firstItemId) not existing in _textManagers.")
                return nil
            }
            
            return nextItemIndex
        }
        else {
            
            var lastTextManager: TextManager?
            var found = false
            topDirectory.lastTextManager(untilItemWithId: containingDirectory.id, previousLastTextManager: &lastTextManager, found: &found)
            
            if let lastTextManager = lastTextManager {
                guard let previousItemIndex = _textManagers.values.firstIndex(of: lastTextManager.id) else {
                    assertionFailure("Error: item with id: \(lastTextManager.id) not existing in _textManagers.")
                    return nil
                }
                return previousItemIndex+1
            }
            else {
                
                // insert at start
                return 0
            }
        }
    }
    
    private func endOfDirectoryTextIndex(_ directoryId: String) -> Int? {
        
        guard let containingDirectoryItem = self.directoryItemManager(withId: directoryId) else {
            assertionFailure("Error: directoryItemManager with id: \(directoryId) is nil.")
            return nil
        }
        
        guard let containingDirectory = containingDirectoryItem as? DirectoryManager else {
            assertionFailure("Error: containingDirectoryItem is not a DirectoryManager.")
            return nil
        }
        
        guard let topDirectory = self.topDirectory else {
            assertionFailure("Error: self.topDirectory is nil")
            return nil
        }
        
        var lastTextManager: TextManager?
        var found = false
        topDirectory.lastTextManager(untilItemWithId: containingDirectory.id, previousLastTextManager: &lastTextManager, found: &found)
        
        if let lastTextManager = lastTextManager {
         
            if !containingDirectory.isEmpty {
            
                // we take the last item and we insert after
                // Note that the directory can contain only directory
                // hence the test for this condition here.
                if let lastTextItemId = containingDirectory.lastTextItemId {
                    
                    guard let previousItemIndex = _textManagers.values.firstIndex(of: lastTextItemId) else {
                        assertionFailure("Error: item with id: \(lastTextItemId) not existing in _textManagers.")
                        return nil
                    }
                    return previousItemIndex+1
                }
                else {
                    guard let previousItemIndex = _textManagers.values.firstIndex(of: lastTextManager.id) else {
                        assertionFailure("Error: item with id: \(lastTextManager.id) not existing in _textManagers.")
                        return nil
                    }
                    return previousItemIndex+1
                }
            }
            else {
                
                guard let previousItemIndex = _textManagers.values.firstIndex(of: lastTextManager.id) else {
                    assertionFailure("Error: item with id: \(lastTextManager.id) not existing in _textManagers.")
                    return nil
                }
                return previousItemIndex+1
            }
        }
        else {
            
            if let lastTextItemId = containingDirectory.recursiveLastTextItemId {
                
                guard let previousItemIndex = _textManagers.values.firstIndex(of: lastTextItemId) else {
                    assertionFailure("Error: item with id: \(lastTextItemId) not existing in _textManagers.")
                    return nil
                }
                return previousItemIndex+1
            }
            else {
                return 0
            }
        }
    }
    
    
}
