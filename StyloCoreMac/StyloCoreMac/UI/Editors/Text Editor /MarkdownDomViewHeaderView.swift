//
//  MarkdownDomViewHeaderView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-11-23.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class MarkdownDomViewHeaderView: NSView {
    
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
        self.backgroundColor = InterfaceConstants.EditorTools.DomInspector.TitleBarColor.cgColor
    }
    
}
