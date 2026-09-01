//
//  FilesOutlineSetReducer.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import PromiseKit

enum FilesOutlineSetAction: ActionType {
    
    case filesOutlineSelected(id: String)
    case filesOutlineAdded(id: String)
    case filesOutlineAddedAtIndex(id: String, index: Int)
    case filesOutlineRemovedAtIndex(index: Int)
    case registerEditorForTextId(editorId: EditorId, textId: TextId)
    case unregisterEditorForTextId(editorId: EditorId, textId: TextId)
}

enum FilesOutlineSetActionResult: ActionResult {
    
    
}

class FilesOutlineSetReducer: Reducer {
    
    @discardableResult
    func online<S>(store: S, action: ActionType) throws -> ActionResult? where S : Store {
        
        guard let filesOutlineSetAction = action as? FilesOutlineSetAction else {
            assert(false, "Error: unsupported action type: \(action)")
            return nil
        }
        
        guard let filesOutlineSetStore = store as? FilesOutlineSetStore else {
            assert(false, "Error: store is not FilesOutlineSetStore")
            return nil
        }
        
        switch filesOutlineSetAction {
        case .filesOutlineSelected(let id):
            assert(filesOutlineSetStore.filesOutlines.values.contains(id))
            filesOutlineSetStore.selectedFilesOutlineId.setValue(id)
        case .filesOutlineAdded(let id):
            filesOutlineSetStore.filesOutlines.append(id)
        case .filesOutlineAddedAtIndex(let id, let index):
            filesOutlineSetStore.filesOutlines.insert(id, at: index)
        case .filesOutlineRemovedAtIndex(let index):
            filesOutlineSetStore.filesOutlines.remove(atIndex: index)
        case .registerEditorForTextId(let editorId, let textId):
            
            if filesOutlineSetStore.activeEditors.values[textId] == nil {
                filesOutlineSetStore.activeEditors.values[textId] = Set<EditorId>()
            }
            var editorsSet = filesOutlineSetStore.activeEditors.values[textId]!
            editorsSet.insert(editorId)
            filesOutlineSetStore.activeEditors.updateValue(editorsSet, forKey: textId)
            
        case .unregisterEditorForTextId(let editorId, let textId):
            
            guard filesOutlineSetStore.activeEditors.values[textId]?.contains(editorId) == true else {
                assertionFailure("Error: trying to remove an unexisting value")
                return nil
            }
            if var editorsSet = filesOutlineSetStore.activeEditors.values[textId] {
                editorsSet.remove(editorId)
                filesOutlineSetStore.activeEditors.updateValue(editorsSet, forKey: textId)
            }
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
    

}
