//
//  TestFontStretchParsing.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
@testable import Web

class TestFontStretchParsing: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /// FIXME: This test does not work.
//    func testFontStretchBasicParsing() {
//        
//        let cssString =
//        "   body {                          " +
//            "       font-stretch : condensed ;         " +
//        "   }                               ";
//        
//        let fontStretch = fontStretchFromCSSFontStretchProperty(sourceString: cssString as NSString)
//        
//        if let fontStretch = fontStretch {
//            
//            let expectedFontStretch = CSSFontStretch.Condensed
//            
//            XCTAssert(fontStretch == expectedFontStretch, "Font stretch is not expected.")
//        }
//        else {
//            XCTAssert(false, "Font stretch is nil.")
//        }
//    }
    
    private func fontStretchFromCSSFontStretchProperty(sourceString: NSString) -> CSSFontStretch? {
        
        let rules = CSSOMModule.shared.parseStyleRules(sourceString, origin: .author )
            
        XCTAssert(rules.count == 1 , "Pass")
        
        let rule = rules[0]
        
        if let style = rule.style {
            
            if let fontStretchDeclaration = style["font-stretch"] {
                
                let resultFont = CSSFontModule.parseFontStretchToValue(fontStretchDeclaration )
                
                return resultFont
            }
            else {
                XCTAssert(false , "Absent font-stretch porperty.")
            }
        }
        else {
            XCTAssert(false , "Missing style in style rule.")
        }
        
        return nil
    }


}
