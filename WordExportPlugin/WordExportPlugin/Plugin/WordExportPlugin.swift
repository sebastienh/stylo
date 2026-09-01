//
//  WordExportPlugin.swift
//  WordExportPlugin
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common
import Web
import WebKit
import PromiseKit

class WordExportPlugin: NSObject, StyloPlugin, DocumentPlugin {
    
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
    
    var wordStyle: CSSStyle? {
        
        return self.documentManager.wordStyle
    }
    
    let documentManager: DocumentManager
    
    var wordExportViewController: WordExportViewController?
    
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
    
    func selectedTextManagersHtmlString(from textManagers: [TextManager]) -> Promise<String> {
        
        var textManagersHtmlStrings = [Promise<String?>]()
        
        for textManager in textManagers {
            textManagersHtmlStrings.append(textManager.htmlBodyContentString)
        }
        
        return when(fulfilled: textManagersHtmlStrings).then { bodyStrings -> Promise<String> in
            
            let bodyContent = bodyStrings.reduce("") { (res, nextValue) -> String in
                return res + (nextValue ?? "")
            }
            
            return Promise<String>(value: "<html><body>\(bodyContent)</body></html>")
        }
    }
    
    func selectedTextManagersWordString(from textManagers: [TextManager]) -> Promise<String> {
        
        return Promise<String> { fulfill, reject in
            
            // get the body string
            firstly {
                self.selectedTextManagersHtmlString(from: textManagers)
            }.then { bodyString in
                self.htmlCompleteWordString(bodyString)
            }.then { completeString in
                fulfill(completeString)
            }.catch { error in
                reject(error)
            }
        }
    }
    
    private func htmlCompleteWordString(_ bodyString: String) -> Promise<String> {
        
        return Promise<String> { fulfill, reject in
            
            if let wordStyle = self.wordStyle {
                
                let styleString = wordStyle.serialize()
                
                fulfill("""
                    <html>
                        <head>
                            <style>
                                \(styleString)
                            </style>
                        </head>
                        <body>
                            \(bodyString)
                        </body>
                    </html>
                    """)
            }
            else {
                reject(NWError.custom(message: "Error: pdfStyleStore is nil"))
            }
        }
    }
}
