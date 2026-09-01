//
//  MarkdownFencedCodeTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-03-17.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Markdown

class MarkdownFencedCodeTests: MarkdownBasicTests {

    ///
    /// ``` js
    /// var foo = function (bar) {
    ///     return bar++;
    /// };
    ///
    /// console.log(foo(5));
    /// ```
    ///
    /// RESULT: PASS
    ///
    func testBasicFencedCode() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "basic-fencedcode.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("``` js\nvar foo = function (bar) {\n    return bar++;\n};\n\nconsole.log(foo(5));\n```")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }

    ///
    /// RESULT: PASS
    ///
    func testReceiveTokensFence() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "fence.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("```` <info>\n    javacode\n    test\n```` ")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    // Reenable after "html_inline" block implementation.
    ///
    /// RESULT: PASS
    ///
    func testReceiveTokensBadFence() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "bad_code_fence.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("```` <info> `\n    java code\n    test\n```` ")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    ///
    /// RESULT: PASS
    ///
    func testBasicFencedCodeWithAttributes() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "basic-fenced-code-with-attributes.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("```{.test}\n js\nvar foo = function (bar) {\n    return bar++;\n};\n\nconsole.log(foo(5));\n```")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
}
