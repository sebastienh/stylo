//
//  CSSTextDecorationModule.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-27.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common


/// http://www.w3.org/TR/css3-color/
struct CSSTextDecorationModule: CSSModule {
    
    static func parseTextDecorationLineToValue(_ declaration: CSDeclaration) -> CSSTextDecorationLine? {
        
        return CSSTextDecorationModule.parseTextDecorationLineToValue(declaration.propertyValueComponentValueList)
    }

    static func parseTextDecorationLineToValue(_ componentValues: [CSComponentValue]) -> CSSTextDecorationLine? {
        
        let textDecorationLineParser = CSSTextDecorationLineParser(componentValueArray: componentValues)
        return textDecorationLineParser.parseTextDecorationLineToValue()
    }
    
    static func parseTextDecorationLinePropertyValueToDOM(_ declaration: CSDeclaration, parentPropertyElement: CSSDOMElement) {
        
        let textDecorationLineDomParser = CSSDOMTextDecorationLineParser(componentValueArray: declaration.propertyValueComponentValueList, parentPropertyElement: parentPropertyElement)
        
        textDecorationLineDomParser.parseTextDecorationLineValueToDOM()
    }
    
    static func parseTextDecorationStyleToValue(_ declaration: CSDeclaration) -> CSSTextDecorationStyle? {
    
        return CSSTextDecorationModule.parseTextDecorationStyleToValue(declaration.propertyValueComponentValueList)
    }

    static func parseTextDecorationStyleToValue(_ componentValues: [CSComponentValue]) -> CSSTextDecorationStyle? {
    
        let textDecorationStyleParser = CSSTextDecorationStyleParser(componentValueArray: componentValues)
        
        return textDecorationStyleParser.parsePropertyValue()
    }
    
    static func parseTextDecorationStylePropertyValueToDOM(_ declaration: CSDeclaration, parentPropertyElement: CSSDOMElement) {
        
        let textDecorationStyleDomEventParser = CSSDOMTextDecorationStyleParser(componentValueArray: declaration.propertyValueComponentValueList, parentPropertyElement: parentPropertyElement)
        
        textDecorationStyleDomEventParser.parseTextDecorationStyleValueToDOM()
    }
    
}
