//
//  SideViewBack.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-04.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class SideViewBack: NSView {
    
    override var isOpaque: Bool {
        
        return true
    }
    
    var backgroundColor: CGColor {
        
        get {
            return self.layer!.backgroundColor!
        }
        set {
            self.layer!.backgroundColor = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.wantsLayer = true
        self.backgroundColor = NSColor(calibratedRed: 48/255, green: 47/255, blue: 46/255, alpha: 1).cgColor
    }
    
}
