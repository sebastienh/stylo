//
//  DomInspectorScrollView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-06-06.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common

class DomInspectorScrollView: NSScrollView {
    
    /// see https://stackoverflow.com/questions/27954538/nstableview-how-to-remove-the-spacebar-event-listener
    override func keyDown(with event: NSEvent) {
        
        if let key = event.charactersIgnoringModifiers?.charAt(0), key == §UnicodeCharacter.whitespace {
            
            return
        }
        
        super.keyDown(with: event)
    }
}
