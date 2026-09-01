//
//  DirectoryItemManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-26.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Igloo

public enum RenameError: LocalizedError {
    
    case empty
    case alreadyExisting(proposedName: String)
    case fileNameTooLong
    case illegalCharacter(character: String)
    
    public var errorDescription: String? {
        
        switch self {
        case .alreadyExisting:
            return "A file with the same name already exists."
        case .empty:
            return "Filename cannot be empty."
        case .fileNameTooLong:
            return "Filename cannot be longer than \(WriterCommon.Constants.Configuration.MaximumFilenameLength) characters."
        case .illegalCharacter(let character):
            return "Illegal character '\(character)'."
        }
    }
}

private enum IllegalFileNamesCharacters: String, CaseIterable {
    
    case slash = "/"
    case endOfString = "\u{0000}"
}

public enum DirectoryItemError: Error {
    case notExistingItem(index: Int)
    case notDirectory
    case missingTopDirectory
}

public enum MoveError: Error {
    case noItemWithId
}

public protocol DirectoryItemManager: Saving {
    
    var id: String { get }
    
    var name: Dynamic<String> { get }
    
    var parentID: Dynamic<String> { get }
    
    var path: String { get }
    
    var pathComponents: DynamicArray<String> { get }
    
    var currentPathComponents: [String] { get }
    
    var sourceSetManager: SourceSetManager? { get }
    
    var isExpandable: Bool { get }
    
    func isVisible(inFilesOutlineManager filesOutlineManager: FilesOutlineManager) -> Bool
    
    func canRename(to newName: String) throws
    
    func setParent(to parentId: String) throws
    
    func removeFromActualParent() throws
    
    func updatePathComponents() throws
    
    func handlePathComponentsChange(_ change: DynamicArray<String>.Change)
}

extension DirectoryItemManager {
    
    public func isVisible(inFilesOutlineManager filesOutlineManager: FilesOutlineManager) -> Bool {
        
        guard let topDirectory = self.sourceSetManager?.topDirectory else {
            assertionFailure("Error: sourceSetManager.topDirectory is nil")
            return false
        }
        
        // we go from top to bottom
        for parentId in self.ordereredLowerToHigherParentIds.reversed() {
            
            if parentId == topDirectory.id {
                continue
            }
            
            if !filesOutlineManager.expandedItems.contains(parentId) {
                return false
            }
        }
        return true
    }
    
    public var parentIds: Set<String> {
        
        return Set<String>(self.ordereredLowerToHigherParentIds)
    }
    
    public var ordereredLowerToHigherParentIds: Array<String> {
        
        var parentIds = Array<String>()
        var currentDirectoryItemId = self.parentID.value
        parentIds.append(currentDirectoryItemId)
        
        while currentDirectoryItemId != self.sourceSetManager?.documentId {
            
            if let parentItem = self.sourceSetManager?.directoryItemManager(withId: currentDirectoryItemId) {
                currentDirectoryItemId = parentItem.parentID.value
                parentIds.append(currentDirectoryItemId)
            }
            else {
                break
            }
        }
        return parentIds
    }
    
    public func removeFromActualParent() throws {
        
        guard let previousParentManager = self.sourceSetManager?.directoryItemManager(withId: self.parentID.value) else {
            assertionFailure("Error: actual parent with id: \(self.parentID.value) is nil")
            return
        }
        
        guard let previousDirectoryManager = previousParentManager as? DirectoryManager else {
            assertionFailure("Error: actual parent is not a directory.")
            return
        }
        
        // remove the item from the old parent directory
        try self.sourceSetManager?.dispatcher?.online(store: previousDirectoryManager.directoryStore, action: DirectoryAction.removeItem(id: self.id))
    }
    
    public func setParent(to parentId: String) throws {
        
        guard let dispatcher = sourceSetManager?.dispatcher else {
            assertionFailure("Error: sourceSetManager is nil")
            throw NWError.custom(message: "Error: sourceSetManager is nil")
        }
        
        let setParentAction = DirectoryAction.setParentId(id: parentId)
        // set the new parent in the item itself
        switch self {
        case let textManager as TextManager:
            assert(self.sourceSetManager?.documentId! != parentId, "Cannot move a text element to the top level.")
            try dispatcher.online(store: textManager.markdownDocumentStore, action: setParentAction)
        case let directoryManager as DirectoryManager:
            try dispatcher.online(store: directoryManager.directoryStore, action: setParentAction)
        default:
            assertionFailure("Error: unsupported element type: \(type(of: self))")
            break
        }
    }
    
    public func handlePathComponentsChange(_ change: DynamicArray<String>.Change) {
        switch change {
        case .end(let updatedArray):
            self.pathComponents.replaceItems(withItems: updatedArray)
        default:
            // nothing wait for the end
            break
        }
    }
}


extension DirectoryItemManager where Self: Saving {
    
    public func canRename(to newName: String) throws {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: sourceSetManager is nil")
            throw RenameError.empty
        }
        
        if newName.isEmpty || newName.trimmed().isEmpty {
            throw RenameError.empty
        }
        
        if newName.count >= Constants.Configuration.MaximumFilenameLength {
            throw RenameError.fileNameTooLong
        }
        
        
        for illegalCharacter in IllegalFileNamesCharacters.allCases {
            
            switch illegalCharacter {
            case .endOfString:
                if newName.contains(§illegalCharacter) {
                    throw RenameError.illegalCharacter(character: "\0")
                }
            default:
                if newName.contains(§illegalCharacter) {
                    throw RenameError.illegalCharacter(character: §illegalCharacter)
                }
            }
        }
        
