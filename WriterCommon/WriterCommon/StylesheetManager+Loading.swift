//
//  StylesheetManager+Loading.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-03-09.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web
import Igloo
import PromiseKit
import os

extension StylesheetManager {
    
    func createStringResourceModelSync(templateName: TemplateId, from template: TemplateStore, context: [String: Any]?) -> String {
        
        let renderTemplateAction = TemplateActionFactory.renderTemplateSyncAction(templateName: templateName, context: context)
        let renderResult = dispatcher.sync(store: template, action: renderTemplateAction) as? TemplateActionResult
        
        assert(renderResult != nil)
        if let renderResult = renderResult {
            switch renderResult {
            case .renderResult(let renderedString):
                return renderedString
            case .updatedTemplate:
                assert(false)
            }
        }
        return ""
    }
    
    func createStringResourceModel(from url: URL, withEncoding encoding: Encoding? = nil) -> String? {
        
        let action = EditableStoreActionsFactory.loadStringAction(url: url)
        let result = self.dispatcher.sync(store: self.stylesheetDocumentStore, action: action)
        if let editableActionResult = result as? EditableActionResult, let loadedString = editableActionResult.loadedString {
            return loadedString
        } else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error while creating sring resource model.", log: Log.WriterCommon.all, type: .error)
            #endif
        }
        return nil
    }

    private func stylesheetOrigin(from title: String) -> CSSOrigin? {
        
        if title.endsWith("user") {
            return .user
        }
        else if title.endsWith("ua") {
            return .userAgent
        }
        return .author
    }
    
    
}
