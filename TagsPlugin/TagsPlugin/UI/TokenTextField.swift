//
//  TokenTextField.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-09.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import Common
import os

class TokenTextField: NSTextField {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    private func configure() {
        
        self.isBordered = false
        self.focusRingType = .none
        self.backgroundColor = NSColor.clear
        self.drawsBackground = true
        self.usesSingleLineMode = true
        self.cell?.truncatesLastVisibleLine = true
        self.usesSingleLineMode = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isEditable = false
        self.lineBreakMode = .byTruncatingTail
        self.alignment = .left
        self.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(1), for: .horizontal)
    }
}
