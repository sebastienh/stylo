//
//  StyloButton.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-27.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

public class StyloButton: AppearanceFollowerButton, TextColorableButton {
    
    @IBInspectable var textColor: NSColor? {
        didSet {
            assert(Thread.isMainThread)
            self.needsDisplay = true
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    
    override public func draw(_ dirtyRect: NSRect) {
        
        updateText()
        assert(Thread.isMainThread)
        super.draw(dirtyRect)
    }
    
    fileprivate func updateText() {
            
        if let textColor = textColor, let font = font {
            
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            
            let attributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: textColor,
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.paragraphStyle: style
            ]
            
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            self.attributedTitle = attributedTitle
        }
    }
    
}
