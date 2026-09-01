//
//  CSSFontVariantParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSFontVariantParser : CSSComponentsParser {
    
    let validatorDelegate: CSSFontVariantValidatorDelegate
    
    override init(componentValueArray: [CSComponentValue] ) {
        
        self.validatorDelegate = CSSFontVariantValidatorDelegate()
        
        super.init(componentValueArray: componentValueArray)
    }
    
    func parseFontVariantToValue() -> CSSFontVariant? {

        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing implementation", log: Log.Web.all, type: .fault)
        #endif
        
//        var fontVariant: CSSFontVariant?
//        
//        parseWhitespaces()
//        
//        if let componentValue = currentComponentValue() {
//            
//            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
//                
//                // it is a keyword color
//                if preservedToken.isTokenId(§CSTokenId.IdentToken) {
//                    
//                    let fontVariantString = preservedToken.value.stringRepresentation
//                    
//                    if let fontVariant = CSSFontVariant(rawValue: fontVariantString) {
//                        
//                        return fontVariant
//                    }
//                    else {
//                        
//                        // unsupported font style
//                        messageHandler.addMessage(MessageCode.UnsupportedFontVariant,
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
//        
//        return fontVariant
        return nil
    }
}
