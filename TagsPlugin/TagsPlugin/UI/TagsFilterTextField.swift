//
//  TagsFilterTextField.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-29.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

class TagsFilterTextField: NSTextField {
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        updateAppearance()    
    }
    
    override open func viewDidChangeEffectiveAppearance() {
        updateAppearance()
        super.viewDidChangeEffectiveAppearance()
    }
    
    private func updateAppearance() {
        
        let attributedString = NSMutableAttributedString(string: "Filter", attributes: [NSAttributedString.Key.font : NSFont.systemFont(ofSize: NSFont.systemFontSize)])

        let appearanceName = self.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.white.withAlphaComponent(0.3), range: NSMakeRange(0, attributedString.length))
            
        case .aqua?:
            
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.systemGray.withAlphaComponent(0.5), range: NSMakeRange(0, attributedString.length))
            
        default:
            assert(false)
        }
        
        self.placeholderAttributedString = attributedString
    }
}
