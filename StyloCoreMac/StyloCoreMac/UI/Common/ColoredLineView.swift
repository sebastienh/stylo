//
//  ColoredLineView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-09-03.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Cocoa

/// This class is expected to replace all NSBox ( Horozontal Line
/// and Vertical Line) in my interface so I can more easily change 
/// the color of them.
public class ColoredLineView: NSView, DisappearableView {
    
    internal var visibleBackgroundColor: CGColor?
    
    override public var acceptsFirstResponder: Bool {
        
        return true
    }
    
    override public var isOpaque: Bool {
        
        return true
    }
    
    override public var allowsVibrancy: Bool {
        
        return false
    }
    
    @IBInspectable var backgroundColor: NSColor? {
        didSet {
            self.needsLayout = true
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
    
    override public func layout() {
        
        layer?.backgroundColor = backgroundColor?.cgColor
        super.layout()
    }
    
    override public func mouseDragged(with event: NSEvent) {
        
        // do nothing
    }
    
    override public func mouseDown(with event: NSEvent) {
        
        // nothing
    }
    
    override public func mouseMoved(with event: NSEvent) {
        
        // do nothing
    }
    
    override public func mouseUp(with event: NSEvent) {
        
        // do nothing
    }
    
    override public func mouseExited(with event: NSEvent) {
        
        // do nothing
    }
    
    override public func mouseEntered(with event: NSEvent) {
        
        // do nothing
    }
    
    override public func otherMouseDragged(with event: NSEvent) {
        
        // do nothing
    }
    
    override public func rightMouseDragged(with event: NSEvent) {
        
        // do nothing
    }
    
    override public func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        
        return true
    }
}
