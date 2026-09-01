//
//  TextStylizer.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-05-07.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import Web
import os

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

fileprivate let zero = NSNumber(value: 0)

class TextStylizer {
    
    /// Singleton instance.
    static var shared = TextStylizer()
    
    fileprivate init() {
        
    }
    
    func blockStyle(from cssStyleDeclaration: ComputedStyleDeclaration?, element: Element? = nil) -> [NSAttributedString.Key : AnyObject]? {
        
        if let cssStyleDeclaration = cssStyleDeclaration {
            
            var attributes = [NSAttributedString.Key:AnyObject]()
            
            var strikethroughStyleAdded = false
            var underlineStyleAdded = false
            var overlineStyleAdded = false
            
            // if it's something else than noUnderline it will
            // be handled.
            if let _underlines = underline(from: cssStyleDeclaration) {
                
                // get the style
                let _underlineStyle = underlineStyle(from: cssStyleDeclaration)
                
                for _underline in _underlines {
                    
                    attributes.updateValue(_underlineStyle as AnyObject, forKey: _underline)
                    
                    switch _underline {
                    case NSAttributedString.Key.strikethroughStyle:
                        strikethroughStyleAdded = true
                    case NSAttributedString.Key.underlineStyle:
                        underlineStyleAdded = true
                    case NSAttributedString.Key(rawValue: §StyloAttribute.overlineStyle):
                        overlineStyleAdded = true
                    default:
                        assert(false, "problem unsupported underline type.")
                        break
                    }
                    
                    if let _underlineColor = underlineColor(from: cssStyleDeclaration) {
                        
                        switch _underline {
                        case NSAttributedString.Key.strikethroughStyle:
                            attributes.updateValue(_underlineColor, forKey: NSAttributedString.Key(rawValue: §StyloAttribute.strikethroughColor))
                        case NSAttributedString.Key.underlineStyle:
                            attributes.updateValue(_underlineColor, forKey: NSAttributedString.Key.underlineColor)
                        case NSAttributedString.Key(rawValue: §StyloAttribute.overlineStyle):
                            attributes.updateValue(_underlineColor, forKey: NSAttributedString.Key(rawValue: §StyloAttribute.overlineColor))
                        default:
                            assert(false, "problem unsupported underline type.")
                            break
                        }
                    }
                }
            }
            
            if !strikethroughStyleAdded {
                attributes.updateValue(zero, forKey: NSAttributedString.Key.strikethroughStyle)
            }
            if !underlineStyleAdded {
                attributes.updateValue(zero, forKey: NSAttributedString.Key.underlineStyle)
            }
            if !overlineStyleAdded {
                attributes.updateValue(zero, forKey: NSAttributedString.Key(rawValue: §StyloAttribute.overlineStyle))
            }
            return attributes
        }
        return nil
    }
    
    func textDecorationStyle(from cssStyleDeclaration: ComputedStyleDeclaration?, element: Element? = nil) -> [NSAttributedString.Key : Any]? {
        
        if let cssStyleDeclaration = cssStyleDeclaration {
            
            var attributes = [NSAttributedString.Key: Any]()
            
            var strikethroughStyleAdded = false
            var underlineStyleAdded = false
            var overlineStyleAdded = false
            
            if let underlines = self.underline(from: cssStyleDeclaration) {
                
                // get the style
                let underlineStyle = self.underlineStyle(from: cssStyleDeclaration)
                
                for underline in underlines {
                    
                    attributes.updateValue(underlineStyle as AnyObject, forKey: underline)
                    
                    switch underline {
                    case NSAttributedString.Key.strikethroughStyle:
                        strikethroughStyleAdded = true
                    case NSAttributedString.Key.underlineStyle:
                        underlineStyleAdded = true
                    case NSAttributedString.Key(rawValue: §StyloAttribute.overlineStyle):
                        overlineStyleAdded = true
                    default:
                        assert(false, "problem unsupported underline type.")
                        break
                    }
                    
                    if let underlineColor = self.underlineColor(from: cssStyleDeclaration) {
                        
                        switch underline {
                        case NSAttributedString.Key.strikethroughStyle:
                            attributes.updateValue(underlineColor, forKey: NSAttributedString.Key(rawValue: §StyloAttribute.strikethroughColor))
                        case NSAttributedString.Key.underlineStyle:
                            attributes.updateValue(underlineColor, forKey: NSAttributedString.Key.underlineColor)
                        case NSAttributedString.Key(rawValue: §StyloAttribute.overlineStyle):
                            attributes.updateValue(underlineColor, forKey: NSAttributedString.Key(rawValue: §StyloAttribute.overlineColor))
                        default:
                            assert(false, "problem unsupported underline type.")
                            break
                        }
                    }
                }
            }
            
            if !strikethroughStyleAdded {
                attributes.updateValue(zero, forKey: NSAttributedString.Key.strikethroughStyle)
            }
            if !underlineStyleAdded {
                attributes.updateValue(zero, forKey: NSAttributedString.Key.underlineStyle)
            }
            if !overlineStyleAdded {
                attributes.updateValue(zero, forKey: NSAttributedString.Key(rawValue: §StyloAttribute.overlineStyle))
            }
            
            return attributes
        }
        return nil
    }
    
