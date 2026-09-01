 //
//  CSSTextDecorationLineParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-28.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

typealias TextDecorationLineDomArg = (sourceStringSegment: SourceStringSegment, textDecorationLineString: String?, textDecorationLineKeywordClass: String?, message: Message?)

final class CSSTextDecorationLineParser : CSSComponentsParser {

    let validatorDelegate: CSSTextDecorationLineValidatorDelegate
    
    override init(componentValueArray: [CSComponentValue]) {
        
        self.validatorDelegate = CSSTextDecorationLineValidatorDelegate()
        super.init(componentValueArray: componentValueArray)
    }
    
    func parseTextDecorationLineToValue() -> CSSTextDecorationLine? {
        
        var textDecorationLine = CSSTextDecorationLine()
        
        parseWhitespaces()
        
        while let componentValue = currentComponentValue() {
            
            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
                
                let textDecorationLineString = preservedToken.value.stringRepresentation
                
                // it is a keyword token
                if preservedToken.isTokenId(§CSTokenId.identToken) {
                    
                    if let type = CSSTextDecorationLineType.valueFromKeyword(textDecorationLineString) {
                        
                        textDecorationLine.addTextDecorationLineType(type)
                    }
                }
            }
            
            advanceComponentValueIndex()
        }
        return textDecorationLine
    }
}
