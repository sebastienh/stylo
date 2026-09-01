//
//  CSSPropertyEvaluator.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-09-04.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

struct CSSPropertyEvaluator {
    
    /// Generic method to parse any CSDeclaration to it's DOM representation.
    static func parsePropertyValueToDOM(_ declaration: CSDeclaration, parentPropertyValueElement: CSSDOMElement) {
        
        // Even if the property is not supported we will get a module because
        // we have created the UnsupportedPropertyModule to handle the conversion
        // from CSSOM to CSS DOM.
        
        if let property = CSSProperty(rawValue: declaration.propertyName) {
            
            switch property {
            case .fontFamily:
                CSSFontModule.parseFontFamilyToDom(declaration, parentPropertyElement: parentPropertyValueElement)
            case .fontSize:
                CSSFontModule.parseFontSizeToDom(declaration, parentPropertyElement: parentPropertyValueElement)
            case .fontWeight:
                CSSFontModule.parseFontWeightToDom(declaration, parentPropertyElement: parentPropertyValueElement)
            case .fontStyle:
                CSSFontModule.parseFontStyleToDom(declaration, parentPropertyElement: parentPropertyValueElement)
            case .color:
                CSSColorModule.parseColorValueToDOM(declaration, parentPropertyElement: parentPropertyValueElement)
            case .backgroundColor:
                CSSColorModule.parseColorValueToDOM(declaration, parentPropertyElement: parentPropertyValueElement)
            case .textDecorationColor:
                CSSColorModule.parseColorValueToDOM(declaration, parentPropertyElement: parentPropertyValueElement)
            case .textDecorationLine:
                CSSTextDecorationModule.parseTextDecorationLinePropertyValueToDOM(declaration, parentPropertyElement: parentPropertyValueElement)
            case .textDecorationStyle:
                CSSTextDecorationModule.parseTextDecorationStylePropertyValueToDOM(declaration, parentPropertyElement: parentPropertyValueElement)
            case .caretColor:
                CSSColorModule.parseColorValueToDOM(declaration, parentPropertyElement: parentPropertyValueElement)
            }
        }
        // could ve a var property definition of the form:
        // --test: blue;
        // or
        // --test: var(--blue, red);
        else if  declaration.propertyName.starts(with: "--") {
            UnknownPropertyModule.shared.parsePropertyValueToDOM(declaration, parentPropertyElement: parentPropertyValueElement)
        }
        else {
            
            UnsupportedPropertyModule.shared.parsePropertyValueToDOM(declaration, parentPropertyElement: parentPropertyValueElement)
        }
    }
    
    /// Generic method to parse any CSDeclaration a get it's value.
    static func parsePropertyValue(_ declaration: CSDeclaration) -> CSSPropertyValueContainer? {
        
        if declaration.propertyName.starts(with: "--") {
            
            // we have a custom property value definition.
            // [CSS](https://drafts.csswg.org/css-variables/#defining-variables)
            
            // in this case we can not know the value type until
            // the custom property is used in a var(...) declaration
            // like this:
            // ``` css
            //      color: var(--custom-property);
            // ```
            return CSSPropertyValueContainer.customValue(declaration)
        }
        else if let property = CSSProperty(rawValue: declaration.propertyName) {
            
            switch property {
                
            case .fontFamily:
                
                if let fontFamilyValue = CSSFontModule.parseFontFamilyToValue(declaration) {
                    
                    return CSSPropertyValueContainer.fontFamily(fontFamilyValue)
                }
                
            case .fontSize:
                
                if let fontSizeValue = CSSFontModule.parseFontSizeToValue(declaration) {
                    
                    return CSSPropertyValueContainer.fontSize(fontSizeValue)
                }
                
            case .fontWeight:
                
                if let fontWeightValue = CSSFontModule.parseFontWeightToValue(declaration) {
                    
                    return CSSPropertyValueContainer.fontWeight(fontWeightValue)
                }
                
            case .fontStyle:
                
                if let fontStyleValue = CSSFontModule.parseFontStyleToValue(declaration) {
                    return CSSPropertyValueContainer.fontStyle(fontStyleValue)
                }
                
            case .caretColor:
                
                // This module returns a CSSColor value which contains the CIColor
                if let cssColor = CSSColorModule.parseColorToValue(declaration) {
                    return CSSPropertyValueContainer.caretColor(cssColor)
                }
                
            case .color:
                
                // This module returns a CSSColor value which contains the CIColor
                if let cssColor = CSSColorModule.parseColorToValue(declaration) {
                    return CSSPropertyValueContainer.color(cssColor)
                }
                
            case .backgroundColor:
                
                // This module returns a CSSColor value which contains the CIColor
                if let cssColor = CSSColorModule.parseColorToValue(declaration) {
                    return CSSPropertyValueContainer.backgroundColor(cssColor)
                }
                
            case .textDecorationColor:
                
                // This module returns a CSSColor value which contains the CIColor
                if let cssColor = CSSColorModule.parseColorToValue(declaration) {
                    
                    return CSSPropertyValueContainer.textDecorationColor(cssColor)
                }
                
            case .textDecorationLine:
                
                // This module returns a CSSColor value which contains the CIColor
                if let textDecorationLineValue = CSSTextDecorationModule.parseTextDecorationLineToValue(declaration) {
                    
                    return CSSPropertyValueContainer.textDecorationLine(textDecorationLineValue)
                }
                
            case .textDecorationStyle:
                
                // This module returns a CSSColor value which contains the CIColor
                if let textDecorationStyleValue = CSSTextDecorationModule.parseTextDecorationStyleToValue(declaration) {
                    return CSSPropertyValueContainer.textDecorationStyle(textDecorationStyleValue)
                }
            }
        }
        return nil
    }
    
