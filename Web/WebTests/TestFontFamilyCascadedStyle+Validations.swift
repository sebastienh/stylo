//
//  TestFontFamilyCascadedStyle+Validations.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-29.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import XCTest
@testable import Web

extension TestFontFamilyCascadedStyle {
    
    func validateFontFamilyActualValue(fontFamilyValue: CSSPropertyValueContainer, expectedValue: CSSFontFamily) -> Bool {
        
        switch fontFamilyValue {
            
        case .fontFamily(let fontFamily):
            if fontFamily == expectedValue {
                return true
            }
            else {
                XCTAssert(false, "Expected \(expectedValue), received: \(fontFamily)")
            }
        default:
            XCTAssert(false, "Expected FontFamily type value")
            
        }
        
        return false
    }
    
}
