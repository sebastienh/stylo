//
//  SourceSetReducer.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-29.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Common
import PromiseKit

enum SourceSetAction: ActionType {
    
}

enum SourceSetResult: ActionResult {
    
    case updatedContext(context: [String: Any]?)
}

class SourceSetReducer: Reducer {
    
    @discardableResult
    func online<S>(store: S, action: ActionType) throws -> ActionResult? where S : Store {
        
        guard let sourceSetAction = action as? SourceSetAction else {
            assert(false)
            return nil
        }
        
        guard let sourceSetStore = store as? SourceSetStore else {
            assert(false)
            return nil
        }
        
        switch sourceSetAction {
            // no action
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