    /// Generic method to parse any CSDeclaration a get it's value.
    static func parsePropertyValue(_ property: CSSProperty, componentValues: [CSComponentValue]) -> CSSPropertyValueContainer? {
        
        switch property {
        case .fontFamily:
            
            if let fontFamilyValue = CSSFontModule.parseFontFamilyToValue(componentValues) {
                return CSSPropertyValueContainer.fontFamily(fontFamilyValue)
            }
            
        case .fontSize:
            
            if let fontSizeValue = CSSFontModule.parseFontSizeToValue(componentValues) {
                return CSSPropertyValueContainer.fontSize(fontSizeValue)
            }
            
        case .fontWeight:
            
            if let fontWeightValue = CSSFontModule.parseFontWeightToValue(componentValues) {
                return CSSPropertyValueContainer.fontWeight(fontWeightValue)
            }
            
        case .fontStyle:
            
            if let fontStyleValue = CSSFontModule.parseFontStyleToValue(componentValues) {
                return CSSPropertyValueContainer.fontStyle(fontStyleValue)
            }
            
        case .caretColor:
            
            // This module returns a CSSColor value which contains the CIColor
            if let cssColor = CSSColorModule.parseColorToValue(componentValues) {
                return CSSPropertyValueContainer.caretColor(cssColor)
            }
            
        case .color:
            
            // This module returns a CSSColor value which contains the CIColor
            if let cssColor = CSSColorModule.parseColorToValue(componentValues) {
                return CSSPropertyValueContainer.color(cssColor)
            }
            
        case .backgroundColor:
            
            // This module returns a CSSColor value which contains the CIColor
            if let cssColor = CSSColorModule.parseColorToValue(componentValues) {
                return CSSPropertyValueContainer.backgroundColor(cssColor)
            }
            
        case .textDecorationColor:
            
            // This module returns a CSSColor value which contains the CIColor
            if let cssColor = CSSColorModule.parseColorToValue(componentValues) {
                return CSSPropertyValueContainer.textDecorationColor(cssColor)
            }
            
        case .textDecorationLine:
            
            // This module returns a CSSColor value which contains the CIColor
            if let textDecorationLineValue = CSSTextDecorationModule.parseTextDecorationLineToValue(componentValues) {
                
                return CSSPropertyValueContainer.textDecorationLine(textDecorationLineValue)
            }
            
        case .textDecorationStyle:
            
            // This module returns a CSSColor value which contains the CIColor
            if let textDecorationStyleValue = CSSTextDecorationModule.parseTextDecorationStyleToValue(componentValues) {
                return CSSPropertyValueContainer.textDecorationStyle(textDecorationStyleValue)
            }
        }
        return nil
    }
}
