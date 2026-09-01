//
//  TestTextDecorationLineParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-29.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
@testable import Web

class TestTextDecorationLineParser: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /// FIXME: This test does not work.
    func testNoneTextDecorationParsing() {
        
        let cssString =
        "   body {                          " +
            "       text-decoration-line : none ;         " +
        "   }                               ";
        
        let textDecorationLine = textDecorationLineFromCSSTextDecorationLineProperty(sourceString: cssString as NSString)
        
        if let textDecorationLine = textDecorationLine {
            
            var expectedTextDecorationLine = CSSTextDecorationLine()
            expectedTextDecorationLine.addTextDecorationLineType(CSSTextDecorationLineType.noUnderline)
            
            XCTAssert(textDecorationLine == expectedTextDecorationLine, "Text Decoration Line is not expected.")
        }
        else {
            XCTAssert(false, "Text Decoration Line is nil.")
        }
    }
    
    /// FIXME: This test does not work.
    func testUnderlineOverlineTextDecorationParsing() {
        
        let cssString =
        "   body {                          " +
            "       text-decoration-line : underline overline ;         " +
        "   }                               ";
        
        let textDecorationLine = textDecorationLineFromCSSTextDecorationLineProperty(sourceString: cssString as NSString)
        
        if let textDecorationLine = textDecorationLine {
            
            var expectedTextDecorationLine = CSSTextDecorationLine()
            expectedTextDecorationLine.addTextDecorationLineType(CSSTextDecorationLineType.underline)
            expectedTextDecorationLine.addTextDecorationLineType(CSSTextDecorationLineType.overline)
            
            XCTAssert(textDecorationLine == expectedTextDecorationLine, "Text Decoration Line is not expected.")
        }
        else {
            XCTAssert(false, "Text Decoration Line is nil.")
        }
    }
    
    private func textDecorationLineFromCSSTextDecorationLineProperty(sourceString: NSString) -> CSSTextDecorationLine? {

        let rules = CSSOMModule.shared.parseStyleRules(sourceString, origin: .author )
            
        XCTAssert(rules.count == 1 , "Pass")
        
        let rule = rules[0]
        
        if let style = rule.style {
            
            if let textDecorationLineDeclaration = style["text-decoration-line"] {
                
                let resultFont = CSSTextDecorationModule.parseTextDecorationLineToValue(textDecorationLineDeclaration )
                
                return resultFont
            }
            else {
                XCTAssert(false , "Absent text-decoration-line porperty.")
            }
        }
        else {
            XCTAssert(false , "Missing style in style rule.")
        }
        
        return nil
    }

}
