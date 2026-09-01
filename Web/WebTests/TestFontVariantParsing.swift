//
//  TestFontVariantParsing.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
@testable import Web

class TestFontVariantParsing: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /// FIXME: This test does not work.
//    func testFontVariantSmallCapsParsing() {
//
//        let cssString =
//        "   body {                          " +
//            "       font-variant : small-caps ;         " +
//        "   }                               ";
//
//        let fontVariant = fontVariantFromCSSFontStyleProperty(sourceString: cssString as NSString)
//
//        if let fontVariant = fontVariant {
//
//            let expectedFontVariant = CSSFontVariant.SmallCaps
//
//            XCTAssert(fontVariant == expectedFontVariant, "Font variant is not expected.")
//        }
//        else {
//            XCTAssert(false, "Font variant is nil.")
//        }
//    }
    
    /// FIXME: This test does not work.
//    func testFontVariantNormalParsing() {
//
//        let cssString =
//        "   body {                          " +
//            "       font-variant : normal ;         " +
//        "   }                               ";
//
//        let fontVariant = fontVariantFromCSSFontStyleProperty(sourceString: cssString as NSString)
//
//        if let fontVariant = fontVariant {
//
//            let expectedFontVariant = CSSFontVariant.Normal
//
//            XCTAssert(fontVariant == expectedFontVariant, "Font variant is not expected.")
//        }
//        else {
//            XCTAssert(false, "Font variant is nil.")
//        }
//    }
    
    
    private func fontVariantFromCSSFontStyleProperty(sourceString: NSString) -> CSSFontVariant? {
        
        let rules = CSSOMModule.shared.parseStyleRules(sourceString, origin: .author )
            
        XCTAssert(rules.count == 1 , "Pass")
        
        let rule = rules[0]
        
        if let style = rule.style {
            
            if let fontVariantDeclaration = style["font-variant"] {
                
                let resultFont = CSSFontModule.parseFontVariantToValue(fontVariantDeclaration )
                
                return resultFont
            }
            else {
                XCTAssert(false , "Absent font-variant porperty.")
            }
        }
        else {
            XCTAssert(false , "Missing style in style rule.")
        }
        
        return nil
    }
    
    
}

