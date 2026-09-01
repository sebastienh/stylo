//
//  CSSFontSizeParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSFontSizeParser: CSSComponentsParser {
    
    let validatorDelegate: CSSFontSizeValidatorDelegate
    
    override init(componentValueArray: [CSComponentValue]) {
        
        self.validatorDelegate = CSSFontSizeValidatorDelegate()
        super.init(componentValueArray: componentValueArray)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: PropertyValueParser protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
        
    /// Method used to get the value property. It does not need and must not have the
    /// parentPropertyValuePseudoElement variable set, beacause it will cause unecessary
    /// computing.
    func parsePropertyValue() -> CSSFontSize? {
        
        parseWhitespaces()
        
        if let componentValue = currentComponentValue() {
            
            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
                
                let sourceStringSegment = preservedToken.sourceStringSegment!
                
                let fontSizeString = preservedToken.value.stringRepresentation
                
                // it is a keyword size
                if preservedToken.isTokenId(§CSTokenId.identToken) {
                    
                    let fontSize: CSSFontSize?
                    
                    if let _fontSize = CSSFontSize.valueFromKeyword(fontSizeString) {
                        
                        fontSize = _fontSize
                    }
                    else {
                        
                        fontSize = nil
                    }
                    
                    return fontSize
                }
                else if preservedToken.isTokenId(§CSTokenId.dimensionToken) {
                    
                    if let dimensionToken = preservedToken.value as? DimensionToken {
                        
                        if let value = dimensionToken.number?.cgFloat {
                            
                            var fontSize: CSSFontSize?
                            
                            if !validatorDelegate.validateFontSizeValueIsNonNegative(value) {
                                
                                fontSize = nil
                            }
                            
                            if let dimensionUnit = CSSDimension(rawValue: dimensionToken.unit.lowercased()) {
                                
                                let lengthValue: CSSLength = dimensionUnit.cssLengthWithValue(value) // CSSLength.CM(12.0)
                                fontSize = CSSFontSize.length(lengthValue)
                            }
                            else {
                                
                                fontSize = nil
                            }
                            
                            return fontSize
                        }
                        else {
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("value is nil.", log: Log.Web.all, type: .error)
                            #endif
                        }
                    }
                    else {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("DimensionToken should be of type DimensionToken...", log: Log.Web.all, type: .error)
                        #endif
                    }
                }
                else if preservedToken.isTokenId(§CSTokenId.percentageToken) {
                    
                    if let numberToken = preservedToken.value as? NumberToken {
                    
                        let value = numberToken.number.cgFloat
                        
                        var fontSize: CSSFontSize? = nil
                        
                        if let value = value {
                            
                            fontSize = CSSFontSize.percentage(value)
                        }
                        else {
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("value is nil.", log: Log.Web.all, type: .error)
                            #endif
                        }
                        
                        return fontSize
                    }
                    else {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("PercentageToken should be of type NumberToken....", log: Log.Web.all, type: .error)
                        #endif
                        assert(false, "PercentageToken should be of type NumberToken...")
                    }
                }
                consumeRestOfInputValueAsUnexpectedCharacters()
            }
        }
        
        return nil
    }

    fileprivate func supportedDefaultingType(string defaultedValue: String) {
        
    }

}
