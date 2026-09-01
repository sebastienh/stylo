//
//  AutocompleteWindow.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-02-10.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

/// see http://stackoverflow.com/questions/15179288/custom-nswindow-with-rounded-corners-which-clip-subviews
final class AutocompleteWindow: NSPanel {
    
    override var canBecomeKey: Bool {
        
        return false
    }
    
    override var isResizable: Bool {
        
        return false
    }
    
    override init(contentRect: NSRect, styleMask aStyle: NSWindow.StyleMask, backing bufferingType: NSWindow.BackingStoreType, defer flag: Bool) {
        
        // Note: removing titled removes the round corners 
        let windowMask: NSWindow.StyleMask = [.borderless, .fullSizeContentView, .titled, ]
        
        super.init(contentRect: contentRect, styleMask: windowMask, backing: NSWindow.BackingStoreType.buffered, defer: false)
        
        // see http://stackoverflow.com/questions/840015/lock-the-position-of-an-nswindow
        self.isMovable = false
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.isMovableByWindowBackground = false
        self.showsToolbarButton = false
    }
}
