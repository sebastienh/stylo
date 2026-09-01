//
//  FeedbackWindow.swift
//  Stylo
//
//  Created by Sebastien hamel on 2018-12-25.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class FeedbackWindow: NSWindow {
    
    func hideLeftButtons() {
        
        self.standardWindowButton(NSWindow.ButtonType.closeButton)?.isHidden = true
        self.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isHidden = true
        self.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)?.isHidden = true
    }
}
