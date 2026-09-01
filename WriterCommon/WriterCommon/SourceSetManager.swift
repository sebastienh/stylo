//
//  SourceSetManager.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-10-11.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import os


public class SourceSetManager {
    
    weak var document: TextDocument?
    
    public var topDirectory: DirectoryManager?
    
    var dispatcher: StyloDocumentDispatcher? {
        
        return self.document?.documentDispatcher
    }
    
    public var firstDirectoryManager: DirectoryManager? {
        
        return topLevelDirectoryItemManagers.first as? DirectoryManager
    }
    
    var topLevelDirectoryItemManagers: [DirectoryItemManager] {
        
        guard let topDirectory = self.topDirectory else {
            assertionFailure("Error: self.topDirectory is nil")
            return []
        }
        
        return topDirectory.directoryItems
    }
    
    var textManagersArray: [TextManager] {
        
        return directoryItemManagers.values.compactMap { (entry) -> TextManager? in
            let (_, directoryItemManager) = entry
            if let textManager = directoryItemManager as? TextManager {
                return textManager
            }
            return nil
        }
    }
    
    var directoryManagers: [DirectoryManager] {
        
        return directoryItemManagers.values.compactMap { (entry) -> DirectoryManager? in
            
            let (_, directoryItemManager) = entry
            if let directoryManager = directoryItemManager as? DirectoryManager {
                return directoryManager
            }
            return nil
        }
    }
    
    var strings: [String] {
        return textManagersArray.map { (textManager) -> String in
            textManager.string
        }
    }
    
    var globalString: String {
        return strings.reduce(into: "", { (res, string) in
            res += string
        })
    }
    
    let sourceSetStore: SourceSetStore
    
    var nextAvailableUntitledGroupName: String {
        
        var directoryNames = [String]()
        
        var directoryWithDefaultUntitledNameExists: Bool = false
        
        for topLevelDirectoryItemManager: DirectoryItemManager in topLevelDirectoryItemManagers {
            
            let topLevelDirectoryManager = topLevelDirectoryItemManager as? DirectoryManager
            
            assert(topLevelDirectoryManager != nil)
            if let topLevelDirectoryManager = topLevelDirectoryManager {
                
                let directoryName = topLevelDirectoryManager.name.value
                
                if directoryName.lowercased() == Constants.Filename.DefaultFilesGroupName.lowercased() {
                    directoryWithDefaultUntitledNameExists = true
                }
                
                directoryNames.append(topLevelDirectoryManager.name.value)
            }
        }
        
        if !directoryWithDefaultUntitledNameExists {
            return Constants.Filename.DefaultFilesGroupName
        }
        return "\(Constants.Filename.DefaultFilesGroupName) \(directoryNames.nextFreeEndNumber)"
    }
    
    public var documentId: String? {
        
        assert(document?.documentManager != nil)
        assert(document?.documentManager?.id != nil)
        return document?.documentManager?.id
    }
    
    public var directoryItemsManagersArray: [DirectoryItemManager] {
        
        return directoryItemManagers.values.map { $0.1 }
    }
    
    ///
    /// Note: we need to keep this value internal since FilesOutlineManager
    /// need to subscribe to it to know when to remove expanded items.
    let directoryItemManagers: DynamicOrderedDictionary<String, DirectoryItemManager>
    
    /// An ordered array of all the text managers ids
    let _textManagers: DynamicArray<String>
    
    public init(document: TextDocument) {
        
        self.document = document
        self.directoryItemManagers = DynamicOrderedDictionary<String, DirectoryItemManager>()
        self._textManagers = DynamicArray<String>()
        self.sourceSetStore = SourceSetStore()
    }
    
    init(document: TextDocument, sourceSetMetadata: SourceSetMetadata) {
        
        self.document = document
        // this is a default which can replaced when reading
        // an existing document
        self.directoryItemManagers = DynamicOrderedDictionary<String, DirectoryItemManager>()
        self._textManagers = DynamicArray<String>()
        self.sourceSetStore = SourceSetStore(sourceSetMetadata: sourceSetMetadata)
    }
    
