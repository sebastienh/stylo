//
//  MarkdownAttributesBlocTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-05-01.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class MarkdownAttributesBlocTokensTests: MarkdownBasicTests {

    ///
    /// RESULT: PASS
    ///
    func testSimpleClassAttribute() {
    
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "simple-class-attribute.json")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        let tokens = md.parse("\n{ .className }\n")
        
        let resultString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(resultString == expectedString, "Expected: \"\(expectedString)\", received: \"\(resultString)\"")
        print(tokens.toString())
    }
    
    ///
    /// RESULT: PASS
    ///
    func testSimpleIdAttribute() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "simple-id-attribute.json")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        let tokens = md.parse("\n{ #idName }\n")
        
        let resultString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(resultString == expectedString, "Expected: \"\(expectedString)\", received: \"\(resultString)\"")
        print(tokens.toString())
    }
    
    ///
    /// RESULT: PASS
    ///
    func testSimpleKeyValueAttribute() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "simple-key-value-attribute.json")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        let tokens = md.parse("\n{ key=value }\n")
        
        let resultString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(resultString == expectedString, "Expected: \"\(expectedString)\", received: \"\(resultString)\"")
        print(tokens.toString())
    }
    
    ///
    /// RESULT: PASS
    ///
    func testSimpleClassAttributeAppliedToParagraph() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "simple-class-attribute-to-paragraph.json")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        let tokens = md.parse("\n{ .className }\nsimple paragraph")
        
        let resultString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(resultString == expectedString, "Expected: \"\(expectedString)\", received: \"\(resultString)\"")
        print(tokens.toString())
    }
    
    ///
    /// RESULT: PASS
    ///
    func testAttributeFollowedByText() {

        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "attribute-followed-by-text.json")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        let tokens = md.parse("\n{ .className }Some text not part of the attribute bloc.\n")
        
        let resultString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(resultString == expectedString, "Expected: \"\(expectedString)\", received: \"\(resultString)\"")
        print(tokens.toString())
    }
}
