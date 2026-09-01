//
//  MarkdownParserBasicTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-26.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class MarkdownParserBasicTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReceiveTokens2() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "blockquote+paragraph.json")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("> first\n> second")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    func testReceiveTokens2CarriageREturn() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "blockquote+paragraph+carriage-return.json")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("> first\r\n> second")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }

    func testReceiveTokensBlockquoteHeadingCode() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "code+blockquote+paragraph+heading.json")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("> # first\r\n> ## second\n\n    javacode\n    test")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        print(tokens.toString())
        
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    func testReceiveTokensHtmlBlockNonClosing() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "html-block-non-closing.json")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("<html>\n    java code")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }

    
    func testBackticks() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "backticks.json")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("The `markdown-it` killer feature.")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    //
    

    

    

    

    
    /// THIS TEST DOES NOT WORK
//    func testMarkdownPerformance() {
//
//        let markdownItString = try! String(contentsOfURL: urlOfFile(named: "performance1-test.md")!, encoding: NSUTF8StringEncoding)
//        
//        self.measureBlock {
//     
//            let md = MarkdownParser()
//            
//            for var i = 0; i < 100; i++ {
//            
//                md.parse(markdownItString)
//            }
//        }
//    }
    
    
    fileprivate func replaceAllWhitespaces(_ string: String) -> String {
        
        return string.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    
    fileprivate func urlOfFile(named name: String) -> URL? {
        
        let unitTestBundle = Bundle(for: type(of: self))
        
        let resourcesDirectoryURL = unitTestBundle.resourceURL!
        
        let fileManager = FileManager.default
        
        let resourcesDirectoryURLs: [URL] = (try! fileManager.contentsOfDirectory(at: resourcesDirectoryURL, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants))
        
        for url in resourcesDirectoryURLs {
            
            let last = url.lastPathComponent
            
            if last == name {
                
                return url
            }
        }
        
        return nil
    }
    
}
