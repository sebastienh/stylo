//
//  StyleNameTextField.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-06-02.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import os

class StyleNameTextField: NSTextField {
    
    var selected: Bool = false

    override init(frame: NSRect) {
        
        super.init(frame: frame)
        self.prepareAutosizingTextField()
        self.addTrackingArea(NSTrackingArea(rect: .zero, options: NSTrackingArea.Options.inVisibleRect.union(.activeInKeyWindow).union(.mouseEnteredAndExited).union(.mouseMoved), owner: self, userInfo: nil))
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.prepareAutosizingTextField()
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(.activeInKeyWindow).union(.mouseEnteredAndExited).union(.mouseMoved), owner: self, userInfo: nil))
    }

    func prepareAutosizingTextField() {
        
        self.lineBreakMode = .byTruncatingTail
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override var intrinsicContentSize: NSSize {
        
        var size: NSSize
        let bounds = self.bounds
        
        let cell = self.cell as! NSTextFieldCell
        size = cell.cellSize(forBounds: NSMakeRect(0, 0, CGFloat.greatestFiniteMagnitude, CGFloat.greatestFiniteMagnitude))
        
        if let fieldEditor = self.currentEditor() as? NSTextView {

            let contraintSize = NSMakeSize(CGFloat.greatestFiniteMagnitude, size.height)
            
            let _usedRect = self.attributedStringValue.boundingRect(with: contraintSize, options: NSString.DrawingOptions.usesLineFragmentOrigin)
            
            let usedRect = NSMakeRect(_usedRect.origin.x, _usedRect.origin.y, _usedRect.size.width + 5.0, _usedRect.size.height)
            
            let fieldEditorSuperview = fieldEditor.superview!
            let clipRect = self.convert(fieldEditorSuperview.bounds, from: fieldEditor.superview)

            let clipDelta = NSSize(width: NSWidth(bounds) - NSWidth(clipRect), height:NSHeight(bounds) - NSHeight(clipRect))
            size = NSSize(width: ceil(NSWidth(usedRect) + clipDelta.width), height: NSHeight(usedRect) + clipDelta.height)

        } else {
            
            let cell = self.cell as! NSTextFieldCell
            size = cell.cellSize(forBounds: NSMakeRect(0, 0, CGFloat.greatestFiniteMagnitude, CGFloat.greatestFiniteMagnitude))
            size.width = ceil(size.width)
            size.height = ceil(size.height)
        }
        return size
    }
    
    // Autolayout
    
    override func mouseDown(with event: NSEvent) {
        
        // only if the text field is selected
        if selected {
            super.mouseDown(with: event)
        }
        else {
            self.nextResponder?.mouseDown(with: event)
        }
    }
    
    // In the textfield subclass:
    override func mouseEntered(with event: NSEvent) {
        
        if let _ = self.currentEditor() as? NSTextView {
        
            super.mouseEntered(with: event)
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("StyleNameTextField mouseEntered", log: Log.StyleEditor.all, type: .info)
            #endif

            super.mouseEntered(with: event)
            
            if selected {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("StyleNameTextField.mouseEntered -> NSCursor.iBeam.set()", log: Log.StyleEditor.all, type: .info)
                #endif

                NSCursor.iBeam.set()
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("StyleNameTextField.mouseEntered -> NSCursor.arrow.set()", log: Log.StyleEditor.all, type: .info)
                #endif

                NSCursor.arrow.set()
            }
        }
    }
    
    // In the textfield subclass:
    override func mouseExited(with event: NSEvent) {
        
        if let _ = self.currentEditor() as? NSTextView {
            
            super.mouseExited(with: event)
        }
        else {
        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("StyleNameTextField.mouseExited -> NSCursor.arrow.set()", log: Log.StyleEditor.all, type: .info)
            #endif

            NSCursor.arrow.set()
        }
    }
    
    override func mouseMoved(with event: NSEvent) {

        if let _ = self.currentEditor() as? NSTextView {
            
            super.mouseMoved(with: event)
        }
        else {
        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("StyleNameTextField mouseMoved", log: Log.StyleEditor.all, type: .info)
            #endif

            if selected {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("NSCursor.iBeam.set()", log: Log.StyleEditor.all, type: .info)
                #endif

                NSCursor.iBeam.set()
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("NSCursor.arrow.set()", log: Log.StyleEditor.all, type: .info)
                #endif

                NSCursor.arrow.set()
            }
        }
    }
    
}

