//
//  CSSFontStyleParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

final class CSSFontStyleParser : CSSComponentsParser {
    
    let validatorDelegate: CSSFontStyleValidatorDelegate
    
    override init(componentValueArray: [CSComponentValue]) {
        
        self.validatorDelegate = CSSFontStyleValidatorDelegate()
        
        super.init(componentValueArray: componentValueArray)
    }
    
    func parseFontStyleToValue() -> CSSFontStyle? {
        
        parseWhitespaces()
        
        if let componentValue = currentComponentValue() {
            
            var fontStyleValue: CSSFontStyle?
            
            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
                
                // it is a keyword token
                if preservedToken.isTokenId(§CSTokenId.identToken) {
                 
                    let fontStyleString = preservedToken.value.stringRepresentation
                    
                    if let fontStyleKeyword = CSSFontStyleKeywordValue(rawValue: fontStyleString) {
                        
                        fontStyleValue = CSSFontStyle.keyword(fontStyleKeyword)
                    }
                    else if let fontStyleDefaulted = DefaultingType(rawValue: fontStyleString) {
                        
                        fontStyleValue = CSSFontStyle.defaulted(fontStyleDefaulted)
                    }
                }
                consumeRestOfInputValueAsUnexpectedCharacters()
                return fontStyleValue
            }
        }

        return nil
    }
}
