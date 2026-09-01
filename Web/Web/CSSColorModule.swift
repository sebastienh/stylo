//
//  CSSColorModuleLevel3.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-18.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

/// http://www.w3.org/TR/css3-color/
struct CSSColorModule: CSSModule {

    /// Parse a color property to it's NSColor value.
    static func parseColorToValue(_ declaration: CSDeclaration ) -> CSSColor? {
    
        return CSSColorModule.parseColorToValue(declaration.propertyValueComponentValueList)
    }

    /// Parse a color property to it's NSColor value.
    static func parseColorToValue(_ componentValues: [CSComponentValue]) -> CSSColor? {
    
        let colorParser = CSSColorParser(componentValueArray: componentValues)
        if let color = colorParser.parseToValue() {
            return color
        }
        return nil
    }
    
    static func parseColorValueToDOM(_ declaration: CSDeclaration, parentPropertyElement: CSSDOMElement ) {
        
        let colorParser = CSSDOMColorParser(componentValueArray: declaration.propertyValueComponentValueList, parentPropertyElement: parentPropertyElement )
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        for component in declaration.propertyValueComponentValueList {
            os_log("Component string value: %@", log: Log.Web.all, type: .info, %%component.cssText())
        }
        #endif
        
        colorParser.parseColorValueToDOM()
    }
    
}
