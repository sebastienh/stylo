//
//  BackgroundView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-05-17.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class BackgroundView: NSView {
    
    override var isOpaque: Bool {
        return false
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func mouseDown(with event: NSEvent) {
        // do nothing
    }
    
    override func mouseMoved(with event: NSEvent) {
        // do nothing
    }

    override func mouseEntered(with event: NSEvent) {
        // do nothing
    }
    
}
