//
//  FailableActionsFactory.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-03-23.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo

public enum FailableStoreAction: ActionType {
    
    case updateErrorMessages
    case updateFailableState(state: FailableStoreState)
}

struct FailableActionsFactory: ActionsFactory {
    
    static func updateErrorMessagesAsyncAction() -> AsyncAction {
        
        let actionType = FailableStoreAction.updateErrorMessages
        return AsyncAction(type: actionType)
    }
    
    static func updateErrorMessagesSyncAction() -> SyncAction {
        
        let actionType = FailableStoreAction.updateErrorMessages
        return SyncAction(type: actionType)
    }
    
    static func updateFailableStateAction(state: FailableStoreState) -> AsyncAction {
        
        let actionType = FailableStoreAction.updateFailableState(state: state)
        return AsyncAction(type: actionType)
    }
}
