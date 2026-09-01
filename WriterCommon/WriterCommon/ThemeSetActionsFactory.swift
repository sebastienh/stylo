//
//  ThemeSetActionsFactory.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-03-22.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo

enum ThemeSetAction: ActionType {
    
    case addTheme(themeStore: ThemeStore)
}

struct ThemeSetActionsFactory: ActionsFactory {
    
    static func addThemeAction(themeStore: ThemeStore) -> SyncAction {
        
        let actionType = ThemeSetAction.addTheme(themeStore: themeStore)
        return SyncAction(type: actionType)
    }
}
