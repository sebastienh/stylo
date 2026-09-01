//
//  MarkdownTokenContainingTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2018-10-24.
//  Copyright © 2018 Textually Inc All rights reserved.
//

import XCTest
@testable import Markdown

class MarkdownTokenContainingTests: MarkdownBasicTests {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTokenContaining() {
        
        let string = try! String(contentsOf: urlOfFile(named: "token-containing.md")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        let tokens = md.parse(string)
        var foundAllTokens = true
        
        let tokensString = tokens.toString(includePosition: true)
        
        print("tokens: \(tokensString)")
        
        for index in 0..<string.count-1 {
            if tokens.tokenIndexContaining(index) == nil {
                foundAllTokens = false
                debugPrint("Didn't find token at index: \(index)")
            }
        }
        XCTAssert(foundAllTokens)
    }

    func testTokenContaining29() {
        
        let string = try! String(contentsOf: urlOfFile(named: "token-containing.md")!, encoding: String.Encoding.utf8)
        let md = MarkdownParser()
        let tokens = md.parse(string)
        let index = tokens.tokenIndexContaining(29)
        XCTAssert(index == 0, "index was: \(index)")
    }
    
    func testTokenContaining30() {
        
        let string = try! String(contentsOf: urlOfFile(named: "token-containing.md")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        let tokens = md.parse(string)
        let index = tokens.tokenIndexContaining(30)
        XCTAssert(index == 0)
    }
    
    func testTokenContaining31() {
        
        let string = try! String(contentsOf: urlOfFile(named: "token-containing.md")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        let tokens = md.parse(string)
        let index = tokens.tokenIndexContaining(31)
        XCTAssert(index == 0)
    }
    
    func testTokenContaining23() {
        
        let string = try! String(contentsOf: urlOfFile(named: "array-containing.md")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        let tokens = md.parse(string)
        let index = tokens.tokenIndexContaining(23)
        XCTAssert(index == 6)
    }
    
    func testTokenContainingSpec() {
        
        let string = try! String(contentsOf: urlOfFile(named: "spec.txt")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        let tokens = md.parse(string)
        var foundAllTokens = true
        
        let tokensString = tokens.toString(includePosition: true)
        
        print("tokens: \(tokensString)")
        
        for index in 0..<string.count-1 {
            if tokens.tokenIndexContaining(index) == nil {
                foundAllTokens = false
                debugPrint("Didn't find token at index: \(index)")
            }
        }
        XCTAssert(foundAllTokens)
    }

}
