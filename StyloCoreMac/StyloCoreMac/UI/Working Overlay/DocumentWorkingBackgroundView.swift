//
//  DocumentWorkingBackgroundView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-05-17.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class DocumentWorkingBackgroundView: NSView {
    
    @IBInspectable open var background: NSColor = NSColor(red: 88.3 / 256, green: 104.4 / 256, blue: 118.5 / 256, alpha: 0.8) {
        
        didSet {
            self.layer!.backgroundColor = NSColor.clear.cgColor
        }
    }
    
    required init?(coder decoder: NSCoder) {
        
        super.init(coder: decoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.wantsLayer = true
//        self.layer!.backgroundColor = NSColor.clear.cgColor
    }
    
}
