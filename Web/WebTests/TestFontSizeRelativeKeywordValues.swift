//
//  TestFontSizeRelativeKeywordValues.swift
//  Web
//
//  Created by Sebastien hamel on 2019-02-03.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Web

class TestFontSizeRelativeKeywordValues: TestCascading {

    func testFontSizeComputedValueSmallerFromXXLarge() {
        
        // since 34px is considered xx-large we will be one level smaller and get large value
        fontSizeComputedValueExpectation(declaredValue: "smaller", expectedValue: CSSFontSize.xLarge.pixelValueFromKeyword())
    }
    
    func testFontSizeComputedValueLargerFromXXLarge() {
        
        fontSizeComputedValueExpectation(declaredValue: "larger", expectedValue: 1.5*34)
    }
    
    func testFontSizeComputedValueSmallerFromXLarge() {
        
        // since 34px is considered xx-large we will be one level smaller and get large value
        fontSizeComputedValueExpectation(baseValue: "x-large", declaredValue: "smaller", expectedValue: CSSFontSize.large.pixelValueFromKeyword())
    }
    
    func testFontSizeComputedValueLargerFromXLarge() {
        
        fontSizeComputedValueExpectation(baseValue: "x-large", declaredValue: "larger", expectedValue: CSSFontSize.xxLarge.pixelValueFromKeyword())
    }
    
    func testFontSizeComputedValueSmallerFromLarge() {
        
        // since 34px is considered xx-large we will be one level smaller and get large value
        fontSizeComputedValueExpectation(baseValue: "large", declaredValue: "smaller", expectedValue: CSSFontSize.medium.pixelValueFromKeyword())
    }
    
    func testFontSizeComputedValueLargerFromLarge() {
        
        fontSizeComputedValueExpectation(baseValue: "large", declaredValue: "larger", expectedValue: CSSFontSize.xLarge.pixelValueFromKeyword())
    }

    func testFontSizeComputedValueSmallerFromMedium() {
        
        // since 34px is considered xx-large we will be one level smaller and get large value
        fontSizeComputedValueExpectation(baseValue: "medium", declaredValue: "smaller", expectedValue: CSSFontSize.small.pixelValueFromKeyword())
    }
    
    func testFontSizeComputedValueLargerFromMedium() {
        
        fontSizeComputedValueExpectation(baseValue: "medium", declaredValue: "larger", expectedValue: CSSFontSize.large.pixelValueFromKeyword())
    }
    
    func testFontSizeComputedValueSmallerFromSmall() {
        
        // since 34px is considered xx-large we will be one level smaller and get large value
        fontSizeComputedValueExpectation(baseValue: "small", declaredValue: "smaller", expectedValue: CSSFontSize.xSmall.pixelValueFromKeyword())
    }
    
    func testFontSizeComputedValueLargerFromSmall() {
        
        fontSizeComputedValueExpectation(baseValue: "small", declaredValue: "larger", expectedValue: CSSFontSize.medium.pixelValueFromKeyword())
    }
    
    func testFontSizeComputedValueSmallerFromXSmall() {
        
        // since 34px is considered xx-large we will be one level smaller and get large value
        fontSizeComputedValueExpectation(baseValue: "x-small", declaredValue: "smaller", expectedValue: CSSFontSize.xxSmall.pixelValueFromKeyword())
    }
    
    func testFontSizeComputedValueLargerFromXSmall() {
        
        fontSizeComputedValueExpectation(baseValue: "x-small", declaredValue: "larger", expectedValue: CSSFontSize.small.pixelValueFromKeyword())
    }
    
    func testFontSizeComputedValueSmallerFromXXSmall() {
        
        // since 34px is considered xx-large we will be one level smaller and get large value
        fontSizeComputedValueExpectation(baseValue: "xx-small", declaredValue: "smaller", expectedValue: CSSFontSize.xxSmall.pixelValueFromKeyword()*0.85)
    }
    
    func testFontSizeComputedValueLargerFromXXSmall() {
        
        fontSizeComputedValueExpectation(baseValue: "xx-small", declaredValue: "larger", expectedValue: CSSFontSize.xSmall.pixelValueFromKeyword())
    }
    
    func testFontSizeComputedValueSmallerFrom5px() {
        
        // since 34px is considered xx-large we will be one level smaller and get large value
        fontSizeComputedValueExpectation(baseValue: "5px", declaredValue: "smaller", expectedValue: 5*0.85)
    }
    
    func testFontSizeComputedValueSmallerFrom0px() {
        
        // since 34px is considered xx-large we will be one level smaller and get large value
        fontSizeComputedValueExpectation(baseValue: "0px", declaredValue: "smaller", expectedValue: 0*0.85)
    }
    
    func testFontSizeComputedValueSmallerFromNegativeValue() {
        
        // -10px should resolve to 0px
        fontSizeComputedValueExpectation(baseValue: "-10px", declaredValue: "smaller", expectedValue: 0)
    }
}
