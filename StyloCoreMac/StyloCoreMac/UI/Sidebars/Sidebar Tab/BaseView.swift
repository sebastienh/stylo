//
//  BaseView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-15.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
//
//  BaseView.swift
//  ProgressKit
//
//  Created by Kauntey Suryawanshi on 04/10/15.
//  Copyright (c) 2015 Kauntey Suryawanshi. All rights reserved.
//
import AppKit

@IBDesignable
open class BaseView: NSView {
    
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.configureLayers()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayers()
    }
    
    /// Configure the Layers
    func configureLayers() {
        self.wantsLayer = true
        notifyViewRedesigned()
    }
    
    @IBInspectable open var background: NSColor = NSColor.selectedContentBackgroundColor {
        didSet {
            self.notifyViewRedesigned()
        }
    }
    
    @IBInspectable open var foreground: NSColor = NSColor.underPageBackgroundColor {
        didSet {
            self.notifyViewRedesigned()
        }
    }
    
    @IBInspectable open var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.notifyViewRedesigned()
        }
    }
    
    /// Call when any IBInspectable variable is changed
    func notifyViewRedesigned() {
        self.layer?.backgroundColor = background.cgColor
        self.layer?.cornerRadius = cornerRadius
    }
}
