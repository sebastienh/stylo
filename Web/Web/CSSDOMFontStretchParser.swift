//
//  CSSDOMFontStretchParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSDOMFontStretchParser : CSSDOMPropertyParser {
    
    let validatorDelegate: CSSFontStretchValidatorDelegate
    
    init(componentValueArray: [CSComponentValue], parentPropertyElement: CSSDOMElement ) {
        
        self.validatorDelegate = CSSFontStretchValidatorDelegate()
        
        super.init(componentValueArray: componentValueArray, parentPropertyElement: parentPropertyElement)
    }
    
    func parseFontStretchValueToDOM()  {
        
        assert(false, "parseFontStretchValueToDOM()  missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("parseFontStretchValueToDOM()  missing implementation.", log: Log.Web.all, type: .error)
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
//                    let fontStyleString = preservedToken.value.stringRepresentation
//                    
//                    if let fontStretch = CSSFontStretch(rawValue: fontStyleString) {
//                        
//                        let keywordElement = CSSDOMKeywordElement(sourceStringSegment: preservedToken.sourceStringSegment, document: document, localName: fontStyleString)
//                        
//                        propertyValueElement.appendChild(keywordElement, exception: &exception)
//                        
//                        if exception.isError() {
//                            
//                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                            os_log("Exception while appendingChild to element : \(exception).", log: Log.Web.all, type: .error)
//                            #endif
//                        }
//                    }
//                    else {
//                        // MessageCode.UnsupportedFontStretch,
//                        let element = CSSDOMUnknownElement(sourceStringSegment: preservedToken.sourceStringSegment, document: document)
//                        
//                        propertyValueElement.appendChild(element, exception: &exception)
//                        
//                        if exception.isError() {
//                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                            os_log("Exception while appendingChild to element : \(exception).", log: Log.Web.all, type: .error)
//                            #endif
//                        }
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
//                
//                consumeNextComponentsAsUnknownDomElements()
//            }
//        }
//        
//        return propertyValueElement
    }
    
}
