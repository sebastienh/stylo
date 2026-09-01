//
//  StyleHeaderStyleNameTextField.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-12-09.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation

import Foundation
import Cocoa
import os

class StyleHeaderStyleNameTextField: NSTextField {
    
    override public var intrinsicContentSize: NSSize {
        
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
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Returning size: %@ from FilesOutlineTitleTextField with id: %@", log: Log.StyloCore.all, type: .info, %%size, %%ObjectIdentifier(self))
        #endif
        
        return size
    }
    
    var isEditing: Bool {
        return self.currentEditor() != nil
    }
    
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
    
    override func selectText(_ sender: Any?) {
        
        // nothing to do
    }
    
    private func prepareAutosizingTextField() {
        
        self.lineBreakMode = .byTruncatingTail
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
