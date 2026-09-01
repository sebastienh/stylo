//
//  DirectoryManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-26.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Common
import os

public final class DirectoryManager: NSObject, ResourceModelManager, Observer {
    
    public var priority: ObserverPriority {
        return .background
    }
    
    public let id: String
    
    public let parentID: Dynamic<String>
    
    public let name: Dynamic<String>
    
    public var directoryItemsIds: DynamicArray<String>
    
    public var isEmpty: Bool {
        
        return directoryItemsIds.isEmpty
    }
    
    public var itemsCount: Int {
        return directoryItemsIds.count
    }
    
    public var firstItemId: String? {
        
        return directoryItemsIds.values.first
    }
    
    public var lastItemId: String? {
        
        return directoryItemsIds.values.last
    }

    public var lastItem: DirectoryItemManager? {
        
        if let lastItemId = self.lastItemId {
            guard let directoryItem = self.sourceSetManager?.directoryItemManager(withId: lastItemId) else {
                assertionFailure("Error: item with id \(lastItemId) is not present in directoryItemManager")
                return nil
            }
            return directoryItem
        }
        return nil
    }
    
    public let pathComponents: DynamicArray<String>
    
    /// This returns the last text id in the current dirctory
    /// without considering subdirectories
    public var lastTextItemId: String? {
        
        for directoryItemsId in directoryItemsIds.reversed() {
            
            guard let directoryItem = self.sourceSetManager?.directoryItemManager(withId: directoryItemsId) else {
                assertionFailure("Error: item with id \(directoryItemsId) is not present in directoryItemManager")
                return nil
            }
            
            if directoryItem is TextManager {
                return directoryItemsId
            }
            else if let directoryManager = directoryItem as? DirectoryManager {
                if let lastTextItemId = directoryManager.lastTextItemId {
                    return lastTextItemId
                }
            }
        }
        return nil
    }
    
    // This will consider subdirectories also and return the last text id
    // considering all subdirectories
    public var recursiveLastTextItemId: String? {
        
        for directoryItemsId in directoryItemsIds.reversed() {
            
            guard let directoryItem = self.sourceSetManager?.directoryItemManager(withId: directoryItemsId) else {
                assertionFailure("Error: item with id \(directoryItemsId) is not present in directoryItemManager")
                return nil
            }
            
            switch directoryItem {
            case let directoryManager as DirectoryManager:
                if let recursiveLastTextItemId = directoryManager.recursiveLastTextItemId {
                    return recursiveLastTextItemId
                }
            case let textManager as TextManager:
                return textManager.id
            default:
                assertionFailure("Error: unhandled directory item type: \(type(of: directoryItem))")
                return nil
            }
        }
        return nil
    }
    
    public var isTopDirectory: Bool {
        
        guard let topDirectory = self.sourceSetManager?.topDirectory else {
            assertionFailure("Error: sourceSetManager.topDirectory is nil")
            return false
        }
        
        return topDirectory.containsItem(withId: id)
    }

    var descendantsItemManagers: [String] {
        
        var itemManagers = [String]()
        for item in self.directoryItems {
            switch item {
            case let textManager as TextManager:
                itemManagers.append(textManager.id)
            case let directoryManager as DirectoryManager:
                itemManagers.append(contentsOf: directoryManager.descendantsItemManagers)
            default:
                assertionFailure("Error: unhandled item of type: \(type(of: item))")
                break
            }
        }
        return itemManagers
    }

    var selfIncludingDescendantsDirectoryManagers: [String] {
        
        var itemManagers = [self.id]
        for item in self.directoryItems {
            switch item {
            case let textManager as TextManager:
                itemManagers.append(textManager.id)
            case let directoryManager as DirectoryManager:
                itemManagers.append(contentsOf: directoryManager.selfIncludingDescendantsDirectoryManagers)
            default:
                assertionFailure("Error: unhandled item of type: \(type(of: item))")
                break
            }
        }
        return itemManagers
    }
    
    
    var descendantsTextManagers: [String] {
        
        var textManagers = [String]()
        for item in self.directoryItems {
            
            switch item {
            case _ as TextManager:
                textManagers.append(item.id)
            case let directoryManager as DirectoryManager:
                textManagers.append(contentsOf: directoryManager.descendantsTextManagers)
            default:
                assertionFailure("Error: unhandled item of type: \(type(of: item))")
                break
            }
        }
        return textManagers
    }
    
