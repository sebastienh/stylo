//
//  CSSDOMTextDecorationLineParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-06-30.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common

final class CSSDOMTextDecorationLineParser: CSSDOMPropertyParser {
    
    let delegate: CSSTextDecorationLineValidatorDelegate
    
    init(componentValueArray: [CSComponentValue], parentPropertyElement: CSSDOMElement) {
        
        self.delegate = CSSTextDecorationLineValidatorDelegate()
        
        super.init(componentValueArray: componentValueArray, parentPropertyElement: parentPropertyElement)
    }
    
    func parseTextDecorationLineValueToDOM() {
        
        parseWhitespaces()
        
        var exception = Exception()
        
        if let parentPropertyElement = parentPropertyElement {
            
            let componentValue = currentComponentValue()
            
            if let componentValue = componentValue {
                
                let segment = componentValue.sourceStringSegment
                
                assert(segment != nil)
                if let segment = segment {
                    
                    var textDecorationLineValueElement = CSSDOMElement(segment: segment, document: document, localName: §CSSElementType.TextDecorationLineValue)
                    
                    parentPropertyElement.appendChild(textDecorationLineValueElement, exception: &exception)
                    exception.logIfError()
                    
                    while let componentValue = currentComponentValue() {
                        
                        textDecorationLineValueElement.sourceStringSegment?.endIndex = componentValue.sourceStringSegment!.endIndex
                        
                        let sourceStringSegment = componentValue.sourceStringSegment
                        
                        assert(sourceStringSegment != nil)
                        if let sourceStringSegment = sourceStringSegment {
                            
                            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
                                
                                let textDecorationLineString = preservedToken.value.stringRepresentation
                                
                                // it is a keyword token
                                if preservedToken.isTokenId(§CSTokenId.identToken) {
                                    
                                    if let type = CSSTextDecorationLineType.valueFromKeyword(textDecorationLineString) {
                                        
                                        let textDecorationLineKeywordElement = CSSDOMElement(segment: sourceStringSegment, document: document, localName: §CSSElementType.TextDecorationLineKeyword)
                                    
                                        textDecorationLineKeywordElement.addClassAttribute(type.string)
                                        textDecorationLineKeywordElement.addClassAttribute(textDecorationLineString)
                                        textDecorationLineValueElement.appendChild(textDecorationLineKeywordElement, exception: &exception)
                                        exception.logIfError()
                                        
                                        let identToken = CSSDOMTokenElement(segment: sourceStringSegment, document: document, tokenClass: TokenClassType.IdentToken, textValue: textDecorationLineString)
                                        
                                        assert(!(textDecorationLineKeywordElement is CSSDOMTokenElement))
                                        textDecorationLineKeywordElement.appendChild(identToken, exception: &exception)
                                        exception.logIfError()
                                    }
                                    else {
                                        
                                        handleComponentValueToDom(componentValue, in: textDecorationLineValueElement, messageCode: MessageCode.unexpectedToken)
                                    }
                                }
                                else if !preservedToken.isTokenId(§CSTokenId.whitespaceToken) {
                                    
                                    // the token is unexpected
                                    handleComponentValueToDom(componentValue, in: textDecorationLineValueElement, messageCode: MessageCode.unexpectedToken)
                                }
                            }
                            else {
                                // the token is unexpected
                                handleComponentValueToDom(componentValue, in: textDecorationLineValueElement, messageCode: MessageCode.unexpectedToken)
                            }
                        }
                        advanceComponentValueIndex()
                    }
                }
            }
        }
        consumeNextComponentsAsUnknownDomElements()
    }
}
