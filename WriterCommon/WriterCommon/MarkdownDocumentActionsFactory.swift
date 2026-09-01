//
//  MarkdownDocumentActionsFactory.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-03-22.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import WebKit
import Common

enum TextDocumentAction: ActionType {
    
    case changeMarkdownPresets(presetsName: String)
    
    case compileMarkdownTokens(string: String)
    
    case updateTokenAttributes
    
    case cleanState
    
    case renamed(name: String)
}

struct MarkdownDocumentActionsFactory: ActionsFactory {

    
    static func renameAction(to newName: String) -> SyncAction {
        
        let actionType = TextDocumentAction.renamed(name: newName)
        return SyncAction(type: actionType)
    }
    
    static func cleanStateAction() -> SyncAction {
        
        let actionType = TextDocumentAction.cleanState
        return SyncAction(type: actionType)
    }

    static func changeMarkdownPresetsAction(presetsName: String) -> SyncAction {
        
        let actionType = TextDocumentAction.changeMarkdownPresets(presetsName: presetsName)
        return SyncAction(type: actionType)
    }
    
}
