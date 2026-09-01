//
//  PdfExportPlugin.swift
//  PdfExportPlugin
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common
import WebKit
import Web

class PdfExportPlugin: NSObject, StyloPlugin, DocumentPlugin {

    var name: String {
        return Constants.Plugin.Name
    }

    var isEdited: Bool {
        return false
    }
    
    var isDraft: Bool {
        return false
    }
    
    var printInfo: NSPrintInfo? {
        
        return self.documentManager.printInfo
    }
    
    var pdfStyle: CSSStyle? {
        
        return self.documentManager.pdfStyle
    }
    
    let documentManager: DocumentManager
    
    var pdfExportViewController: PdfExportViewController?
    
    var pdfExportJobs: [URL: (webView: WebView, delegate: WebFrameLoaderDelegate)] = [:]
    
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
