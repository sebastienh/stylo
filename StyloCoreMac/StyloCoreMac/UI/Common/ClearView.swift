//
//  ClearView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-01-24.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon

public class ClearView: NSView {
    
    override public var allowsVibrancy: Bool {
        
        return false
    }
    
    override public var isOpaque: Bool {
        
        #if ALPHA_COLOR_ENABLED
        return false
        #else
        return true
        #endif
    }
    
    override public var isFlipped: Bool {
        
        return true
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.wantsLayer = true
        
        #if ALPHA_COLOR_ENABLED
        self.layer?.backgroundColor = NSColor.clear.cgColor
        #endif
    }
    
    required init?(coder decoder: NSCoder) {
        
        super.init(coder: decoder)
        self.wantsLayer = true
        
        #if ALPHA_COLOR_ENABLED
        self.layer?.backgroundColor = NSColor.clear.cgColor
        #endif
    }
}
