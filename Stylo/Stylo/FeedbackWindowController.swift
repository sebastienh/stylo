//
//  FeedbackWindowController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2018-12-25.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class FeedbackWindowController: NSWindowController, NSWindowDelegate {
    
    override func windowDidLoad() {
        
        super.windowDidLoad()
        let feedbackWindow = self.window as? FeedbackWindow
            
        assert(feedbackWindow != nil)
        feedbackWindow?.hideLeftButtons()
    }
    
    func windowWillClose(_ notification: Notification) {
        NSApp.stopModal()
    }
    
}
