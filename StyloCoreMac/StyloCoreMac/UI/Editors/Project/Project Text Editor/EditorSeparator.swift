//
//  EditorSeparator.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-03-03.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import Common

class EditorSeparator: ColoredView {
    
    var baseColor: NSColor? {
        didSet {
            updateSeparatorColor()
        }
    }
    
    var isLast: Bool = false {
        didSet {
            updateSeparatorColor()
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.backgroundColor = nsColor(named: "TitleSeparatorColor", bundle: Bundle(for: type(of: self)))
        self.cornerRadius = 2
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = nsColor(named: "TitleSeparatorColor", bundle: Bundle(for: type(of: self)))
        self.cornerRadius = 2
    }
    
    override func viewDidChangeEffectiveAppearance() {
        self.updateSeparatorColor()
        super.viewDidChangeEffectiveAppearance()
    }
    
    private func updateSeparatorColor() {
        
        if let baseColor = self.baseColor {
            if isLast {
                self.backgroundColor = baseColor
            }
            else {
                if isLight(color: baseColor) {
                    self.backgroundColor = baseColor.darkened(amount: 0.1)
                }
                else {
                    self.backgroundColor = baseColor.darkened(amount: 0.05)
                }
            }
        }
        else {
            self.backgroundColor = nsColor(named: "TitleSeparatorColor", bundle: Bundle(for: type(of: self)))
        }
        
        self.needsDisplay = true
    }
    
    private func isLight(color: NSColor) -> Bool {
        
        if let color = DynamicColor(cgColor: color.cgColor) {
            return color.isLight()
        }
        return true
    }
    
}
