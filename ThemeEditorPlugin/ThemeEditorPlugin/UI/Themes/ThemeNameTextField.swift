//
//  StyleNameTextField.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-06-02.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class ThemeNameTextField: NSTextField {
    
    weak var themesTableCellView: ThemesTableCellView!

    override init(frame: NSRect) {
        
        super.init(frame: frame)
        self.prepareAutosizingTextField()
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.prepareAutosizingTextField()
    }

    func prepareAutosizingTextField() {
        
        self.lineBreakMode      = .byTruncatingTail
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
        if themesTableCellView.selected {
            
            super.mouseDown(with: event)
        }
        else {
            self.nextResponder?.mouseDown(with: event)
        }
    }
    
}
