//
//  HtmlExportPlugin.swift
//  HtmlExportPlugin
//
//  Created by Sebastien hamel on 2019-09-22.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common
import Web
import WebKit
import PromiseKit

class HtmlExportPlugin: NSObject, StyloPlugin, DocumentPlugin {
    
    var isEdited: Bool {
        return false
    }

    var name: String {
        return Constants.Plugin.Name
    }
    
    var isDraft: Bool {
        return false
    }
    
    var htmlStyle: CSSStyle? {
        
        return self.documentManager.htmlStyle
    }
    
    let documentManager: DocumentManager
    
    var htmlExportViewController: HtmlExportViewController?
    
    var webViewLoadedPromise: Promise<Void>?
    var fulfill: ((Void) -> Swift.Void)?
    var reject: ((Error) -> Swift.Void)?
    
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
