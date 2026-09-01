//
//  CSSTextAlignParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-28.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSTextAlignParser : CSSComponentsParser {
    
    let validatorDelegate: CSSTextAlignValidatorDelegate
    
    override init(componentValueArray: [CSComponentValue] ) {
        
        self.validatorDelegate = CSSTextAlignValidatorDelegate()
        
        super.init(componentValueArray: componentValueArray)
    }
    
    func parseFontStyleToValue() -> CSSFontStyle? {
        
//        var fontStyle: CSSFontStyle?
//        
//        parseWhitespaces()
//        
//        if let componentValue = currentComponentValue() {
//            
//            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
//                
//                
//            }
//        }
        
        assert(false, "Missing Implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("parseFontStyleToValue() missing implementation.", log: Log.Web.all, type: .error)
        #endif
        return nil
    }
}
