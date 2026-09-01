//
//  CSSDOMFontWeightParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-06-29.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSDOMFontWeightParser: CSSDOMPropertyParser {
    
    let delegate: CSSFontWeightValidatorDelegate
    
    init(componentValueArray: [CSComponentValue], parentPropertyElement: CSSDOMElement) {
        
        self.delegate = CSSFontWeightValidatorDelegate()
        
        super.init(componentValueArray: componentValueArray, parentPropertyElement: parentPropertyElement)
    }
    
    func parseFontSizeValueToDOM() {
        
        parseWhitespaces()
        
        var exception = Exception()
        
        if let parentPropertyElement = parentPropertyElement {
            
            if let componentValue = currentComponentValue() {
                
                if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
                    
                    var exception = Exception()
                    
                    let fontWeightValueElement = CSSDOMElement(segment: preservedToken.sourceStringSegment, document: document, localName: §CSSElementType.FontWeightValue)
                    
                    parentPropertyElement.appendChild(fontWeightValueElement, exception: &exception)
                    exception.logIfError()
                    
                    let tokenElement = CSSDOMTokenElement.Create(preservedToken, document: document)!
                    
                    fontWeightValueElement.appendChild(tokenElement, exception: &exception)
                    exception.logIfError()
                    
                    // it is a keyword size
                    if preservedToken.isTokenId(§CSTokenId.identToken) {
                        
                        var fontWeightValue: CSSFontWeight?
                        let fontWeightString = preservedToken.value.stringRepresentation
                        fontWeightValueElement.addClassAttribute(fontWeightString)
                        
                        if let fontWeightKeyword = CSSFontWeigthRelativeValue(rawValue: fontWeightString) {
                            
                            fontWeightValue =  CSSFontWeight.relative(fontWeightKeyword)
                        }
                        else if let fontWeightKeyword = CSSFontWeigthAbsoluteValue(rawValue: fontWeightString) {
                            
                            fontWeightValue = CSSFontWeight.absolute(fontWeightKeyword)
                        }
                        else if let fontWeightDefaulted = DefaultingType(rawValue: fontWeightString) {
                            
                            fontWeightValue = CSSFontWeight.defaulted(fontWeightDefaulted)
                        }
                        else {
                            
                            // unsupported font weight keyword
                            tokenElement.addMessage(MessageCode.unsupportedFontWeightKeyword, args: [preservedToken.value.stringRepresentation])
                        }
                    }
                    else if preservedToken.isTokenId(§CSTokenId.numberToken) {
                        
                        let numberToken = preservedToken.value as? NumberToken
                        
                        assert(numberToken != nil)
                        if let numberToken = numberToken {
                            
                            let value = numberToken.number
                            
                            if value.numberType == .integer {
                                
                                let intValue = value.int
                                
                                assert(intValue != nil)
                                if let intValue = intValue {
                                    
                                    if CSSFontWeigthNumericValue(rawValue: intValue) == nil {
                                        
                                        tokenElement.addMessage(MessageCode.unsupportedFontWeightValue,
                                                                args: [preservedToken.value.stringRepresentation])
                                    }
                                }
                                else {
                                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                                    os_log("value is nil.", log: Log.Web.all, type: .error)
                                    #endif
                                }
                            }
                            else {
                                
                                tokenElement.addMessage(MessageCode.unsupportedFontWeightValueType, args: [preservedToken.value.stringRepresentation])
                            }
                        }
                    }
                }
            }
        }
        consumeNextComponentsAsUnknownDomElements()
    }
}