    public var directoryItems: [DirectoryItemManager] {
        
        return directoryItemsIds.compactMap({ (id) -> DirectoryItemManager? in
            guard let item = self.sourceSetManager?.directoryItemManager(withId: id) else {
                // this error can happen if the file saved was corrupted, the code is still right
                // so we dont need to assert failure
                return nil
            }
            return item
        })
    }
    
    public var title: String {
        get {
            return self.name.value
        }
        set {
            
            try? self.rename(to: newValue)
        }
    }
    
    public weak var sourceSetManager: SourceSetManager?
    
    let directoryStore: DirectoryStore
    
    var documentDispatcher: Dispatcher? {

        return self.sourceSetManager?.dispatcher
    }
    
    var nextAvailableUntitledDirectoryName: String {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: sourceSetManager is nil")
            let hasher = Hashids(salt: "directory")
            guard let code = hasher.encode(Int.random(in: 0..<Int.max)) else {
                assertionFailure("Error: code is nil")
                return Constants.Filename.DefaultDirectoryName
            }
            return "\(Constants.Filename.DefaultDirectoryName) \(code)"
        }
        
        var itemWithDefaultUntitledNameExists: Bool = false
        var directoryItemNames = [String]()
        let directoryItemManagers = sourceSetManager.directoryItemManagersArray(with: directoryItemsIds.values)
        
        for directoryItemManager in directoryItemManagers {
            
            let itemName = directoryItemManager.name.value
            
            if itemName.lowercased() == Constants.Filename.DefaultDirectoryName.lowercased() {
                itemWithDefaultUntitledNameExists = true
            }
            directoryItemNames.append(directoryItemManager.name.value)
        }
        
