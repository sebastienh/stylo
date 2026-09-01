//
//  DocumentWorkingViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-05-17.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class DocumentWorkingViewController: NSViewController {
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator?
    
    override func viewDidAppear() {
        
        super.viewDidAppear()
        progressIndicator?.startAnimation(self)
    }
    
    override func viewWillDisappear() {
        
        super.viewWillDisappear()
        progressIndicator?.stopAnimation(self)
    }
    
}
