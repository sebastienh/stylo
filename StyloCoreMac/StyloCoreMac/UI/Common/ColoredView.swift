//
//  ColoredViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-07-20.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon

public class ColoredView: NSView {
    
    public override var isOpaque: Bool {
        
        #if ALPHA_COLOR_ENABLED
        return false
        #else
        return true
        #endif
    }
    
    @IBInspectable public var backgroundColor: NSColor? {
        didSet {
            self.needsLayout = true 
        }
    }

    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer!.cornerRadius = cornerRadius
            layer!.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable public var borderWidth: CGFloat = 0 {
        
        didSet {
            layer!.borderWidth = borderWidth
        }
    }
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.wantsLayer = true
    }

    required init?(coder: NSCoder) {

        super.init(coder: coder)
        self.wantsLayer = true
    }
    
    public override func layout() {
        
        self.layer!.backgroundColor = backgroundColor?.cgColor
        super.layout()
    }
    
}
