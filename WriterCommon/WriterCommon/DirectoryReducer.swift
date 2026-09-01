//
//  DirectoryReducer.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-25.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import PromiseKit

enum DirectoryError: Error {
    case noItemWithId(id: String)
}

enum DirectoryAction: ActionType {
    
    case appendItem(id: String)
    case setParentId(id: String)
    case addItem(id: String, index: Int)
    case addItemBefore(addedItemId: String, existingItemId: String)
    case addItemAfter(addedItemId: String, existingItemId: String)
    case removeItem(id: String)
    case rename(name: String)
    case updatePathComponents(path: [String])
}

enum DirectoryActionResult: ActionResult {
    
    
}

class DirectoryReducer: Reducer {

    @discardableResult
    public func online<S: Store>(store: S, action: ActionType) throws -> ActionResult? {
        
        guard let directoryAction = action as? DirectoryAction else {
            assert(false, "Error: unsupported action type: \(action)")
            return nil
        }
        
        guard let directoryStore = store as? DirectoryStore else {
            assert(false, "Error: store is not DirectoryStore")
            return nil
        }
        
        switch directoryAction {
        case .addItem(let id, let index):
            directoryStore.directoryItemsIds.insert(id, at: index, sameExecutionStack: true)
        case .appendItem(let id):
            directoryStore.directoryItemsIds.append(id, sameExecutionStack: true)
        case .removeItem(let id):
            for (index, value) in directoryStore.directoryItemsIds.values.enumerated() {
                if value == id {
                    directoryStore.directoryItemsIds.remove(atIndex: index, sameExecutionStack: true)
                }
            }
        case .setParentId(let id):
            directoryStore.parentID.setValue(id, sameExecutionStack: true)
        case .rename(let name):
            directoryStore.name.setValueIfDifferent(name, notify: true, sameExecutionStack: true)
        case .addItemAfter(let addedItemId, let existingItemId):
            var valueAdded = false
            for (index, value) in directoryStore.directoryItemsIds.values.enumerated() {
                if existingItemId == value {
                    directoryStore.directoryItemsIds.insert(addedItemId, at: index+1, sameExecutionStack: true)
                    valueAdded = true
                    break
                }
            }
            assert(valueAdded, "Error: value was not added")
            if !valueAdded {
                throw DirectoryError.noItemWithId(id: existingItemId)
            }
        case .addItemBefore(let addedItemId, let existingItemId):
            var valueAdded = false
            for (index, value) in directoryStore.directoryItemsIds.values.enumerated() {
                if existingItemId == value {
                    directoryStore.directoryItemsIds.insert(addedItemId, at: index, sameExecutionStack: true)
                    valueAdded = true
                    break
                }
            }
            assert(valueAdded, "Error: value was not added")
            if !valueAdded {
                throw DirectoryError.noItemWithId(id: existingItemId)
            }
            
        case .updatePathComponents(let path):
            directoryStore.pathComponents.replaceItems(withItems: path)
        }
        return nil
    }
    
    func sync<S>(store: S, action: SyncAction) -> ActionResult? where S : Store {
        fatalError("missing implementation")
    }
    
    func async<S>(store: S, action: AsyncAction) -> Promise<ActionResult?> where S : Store {
        fatalError("missing implementation")
    }
}
