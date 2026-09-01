//
//  CSSDOMTextDecorationStyleParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-06-30.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common

final class CSSDOMTextDecorationStyleParser: CSSDOMPropertyParser {
    
    let delegate: CSSTextDecorationStyleValidatorDelegate
    
    init(componentValueArray: [CSComponentValue], parentPropertyElement: CSSDOMElement) {
        
        self.delegate = CSSTextDecorationStyleValidatorDelegate()
        
        super.init(componentValueArray: componentValueArray, parentPropertyElement: parentPropertyElement)
    }
    
    func parseTextDecorationStyleValueToDOM() {
        
        parseWhitespaces()
        
        var exception = Exception()
        
        if let componentValue = currentComponentValue() {
            
            if let parentPropertyElement = parentPropertyElement {
                
                if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
                    
                    // it is a keyword size
                    if preservedToken.isTokenId(§CSTokenId.identToken) {
                    
                        let sourceStringSegment = preservedToken.sourceStringSegment
                        
                        assert(sourceStringSegment != nil)
                        if let sourceStringSegment = sourceStringSegment {
                            
                            let textDecorationStyleString = preservedToken.value.stringRepresentation
                            
                            let textDecorationStyleValueElement = CSSDOMElement(segment: sourceStringSegment, document: document, localName: §CSSElementType.TextDecorationStyleValue)
                            
                            parentPropertyElement.appendChild(textDecorationStyleValueElement, exception: &exception)
                            exception.logIfError()
                            
                            let textDecorationStyleKeywordElement = CSSDOMElement(segment: sourceStringSegment, document: document, localName: §CSSElementType.FontSizeKeyword)
                            
                            assert(!(textDecorationStyleValueElement is CSSDOMTokenElement))
                            textDecorationStyleValueElement.appendChild(textDecorationStyleKeywordElement, exception: &exception)
                            exception.logIfError()
                            
                            textDecorationStyleKeywordElement.addClassAttribute(textDecorationStyleString)
                            
                            let identToken = CSSDOMTokenElement(segment: sourceStringSegment, document: document, tokenClass: TokenClassType.IdentToken, textValue: textDecorationStyleString)
                            
                            assert(!(textDecorationStyleKeywordElement is CSSDOMTokenElement))
                            textDecorationStyleKeywordElement.appendChild(identToken, exception: &exception)
                            exception.logIfError()
                            
                            if CSSTextDecorationStyle.valueFromKeyword(textDecorationStyleString) != nil {
                                
                                textDecorationStyleKeywordElement.addClassAttribute(textDecorationStyleString)
                            }
                            else {

                                // unsupported font size keyword
                                // Should be added to preservedToken
                                textDecorationStyleKeywordElement.addMessage(MessageCode.unsupportedTextDecorationStyleKeyword, args: [preservedToken.value.stringRepresentation])
                            }
                            advanceComponentValueIndex()
                        }
                    }
                }
            }
        }
        consumeComponentsAsUnknownDomElements()
    }
}
