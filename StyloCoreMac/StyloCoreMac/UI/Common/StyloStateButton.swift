//
//  StyloStateButton.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-26.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation

import Cocoa

@IBDesignable
class StyloStateButton: AppearanceFollowerButton, TextColorableButton {
    
    @IBInspectable var textColor: NSColor? {
        didSet {
            assert(Thread.isMainThread)
            self.needsDisplay = true
        }
    }
    
    var additionalAttributes: [NSAttributedString.Key : Any]? {
        didSet {
            self.needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
    
        updateText()
        assert(Thread.isMainThread)
        super.draw(dirtyRect)
    }
    
    func updateText() {
        
        if !self.isEnabled {
        
            if let font = font {
                
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                
                var attributes: [NSAttributedString.Key : Any] = [
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.paragraphStyle: style]
                
                attributes[NSAttributedString.Key.foregroundColor] = NSColor.alternateSelectedControlTextColor
                
                if let additionalAttributes = additionalAttributes {
                    
                    for (name, value) in additionalAttributes {
                        attributes[name] = value
                    }
                }
                
                let attributedTitle = NSAttributedString(string: title, attributes: attributes)
                self.attributedTitle = attributedTitle
            }
        }
        else {
            
            if let font = font {
               
                let textColor = NSColor.selectedControlTextColor
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                
                var attributes: [NSAttributedString.Key : Any] = [
                    NSAttributedString.Key.foregroundColor: textColor,
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.paragraphStyle: style
                ]
                
                if let additionalAttributes = additionalAttributes {
                    for (name, value) in additionalAttributes {
                        attributes[name] = value
                    }
                }
                
                let attributedTitle = NSAttributedString(string: title, attributes: attributes)
                self.attributedTitle = attributedTitle
            }
        }
    }
    
}
