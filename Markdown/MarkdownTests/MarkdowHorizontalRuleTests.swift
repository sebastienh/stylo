//
//  MarkdowHorizontalRuleTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-03-12.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class MarkdowHorizontalRuleTests: MarkdownBasicTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

    }

    ///
    ///        ---
    ///
    /// RESULT: PASS
    ///
    func testBasicHr() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "basic-hr.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("---")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        if tokenString != expectedString {
            
            displayStringDifferences(tokenString, string2: expectedString)
        }
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    ///        ```` <info> `
    ///        java code
    ///        test
    ///        ----
    /// RESULT: PASS
    ///
    func testHr() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "hr.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("```` <info> `\n    java code\n    test\n----")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
        
    }

}
