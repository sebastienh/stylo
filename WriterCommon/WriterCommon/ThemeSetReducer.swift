//
//  ThemeSetReducer.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-11-15.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Igloo

public struct ThemeSetReducer: Reducer {

    
    init() {
        // nothing to do
    }
    
    @discardableResult
    public func online<S: Store>(store: S, action: ActionType) throws -> ActionResult? {
        fatalError("missing implementation")
    }
    
    public func sync<S: Store>(store: S, action: SyncAction) -> ActionResult? {
        
        var result: ActionResult? = nil
        
        if let themeSetAction = action.type as? ThemeSetAction {
            
            if let themeSetStore = store as? ThemeSetStore {
                
                switch themeSetAction {
                    
                case .addTheme(let themeStore):
                    
                    themeSetStore.themes.append(themeStore)
                }
            }
            else {
                let error = NWError.unhandledStoreType(storeId: String(describing: store))
                debugPrint("Error: \(error)")
            }
        }
        else {
            let error = NWError.unhandledActionType(actionType: action.type)
            assertionFailure("Error: \(error)")
        }
        return result
    }
    
    public func async<S: Store>(store: S, action: AsyncAction) -> Promise<ActionResult?> {
        
        return Promise<ActionResult?> { fulfill, reject in
            
            if let _ = store as? ThemeSetStore {

                let error = NWError.unhandledActionType(actionType: action.type)
                assertionFailure("Error: \(error)")
                reject(error)
            }
            else {
                let error = NWError.unhandledStoreType(storeId: String(describing: store))
                assertionFailure("Error: \(error)")
                reject(error)
            }
        }
            
    }
}
