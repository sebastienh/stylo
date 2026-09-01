//
//  AudioFileTitleTextField.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-09-15.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import Cocoa
import os

class AudioFileTitleTextField: NSTextField {
    
    var selected: Bool = false
    
    override init(frame: NSRect) {
        
        super.init(frame: frame)
        self.prepareAutosizingTextField()
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.mouseMoved), owner: self, userInfo: nil))
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.prepareAutosizingTextField()
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.mouseMoved), owner: self, userInfo: nil))
    }
    
    func prepareAutosizingTextField() {
        
        self.lineBreakMode = .byTruncatingTail
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override var intrinsicContentSize: NSSize {
        
        var size: NSSize
        let bounds = self.bounds
        
        if let fieldEditor = self.currentEditor() as? NSTextView {
            
            let fieldEditorSuperview = fieldEditor.superview!
            let textContainer = fieldEditor.textContainer
            let layoutManager = fieldEditor.layoutManager
            
            let usedRect = layoutManager?.usedRect(for: textContainer!)
            let clipRect = self.convert(fieldEditorSuperview.bounds, from: fieldEditor.superview)
            
            let clipDelta = NSSize(width: NSWidth(bounds) - NSWidth(clipRect), height:NSHeight(bounds) - NSHeight(clipRect))
            size = NSSize(width: ceil(NSWidth(usedRect!) + clipDelta.width), height: NSHeight(usedRect!) + clipDelta.height)
            
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
            os_log("AudioFileTitleTextField.mouseEntered", log: Log.Audio.all, type: .info)
            #endif
            
            super.mouseEntered(with: event)
            
            if selected {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("AudioFileTitleTextField.mouseEntered -> NSCursor.iBeam.set()", log: Log.Audio.all, type: .info)
                #endif
                
                NSCursor.iBeam.set()
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("AudioFileTitleTextField.mouseEntered -> NSCursor.arrow.set()", log: Log.Audio.all, type: .info)
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
            os_log("AudioFileTitleTextField.mouseExited -> NSCursor.arrow.set()", log: Log.Audio.all, type: .info)
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
            os_log("StyleNameTextField mouseMoved", log: Log.Audio.all, type: .info)
            #endif
            
            if selected {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("AudioFileTitleTextField.mouseMoved -> NSCursor.iBeam.set()", log: Log.Audio.all, type: .info)
                #endif
                
                NSCursor.iBeam.set()
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("AudioFileTitleTextField.mouseMoved -> NSCursor.arrow.set()", log: Log.Audio.all, type: .info)
                #endif
                
                NSCursor.arrow.set()
            }
        }
    }
    
}
