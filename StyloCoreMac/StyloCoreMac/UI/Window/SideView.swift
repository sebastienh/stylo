//
//  SideView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-04.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class SideView: NSView {
    
    override var isOpaque: Bool {
        
        return true
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        
        self.wantsLayer = true
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        self.wantsLayer = true
    }
    
}
