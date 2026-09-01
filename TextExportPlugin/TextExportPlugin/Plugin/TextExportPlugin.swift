//
//  TextExportPlugin.swift
//  TextExportPlugin
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common

class TextExportPlugin: NSObject, StyloPlugin, DocumentPlugin {
    
    var name: String {
        return Constants.Plugin.Name
    }
    
    var isEdited: Bool {
        return false
    }
    
    var isDraft: Bool {
        return false
    }
    
    let documentManager: DocumentManager
    
    var textExportPanelViewController: TextExportViewController?
    
    var _previewData: Data?
    
    required init(documentManager: DocumentManager) {
        self.documentManager = documentManager
    }
    
    func pluginDidLoad() {
        // nothing to do
    }
    
    func documentDidLoad() {
        // nothing to do
    }
    
    func documentWillClose() {
        // nothing to do
    }
    
    func documentWillSave() {
        // nothing to do
    }
    
    func documentDidSave() {
        // nothing to do
    }
}
