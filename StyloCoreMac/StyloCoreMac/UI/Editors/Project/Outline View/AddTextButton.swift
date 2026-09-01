//
//  AddTextButton.swift
//  Stylo
//
//  Created by Sebastien Hamel on 2019-12-14.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa

class AddTextButton: NSButton {
    
    override var refusesFirstResponder: Bool {
        set {}
        get {return true}
    }
    
    override var bezelColor: NSColor? {
        get {return nil}
        set {}
    }
    
    override func becomeFirstResponder() -> Bool {
        return false
    }
}
