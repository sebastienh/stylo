//
//  CSSFontStretchParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSFontStretchParser : CSSComponentsParser {
    
    let validatorDelegate: CSSFontStretchValidatorDelegate
    
    override init(componentValueArray: [CSComponentValue] ) {
        
        self.validatorDelegate = CSSFontStretchValidatorDelegate()
        
        super.init(componentValueArray: componentValueArray)
    }
    
    func parseFontStretchToValue() -> CSSFontStretch? {

        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing implementation", log: Log.Web.all, type: .fault)
        #endif
        
//        parseWhitespaces()
//        
//        if let componentValue = currentComponentValue() {
//            
//            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
//                
//                // it is a keyword color
//                if preservedToken.isTokenId(§CSTokenId.IdentToken) {
//                    
//                    let fontStyleString = preservedToken.value.stringRepresentation
//                    
//                    if let fontStretch = CSSFontStretch(rawValue: fontStyleString) {
//                        
//                        return fontStretch
//                    }
//                    else {
//                        
//                        // unsupported font stretch
//                        messageHandler.addMessage(MessageCode.UnsupportedFontStretch,
//                            sourceStringSegment: preservedToken.sourceStringSegment,
//                            args: [preservedToken.value.stringRepresentation])
//                    }
//                }
//                else {
//                    
//                    messageHandler.addMessage(MessageCode.UnexpectedCharacter,
//                        sourceStringSegment: preservedToken.sourceStringSegment,
//                        args: [preservedToken.value.stringRepresentation])
//                }
//                
//                consumeRestOfInputValueAsUnexpectedCharacters()
//            }
//        }
        
        return nil
    }
}
