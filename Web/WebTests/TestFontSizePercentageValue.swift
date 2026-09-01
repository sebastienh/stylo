//
//  TestFontSizePercentageValue.swift
//  Web
//
//  Created by Sebastien hamel on 2019-02-03.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Web

class TestFontSizePercentageValue: TestCascading {

    func testFontSizeComputedValuePercentage() {
        
        fontSizeComputedValueExpectation(declaredValue: "80%", expectedValue: (80/100)*34)
    }
    
    func testFontSizeComputedValuePercentage2() {
        
        fontSizeComputedValueExpectation(declaredValue: "10%", expectedValue: (10/100)*34)
    }
    
    func testFontSizeComputedValueNegativePercentage() {
        
        // In this case we expect it to be xx-small
        fontSizeComputedValueExpectation(declaredValue: "-10%", expectedValue: CSSFontSize.xxSmall.pixelValueFromKeyword())
    }
    
    func testFontSizeComputedValueZeroPercentage() {
        
        // In this case we expect it to be xx-small
        fontSizeComputedValueExpectation(declaredValue: "0%", expectedValue: CSSFontSize.xxSmall.pixelValueFromKeyword())
    }
}
