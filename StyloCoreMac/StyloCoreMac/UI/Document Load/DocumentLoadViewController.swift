//
//  DocumentLoadViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-08-11.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class DocumentLoadViewController: NSViewController {
    
    @IBOutlet var progressindicator: NSProgressIndicator!
    
    @IBOutlet var textField: NSTextField!
    
    var filename: String? {
        didSet {
            if let filename = filename {
                self.textField.stringValue = "Loading \(filename)"
            }
            else {
                self.textField.stringValue = InterfaceConstants.Load.EmptyFilenamePlaceholder
            }
        }
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        progressindicator.startAnimation(self)
    }
 
    override func viewDidDisappear() {
        
        super.viewDidDisappear()
        progressindicator.stopAnimation(self)
    }
}
