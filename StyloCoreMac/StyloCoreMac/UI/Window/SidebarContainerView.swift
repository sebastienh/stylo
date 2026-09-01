//
//  SidebarContainerView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-07-30.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class SidebarContainerView: NSView {
    
    override var allowsVibrancy: Bool {
        
        return false
    }
    
    override var isOpaque: Bool {
        
        return true
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)

    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    
    override func updateLayer() {
        
        self.layer?.backgroundColor = NSColor.underPageBackgroundColor.cgColor
        super.updateLayer()
    }
    
}
