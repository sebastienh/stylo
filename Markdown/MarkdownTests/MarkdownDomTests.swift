//
//  MarkdownDomTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-21.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Common
@testable import Markdown

class MarkdownDomTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    ///
    /// RESULT: PASS
    ///
    func testBlockquoteHeadingDom() {

        let src = "> # first\r\n> ## second"
        
        let md = MarkdownParser()
        
        let renderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)
        
        let renderResult = md.render(src: src, withRenderer: renderer)
        
        let domParsing = HTMLSerializer.createFlat()
        
        var string = domParsing.serializeHTMLFragment(renderResult)
        
        string.replaceAll(regex("id=\\\"[0-9A-F-]*\\\""), from: string.startIndex, withTemplate: "")
        string.replaceAll(regex(" >"), from: string.startIndex, withTemplate: ">")
        
        debugPrint("Markdown string serialization result: \(string)")
        
        XCTAssert(string == "<!DOCTYPE html><html><head><meta charset=\"utf-8\" /></head><body><blockquote>\n<h1>first</h1>\n<h2>second</h2>\n</blockquote>\n</body></html>", "Received: \(string)")
    }
}
