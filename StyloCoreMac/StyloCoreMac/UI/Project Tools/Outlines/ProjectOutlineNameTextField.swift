//
//  ProjectOutlineNameTextField.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-06.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import os

class ProjectOutlineNameTextField: NSTextField {
    
    var selected: Bool = false
    
    override init(frame: NSRect) {
        
        super.init(frame: frame)
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.mouseMoved), owner: self, userInfo: nil))
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.mouseMoved), owner: self, userInfo: nil))
    }
    
    func prepareAutosizingTextField() {
        
        self.lineBreakMode = .byTruncatingTail
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // In the textfield subclass:
    override func mouseEntered(with event: NSEvent) {
        
        if let _ = self.currentEditor() as? NSTextView {
            
            super.mouseEntered(with: event)
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("StyleNameTextField mouseEntered", log: Log.StyloCore.all, type: .info)
            #endif
            
            super.mouseEntered(with: event)
            
            if selected {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("ProjectOutlineNameTextField.mouseEntered -> NSCursor.iBeam.set()", log: Log.StyloCore.all, type: .info)
                #endif
                
                NSCursor.iBeam.set()
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("ProjectOutlineNameTextField.mouseEntered -> NSCursor.arrow.set()", log: Log.StyloCore.all, type: .info)
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
            os_log("ProjectOutlineNameTextField.mouseExited -> NSCursor.arrow.set()", log: Log.StyloCore.all, type: .info)
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
            os_log("StyleNameTextField mouseMoved", log: Log.StyloCore.all, type: .info)
            #endif
            
            if selected {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("ProjectOutlineNameTextField.mouseMoved -> NSCursor.iBeam.set()", log: Log.StyloCore.all, type: .info)
                #endif
                
                NSCursor.iBeam.set()
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("ProjectOutlineNameTextField.mouseMoved -> NSCursor.arrow.set()", log: Log.StyloCore.all, type: .info)
                #endif
                
                NSCursor.arrow.set()
            }
        }
    }
    
}