    public func needsToDisplayWorkingOverlay(forTextWithIds textIds: [TextId]) -> Bool {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("needsToDisplayWorkingOverlay(forTextWithIds: %@)", log: Log.WriterCommon.all, type: .info, %%textIds)
        #endif
        
        var charactersCount = 0
        
        for textId in textIds {
        
            guard let textManager = self.textManager(withId: textId) else {
                charactersCount += 0
                continue
            }
        
            let textManagerCharactersCount = textManager.string.count
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("needsToDisplayWorkingOverlay -> textManagerCharactersCount: %@  for textManager with name: %@", log: Log.WriterCommon.all, type: .info, %%textManagerCharactersCount, %%textManager.name.value)
            #endif
            
            charactersCount += textManagerCharactersCount
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("needsToDisplayWorkingOverlay -> charactersCount: %@", log: Log.WriterCommon.all, type: .info, %%charactersCount)
        #endif
        
        return charactersCount > 40000
    }
    
    
    public func textManager(withId id: TextId) -> TextManager? {
        
        guard let directoryItemManager = self.directoryItemManager(withId: id) else {
            // we may have deleted the manager
            return nil
        }
        
        switch directoryItemManager {
        case _ as DirectoryManager:
            assertionFailure("Error: ")
            return nil
        case let textManager as TextManager:
            return textManager
        default:
            assertionFailure("Error: ")
            return nil
        }
    }
    
    public func directoryItemManagerExists(withId id: String) -> Bool {
        
        return self.directoryItemManager(withId: id) != nil
    }
    
    public func directoryItemManager(withId id: String) -> DirectoryItemManager? {
        
        if id == self.topDirectory?.id {
            return self.topDirectory
        }
        
        return directoryItemManagers.values[id]
    }

    public func globalIndex(ofDirectoryItemManagerWithId id: String) -> Int? {
        
        return self.directoryItemManagers.values.index(forKey: id)
    }
    
    public func indexInParentOfItem(_ directoryItemManager: DirectoryItemManager) -> Int? {
        
        guard let parent = self.directoryItemManager(withId: directoryItemManager.parentID.value) else {
            assertionFailure("Error: parent is nil")
            return nil
        }
            
        guard let directoryManager = parent as? DirectoryManager else {
            assertionFailure("Error: parent is not DirectoryManager")
            return  nil
        }
            
        return  directoryManager.indexOfChild(whithId: directoryItemManager.id)
    }
    
    public func appendDirectoryItemManager(_ directoryItemManager: DirectoryItemManager, withId id: String) {
        
        directoryItemManagers.insertValue(directoryItemManager, forKey: id, at: directoryItemManagers.count)
    }
    
    public func addDirectoryItemManager(_ directoryItemManager: DirectoryItemManager, withId id: String, afterItemWithId itemId: String) {
    
        guard let itemIndex = self.directoryItemManagers.values.index(forKey: itemId) else {
            assertionFailure("Error: index is nil for item with id: \(itemId)")
            return
        }
        
        self.directoryItemManagers.insertValue(directoryItemManager, forKey: id, at: itemIndex+1)
    }
    
    public func addDirectoryItemManager(_ directoryItemManager: DirectoryItemManager, withId id: String, atStartOfParentWithId parentId: String) {
        
        guard let parentStartIndex = self.startIndex(ofDirectoryWithId: parentId) else {
            assertionFailure("Error: parentEndIndex is nil")
            return
        }
        
        directoryItemManagers.insertValue(directoryItemManager, forKey: id, at: parentStartIndex)
    }
    
    
    public func addDirectoryItemManager(_ directoryItemManager: DirectoryItemManager, withId id: String, atEndOfParentWithId parentId: String) {
        
        guard let parentEndIndex = self.endIndex(ofDirectoryWithId: parentId) else {
            assertionFailure("Error: parentEndIndex is nil")
            return
        }
        
        directoryItemManagers.insertValue(directoryItemManager, forKey: id, at: parentEndIndex)
    }
    
    public func addDirectoryItemManager(_ directoryItemManager: DirectoryItemManager, withId id: String, atIndex index: Int) {
        
        directoryItemManagers.insertValue(directoryItemManager, forKey: id, at: index)
    }

    public func indexOf(itemId: String, in parentId: String) -> Int? {
        
        guard let topDirectory = self.topDirectory else {
            assertionFailure("Error: self.topDirectory is nil")
            return nil
        }
        
        if topDirectory.id == parentId {
            return topDirectory.indexOfChild(whithId: itemId)
        }
        else {
        
            guard let directoryManager = self.directoryItemManagers.values[parentId] as? DirectoryManager else {
                assertionFailure("Error: item with id: \(parentId) is nil or not a DirectoryManager")
                return nil
            }
            
            return directoryManager.indexOfChild(whithId: itemId)
        }
    }
    
    func removeItem(withId id: String) {
        
        // the item may have already been removed
        if let itemManager = self.directoryItemManagers.values[id] {

            switch itemManager {
            case let directoryManager as DirectoryManager:
            
                for directoryItemsId in directoryManager.directoryItemsIds.values {
                    removeItem(withId: directoryItemsId)
                }
                
                let parentId = directoryManager.parentID.value
                
                if parentId != self.topDirectory?.id {
                    
                    let parentDirectoryManager = self.directoryItemManagers.values[parentId] as? DirectoryManager
                    assert(parentDirectoryManager != nil, "Error: item with id: \(parentId) is not a DirectoryManager")
                    try? parentDirectoryManager?.removeChild(whithId: id)
                }
                else {
                    
                    let parentDirectoryManager = self.topDirectory
                    assert(parentDirectoryManager != nil, "Error: item with id: \(parentId) is not a DirectoryManager")
                    try? parentDirectoryManager?.removeChild(whithId: id)
                }

                dispatcher?.documentState?.remove(store: directoryManager.directoryStore)
                
            case let textManager as TextManager:
                
                let parentId = textManager.parentID.value
                let parentDirectoryManager = self.directoryItemManagers.values[parentId] as? DirectoryManager
                
                assert(parentDirectoryManager != nil, "Error: item with id: \(parentId) is not a DirectoryManager")
                try? parentDirectoryManager?.removeChild(whithId: id)
                dispatcher?.documentState?.remove(store: textManager.markdownDocumentStore)
                guard let textManagerIndex = self._textManagers.values.index(of: id) else {
                    assertionFailure("Error: no text manager with id: \(id)")
                    break
                }
                self._textManagers.remove(atIndex: textManagerIndex)
            default:
                assertionFailure("Error: unhandled type: \(type(of: itemManager))")
                break
            }
            
            self.directoryItemManagers.removeValue(forKey: itemManager.id)
        }
    }
    
    public func createEmptyTextManager(under itemId: String) -> TextManager? {
        
        guard let document = self.document else {
            assertionFailure("Error: self.document is nil")
            return nil
        }
        
        guard let parentItem = self.directoryItemManagers.values[itemId] else {
            assertionFailure("Error: item with id: \(itemId) is nil")
            return nil
        }
        
        guard let directoryManager = parentItem as? DirectoryManager else {
            assertionFailure("Error: item with id: \(itemId) is not a DirectoryManager")
            return nil
        }
        
        return directoryManager.addEmptyTextManager(document: document)
    }
    
    func renameUserFilesGroupsManager(at index: Int, to name: String) throws {
        
        guard let topDirectory = self.topDirectory else {
            assertionFailure("Error: self.topDirectory is nil")
            throw DirectoryItemError.missingTopDirectory
        }
        
        guard index < topDirectory.directoryItems.count && index >= 0 else {
            assertionFailure("Error: invalid top directory manager index: \(index) ")
            throw DirectoryItemError.notExistingItem(index: index)
        }
        
        guard let directoryManager = topDirectory.directoryItems[index] as? DirectoryManager else {
            assertionFailure("Error: item is not a DirectoryManager")
            throw DirectoryItemError.notDirectory
        }
        try directoryManager.rename(to: name)
    }
    
    public func topLevelDirectory(at index: Int) -> DirectoryManager? {
        
        guard let topDirectory = self.topDirectory else {
            assertionFailure("Error: self.topDirectory is nil")
            return nil
        }
        
        guard index < topDirectory.directoryItems.count && index >= 0 else {
            assertionFailure("Error: invalid top directory manager index: \(index) ")
            return nil
        }
        
        guard let directoryManager = topDirectory.directoryItems[index] as? DirectoryManager else {
            assertionFailure("Error: item is not a DirectoryManager")
            return nil
        }
        return directoryManager
    }
    
    public func isTopLevelDirectory(id directoryId: String) -> Bool {
        
        guard let topDirectory = self.topDirectory else {
            assertionFailure("Error: self.topDirectory is nil")
            return false
        }
        
        return topDirectory.containsItem(withId: directoryId)
    }
    
    private func startIndex(ofDirectoryWithId directoryId: String) -> Int? {
        
        guard let index = self.directoryItemManagers.values.index(forKey: directoryId) else {
            assertionFailure("Error: index of directoryId: \(directoryId) is nil")
            return nil
        }
        
        return index+1
    }
    
    private func endIndex(ofDirectoryWithId directoryId: String) -> Int? {
        
        guard let directoryManager = self.directoryItemManagers.values[directoryId] else {
            assertionFailure("Error: directoryManager with id: \(directoryId) is nil")
            return nil
        }
        
        guard var index = self.directoryItemManagers.values.index(forKey: directoryId) else {
            assertionFailure("Error: index of directoryId: \(directoryId) is nil")
            return nil
        }
        
        // start at the first index after
        index += 1
        
        // keep the parent
        let targetParentId = directoryManager.parentID.value
        
        while index != self.directoryItemManagers.values.endIndex {
            
            guard let (_, itemManager) = self.directoryItemManagers.values.elementAt(index) else {
                assertionFailure("Error: itemManager at index: \(index) is nil")
                continue
            }
            
            // if the parent of the item is the same as the the containing
            // directory, it means that we are on the same level and we
            // reached the end of the directory.
            if itemManager.parentID.value == targetParentId {
                return index-1
            }
            
            index += 1
        }
        return index
    }
    
    public func firstGroupDirectory(withTitle title: String) -> DirectoryManager? {
    
        guard let topDirectory = self.topDirectory else {
            assertionFailure("Error: self.topDirectory is nil")
            return nil
        }
        
        for directoryItem in topDirectory.directoryItems {
            
            guard let group = directoryItem as? DirectoryManager else {
                assertionFailure("Error: top level directoryItem is not a DirectoryManager")
                return nil
            }
             
            if group.name.value == title {
                return group
            }
        }
        return nil
    }
    
    /// Method that returns a directory item under the top directory
    /// and nil otherwise. 
    public func groupDirectory(withId directoryId: String) -> DirectoryManager? {
        
        guard let topDirectory = self.topDirectory else {
            assertionFailure("Error: self.topDirectory is nil")
            return nil
        }
        
        if topDirectory.containsItem(withId: directoryId) {
            
            guard let directoryItemManager = self.directoryItemManager(withId: directoryId) else {
                assertionFailure("Error: top directory does not contains item with id: \(directoryId)")
                return nil
            }
            
            guard let directoryManager = directoryItemManager as? DirectoryManager else {
                assertionFailure("Error: directoryItemManager is not DirectoryManager")
                return nil
            }
            
            return directoryManager
        }
        return nil
    }
    
    func directoryItemManagersArray(with ids: [String]) -> [DirectoryItemManager] {
        
        var result = [DirectoryItemManager]()
        
        for id in ids {
        
            let directoryItemManager = self.directoryItemManagers.values[id]
            
            assert(directoryItemManager != nil)
            if let directoryItemManager = directoryItemManager {
                
                result.append(directoryItemManager)
            }
        }
        
        return result
    }
    
    func textManager(with id: String) -> TextManager? {
        
        let textManager = directoryItemManagers.values[id] as? TextManager
        assert(textManager != nil)
        return textManager
    }

    @discardableResult
    func addGroup(directoryManager: DirectoryManager) -> DirectoryManager? {
        
        guard let topDirectory = self.topDirectory else {
            assertionFailure("Error: self.topDirectory is nil")
            return nil
        }
        
        try? self.moveItemAtEnd(directoryManager, ofParentWithId: topDirectory.id)
        self.directoryItemManagers.insertValue(directoryManager, forKey: directoryManager.id, at: self.directoryItemManagers.count)
        return directoryManager
    }
    
    @discardableResult
    func addGroup(withTitle title: String) -> DirectoryManager? {
        
        guard let topDirectory = self.topDirectory else {
            assertionFailure("Error: self.topDirectory is nil")
            return nil
        }
        
        let directoryManager = DirectoryManager(sourceSetManager: self, parentId: topDirectory.id, name: title)
        return addGroup(directoryManager: directoryManager)
    }
    
    @discardableResult
    func addUntitledDirectoryToUserFilesGroupsManager() -> DirectoryManager? {
        
        return self.addGroup(withTitle: nextAvailableUntitledGroupName)
    }
    
    public func subscribedToDirectoryItemsManagers(observer: Observer) -> Bool {
        
        return self.directoryItemManagers.subscribed(observer: observer)
    }
    
    public func subscribeToDirectoryItemsManagers(observer: Observer, closure: @escaping DynamicOrderedDictionary<String, DirectoryItemManager>.ObserverClosure) {
        
        self.directoryItemManagers.subscribe(closure, observer: observer)
    }
    
    public func unsubscribeFromDirectoryItemsManagers(observer: Observer) {
        
        self.directoryItemManagers.unsubscribe(observer: observer)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: IdGenerator implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var _hashids: Hashids?
    
    public var nextIntegerSeed: Int {
        assert(false, "Error: should not be calling this method")
        return 0
    }
    
}

