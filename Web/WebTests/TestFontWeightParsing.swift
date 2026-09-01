//
//  TestFontWeightParsing.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
@testable import Web

class TestFontWeightParsing: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFontWeightBasicParsing() {
        
        let cssString = """
            body {
                font-weight : normal;
            }
            """

        let fontWeight = fontWeightFromCSSFontWeightProperty(sourceString: cssString as NSString)
        
        if let fontWeight = fontWeight {
            
            let expectedFontWeight = CSSFontWeight.absolute(.normal)
            
            XCTAssert(fontWeight.fontWeightValue() == expectedFontWeight.fontWeightValue(), "Font weight is not expected.")
        }
        else {
            XCTAssert(false, "Font weight is nil.")
        }
    }

    func testFontWeightLightBasicParsing() {
        
        let cssString =
        "   body {                          " +
            "       font-weight : 300;         " +
        "   }                               ";
        
        let fontWeight = fontWeightFromCSSFontWeightProperty(sourceString: cssString as NSString)
        
        if let fontWeight = fontWeight {
            
            let expectedFontWeight = CSSFontWeight.numeric(.light)
            
            XCTAssert(fontWeight.fontWeightValue() == expectedFontWeight.fontWeightValue(), "Font weight is not expected.")
        }
        else {
            XCTAssert(false, "Font weight is nil.")
        }
    }
    
    private func fontWeightFromCSSFontWeightProperty(sourceString: NSString) -> CSSFontWeight? {
        
        let rules = CSSOMModule.shared.parseStyleRules(sourceString, origin: .author, computePropertyValues: true)
            
        XCTAssert(rules.count == 1 , "Pass")
        
        let rule = rules[0]
        
        if let style = rule.style {
            
            if let fontWeightDeclaration = style["font-weight"] {
                
                let resultFontWeight = CSSFontModule.parseFontWeightToValue(fontWeightDeclaration )
                
                return resultFontWeight
            }
            else {
                XCTAssert(false , "Absent font-weight porperty.")
            }
        }
        else {
            XCTAssert(false , "Missing style in style rule.")
        }
        
        return nil
    }
    
}
