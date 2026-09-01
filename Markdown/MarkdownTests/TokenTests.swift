//
//  TokenTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2018-02-14.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class TokenTests: MarkdownBasicTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTokenIndexContainingContainingStartOfString() {
        
        let md = MarkdownParser()
        
        let tokens = md.parse(" # first\r\n ## second\n\n    javacode\n    test")
        
        let tokenIndex = tokens.tokenIndexContaining(0)
        
        XCTAssert(tokenIndex != nil)
        XCTAssert(tokenIndex! == 0)
    }

    
    func testTokenIndexContainingContainingBasicContaining() {
        
        let md = MarkdownParser()
        
        let tokens = md.parse(" # first\r\n ## second\n\n    javacode\n    test")
        
        let tokenIndex = tokens.tokenIndexContaining(1)
        
        XCTAssert(tokenIndex != nil)
        XCTAssert(tokenIndex! == 0)
    }
    
    func testTokenIndexContainingContainingBasicContaining2() {
        
        let md = MarkdownParser()
        
        let tokens = md.parse(" # first\r\n ## second\n\n    javacode\n    test")
        
        let tokenIndex = tokens.tokenIndexContaining(7)
        
        XCTAssert(tokenIndex != nil)
        XCTAssert(tokenIndex! == 0)
    }
    
    func testTokenIndexContainingContainingBasicContaining3() {
        
        let md = MarkdownParser()
        
        let tokens = md.parse(" # first\r\n ## second\n\n    javacode\n    test")
        
        let tokenIndex = tokens.tokenIndexContaining(8)
        
        XCTAssert(tokenIndex != nil)
        XCTAssert(tokenIndex! == 0)
    }
    
    func testTokenIndexContainingContainingBasicContaining4() {
        
        let md = MarkdownParser()
        
        let tokens = md.parse(" # first\n ## second\n\n   ")
        
        let tokenIndex = tokens.tokenIndexContaining(21)
        
        XCTAssert(tokenIndex != nil)
        XCTAssert(tokenIndex! == 3, "Received token index: \(tokenIndex!)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
