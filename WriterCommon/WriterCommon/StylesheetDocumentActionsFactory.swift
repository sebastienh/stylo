//
//  StylesheetDocumentActionsFactory.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-03-22.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo

enum StylesheetDocumentAction: ActionType {
    
    // this action loads the stylesheet and create the CSSStyleSheet
    // we use this action when we don't want to pass by the sourceStringChanged
    // action to create the CSSStylesheet. It is usefull with user agent stylesheets
    // and in tests when we want to create a style using only one stylesheet.
    case loadStylesheet(url: URL)
    
    case createInitialStylesheet(source: String)
    
    case removeAppearance(appearance: AppearanceMode)
    
    case addAppearance(appearance: AppearanceMode)
    
    case stylesheetCompiled
    
}


struct StylesheetDocumentActionsFactory: ActionsFactory {
    
    static func loadStylesheetAction(url: URL) -> SyncAction {
        
        let actionType = StylesheetDocumentAction.loadStylesheet(url: url)
        return SyncAction(type: actionType)
    }
    
    static func createInitialStylesheetAction(source: String) -> SyncAction {
        
        let actionType = StylesheetDocumentAction.createInitialStylesheet(source: source)
        return SyncAction(type: actionType)
    }
    
}
