//
//  TopDomInspectorView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-06-28.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class TopDomInspectorView: NSVisualEffectView {
    
    @IBInspectable var backgroundColor: CGColor {
        
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
        self.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
        self.backgroundColor = NSColor(calibratedRed: 42/255, green: 41/255, blue: 40/255, alpha: 1).cgColor
    }
}
