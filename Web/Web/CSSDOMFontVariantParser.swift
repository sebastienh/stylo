//
//  CSSDOMFontVariantParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSDOMFontVariantParser : CSSDOMPropertyParser {
    
    let validatorDelegate: CSSFontVariantValidatorDelegate
    
    init(componentValueArray: [CSComponentValue], parentPropertyElement: CSSDOMElement) {
        
        self.validatorDelegate = CSSFontVariantValidatorDelegate()
        
        super.init(componentValueArray: componentValueArray, parentPropertyElement: parentPropertyElement)
    }
    
    func parseFontVariantValueToDOM() {
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("parseFontVariantValueToDOM()  missing implementation.", log: Log.Web.all, type: .error)
        #endif
        
//        parseWhitespaces()
//        
//        var exception = Exception()
//        
//        let position = componentValueArray.extractPositionFromComponents()
//        
//        let propertyValueElement = CSSDOMPropertyValuePseudoElement(document: document)
//        
//        if let componentValue = currentComponentValue() {
//            
//            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
//                
//                if preservedToken.isTokenId(§CSTokenId.IdentToken) {
//                    
//                    let fontVariantString = preservedToken.value.stringRepresentation
//                    
//                    let keywordElement = CSSDOMKeywordElement(sourceStringSegment: preservedToken.sourceStringSegment, document: document, localName: fontVariantString)
//                    
//                    propertyValueElement.appendChild(keywordElement, exception: &exception)
//                    
//                    if let fontVariant = CSSFontVariant(rawValue: fontVariantString) {
//                        
//                        if exception.isError() {
//                            
//                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                            os_log("Exception while appendingChild to element : \(exception).", log: Log.Web.all, type: .error)
//                            #endif
//                        }
//                    }
//                    else {
//                        
//                        // MessageCode.UnsupportedFontVariant
//                        setErrorForElement(propertyValueElement)
//                    }
//                }
//                else {
//                    
//                    let element = CSSDOMUnknownElement(sourceStringSegment: preservedToken.sourceStringSegment, document: document)
//                    
//                    propertyValueElement.appendChild(element, exception: &exception)
//                    
//                    if exception.isError() {
//                        
//                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                        os_log("Exception while appendingChild to element : \(exception).", log: Log.Web.all, type: .error)
//                        #endif
//                    }
//                }
//                consumeNextComponentsAsUnknownDomElements()
//            }
//        }
//        
//        return propertyValueElement
    }
    
}
