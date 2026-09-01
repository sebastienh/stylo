//
//  TestFontFamily.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-24.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
import Common
@testable import Web

class TestFontFamily: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBasicFontFamilyParsing() {

        let cssString =
        "   body {                          " +
            "       font-family : arial, serif ;         " +
        "   }                               ";
        
        let font = fontFromCSSFontFamilyProperty(sourceString: cssString as NSString)
        
        if let font = font {
            
            let expectedFont = CSSFontFamily.custom("Arial")
            
            XCTAssert(font == expectedFont, "Font is not expected.")
        }
        else {
            XCTAssert(false, "Font is nil.")
        }
    }

    func testArrayFontFamilyParsing() {
        
        let cssString =
        "   body {                          " +
            "       font-family : times new roman, serif ;         " +
        "   }                               ";
        
        if let font = fontFromCSSFontFamilyProperty(sourceString: cssString as NSString) {
            
            let expectedFont = CSSFontFamily.custom("Times New Roman")
            
            XCTAssert(font == expectedFont, "Font is not expected.")
        }
        else {
            XCTAssert(false, "Font is nil.")
        }
    }
    
    func testArrayWithManySpacesFontFamilyParsing() {
        
        let cssString =
        "   body {                          " +
            "       font-family : times new roman, serif ;         " +
        "   }                               ";
        
        if let font = fontFromCSSFontFamilyProperty(sourceString: cssString as NSString) {
            
            let expectedFont = CSSFontFamily.custom("Times New Roman")
            
            XCTAssert(font == expectedFont, "Font is not expected.")
        }
        else {
            XCTAssert(false, "Font is nil.")
        }
    }
    
    func testArrayFontFamilyParsingWithQuotes() {
        
        let cssString =
        "   body {                          " +
            "       font-family : \"times new            roman\", Arial, fhdjskfsfs, serif ;         " +
        "   }                               ";
        
        if let font = fontFromCSSFontFamilyProperty(sourceString: cssString as NSString) {
            
            let expectedFont = CSSFontFamily.custom("Times New Roman")
            
            XCTAssert(font == expectedFont, "Font is not expected.")
        }
        else {
            XCTAssert(false, "Font is nil.")
        }
    }
    
    
    func testArrayFontFamilyParsingWithQuotesSecondFontIsChosen() {
        
        let cssString =
        "   body {                          " +
            "       font-family : \"times nerw roman\", Arial, fhdjskfsfs, serif ;         " +
        "   }                               ";
        
        if let font = fontFromCSSFontFamilyProperty(sourceString: cssString as NSString) {
            
            let expectedFont = CSSFontFamily.custom("Arial")
            
            XCTAssert(font == expectedFont, "Font is not expected.")
        }
        else {
            XCTAssert(false, "Font is nil.")
        }
    }
    
    func testArrayFontFamilyParsingWithQuotesSerifIsChosen() {
        
        let cssString =
        "   body {                          " +
            "       font-family : \"times nerw roman\", Ariddddal, fhdjskfsfs, serif ;         " +
        "   }                               ";
        
        if let font = fontFromCSSFontFamilyProperty(sourceString: cssString as NSString) {
            
            let expectedFont = CSSFontFamily.serif
            
            XCTAssert(font == expectedFont, "Font is not expected.")
        }
        else {
            XCTAssert(false, "Font is nil.")
        }
    }
    
    
    private func fontFromCSSFontFamilyProperty(sourceString: NSString) -> CSSFontFamily? {
        
        let rules = CSSOMModule.shared.parseStyleRules(sourceString, origin: .author )
            
        XCTAssert(rules.count == 1 , "Pass")
        
        let rule = rules[0]
        
        if let style = rule.style {
            
            if let fontFamilyDeclaration = style["font-family"] {
                
                return CSSFontModule.parseFontFamilyToValue(fontFamilyDeclaration )
            }
            else {
                XCTAssert(false , "Absent color porperty.")
            }
        }
        else {
            XCTAssert(false , "Missing style in style rule.")
        }
        
        return nil
    }
    
    
}
