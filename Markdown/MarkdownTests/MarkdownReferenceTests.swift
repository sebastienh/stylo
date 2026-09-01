//
//  MarkdownReferenceTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-04-06.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class MarkdownReferenceTests: MarkdownBasicTests {

    /// RESULT: PASS
    func testReference() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "reference.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("[foo]: /url \"title\"")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        debugPrint("token string: \(tokenString)")
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    func testInvalidReference() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "invalid-reference.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("[i d]: https://octodex.github.com/images/dojocat.jpg  \"The Dojocat\"")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        debugPrint("token string: \(tokenString)")
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
        
    }
    
    /// RESULT: PASS
    func testReferenceWithInlineAttributesBloc() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "reference-with-inline-attributes.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("[foo]: /url \"title\" {.red} ")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        debugPrint("token string: \(tokenString)")
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    /// RESULT: PASS
    func testMultilineReferenceWithInlineAttributesBloc() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "multiline-reference-with-inline-attributes.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("[foo]: \n   /url \n        \"title\" {.red} ")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        debugPrint("token string: \(tokenString)")
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }

    /// RESULT: PASS
    func testSimpleReferenceWithInlineAttributesBloc() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "link-with-reference.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("[foo][bar]\n\n[bar]: /url \"title\" {.red}")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        debugPrint("token string: \(tokenString)")
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    ///
    /// RESULT: TBD
    ///
    func testSimpleReferenceWithLinkAfter() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "simple-reference-with-link-after.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("   [foo]: \n      /url  \n           'the title'  \n\n[foo]\n")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        debugPrint("token string: \(tokenString)")
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
}

