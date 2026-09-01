//
//  CSSFontModuleLevel3.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-18.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

struct CSSFontModule: CSSModule {

    /// Font-Family: DOM parsing
    static func parseFontFamilyToDom(_ declaration: CSDeclaration, parentPropertyElement: CSSDOMElement) {
        
        let domFontFamilyParser =  CSSDOMFontFamilyPropertyValueParser(componentValueArray: declaration.propertyValueComponentValueList, parentPropertyElement: parentPropertyElement )
        
        domFontFamilyParser.parsePropertyValueDom()
    }
    
    /// Font-Family: value parsing
    /// This method return the first supported fontFamily.
    static func parseFontFamilyToValue(_ declaration: CSDeclaration) -> CSSFontFamily? {
        
        return CSSFontModule.parseFontFamilyToValue(declaration.propertyValueComponentValueList)
    }
    
    /// Font-Family: value parsing
    /// This method return the first supported fontFamily.
    static func parseFontFamilyToValue(_ componentValues: [CSComponentValue]) -> CSSFontFamily? {
        
        let fontFamilyParser = CSSDOMFontFamilyPropertyValueParser(componentValueArray: componentValues)
        return fontFamilyParser.parsePropertyValue()
    }
    
    static func parseFontVariantToValue(_ declaration: CSDeclaration) -> CSSFontVariant? {
        
        return CSSFontModule.parseFontVariantToValue(declaration.propertyValueComponentValueList)
    }
    
    static func parseFontVariantToValue(_ componentValues: [CSComponentValue]) -> CSSFontVariant? {
        
        let fontVariantParser = CSSFontVariantParser(componentValueArray: componentValues)
        return fontVariantParser.parseFontVariantToValue()
    }
    
    /// Font-Size: DOM parsing
    static func parseFontSizeToDom(_ declaration: CSDeclaration, parentPropertyElement: CSSDOMElement) {
        
        let domFontSizeEventParser = CSSDOMFontSizeParser(componentValueArray: declaration.propertyValueComponentValueList, parentPropertyElement: parentPropertyElement)

        domFontSizeEventParser.parseFontSizeValueToDOM()
    }
    
    /// Font-Size: value parsing
    static func parseFontSizeToValue(_ declaration: CSDeclaration) -> CSSFontSize? {
    
        return CSSFontModule.parseFontSizeToValue(declaration.propertyValueComponentValueList)
    }
    
    /// Font-Size: value parsing
    static func parseFontSizeToValue(_ componentValues: [CSComponentValue]) -> CSSFontSize? {
    
        let fontSizeParser = CSSFontSizeParser(componentValueArray: componentValues)
        
        return fontSizeParser.parsePropertyValue()
    }
    
    /// font-weight
    static func parseFontWeightToValue(_ declaration: CSDeclaration ) -> CSSFontWeight? {
    
        return CSSFontModule.parseFontWeightToValue(declaration.propertyValueComponentValueList)
    }

    /// font-weight
    static func parseFontWeightToValue(_ componentValues: [CSComponentValue]) -> CSSFontWeight? {
    
        let fontWeightParser = CSSFontWeightParser(componentValueArray: componentValues)
        return fontWeightParser.parseFontWeightToValue()
    }
    
    static func parseFontWeightToDom(_ declaration: CSDeclaration, parentPropertyElement: CSSDOMElement) {
        
        let domFontWeightEventParser = CSSDOMFontWeightParser(componentValueArray: declaration.propertyValueComponentValueList, parentPropertyElement: parentPropertyElement)
        domFontWeightEventParser.parseFontSizeValueToDOM()
    }
    
    /// font-style
    static func parseFontStyleToValue(_ declaration: CSDeclaration) -> CSSFontStyle? {
        
        return CSSFontModule.parseFontStyleToValue(declaration.propertyValueComponentValueList)
    }
    
    /// font-style
    static func parseFontStyleToValue(_ componentValues: [CSComponentValue]) -> CSSFontStyle? {
        
        let fontStyleParser = CSSFontStyleParser(componentValueArray: componentValues)
        return fontStyleParser.parseFontStyleToValue()
    }
    
    static func parseFontStyleToDom(_ declaration: CSDeclaration, parentPropertyElement: CSSDOMElement) {
        
        let fontStyleEventDomParser = CSSDOMFontStyleParser(componentValueArray: declaration.propertyValueComponentValueList, parentPropertyElement: parentPropertyElement)
        fontStyleEventDomParser.parseFontStyleValueToDOM()
    }
    
    static func parseFontStretchToValue(_ declaration: CSDeclaration ) -> CSSFontStretch? {
        
        return CSSFontModule.parseFontStretchToValue(declaration.propertyValueComponentValueList)
    }

    static func parseFontStretchToValue(_ componentValues: [CSComponentValue]) -> CSSFontStretch? {
        
        let fontStretchParser = CSSFontStretchParser(componentValueArray: componentValues)
        return fontStretchParser.parseFontStretchToValue()
    }
    
}
