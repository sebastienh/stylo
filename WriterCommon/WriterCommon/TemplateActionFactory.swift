//
//  TemplateActionFactory.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-08.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Web

enum TemplateAction: ActionType {
    
    case loadTemplates(directoryName: String)
    case renderTemplate(templateName: String, context: [String: Any]?)
}

enum TemplateActionResult: ActionResult {
    
    case updatedTemplate
    case renderResult(value: String)
    
}

struct TemplateActionFactory: ActionsFactory {

    static func createLoadTemplatesAsyncAction(with directoryName: String) -> AsyncAction {
        
        let actionType = TemplateAction.loadTemplates(directoryName: directoryName)
        return AsyncAction(type: actionType)
    }
    
    static func createLoadTemplatesSyncAction(with directoryName: String) -> SyncAction {
        
        let actionType = TemplateAction.loadTemplates(directoryName: directoryName)
        return SyncAction(type: actionType)
    }

    static func renderTemplateAsyncAction(templateName: String, context: [String: Any]?) -> AsyncAction {
        
        let actionType = TemplateAction.renderTemplate(templateName: templateName, context: context)
        return AsyncAction(type: actionType)
    }
    
    static func renderTemplateSyncAction(templateName: String, context: [String: Any]?) -> SyncAction {
        
        let actionType = TemplateAction.renderTemplate(templateName: templateName, context: context)
        return SyncAction(type: actionType)
    }
}
