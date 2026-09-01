//
//  CSSTextDecorationStyleParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-28.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

final class CSSTextDecorationStyleParser: CSSComponentsParser {
    
    let validatorDelegate: CSSTextDecorationStyleValidatorDelegate
    
    override init(componentValueArray: [CSComponentValue]) {
        
        self.validatorDelegate = CSSTextDecorationStyleValidatorDelegate()
        
        super.init(componentValueArray: componentValueArray)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: PropertyValueParser protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// Method used to get the value property. It does not need and must not have the
    /// parentPropertyValuePseudoElement variable set, beacause it will cause unecessary
    /// computing.
    @discardableResult
    func parsePropertyValue() -> CSSTextDecorationStyle? {
        
        parseWhitespaces()
        
        if let componentValue = currentComponentValue() {
            
            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
                
                let textDecorationStyleString = preservedToken.value.stringRepresentation
                
                // it is a keyword size
                if preservedToken.isTokenId(§CSTokenId.identToken) {
                    
                    if let textDecorationStyle = CSSTextDecorationStyle.valueFromKeyword(textDecorationStyleString) {
                        
                        return textDecorationStyle
                    }
                }
            }
        }
        
        return nil
    }
}
