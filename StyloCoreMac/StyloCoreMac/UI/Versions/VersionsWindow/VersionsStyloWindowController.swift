//
//  VersionsStyloWindowController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-02-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon

class VersionsStyloWindowController: NSWindowController {
    
    var textManager: TextManager? {
        
        return self.styloDocument?.textManager
    }
    
    private var versionsTextEditorViewController: VersionsTextEditorViewController? {
        
        return self.contentViewController as? VersionsTextEditorViewController
    }
    
    
    @objc dynamic var styloDocument: MacStyloDocument? {
        
        return self.document as? MacStyloDocument
    }
    
    override var document: AnyObject? {
        didSet {
            
            if document != nil {
                
                assert(textManager != nil)
                assert(versionsTextEditorViewController != nil)
                versionsTextEditorViewController?.editableManager = textManager
            }
        }
    }
    
    init() {
        self.init(windowNibName: NSNib.Name(string: "VersionsDocument"))
    }
    
    override init(window: NSWindow?) {
        
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
