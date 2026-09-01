//
//  ThemeReducer.swift
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

public struct ThemeReducer: Reducer {

    init() {
        // nothing to do
    }
    
    @discardableResult
    public func online<S: Store>(store: S, action: ActionType) throws -> ActionResult? {
        fatalError("missing implementation")
    }
    
    public func sync<S: Store>(store: S, action: SyncAction) -> ActionResult? {
        
        let result: ActionResult? = nil
        
        if let themeAction = action.type as? ThemeAction {
            
            if let themeStore = store as? ThemeStore {
                
                switch themeAction {
                
                case .setStyles(let styles):
                    
                    themeStore.styles = styles
                }
            }
        }
        
        return result
    }
    
    public func async<S: Store>(store: S, action: AsyncAction) -> Promise<ActionResult?> {
        
        return Promise<ActionResult?> { fulfill, reject in
            
            if let themeAction = action.type as? ThemeAction {
                
                if let themeStore = store as? ThemeStore {
                    
                    switch themeAction {
                        
                    case .setStyles(let styles):
                        
                        themeStore.styles = styles
                        fulfill(nil)
                    }
                }
                else {
                    let error = NWError.unhandledStoreType(storeId: String(describing: store))
                    debugPrint("Error: \(error)")
                    reject(error)
                }
            }
            else {
                let error = NWError.unhandledActionType(actionType: action.type)
                assertionFailure("Error: \(error)")
                reject(error)
            }
        }
    }
}
