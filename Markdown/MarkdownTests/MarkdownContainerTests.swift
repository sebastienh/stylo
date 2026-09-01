//
//  MarkdownContainerTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-05-01.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class MarkdownContainerTests: MarkdownBasicTests {
    
    ///
    /// RESULT: PASS
    ///
    func testSimpleContainer() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "simple-container.json")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        let tokens = md.parse("\n:::: { key=value } :::::\n\n# level one\n\n::::")
        
        let resultString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(resultString == expectedString)
        print(tokens.toString())
    }

    //
    
    ///
    /// RESULT: TBD
    ///
    func testSimpleContainer2() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "simple-container-2.json")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        let tokens = md.parse("::: class :::\nSome text.\n:::\n")
        
        let resultString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(resultString == expectedString)
        print(tokens.toString())
    }
}
