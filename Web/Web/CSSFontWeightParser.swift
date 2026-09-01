//
//  CSSFontWeightParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSFontWeightParser : CSSComponentsParser {
    
    override init(componentValueArray: [CSComponentValue]) {
        
        super.init(componentValueArray: componentValueArray)
    }
    
    func parseFontWeightToValue() -> CSSFontWeight? {
        
        parseWhitespaces()
        
        if let componentValue = currentComponentValue() {
            
            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
                
                var fontWeightValue: CSSFontWeight?
                
                // it is a keyword size
                if preservedToken.isTokenId(§CSTokenId.identToken) {
                    
                    let fontWeightString = preservedToken.value.stringRepresentation
                    
                    if let fontWeightKeyword = CSSFontWeigthRelativeValue(rawValue: fontWeightString) {
                        
                        fontWeightValue =  CSSFontWeight.relative(fontWeightKeyword)
                    }
                    else if let fontWeightKeyword = CSSFontWeigthAbsoluteValue(rawValue: fontWeightString) {
                     
                        fontWeightValue = CSSFontWeight.absolute(fontWeightKeyword)
                    }
                    else if let fontWeightDefaulted = DefaultingType(rawValue: fontWeightString) {
                        
                        fontWeightValue = CSSFontWeight.defaulted(fontWeightDefaulted)
                    }
                }
                else if preservedToken.isTokenId(§CSTokenId.numberToken) {
                    
                    if let numberToken = preservedToken.value as? NumberToken {
                        
                        let value = numberToken.number
                        
                        if value.numberType == .integer {
                            
                            if let intValue = value.int {
                                
                                if let fontWeigthNumericValue = CSSFontWeigthNumericValue(rawValue: intValue) {
                                
                                    fontWeightValue = CSSFontWeight.numeric(fontWeigthNumericValue)
                                }
                            }
                            else {
                                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                                os_log("value is nil.", log: Log.Web.all, type: .error)
                                #endif
                            }
                        }
                    }
                    else {
                        assert(false, "Expected NumberToken...")
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("Expected NumberToken...", log: Log.Web.all, type: .error)
                        #endif
                    }
                }
                consumeRestOfInputValueAsUnexpectedCharacters()
                return fontWeightValue
            }
        }
        
        return nil
    }
}
