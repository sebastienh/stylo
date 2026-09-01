//
//  BackgroundSidebarView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-11-19.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import os
import Common

class BackgroundSidebarContentView: NSView {
    
    override var isOpaque: Bool {
        
        return true
    }
    
    override var isFlipped: Bool {
        
        return true
    }
    
    var backgroundColor: CGColor {
        
        get {
            return self.layer!.backgroundColor!
        }
        set {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG  && DEBUG_LOGS_ENABLED
            os_log("Setting BackgroundSidebarContentView background color: %@", log: Log.StyloCore.all, type: .info, %%newValue)
            #endif
            self.layer!.backgroundColor = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.wantsLayer = true
        self.backgroundColor = NSColor.clear.cgColor// (calibratedRed: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