    func textStyle(from cssStyleDeclaration: ComputedStyleDeclaration?, element: Element? = nil, documentBackgroundColor: PlateformColorType? = nil, documentCaretColor: PlateformColorType? = nil) -> [NSAttributedString.Key : Any]? {
        
        //loggingPrint("cssStyleDeclaration: \(cssStyleDeclaration)")
        
        if let cssStyleDeclaration = cssStyleDeclaration {
            
            var attributes = [NSAttributedString.Key: Any]()
            
            let fontFromComputedStyle = self.fontFromComputedStyle(cssStyleDeclaration)
            
            assert(fontFromComputedStyle != nil)
            if let fontFromComputedStyle = fontFromComputedStyle {
                
                attributes.updateValue(fontFromComputedStyle, forKey: .font)
            }
            
            if let fontColor = fontColorFromComputedStyle(cssStyleDeclaration) {
                
                attributes.updateValue(fontColor, forKey: .foregroundColor)
            }
            
            if let backgroundColor = self.backgroundColor(from: cssStyleDeclaration) {
                if let documentBackgroundColor = documentBackgroundColor {
                    if backgroundColor != documentBackgroundColor {
                        attributes.updateValue(backgroundColor, forKey: .backgroundColor)
                    }
                }
                else {
                    attributes.updateValue(backgroundColor, forKey: .backgroundColor)
                }
            }
            
            if let caretColor = self.caretColor(from: cssStyleDeclaration) {
                if let documentCaretColor = documentCaretColor {
                    if caretColor != documentCaretColor {
                        attributes.updateValue(caretColor, forKey: StyloAttribute.caretColor.key)
                    }
                }
                else {
                    attributes.updateValue(caretColor, forKey: StyloAttribute.caretColor.key)
                }
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("attributes: %@ for element: %@", log: Log.WriterCommon.all, type: .info, %%attributes, %%String(describing: element?.localName))
            #endif
            return attributes
        }
        
        return nil
    }
    
    
    // text-decoration-line:
    // text-decoration-line: none;
    // text-decoration-line: underline;
    // text-decoration-line: overline;
    // text-decoration-line: line-through;
    // text-decoration-line: blink;
    // text-decoration-line: underline overline;                /* Two decoration lines */
    // text-decoration-line: overline underline line-through;   /* Multiple decoration lines */
    private func underline(from computedStyle: ComputedStyleDeclaration, element: Element? = nil) -> [NSAttributedString.Key]? {
        
        // NSStrikethroughStyleAttributeName
        // NSUnderlineStyleAttributeName
        if let textDecorationLineValueContainer = computedStyle.getCSSPropertyValueContainer(§CSSProperty.textDecorationLine) {
            
            switch textDecorationLineValueContainer {
                
            case .textDecorationLine(let textDecorationLineValues):
                
                var values = [NSAttributedString.Key]()
                
                for textDecorationLineValue in textDecorationLineValues {
                    
                    switch textDecorationLineValue {
                    case .lineThrough:
                        values.append(NSAttributedString.Key.strikethroughStyle)
                    case .noUnderline:
                        // noUnderline takes precedence
                        return nil
                    case .underline:
                        values.append(NSAttributedString.Key.underlineStyle)
                    case .overline:
                        values.append(NSAttributedString.Key(rawValue: §StyloAttribute.overlineStyle))
                    case .defaulted(_):
                        assert(false,"should not have defaulted value here ")
                        break
                    }
                }
                return values
                
            default:
                assert(false, "wrong value container returned...")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("wrong value container returned....", log: Log.WriterCommon.all, type: .error)
                #endif
            }
        }
        
        // default is none
        return nil
    }
    
    // text-decoration-style:
    // text-decoration-style: solid;    :    NSUnderlineStyleSingle
    // text-decoration-style: double;    :    NSUnderlineStyleDouble
    // text-decoration-style: dotted;    :    NSUnderlinePatternDot
    // text-decoration-style: dashed;    :    NSUnderlinePatternDash
    // text-decoration-style: wavy;    :    error (http://www.cocoabuilder.com/archive/cocoa/196182-setting-spell-checker-underlines.html)
    private func underlineStyle(from computedStyle: ComputedStyleDeclaration, element: Element? = nil) -> Int {
        
        if let textDecorationStyleValueContainer = computedStyle.getCSSPropertyValueContainer(§CSSProperty.textDecorationStyle) {
            
            switch textDecorationStyleValueContainer {
                
            case .textDecorationStyle(let textDecorationStyleValue):
                
                switch textDecorationStyleValue {
                    
                case .dashed:
                    return NSUnderlineStyle.patternDash.rawValue | NSUnderlineStyle.single.rawValue
                case .solid:
                    return NSUnderlineStyle.single.rawValue
                case .dotted:
                    return NSUnderlineStyle.patternDot.rawValue | NSUnderlineStyle.single.rawValue
                case .double:
                    return NSUnderlineStyle.double.rawValue
                case .wavy:
                    return §StyloUnderlineStyle.wavy
                case .defaulted(_):
                    return NSUnderlineStyle.single.rawValue
                }
                
            default:
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("not text-decoration-style attribute defined...", log: Log.WriterCommon.all, type: .error)
                #endif
                break
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("no text-decoration-color attribute defined...", log: Log.WriterCommon.all, type: .error)
            #endif
        }
        
        // default is single
        return NSUnderlineStyle.single.rawValue
    }
    
    private func underlineColor(from computedStyle: ComputedStyleDeclaration, element: Element? = nil) -> PlateformColorType? {
        
        if let textDecorationColorValueContainer = computedStyle.getCSSPropertyValueContainer(§CSSProperty.textDecorationColor) {
            
            return textDecorationColorValueContainer.colorValue()
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("no text-decoration-color attribute defined...", log: Log.WriterCommon.all, type: .error)
            #endif
        }
        
        // default is black
        return PlateformColorType(white: 0, alpha: 1)
    }

    private func caretColor(from computedStyle: ComputedStyleDeclaration, element: Element? = nil) -> PlateformColorType? {
        
        guard let caretColorValueContainer = computedStyle.getCSSPropertyValueContainer(§CSSProperty.caretColor) else {
        
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("no color attribute defined...", log: Log.WriterCommon.all, type: .error)
            #endif
            
            // default is black
            return PlateformColorType(calibratedRed: 1, green: 1, blue: 1, alpha: 1)
        }
        return caretColorValueContainer.colorValue()
    }
    
    private func backgroundColor(from computedStyle: ComputedStyleDeclaration, element: Element? = nil) -> PlateformColorType? {
        
        guard let backgroundColorValueContainer = computedStyle.getCSSPropertyValueContainer(§CSSProperty.backgroundColor) else {
        
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("no color attribute defined for element: %@", log: Log.WriterCommon.all, type: .error, %%element?.localName)
            #endif
            
            assertionFailure("Error: no value for §CSSProperty.BackgroundColor")
            return nil
        }
        return backgroundColorValueContainer.colorValue()
    }
    
    private func fontColorFromComputedStyle(_ cssStyleDeclaration: ComputedStyleDeclaration, element: Element? = nil) -> PlateformColorType? {
        
        guard let colorValueContainer = cssStyleDeclaration.getCSSPropertyValueContainer(§CSSProperty.color) else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("no color attribute defined...", log: Log.WriterCommon.all, type: .error)
            #endif
            assertionFailure("Error: no value for §CSSProperty.Color")
            // default is white
            return PlateformColorType(calibratedRed: 0, green: 0, blue: 0, alpha: 1)
        }
        return colorValueContainer.colorValue()
    }
    
    private func fontFromComputedStyle(_ cssStyleDeclaration: ComputedStyleDeclaration) -> PlateformFontType? {
        
        if let fontFamilyValueContainer = cssStyleDeclaration.getCSSPropertyValueContainer(§CSSProperty.fontFamily) {
            
            let fontFamilyName = fontFamilyValueContainer.fontFamilyStringValue()
            
            let fontTraitMask: NSFontTraitMask = self.fontTraitMask(from: cssStyleDeclaration)
            
            if let fontSizeValueContainer = cssStyleDeclaration.getCSSPropertyValueContainer(§CSSProperty.fontSize) {
                
                let fontSize = fontSizeValueContainer.pixelFontSizeValue()
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("availableFonts: %@", log: Log.WriterCommon.all, type: .info, %%NSFontManager.shared.availableFonts)
                #endif
                
                if let fontWeightValueContainer = cssStyleDeclaration.getCSSPropertyValueContainer(§CSSProperty.fontWeight) {
                    
                    let fontWeightValue = fontWeightValueContainer.fontWeightNumericValue()
                    let fontWeightIntValue = fontWeightValue.numericWeight
                    let font = NSFontManager.shared.font(withFamily: fontFamilyName, traits: fontTraitMask, weight: fontWeightIntValue, size: fontSize)
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    
                    os_log("availableFonts memebrs: %@", log: Log.WriterCommon.all, type: .info, %%NSFontManager.shared.availableMembers(ofFontFamily: "Noto Sans Mono"))
                    
                    
                    
                    os_log("fontWeightValue.numericWeight: %@", log: Log.WriterCommon.all, type: .info, %%fontWeightValue.numericWeight)
                    
                    
                    
                    os_log("availableFonts: %@", log: Log.WriterCommon.all, type: .info, %%NSFontManager.shared.availableFontFamilies)

                    for member in NSFontManager.shared.availableMembers(ofFontFamily: "Noto Sans Mono")! {
                        
                        if let font = NSFontManager.shared.font(withFamily: member.first! as! String, traits: fontTraitMask, weight: 3, size: fontSize) {
                            os_log("font member: %@, for requested font family name: %@ and font-weight value: %@", log: Log.WriterCommon.all, type: .info, %%font.fontName, %%fontFamilyName, %%fontWeightValue)
                            
                        }
                        
                    }
                        
                    os_log("returning font: %@, for requested font family name: %@ and font-weight value: %@", log: Log.WriterCommon.all, type: .info, %%font?.fontName, %%fontFamilyName, %%fontWeightValue)
                    #endif
                    
                    if let font = font {
                        return font
                    }
                    else {
                        // we just remove the font traits to see if we can get a font
                        let font = NSFontManager.shared.font(withFamily: fontFamilyName, traits: NSFontTraitMask(), weight: fontWeightIntValue, size: fontSize)
                        
                        if let font = font {
                            return font
                        }
                    }
                    
                }
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Error: unable to find font with name: %@", log: Log.WriterCommon.all, type: .error, %%fontFamilyName)
                #endif
//                assertionFailure("Error: unable to find font with name: \(fontFamilyName)")
                return PlateformFontType(name: fontFamilyName, size: fontSize)!
            }
            else {
                
                // font-weight property is not supported yet: write debugMessage
                // and set the font-size to system default.
                assertionFailure("Error: font-size property with value is not supported yet")
                return PlateformFontType(name: fontFamilyName, size: 18.0)
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("fontFamilyValueContainer is nil.", log: Log.WriterCommon.all, type: .error)
            #endif
        }
        
        return nil
    }
    
    private func fontTraitMask(from declaration: ComputedStyleDeclaration) -> NSFontTraitMask {
        
        var fontTraitMask = NSFontTraitMask()
        
        if let fontStyleValueContainer = declaration.getCSSPropertyValueContainer(§CSSProperty.fontStyle) {
            
            switch fontStyleValueContainer {
            case .fontStyle(let fontStyle):
                
                switch fontStyle {
                case .keyword(let fontStyleKeyword):
                    switch fontStyleKeyword {
                    case .italic:
                        fontTraitMask = NSFontTraitMask.italicFontMask
                    case .oblique:
                        fontTraitMask = NSFontTraitMask.italicFontMask
                    case .normal:
                        fontTraitMask = NSFontTraitMask()
                    }
                default:
                    assert(false, "Received wrong defaulted value.")
                    break
                }
            default:
                assert(false, "Received wrong value from getCSSPropertyValueContainer")
                break
            }
        }
        return fontTraitMask
    }
    
}

