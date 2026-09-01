//
//  TextStylePreview+Loading.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2021-01-05.
//  Copyright © 2021 Textually Inc. All rights reserved.
//

import Foundation

extension TextStylePreview {
    
    static func fromMetadata(_ metadata: TextStylePreviewMetadata) -> TextStylePreview? {
        
        var attributesValue: [TextStylePreview.Element: [NSAttributedString.Key : Any]] = [:]
        
        let bodyColor: NSColor = NSColor(deviceRed: CGFloat(metadata.body.red), green: CGFloat(metadata.body.green), blue: CGFloat(metadata.body.blue), alpha: CGFloat(metadata.body.alpha.value))
        attributesValue[.body] = [.backgroundColor: bodyColor]
        
        let h1Color: NSColor = NSColor(deviceRed: CGFloat(metadata.h1.red), green: CGFloat(metadata.h1.green), blue: CGFloat(metadata.h1.blue), alpha: CGFloat(metadata.h1.alpha.value))
        attributesValue[.h1] = [.foregroundColor: h1Color]
        
        let h2Color: NSColor = NSColor(deviceRed: CGFloat(metadata.h2.red), green: CGFloat(metadata.h2.green), blue: CGFloat(metadata.h2.blue), alpha: CGFloat(metadata.h2.alpha.value))
        attributesValue[.h2] = [.foregroundColor: h2Color]
    
        let h3Color: NSColor = NSColor(deviceRed: CGFloat(metadata.h3.red), green: CGFloat(metadata.h3.green), blue: CGFloat(metadata.h3.blue), alpha: CGFloat(metadata.h3.alpha.value))
        attributesValue[.h3] = [.foregroundColor: h3Color]
        
        let h4Color: NSColor = NSColor(deviceRed: CGFloat(metadata.h4.red), green: CGFloat(metadata.h4.green), blue: CGFloat(metadata.h4.blue), alpha: CGFloat(metadata.h4.alpha.value))
        attributesValue[.h4] = [.foregroundColor: h4Color]
        
        let h5Color: NSColor = NSColor(deviceRed: CGFloat(metadata.h5.red), green: CGFloat(metadata.h5.green), blue: CGFloat(metadata.h5.blue), alpha: CGFloat(metadata.h5.alpha.value))
        attributesValue[.h5] = [.foregroundColor: h5Color]
        
        let h6Color: NSColor = NSColor(deviceRed: CGFloat(metadata.h6.red), green: CGFloat(metadata.h6.green), blue: CGFloat(metadata.h6.blue), alpha: CGFloat(metadata.h6.alpha.value))
        attributesValue[.h6] = [.foregroundColor: h6Color]
        
        let h1TagColor: NSColor = NSColor(deviceRed: CGFloat(metadata.h1Tag.red), green: CGFloat(metadata.h1Tag.green), blue: CGFloat(metadata.h1Tag.blue), alpha: CGFloat(metadata.h1Tag.alpha.value))
        attributesValue[.h1Tag] = [.foregroundColor: h1TagColor]
        
        let h2TagColor: NSColor = NSColor(deviceRed: CGFloat(metadata.h2Tag.red), green: CGFloat(metadata.h2Tag.green), blue: CGFloat(metadata.h2Tag.blue), alpha: CGFloat(metadata.h2Tag.alpha.value))
        attributesValue[.h2Tag] = [.foregroundColor: h2TagColor]
        
        let h3TagColor: NSColor = NSColor(deviceRed: CGFloat(metadata.h3Tag.red), green: CGFloat(metadata.h3Tag.green), blue: CGFloat(metadata.h3Tag.blue), alpha: CGFloat(metadata.h3Tag.alpha.value))
        attributesValue[.h3Tag] = [.foregroundColor: h3TagColor]
        
        let h4TagColor: NSColor = NSColor(deviceRed: CGFloat(metadata.h4Tag.red), green: CGFloat(metadata.h4Tag.green), blue: CGFloat(metadata.h4Tag.blue), alpha: CGFloat(metadata.h4Tag.alpha.value))
        attributesValue[.h4Tag] = [.foregroundColor: h4TagColor]
        
        let h5TagColor: NSColor = NSColor(deviceRed: CGFloat(metadata.h5Tag.red), green: CGFloat(metadata.h5Tag.green), blue: CGFloat(metadata.h5Tag.blue), alpha: CGFloat(metadata.h5Tag.alpha.value))
        attributesValue[.h5Tag] = [.foregroundColor: h5TagColor]
        
        let h6TagColor: NSColor = NSColor(deviceRed: CGFloat(metadata.h6Tag.red), green: CGFloat(metadata.h6Tag.green), blue: CGFloat(metadata.h6Tag.blue), alpha: CGFloat(metadata.h6Tag.alpha.value))
        attributesValue[.h6Tag] = [.foregroundColor: h6TagColor]
        
        let codeColor: NSColor = NSColor(deviceRed: CGFloat(metadata.code.red), green: CGFloat(metadata.code.green), blue: CGFloat(metadata.code.blue), alpha: CGFloat(metadata.code.alpha.value))
        attributesValue[.code] = [.foregroundColor: codeColor]
        
        let hrColor: NSColor = NSColor(deviceRed: CGFloat(metadata.hr.red), green: CGFloat(metadata.hr.green), blue: CGFloat(metadata.hr.blue), alpha: CGFloat(metadata.hr.alpha.value))
        attributesValue[.hr] = [.foregroundColor: hrColor]
        
        let blockquoteColor: NSColor = NSColor(deviceRed: CGFloat(metadata.blockquote.red), green: CGFloat(metadata.blockquote.green), blue: CGFloat(metadata.blockquote.blue), alpha: CGFloat(metadata.blockquote.alpha.value))
        attributesValue[.blockquote] = [.foregroundColor: blockquoteColor]
        
        let pColor: NSColor = NSColor(deviceRed: CGFloat(metadata.p.red), green: CGFloat(metadata.p.green), blue: CGFloat(metadata.p.blue), alpha: CGFloat(metadata.p.alpha.value))
        attributesValue[.p] = [.foregroundColor: pColor]
        
        return TextStylePreview(attributesValue: attributesValue)
    }
    
}
