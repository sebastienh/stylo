//
//  CSSDOMFontSizeParser.swift
//  Web-mac
//
//  Created by Sébastien Hamel on 2018-06-29.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSDOMFontSizeParser: CSSDOMPropertyParser {
    
    let delegate: CSSFontSizeValidatorDelegate
    
    init(componentValueArray: [CSComponentValue], parentPropertyElement: CSSDOMElement) {
        
        self.delegate = CSSFontSizeValidatorDelegate()
        
        super.init(componentValueArray: componentValueArray, parentPropertyElement: parentPropertyElement)
    }
    
    func parseFontSizeValueToDOM() {
        
        parseWhitespaces()
        
        var exception = Exception()
        
        if let parentPropertyElement = parentPropertyElement {
        
            if let componentValue = currentComponentValue() {
                
                if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
                    
                    let sourceStringSegment = preservedToken.sourceStringSegment!
                    
                    let fontSizeString = preservedToken.value.stringRepresentation
                    
                    let fontSizeValueElement = CSSDOMElement(segment: sourceStringSegment, document: document, localName: §CSSElementType.FontSizeValue)
                    
                    parentPropertyElement.appendChild(fontSizeValueElement, exception: &exception)
                    exception.logIfError()
                    
                    // it is a keyword size
                    if preservedToken.isTokenId(§CSTokenId.identToken) {
                        
                        let fontSizeKeywordElement = CSSDOMElement(segment: sourceStringSegment, document: document, localName: §CSSElementType.FontSizeKeyword)
                        fontSizeKeywordElement.addMessages(preservedToken.allMessages)
                        fontSizeKeywordElement.addClassAttribute(fontSizeString)
                        
                        if CSSFontSize.valueFromKeyword(fontSizeString) != nil {
                            
                            let fontSizeKeywordClass = fontSizeKeyworkClass(from: fontSizeString)
                            
                            if let fontSizeKeywordClass = fontSizeKeywordClass {
                                fontSizeKeywordElement.addClassAttribute(fontSizeKeywordClass)
                            }
                        }
                        else {
                            fontSizeKeywordElement.addMessage(MessageCode.unsupportedFontSizeKeyword, args: [preservedToken.value.stringRepresentation])
                        }
                        
                        fontSizeValueElement.appendChild(fontSizeKeywordElement, exception: &exception)
                        exception.logIfError()
                        
                        let identToken = CSSDOMTokenElement(segment: sourceStringSegment, document: document, tokenClass: TokenClassType.IdentToken, textValue: fontSizeString)
                        
                        assert(!(fontSizeKeywordElement is CSSDOMTokenElement))
                        fontSizeKeywordElement.appendChild(identToken, exception: &exception)
                        exception.logIfError()
                        advanceComponentValueIndex()
                    }
                    else if preservedToken.isTokenId(§CSTokenId.dimensionToken) {
                        
                        if let dimensionToken = preservedToken.value as? DimensionToken {
                            
                            if let value = dimensionToken.number?.cgFloat {
                                
                                if !delegate.validateFontSizeValueIsNonNegative(value) {
                                    
                                    fontSizeValueElement.addMessage(MessageCode.unsupportedNegativeValue, args: [dimensionToken.number!.string!])
                                }
                                
                                if CSSDimension(rawValue: dimensionToken.unit.lowercased()) == nil {
                                    
                                    fontSizeValueElement.addMessage(MessageCode.unsupportedDimensionUnitForFontSize,
                                                                    args: [dimensionToken.unit])
                                }
                                
                                let fontSizeLengthElement = CSSDOMElement(segment: sourceStringSegment, document: document, localName: §CSSElementType.FontSizeLength)
                                
                                fontSizeLengthElement.addMessages(dimensionToken.allMessages)
                                
                                fontSizeValueElement.appendChild(fontSizeLengthElement, exception: &exception)
                                exception.logIfError()
                                
                                let numberToken = CSSDOMTokenElement(segment: dimensionToken.numberSegment, document: document, tokenClass: TokenClassType.NumberToken, textValue: fontSizeString)
                                
                                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                os_log("numberToken segment: %@", log: Log.Web.all, type: .info, %%dimensionToken.numberSegment)
                                #endif
                                
                                let unitToken = CSSDOMTokenElement(segment: dimensionToken.unitSegment, document: document, tokenClass: TokenClassType.DimensionToken, textValue: fontSizeString)
                                
                                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                os_log("unitToken segment: %@", log: Log.Web.all, type: .info, %%dimensionToken.unitSegment)
                                #endif
                                
                                assert(!(fontSizeLengthElement is CSSDOMTokenElement))
                                fontSizeLengthElement.appendChild(numberToken, exception: &exception)
                                fontSizeLengthElement.appendChild(unitToken, exception: &exception)
                                exception.logIfError()
                                advanceComponentValueIndex()
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
                            
                            if let value = value {
                                
                                if !delegate.validateFontSizeValueIsNonNegative(value) {
                                    
                                    // Should be added to numberToken
                                    // numberToken.sourceStringSegment
                                    fontSizeValueElement.addMessage(MessageCode.unsupportedNegativeValue, args: [value])
                                }
                                
                                let fontSizePercentageElement = CSSDOMElement(segment: sourceStringSegment, document: document, localName: §CSSElementType.FontSizePercentage)
                                fontSizePercentageElement.addMessages(preservedToken.allMessages)
                                
                                fontSizeValueElement.appendChild(fontSizePercentageElement, exception: &exception)
                                exception.logIfError()
                                
                                let identToken = CSSDOMTokenElement(segment: sourceStringSegment, document: document, tokenClass: TokenClassType.PercentageToken, textValue: fontSizeString)
                                
                                assert(!(fontSizePercentageElement is CSSDOMTokenElement))
                                fontSizePercentageElement.appendChild(identToken, exception: &exception)
                                exception.logIfError()
                                advanceComponentValueIndex()
                            }
                            else {
                                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                                os_log("value is nil.", log: Log.Web.all, type: .error)
                                #endif
                            }
                        }
                        else {
                            assert(false, "PercentageToken should be of type NumberToken...")
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("PercentageToken should be of type NumberToken....", log: Log.Web.all, type: .error)
                            #endif
                        }
                    }
                }
            }
        }
        consumeComponentsAsUnknownDomElements()
    }
    
    fileprivate func fontSizeKeyworkClass(from fontSizeString: String) -> String? {
        
        if let _ = CSSAbsoluteSize(rawValue: fontSizeString) {
            
            return CSSAbsoluteSize.ClassNameValue
        }
        else if let _ = CSSRelativeSize(rawValue: fontSizeString) {
            
            return CSSRelativeSize.ClassNameValue
        }
        else {
            
            assert(DefaultingType(rawValue: fontSizeString) != nil)
            
            return DefaultingType.ClassNameValue
        }
    }
    
    
    fileprivate func supportedDefaultingType(string defaultedValue: String) {
        
    }
}
