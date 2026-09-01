//
//  MarkdownCodeBlockTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-03-17.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Markdown

class MarkdownCodeBlockTests: MarkdownBasicTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    ///
    ///     Start of code block
    ///     end of code block.
    ///
    /// RESULT: PASS
    ///
    func testBasicCodeblock() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "basic-codeblock.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("    Start of code block\n    end of code block.")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }

    ///
    /// RESULT: PASS
    ///
    func testReceiveTokensCode() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "code-2.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("\n    javacode\n    test")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    
    ///
    /// RESULT: PASS
    ///
    func testReceiveTokensCodeWithAttributes() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "code.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("eee `foo`{.red}")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
}
