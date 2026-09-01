//
//  CSSDOMFontStyleParser2.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-06-29.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common

final class CSSDOMFontStyleParser: CSSDOMPropertyParser {
    
    let delegate: CSSColorParserDelegate
    
    init(componentValueArray: [CSComponentValue], parentPropertyElement: CSSDOMElement) {
        
        self.delegate = CSSColorParserDelegate()
        
        super.init(componentValueArray: componentValueArray, parentPropertyElement: parentPropertyElement)
    }
    
    func parseFontStyleValueToDOM() {
        
        parseWhitespaces()
                
        var exception = Exception()

        if let componentValue = currentComponentValue() {
            
            if let parentPropertyElement = parentPropertyElement {
            
                if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
                    
                    // it is a keyword token
                    if preservedToken.isTokenId(§CSTokenId.identToken) {
                    
                        let fontStyleValueElement = CSSDOMElement(segment: preservedToken.sourceStringSegment, document: document, localName: §CSSElementType.FontStyleValue)
                        fontStyleValueElement.addMessages(preservedToken.allMessages)
                        
                        parentPropertyElement.appendChild(fontStyleValueElement, exception: &exception)
                        exception.logIfError()
                        
                        let tokenElement = CSSDOMTokenElement.Create(preservedToken, document: document)!
                        fontStyleValueElement.appendChild(tokenElement, exception: &exception)
                        exception.logIfError()
                        
                        let fontStyleString = preservedToken.value.stringRepresentation
                        
                        if CSSFontStyleKeywordValue(rawValue: fontStyleString) != nil {
                            
                            // nothing, all is good
                        }
                        else if DefaultingType(rawValue: fontStyleString) != nil {
                            
                            // nothing, all is good
                        }
                        else {
                        
                            // unsupported font style
                            tokenElement.addMessage(MessageCode.unsupportedFontStyle,
                                                    args: [preservedToken.value.stringRepresentation])
                        }
                        advanceComponentValueIndex()
                    }
                }
            }
        }
        
        consumeComponentsAsUnknownDomElements()
    }
    
}
