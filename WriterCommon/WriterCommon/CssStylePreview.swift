//
//  CssStylePreview.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-07-17.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common

public struct CssStylePreview: StylePreview {
    
    let backgroundColor: PlateformColorType?
    
    var propertyNameColor: PlateformColorType?
    
    var propertyValueColor: PlateformColorType?
    
    var propertyNameAttributes: [NSAttributedString.Key : Any]?
    
    public var focusAttributes: [NSAttributedString.Key : Any] {
             
        assertionFailure("Error: missing implementation here, this value should not be used")
        return [.foregroundColor: NSColor.red]
    }
    
    public var paragraphStyle: NSParagraphStyle? {
        
        assert(propertyNameAttributes != nil)
        if let propertyNameAttributes = propertyNameAttributes {
            
            if let font = propertyNameAttributes[NSAttributedString.Key.font] as? NSFont {
        
                let paragraphStyle = self.paragraphStyle(using: font)        
                assert(paragraphStyle != nil)
                return paragraphStyle
            }
        }
        return nil
    }
    
    init(backgroundColor: PlateformColorType?, propertyNameColor: PlateformColorType?, propertyValueColor: PlateformColorType?, propertyNameAttributes: [NSAttributedString.Key : Any]?) {
        
        self.backgroundColor = backgroundColor
        self.propertyNameColor = propertyNameColor
        self.propertyValueColor = propertyValueColor
        self.propertyNameAttributes = propertyNameAttributes
    }
    
    private func paragraphStyle(using font: NSFont) -> NSParagraphStyle? {
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        let screenFont = font.screenFont(with: NSFontRenderingMode.defaultRenderingMode)
        let charWidth = screenFont.advancement(forGlyph: NSGlyph(" ")).width
        paragraphStyle.defaultTabInterval = charWidth*4
        paragraphStyle.tabStops = []
        return paragraphStyle
    }
}
