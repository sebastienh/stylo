//
//  StyloVisualEffectView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-29.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

open class StyloVisualEffectView: NSVisualEffectView {
    
    open override var allowsVibrancy: Bool {
        return true
    }
    
    open override func layout() {
        assert(!self.hasAmbiguousLayout)
        super.layout()
    }

}
