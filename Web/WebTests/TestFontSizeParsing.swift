//
//  TestFontSizeParsing.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
@testable import Web

class TestFontSizeParsing: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFontSizeSmallBasicParsing() {
        
        let cssString =
        "   body {                          " +
            "       font-size : small ;         " +
        "   }                               ";
        
        let fontSize = fontSizeFromCSSFontSizeProperty(sourceString: cssString as NSString)
        
        if let fontSize = fontSize {
            
            let expectedFontSize = CSSFontSize.small
            
            XCTAssert(fontSize == expectedFontSize, "Font size is not expected.")
        }
        else {
            XCTAssert(false, "Font size is nil.")
        }
    }
    
    func testFontSizePTBasicParsing() {
        
        let cssString =
        "   body {                          " +
            "       font-size : 12pt ;         " +
        "   }                               ";
        
        let fontSize = fontSizeFromCSSFontSizeProperty(sourceString: cssString as NSString)
        
        if let fontSize = fontSize {
            
            let expectedFontSize = CSSFontSize.length(CSSLength.pt(12.0))
            
            XCTAssert(fontSize == expectedFontSize, "Font size is not expected.")
        }
        else {
            XCTAssert(false, "Font size is nil.")
        }
    }
    
    func testFontSizeEMBasicParsing() {
        
        let cssString =
        "   body {                          " +
            "       font-size : 12em ;         " +
        "   }                               ";
        
        let fontSize = fontSizeFromCSSFontSizeProperty(sourceString: cssString as NSString)
        
        if let fontSize = fontSize {
            
            let expectedFontSize = CSSFontSize.length(CSSLength.em(12.0))
            
            XCTAssert(fontSize == expectedFontSize, "Font size is not expected.")
        }
        else {
            XCTAssert(false, "Font size is nil.")
        }
    }
    
    func testFontSizePercentageBasicParsing() {
        
        let cssString =
        "   body {                          " +
            "       font-size : 150% ;         " +
        "   }                               ";
        
        let fontSize = fontSizeFromCSSFontSizeProperty(sourceString: cssString as NSString)
        
        if let fontSize = fontSize {
            
            let expectedFontSize = CSSFontSize.percentage(150)
            
            XCTAssert(fontSize == expectedFontSize, "Font size is not expected.")
        }
        else {
            XCTAssert(false, "Font size is nil.")
        }
    }
    
    func testFontSizeRelativeBasicParsing() {
        
        let cssString =
        "   body {                          " +
            "       font-size : larger;         " +
        "   }                               ";
        
        let fontSize = fontSizeFromCSSFontSizeProperty(sourceString: cssString as NSString)
        
        if let fontSize = fontSize {
            
            let expectedFontSize = CSSFontSize.larger
            
            XCTAssert(fontSize == expectedFontSize, "Font size is not expected.")
        }
        else {
            XCTAssert(false, "Font size is nil.")
        }
    }
    
    private func fontSizeFromCSSFontSizeProperty(sourceString: NSString) -> CSSFontSize? {
        
        let rules = CSSOMModule.shared.parseStyleRules(sourceString, origin: .author )
            
        XCTAssert(rules.count == 1 , "Pass")
        
        let rule = rules[0]
        
        if let style = rule.style {
            
            if let fontSizeDeclaration = style["font-size"] {
                
                let resultFontSize = CSSFontModule.parseFontSizeToValue(fontSizeDeclaration )
                
                return resultFontSize
            }
            else {
                XCTAssert(false , "Absent font-size porperty.")
            }
        }
        else {
            XCTAssert(false , "Missing style in style rule.")
        }
        
        return nil
    }

}
