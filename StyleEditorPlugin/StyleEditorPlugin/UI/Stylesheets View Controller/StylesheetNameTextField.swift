//
//  StylesheetNameTextField.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-12-11.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import os

class StylesheetNameTextField: NSTextField {

    override var isEditable: Bool {
        get {return true}
        set {}
    }

    override init(frame: NSRect) {

        super.init(frame: frame)
        self.prepareAutosizingTextField()
//        self.addTrackingArea(NSTrackingArea(rect: .zero, options: NSTrackingArea.Options.inVisibleRect.union(.activeInKeyWindow).union(.mouseEnteredAndExited).union(.mouseMoved), owner: self, userInfo: nil))
    }

    required init?(coder: NSCoder) {

        super.init(coder: coder)
        self.prepareAutosizingTextField()
//        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.mouseMoved), owner: self, userInfo: nil))
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
    
    override func validateProposedFirstResponder(_ responder: NSResponder, for event: NSEvent?) -> Bool {
        return true
    }
    
}

