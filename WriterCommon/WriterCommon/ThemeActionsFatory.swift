//
//  ThemeActionsFatory.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-03-22.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo

enum ThemeAction: ActionType {
    
    case setStyles(styles: [ThemeId: StyleAssemblyStore])
}

struct ThemeActionsFactory: ActionsFactory {
    
    static func setStylesAction(styles: [ThemeId: StyleAssemblyStore]) -> SyncAction {
        
        let actionType = ThemeAction.setStyles(styles: styles)
        return SyncAction(type: actionType)
    }
}