        if !itemWithDefaultUntitledNameExists {
            return Constants.Filename.DefaultDirectoryName
        }
        return "\(Constants.Filename.DefaultDirectoryName) \(directoryItemNames.nextFreeEndNumber)"
    }
    
    var nextAvailableUntitledTextName: String {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: sourceSetManager is nil")
            let hasher = Hashids(salt: "text")
            guard let code = hasher.encode(Int.random(in: 0..<Int.max)) else {
                assertionFailure("Error: code is nil")
                return Constants.Filename.DefaultTextName
            }
            return "\(Constants.Filename.DefaultTextName) \(code)"
        }
        
        var itemWithDefaultUntitledNameExists: Bool = false
        var directoryItemNames = [String]()
        let directoryItemManagers = sourceSetManager.directoryItemManagersArray(with: directoryItemsIds.values)
        
        for directoryItemManager in directoryItemManagers {
            
            let itemName = directoryItemManager.name.value
            
            if itemName.lowercased() == Constants.Filename.DefaultTextName.lowercased() {
                itemWithDefaultUntitledNameExists = true
            }
            directoryItemNames.append(directoryItemManager.name.value)
        }
        
        if !itemWithDefaultUntitledNameExists {
            return Constants.Filename.DefaultTextName
        }
        return "\(Constants.Filename.DefaultTextName) \(directoryItemNames.nextFreeEndNumber)"
    }
    
    init(sourceSetManager: SourceSetManager, parentId: String, name: String, id: String = UUID().uuidString) {
        
        
        if Int(parentId) == 0 {
            debugPrint("here")
        }
        self.id = id
        self.sourceSetManager = sourceSetManager
        self.directoryStore = DirectoryStore(id: id, name: name, parentId: parentId)
        self.parentID = Dynamic<String>(parentId)
        self.name = Dynamic<String>(name)
        self.directoryItemsIds = DynamicArray<String>()
        self.pathComponents = DynamicArray<String>()
        super.init()
        subscribeToStore()
        registerDirectoryStore()
    }
    
    init(name: String, sourceSetManager: SourceSetManager, directoryMetadata: DirectoryMetadata, parentId: String) {
        
        self.sourceSetManager = sourceSetManager
        self.directoryStore = DirectoryStore(directoryMetadata: directoryMetadata, name: name, parentId: parentId)
        self.id = directoryMetadata.id
        self.parentID = Dynamic<String>(parentId)
        self.name = Dynamic<String>(name)
        self.directoryItemsIds = DynamicArray<String>()
        self.pathComponents = DynamicArray<String>()
        super.init()
        subscribeToStore()
        registerDirectoryStore()
    }
    
    func globalTextIdOfFirstTextBefore(index localIndex: Int) -> String? {
    
        guard localIndex != 0 else {
            assertionFailure("Error: requesting global index of item before the first one.")
            return nil
        }
        
        guard !self.isEmpty else {
            assertionFailure("Error: requesting global index of item before local index in empty directory")
            return nil
        }
        
        guard let recursiveLastTextItemIdBefore = self.recursiveLastTextItemId(beforeIndex: localIndex) else {
            assertionFailure("Error: recursiveLastTextItemIdBefore is nil")
            return  nil
        }
        
        return recursiveLastTextItemIdBefore
    }
    
    private func recursiveLastTextItemId(beforeIndex localIndex: Int) -> String? {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: sourceSetManager is nil")
            return nil
        }
        
        for directoryItemsId in directoryItemsIds.values[0..<localIndex].reversed() {
            
            guard let directoryItem = sourceSetManager.directoryItemManager(withId: directoryItemsId) else {
                assertionFailure("Error: item with id \(directoryItemsId) is not present in directoryItemManager")
                return nil
            }
            
            switch directoryItem {
            case let directoryManager as DirectoryManager:
                if let recursiveLastTextItemId = directoryManager.recursiveLastTextItemId {
                    return recursiveLastTextItemId
                }
            case let textManager as TextManager:
                return textManager.id
            default:
                assertionFailure("Error: unhandled directory item type: \(type(of: directoryItem))")
                return nil
            }
        }
        return nil
    }
    
    
    func lastTextManager(untilItemWithId id: String, previousLastTextManager: inout TextManager?, found: inout Bool) {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: sourceSetManager is nil")
            previousLastTextManager = nil
            found = false
            return
        }
        
        for itemId in self.directoryItemsIds {
            
            if !found {
                if itemId == id {
                    found = true
                    break
                }
                
                guard let item = sourceSetManager.directoryItemManager(withId: itemId) else {
                    assertionFailure("Error: directory item with id: \(itemId) is nil")
                    continue
                }
                
                switch item {
                case let textManager as TextManager:
                    previousLastTextManager = textManager
                case let directoryManager as DirectoryManager:
                    directoryManager.lastTextManager(untilItemWithId: id, previousLastTextManager: &previousLastTextManager, found: &found)
                default:
                    assertionFailure("Error: unhandled item of type: \(type(of: item))")
                    break
                }
            }
            else {
                break
            }
        }
    }
    
    func containsItem(withId itemId: String) -> Bool {
        
        return indexOfChild(whithId: itemId) != nil
    }
    
    func removeChild(whithId childId: String) throws {
        
        assert(self.documentDispatcher != nil)
        try documentDispatcher?.online(store: self.directoryStore, action: DirectoryAction.removeItem(id: childId))
    }
    
    public func childId(at index: Int) -> String? {
        
        if index < self.directoryItemsIds.values.count {
            return self.directoryItemsIds.values[index]
        }
        return nil
    }
    
    public func indexOfChild(whithId childId: String) -> Int? {
        
        for (index, itemId) in self.directoryItemsIds.values.enumerated() {
            if itemId == childId {
                return index
            }
        }
        return nil
    }
    
    func textIndexOfChild(whithId childId: String) -> Int? {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: sourceSetManager is nil")
            return nil
        }
        
        guard let item = sourceSetManager.directoryItemManager(withId: childId) else {
            assertionFailure("Error: directory item with id: \(childId) is nil")
            return nil
        }
        
        guard item is TextManager else {
            assertionFailure("Error: item is not TextManager")
            return nil
        }
        
        var count = 0
        
        for itemId in self.directoryItemsIds.values {
            
            if itemId == childId {
                return count
            }
            
            guard let item = sourceSetManager.directoryItemManager(withId: itemId) else {
                assertionFailure("Error: directory item with id: \(itemId) is nil")
                return nil
            }
            
            if item is TextManager {
                count += 1
            }
        }
        return nil
    }
    
    
    public func rename(to name: String) throws {
    
        assert(self.documentDispatcher != nil)
        try canRename(to: name)
        try documentDispatcher?.online(store: self.directoryStore, action: DirectoryAction.rename(name: name))
        try self.updatePathComponents()
    }
    
    @discardableResult
    public func addEmptyTextManager(document: TextDocument) -> TextManager? {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: sourceSetManager is nil")
            return nil
        }
        
        guard let documentDispatcher = self.documentDispatcher else {
            assertionFailure("Error: self.documentDispatcher is nil")
            return nil
        }
        
        // we take the first directory in the case of this method
        let textManager = TextManager(title: nextAvailableUntitledTextName, id: UUID().uuidString, sourceSetManager: sourceSetManager, parentID: self.id, dispatcher: documentDispatcher)
        textManager.undoManager = self.sourceSetManager?.document?.undoManager
        
        textManager.setText(string: Constants.Markdown.newTextStringContent)
        textManager.compileInitialDocument()
        
        guard let styleManager = document.styleSetManager?.selectedStyleManager.value else {
            assertionFailure("Error: styleManager is nil")
            return textManager
        }
        
        try? textManager.setStyle(withStyleManager: styleManager, visibleRanges: textManager.visibleRanges)
        return textManager
    }
    
    public func addTextManager(document: TextDocument, string: String) -> TextManager? {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: sourceSetManager is nil")
            return nil
        }
        
        guard let documentDispatcher = self.documentDispatcher else {
            assertionFailure("Error: self.documentDispatcher is nil")
            return nil
        }
        
        let textManager = TextManager(title: nextAvailableUntitledTextName, id: UUID().uuidString, sourceSetManager: sourceSetManager, parentID: self.id, dispatcher: documentDispatcher)
        textManager.undoManager = self.sourceSetManager?.document?.undoManager
        
        textManager.setText(string: string)
        textManager.compileInitialDocument()
        
        guard let styleManager = document.styleSetManager?.selectedStyleManager.value else {
            assertionFailure("Error: styleManager is nil")
            return textManager
        }
        
        try? textManager.setStyle(withStyleManager: styleManager, visibleRanges: textManager.visibleRanges)
        return textManager
    }
    
    private func subscribeToStore() {
        
        self.name.bind(to: self.directoryStore.name)
        
        self.directoryStore.parentID.subscribe({ [weak self](newParentId) in
            self?.parentID.setValue(newParentId)
            try? self?.updatePathComponents()
            self?.updateDescendantsPathsComponents()
        }, observer: self)
        
        self.directoryStore.pathComponents.subscribe({ [weak self](change) in
            self?.handlePathComponentsChange(change)
            self?.updateDescendantsPathsComponents()
        }, observer: self)
        
        self.directoryStore.directoryItemsIds.subscribe({ [weak self](arrayChange) in
            switch arrayChange {
            case .insert(let newElement, let index, _):
                self?.directoryItemsIds.insert(newElement, at: index)
            case .deletes(let indexes, _, _):
                self?.directoryItemsIds.remove(atIndexes: indexes)
            case .inserts(let newElements, let indexes, _):
                self?.directoryItemsIds.insert(newElements: newElements, at: indexes)
            case .move(_, let sourceIndex, let targetIndex, _):
                self?.directoryItemsIds.move(elementAt: sourceIndex, to: targetIndex)
            case .end: fallthrough
            case .start:
                break
            }
        }, observer: self)
    }
    
    private func updateDescendantsPathsComponents() {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: sourceSetManager is nil")
            return
        }
        
        for descendantItemManager in self.descendantsItemManagers {
            
            guard let item = sourceSetManager.directoryItemManager(withId: descendantItemManager) else {
                assertionFailure("Error: directory item with id: \(descendantItemManager) is nil")
                continue
            }
            
            try? item.updatePathComponents()
        }
    }
    
    private func registerDirectoryStore() {
        
        assert(self.documentDispatcher != nil)
        self.documentDispatcher?.register(store: directoryStore)
    }
    
    deinit {
        self.directoryStore.parentID.unsubscribe(observer: self)
        self.directoryStore.parentID.unsubscribe(observer: self)
        self.name.unbind(from: self.directoryStore.name)
        self.directoryStore.pathComponents.unsubscribe(observer: self)
        self.directoryStore.directoryItemsIds.unsubscribe(observer: self)
    }
}
