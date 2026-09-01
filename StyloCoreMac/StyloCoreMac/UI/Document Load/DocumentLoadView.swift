//
//  DocumentLoadView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-08-11.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class DocumentLoadView: NSView {
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer!.backgroundColor = NSColor.gray.withAlphaComponent(0.5).cgColor
    }
    
    required init?(coder decoder: NSCoder) {
        
        super.init(coder: decoder)
        self.wantsLayer = true
        self.layer!.backgroundColor = NSColor.gray.withAlphaComponent(0.5).cgColor
    }
    
    override func mouseDown(with event: NSEvent) {
        
        // do nothing
    }
    
}
