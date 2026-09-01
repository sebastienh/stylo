//
//  TimerField.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-11-08.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Cocoa

class TimerField: NSTextField {
    
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
    
}
