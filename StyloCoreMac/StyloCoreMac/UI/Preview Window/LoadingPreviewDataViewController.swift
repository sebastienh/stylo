//
//  LoadingPreviewDataViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa

class LoadingPreviewDataViewController: NSViewController {
    
    @IBOutlet var progressIndicator: NSProgressIndicator!
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        progressIndicator.startAnimation(self)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        progressIndicator.stopAnimation(self)
    }
    
    
}
