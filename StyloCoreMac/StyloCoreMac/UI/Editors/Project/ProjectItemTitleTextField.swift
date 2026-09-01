//
//  ProjectItemTitleTextField.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-19.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import os
import WriterCommon

class ProjectItemTitleTextField: NSTextField {
    
    var selected: Bool = false
    
    weak var textManager: TextManager?
    
    var toolTipString: String? {
        
        return textManager?.path ?? ""
    }
    
    override init(frame: NSRect) {
        
        super.init(frame: frame)
        self.allowsExpansionToolTips = true
        self.prepareAutosizingTextField()
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.mouseMoved), owner: self, userInfo: nil))
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.allowsExpansionToolTips = true 
        self.prepareAutosizingTextField()
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.mouseMoved), owner: self, userInfo: nil))
    }
    
    override public func expansionFrame(withFrame contentFrame: NSRect) -> NSRect {
        self.updateTooltip()
        return super.expansionFrame(withFrame: contentFrame)
    }
    
    func updateTooltip() {
        
        guard let toolTipString = self.toolTipString else {
            assertionFailure("Error: self.toolTipString is nil")
            return
        }

        self.toolTip = toolTipString
    }
    
    func prepareAutosizingTextField() {
        
        self.lineBreakMode = .byTruncatingTail
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
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
        
        return size
    }
    
    override public func mouseDown(with event: NSEvent) {
        
        if event.clickCount == 2 {
            super.mouseDown(with: event)
            if let editor = self.currentEditor() {
                editor.perform(#selector(selectAll(_:)), with: self, afterDelay: 0)
            }
        }
        else {
            self.resignFirstResponder()
            self.nextResponder?.mouseDown(with: event)
        }
    }
    
    override public func addToolTip(_ rect: NSRect, owner: Any, userData data: UnsafeMutableRawPointer?) -> NSView.ToolTipTag {
        
        self.updateTooltip()
        return super.addToolTip(rect, owner: owner, userData: data)
    }
    
}
