//
//  TestFontSizeRelativeLengthValue.swift
//  Web
//
//  Created by Sebastien hamel on 2019-02-03.
//  Copyright © 2019 testually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Web

class TestFontSizeRelativeLengthValue: TestCascading {

    // ch
    func testChFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "3ch", expectedValue: 42.528)
    }

    func testNegativeChFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "-3ch", expectedValue: 0)
    }
    
    func testZeroChFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "0ch", expectedValue: 0)
    }
    
    func testBigChFontSizeValue() {
     
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "330ch", expectedValue: 4678.08)
    }
    
    // em
    func testEmFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "3em", expectedValue: 48)
    }
    
    func testNegativeEmFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "-3em", expectedValue: 0)
    }
    
    func testZeroEmFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "0em", expectedValue: 0)
    }
    
    func testBigEmFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "330em", expectedValue: 5280)
    }
    
    // ex
    func testExFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "3ex", expectedValue: 22.464000000000002)
    }
    
    func testNegativeExFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "-3ex", expectedValue: 0)
    }
    
    func testZeroExFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "0ex", expectedValue: 0)
    }
    
    func testBigExFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "330ex", expectedValue: 2471.04)
    }
    
    // rem
    func testRemFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "3rem", expectedValue: 48)
    }
    
    func testNegativeRemFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "-3rem", expectedValue: 0)
    }
    
    func testZeroRemFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "0rem", expectedValue: 0)
    }
    
    func testBigRemFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "330rem", expectedValue: 5280)
    }
    
    // vh
    func testVhFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "3vh", expectedValue: 33.6)
    }
    
    func testNegativeVhFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "-3vh", expectedValue: 0)
    }
    
    func testZeroVhFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "0vh", expectedValue: 0)
    }
    
    func testBigVhFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "330vh", expectedValue: 3696.0000000000005)
    }
    
    // vmax
    func testVmaxFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "3vmax", expectedValue: 53.760000000000005)
    }
    
    func testNegativeVmaxFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "-3vmax", expectedValue: 0)
    }
    
    func testZeroVmaxFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "0vmax", expectedValue: 0)
    }
    
    func testBigVmaxFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "330vmax", expectedValue: 5913.6)
    }
    
    // vmin
    func testVminFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "3vmin", expectedValue: 33.6)
    }
    
    func testNegativeVminFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "-3vmin", expectedValue: 0)
    }
    
    func testZeroVminFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "0vmin", expectedValue: 0)
    }
    
    func testBigVminFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "330vmin", expectedValue: 3696.0000000000005)
    }
    
    // vw
    func testVwFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "3vw", expectedValue: 53.760000000000005)
    }
    
    func testNegativeVwFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "-3vw", expectedValue: 0)
    }
    
    func testZeroVwFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "0vw", expectedValue: 0)
    }
    
    func testBigVwFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "330vw", expectedValue: 5913.6)
    }
    
    // cm
    func testCmFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "3cm", expectedValue: 113.38582677165354)
    }
    
    func testNegativeCmFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "-3cm", expectedValue: 0)
    }
    
    func testZeroCmFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "0cm", expectedValue: 0)
    }
    
    func testBigCmFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "330cm", expectedValue: 12472.44094488189)
    }
    
    // mm
    func testMmFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "3mm", expectedValue: 11.338582677165354)
    }
    
    func testNegativeMmFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "-3mm", expectedValue: 0)
    }
    
    func testZeroMmFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "0mm", expectedValue: 0)
    }
    
    func testBigMmFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "330mm", expectedValue: 1247.244094488189)
    }
    
    // in
    func testInFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "3in", expectedValue: 288)
    }
    
    func testNegativeInFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "-3in", expectedValue: 0)
    }
    
    func testZeroInFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "0in", expectedValue: 0)
    }
    
    func testBigInFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "330in", expectedValue: 31680.000000000004)
    }
    
    // px
    func testPxFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "3px", expectedValue: 3)
    }
    
    func testNegativePxFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "-3px", expectedValue: 0)
    }
    
    func testZeroPxFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "0px", expectedValue: 0)
    }
    
    func testBigPxFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "330px", expectedValue: 330)
    }
    
    // pt
    func testPtFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "3pt", expectedValue: 4)
    }
    
    func testNegativePtFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "-3pt", expectedValue: 0)
    }
    
    func testZeroPtFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "0pt", expectedValue: 0)
    }
    
    func testBigPtFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "330pt", expectedValue: 439.99999999999994)
    }
    
    // pc
    func testPcFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "3pc", expectedValue: 48)
    }
    
    func testNegativePcFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "-3pc", expectedValue: 0)
    }
    
    func testZeroPcFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "0pc", expectedValue: 0)
    }
    
    func testBigPcFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "330pc", expectedValue: 5279.999999999999)
    }
    
    // q
    func testQFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "3q", expectedValue: 2.8346456692913384)
    }
    
    func testNegativeQFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "-3q", expectedValue: 0)
    }
    
    func testZeroQFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "0q", expectedValue: 0)
    }
    
    func testBigQFontSizeValue() {
        
        fontSizeComputedValueExpectation(baseValue: "16px", declaredValue: "330q", expectedValue: 311.81102362204723)
    }
}
