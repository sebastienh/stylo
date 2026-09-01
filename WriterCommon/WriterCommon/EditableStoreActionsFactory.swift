//
//  EditableStoreActionsFactory.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-13.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Common
import Web


public struct EditableStoreActionsFactory {
    
    static func loadStringAction(url: URL) -> SyncAction {
        
        let actionType = EditableStoreAction.loadString(url: url)
        return SyncAction(type: actionType)
    }
    
    static func sourceStringChangedActionSync(description: SourceStringChangeDescription) -> SyncAction {
        
        let actionType = EditableStoreAction.sourceStringChanged(description: description)
        return SyncAction(type: actionType)
    }
    
    static func sourceStringChangedActionAsync(description: SourceStringChangeDescription) -> AsyncAction {
        
        let actionType = EditableStoreAction.sourceStringChanged(description: description)
        return AsyncAction(type: actionType)
    }
    
    static func resetPendingChangesActionSync() -> SyncAction {
        
        let actionType = EditableStoreAction.resetPendingChanges
        return SyncAction(type: actionType)
    }

    static func resetPendingChangesActionAsync() -> AsyncAction {
        
        let actionType = EditableStoreAction.resetPendingChanges
        return AsyncAction(type: actionType)
    }
    
}
