//
//  TestFontSizeAbsolutKeywordValues.swift
//  Web
//
//  Created by Sebastien hamel on 2019-02-03.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Web

class TestFontSizeAbsolutKeywordValues: TestCascading {
    
    //
    //    case .xxSmall:
    //    return CSSFontSize.medium.pixelValueFromKeyword() * 3/5
    func testFontSizeComputedValueXXSmall() {
        
        fontSizeComputedValueExpectation(declaredValue: "xx-small", expectedValue: CSSFontSize.medium.pixelValueFromKeyword() * 3/5)
    }
    
    //
    //    case .xSmall:
    //    return CSSFontSize.medium.pixelValueFromKeyword() * 3/4
    func testFontSizeComputedValueXSmall() {
        
        fontSizeComputedValueExpectation(declaredValue: "x-small", expectedValue: CSSFontSize.medium.pixelValueFromKeyword() * 3/4)
    }
    
    //
    //    case .small:
    //    return CSSFontSize.medium.pixelValueFromKeyword() * 8/9
    func testFontSizeComputedValueSmall() {
        
        fontSizeComputedValueExpectation(declaredValue: "small", expectedValue: CSSFontSize.medium.pixelValueFromKeyword() * 8/9)
    }
    
    //
    //    case .medium:
    //    return UserAgent.shared.mediumFontSizePixelValue
    func testFontSizeComputedValueMedium() {
        
        fontSizeComputedValueExpectation(declaredValue: "medium", expectedValue: CSSFontSize.medium.pixelValueFromKeyword())
    }
    
    //
    //    case .large:
    //    return CSSFontSize.medium.pixelValueFromKeyword() * 6/5
    func testFontSizeComputedValueLarge() {
        
        fontSizeComputedValueExpectation(declaredValue: "large", expectedValue: CSSFontSize.medium.pixelValueFromKeyword() * 6/5)
    }
    
    //
    //    case .xLarge:
    //    return CSSFontSize.medium.pixelValueFromKeyword() * 3/2
    func testFontSizeComputedValueXLarge() {
        
        fontSizeComputedValueExpectation(declaredValue: "x-large", expectedValue: CSSFontSize.medium.pixelValueFromKeyword() * 3/2)
    }
    
    //
    //    case .xxLarge:
    //    return CSSFontSize.medium.pixelValueFromKeyword() * 2/1
    func testFontSizeComputedValueXXLarge() {
        
        fontSizeComputedValueExpectation(declaredValue: "xx-large", expectedValue: CSSFontSize.medium.pixelValueFromKeyword() * 2/1)
    }

}
