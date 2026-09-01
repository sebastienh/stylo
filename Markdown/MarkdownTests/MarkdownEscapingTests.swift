//
//  MarkdownEscapingTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-05-19.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class MarkdownEscapingTests: MarkdownBasicTests {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEscape() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "escape.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        md.options.markdownOut = false
        
        let tokens = md.parse("\\> La nuit!")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        print(tokenString)
        
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        print(expectedString)
        
        //
        XCTAssert(tokenString.utf16.count == expectedString.utf16.count)
        
        XCTAssert(tokenString.characters.count == expectedString.characters.count)
        
//        for (index, _) in tokenString.utf16.enumerate() {
//            
//            let tokenCharacter = tokenString.charAt(index)!
//            let expectedCharacter = expectedString.charAt(index)!
//            
//            XCTAssert(tokenCharacter == expectedCharacter, "char: \(String.fromCharCode(tokenCharacter)) is not equal to \(String.fromCharCode(expectedCharacter))")
//        }
        
        print(tokens.toString())
        
    }
    
    func testEscapePound() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "escape-pound.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        // \# test
        
        let tokens = md.parse("\\# test")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        if tokenString != expectedString {
            
            displayStringDifferences(tokenString, string2: expectedString)
        }
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
}
