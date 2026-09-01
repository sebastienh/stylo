//
//  TestFontStyleParsing.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
@testable import Web

class TestFontStyleParsing: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFontStyleNormalParsing() {
        
        let cssString =
        "   body {                          " +
            "       font-style : normal ;         " +
        "   }                               ";
        
        let fontStyle = fontStyleFromCSSFontStyleProperty(sourceString: cssString as NSString)
        
        if let fontStyle = fontStyle {
            
            let expectedFontStyle = CSSFontStyle.keyword(.normal)
            
            XCTAssert(fontStyle == expectedFontStyle, "Font style is not expected.")
        }
        else {
            XCTAssert(false, "Font style is nil.")
        }
    }
    
    func testFontStyleItalicParsing() {
        
        let cssString =
        "   body {                          " +
            "       font-style : italic ;         " +
        "   }                               ";
        
        let fontStyle = fontStyleFromCSSFontStyleProperty(sourceString: cssString as NSString)
        
        if let fontStyle = fontStyle {
            
            let expectedFontStyle = CSSFontStyle.keyword(.italic)
            
            XCTAssert(fontStyle == expectedFontStyle, "Font style is not expected.")
        }
        else {
            XCTAssert(false, "Font style is nil.")
        }
    }
    
    func testFontStyleOblicParsing() {
        
        let cssString =
        "   body {                          " +
            "       font-style : oblique ;         " +
        "   }                               ";
        
        let fontStyle = fontStyleFromCSSFontStyleProperty(sourceString: cssString as NSString)
        
        if let fontStyle = fontStyle {
            
            let expectedFontStyle = CSSFontStyle.keyword(.oblique)
            
            XCTAssert(fontStyle == expectedFontStyle, "Font style is not expected.")
        }
        else {
            XCTAssert(false, "Font style is nil.")
        }
    }
    
    
    private func fontStyleFromCSSFontStyleProperty(sourceString: NSString) -> CSSFontStyle? {
        
        let rules = CSSOMModule.shared.parseStyleRules(sourceString, origin: .author )
            
        XCTAssert(rules.count == 1 , "Pass")
        
        let rule = rules[0]
        
        if let style = rule.style {
            
            if let fontFamilyDeclaration = style["font-style"] {
                
                let resultFont = CSSFontModule.parseFontStyleToValue(fontFamilyDeclaration )
                
                return resultFont
            }
            else {
                XCTAssert(false , "Absent font-style porperty.")
            }
        }
        else {
            XCTAssert(false , "Missing style in style rule.")
        }
        
        return nil
    }
    

}
