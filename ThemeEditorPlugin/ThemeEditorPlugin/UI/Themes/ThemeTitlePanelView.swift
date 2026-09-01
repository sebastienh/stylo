//
//  StyleTitlePanelView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-01-29.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import WriterCommon
import StyloCoreMac

final class ThemeTitlePanelView: NSView {
    
    override var isOpaque: Bool {
        
        return true
    }
    
    @IBInspectable dynamic var backgroundColor: CGColor? {
        
        get {
            return self.layer?.backgroundColor
        }
        set {
            self.layer?.backgroundColor = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.wantsLayer = true
    }

    override func viewDidChangeEffectiveAppearance() {
        
        self.updateLayer()
        super.viewDidChangeEffectiveAppearance()
    }
    
    override func updateLayer() {
        
        self.layer?.backgroundColor = cgColor(named: "TitleViewBackgroundColor")
        super.updateLayer()
    }
    
}
