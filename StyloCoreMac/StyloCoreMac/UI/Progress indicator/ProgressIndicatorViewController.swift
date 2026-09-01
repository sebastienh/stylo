//
//  ProgressIndicatorViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-04-26.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common

class ProgressIndicatorViewController: NSViewController {
    
    enum ProgressType {
        
        case printing
        case exporting
    }
    
    enum ExportType: String {
        
        case pdf = "PDF"
        case word = "Word"
        case plainText = "Plain Text"
        case markdown = "Markdown"
        case html = "HTML"
        case history = "Edit History"
    }
    
    var progressType: ProgressType?
    
    @IBOutlet var textField: NSTextField!
    
    var exportType: ExportType?
    
    var documentName: String?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        updateTextFieldTitle()
    }
    
    private func updateTextFieldTitle() {
        
        assert(self.progressType != nil)
        if let progressType = progressType {
        
            switch progressType {
            
            case .printing:
                
                assert(textField != nil)
                assert(documentName != nil)
                assert(textField != nil)
                if let documentName = documentName {
                    self.textField.stringValue = "Preparing \(documentName) for printing..."
                }
                else {
                    self.textField.stringValue = "Preparing document for printing..."
                }
                
            case .exporting:
                
                assert(exportType != nil)
                if let exportType = exportType {
                
                    assert(documentName != nil)
                    assert(textField != nil)
                    if let documentName = documentName {
                        self.textField.stringValue = "Exporting \(documentName) to \(§exportType)"
                    }
                    else {
                        self.textField.stringValue = "\(InterfaceConstants.Export.EmptyDocumentNamePlaceholder) to \(§exportType)"
                    }
                }
                else {
                
                    self.textField.stringValue = "\(InterfaceConstants.Export.EmptyDocumentNamePlaceholder)"
                }
            }
        }
    }
    
}