        if self.parentID.value == sourceSetManager.documentId {
            for topLevelDirectoryItemManager in sourceSetManager.topLevelDirectoryItemManagers {
                if topLevelDirectoryItemManager.name.value == newName && topLevelDirectoryItemManager.id != self.id {
                    let proposedName = self.nextAvailableName(using: newName)
                    throw RenameError.alreadyExisting(proposedName: proposedName)
                }
            }
        }
        else {
            let parentDirectoryManager = sourceSetManager.directoryItemManager(withId: self.parentID.value)
            let directoryManager = parentDirectoryManager as? DirectoryManager
            
            assert(directoryManager != nil, "Error: directoryManager is nil")
            if let directoryManager = directoryManager {
                
                let values = directoryManager.directoryItemsIds.values
                
                for value in values {
                    
                    let directoryItemManager = sourceSetManager.directoryItemManager(withId: value)
                    
                    assert(directoryItemManager != nil)
                    if let directoryItemManager = directoryItemManager, directoryItemManager.id != self.id {
                        
                        if directoryItemManager.name.value == newName {
                            let proposedName = self.nextAvailableName(using: newName)
                            throw RenameError.alreadyExisting(proposedName: proposedName)
                        }
                    }
                }
            }
        }
    }
    
    private func nextAvailableName(using baseBase: String) -> String {
        
        var itemNames = [String]()
        
        var itemWithBaseNameExists: Bool = false
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: sourceSetManager is nil")
            let hasher = Hashids(salt: "item")
            guard let code = hasher.encode(Int.random(in: 0..<Int.max)) else {
                assertionFailure("Error: code is nil")
                return baseBase
            }
            return "\(baseBase) \(code)"
        }
        
        let _itemManagersIds: [String]? = {
            if self.parentID.value == sourceSetManager.documentId {
                return sourceSetManager.topLevelDirectoryItemManagers.map { (directoryItemManager) -> String in
                    return directoryItemManager.id
                }
            }
            else {
                
                let parentDirectoryManager = sourceSetManager.directoryItemManager(withId: self.parentID.value)
                let directoryManager = parentDirectoryManager as? DirectoryManager
                assert(directoryManager != nil, "Error: directoryManager is nil")
                if let directoryManager = directoryManager {
                    return directoryManager.directoryItemsIds.values
                }
                return nil
            }
        }()
        
        guard let itemManagersIds = _itemManagersIds else {
            assertionFailure("Error: _itemManagersIds is nil")
            return baseBase
        }
        
        for directoryItemManagerId: String in itemManagersIds {
            
            guard let directoryItemManager = sourceSetManager.directoryItemManager(withId: directoryItemManagerId) else {
                assertionFailure("Error: ")
                continue
            }
            
            let name = directoryItemManager.name.value
            if name == baseBase {
                itemWithBaseNameExists = true
            }
            itemNames.append(name)
        }
        
        if !itemWithBaseNameExists {
            return baseBase
        }
        return "\(baseBase) \(itemNames.nextFreeEndNumber)"
    }
    
    public var currentPathComponents: [String] {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: sourceSetManager is nil")
            return []
        }
        
        let path = self.fileWrapperId
        var currentDirectoryItemId = self.parentID.value
        
        guard let topDirectoryId = sourceSetManager.topDirectory?.id else {
            assertionFailure("Error: self.sourceSetManager.topDirectory?.id is nil")
            return [path]
        }
        
        var components = [String]()
        components.append(path)
        
        while currentDirectoryItemId != topDirectoryId {
            
            if let parentItem = sourceSetManager.directoryItemManager(withId: currentDirectoryItemId) {
                
                components.insert(parentItem.fileWrapperId, at: 0)
                currentDirectoryItemId = parentItem.parentID.value
            }
            else {
                break
            }
        }
        return components
    }
    
    public var path: String {
        
        var path = self.fileWrapperId
        var currentDirectoryItemId = self.parentID.value
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: sourceSetManager is nil")
            return ""
        }
        
        guard let topDirectoryId = sourceSetManager.topDirectory?.id else {
            assertionFailure("Error: self.sourceSetManager.topDirectory?.id is nil")
            return path
        }
        
        while currentDirectoryItemId != topDirectoryId {
            
            if let parentItem = sourceSetManager.directoryItemManager(withId: currentDirectoryItemId) {
                
                path = parentItem.fileWrapperId + "/" + path
                currentDirectoryItemId = parentItem.parentID.value
            }
            else {
                break 
            }
        }
        return path
    }

    public func updatePathComponents() throws {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: sourceSetManager is nil")
            return
        }
        
        let dispatcher = sourceSetManager.dispatcher
        
        let updatePathComponentsAction = DirectoryAction.updatePathComponents(path: self.currentPathComponents)
        // set the new parent in the item itself
        switch self {
        case let textManager as TextManager:
            try dispatcher?.online(store: textManager.markdownDocumentStore, action: updatePathComponentsAction)
        case let directoryManager as DirectoryManager:
            try dispatcher?.online(store: directoryManager.directoryStore, action: updatePathComponentsAction)
        default:
            assertionFailure("Error: unsupported element type: \(type(of: self))")
            break
        }
    }
    
}
