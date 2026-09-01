//
//  EditorSideSeparator.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-09-26.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import Common

class EditorSideSeparator: ColoredView {
    
    var baseColor: NSColor? {
        didSet {
            updateSeparatorColor()
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.backgroundColor = nsColor(named: "TitleSeparatorColor", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = nsColor(named: "TitleSeparatorColor", bundle: Bundle(for: type(of: self)))
    }
    
    override func viewDidChangeEffectiveAppearance() {
        self.updateSeparatorColor()
        super.viewDidChangeEffectiveAppearance()
    }
    
    private func updateSeparatorColor() {
        
        if let baseColor = self.baseColor {
            self.backgroundColor = baseColor
        }
        else {
            self.backgroundColor = nsColor(named: "TitleSeparatorColor", bundle: Bundle(for: type(of: self)))
        }
        
        self.needsDisplay = true
    }
    
}
