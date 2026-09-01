//
//  PreviewBackgroundSidebarView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-09-06.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class PreviewBackgroundSidebarView: NSView {
    
    override var isOpaque: Bool {
        
        return true
    }
    
    override var isFlipped: Bool {
        
        return true
    }
    
    private var backgroundColor: CGColor {
        
        get {
            return self.layer!.backgroundColor!
        }
        set {
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

