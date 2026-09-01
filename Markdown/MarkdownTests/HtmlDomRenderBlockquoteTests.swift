//
//  HtmlDomRenderBlockquoteTests.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-03-15.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Markdown
import Web
import Common

class HtmlDomRenderBlockquoteTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    ///
    /// This test validate that the Markdown DOM generated from the
    /// Markdown tokens is right.
    ///
    /// RESULT: PASS
    ///
    func testBasicBlockquoteWithH1() {
        
        let sourceMarkdown = "> # titre 1\n"
        
        // The passed options are enabling output of markdown elements i.e.
        // markdownOut = true
        let md = MarkdownParser(options: Presets.GetMarkdownDomPresets().options!)
        
        let renderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)
        
        // > # titre 1
        
        // this returns the HTML Document againts which we must validate
        // it may contain invalid HTML nodes that are in the Markdown namespace.
        // It this case it not true.
        let renderResult = md.render(src: sourceMarkdown, withRenderer: renderer)
        
        let htmlDomValidator = HtmlDomValidator()
        
        //
        //  html
        //      ->  head
        //      ->  body
        //          ->  blockquote
        //              ->  h1
        //                  -> #text
        htmlDomValidator.pushNodeNameToValidate("html")
        htmlDomValidator.pushNodeNameToValidate("head")
        htmlDomValidator.pushNodeNameToValidate("body")
        htmlDomValidator.pushNodeNameToValidate("blockquote")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("h1")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        
        renderResult.accept(htmlDomValidator)
        
        XCTAssert(htmlDomValidator.validationStack.isEmpty)
        XCTAssert(htmlDomValidator.success)
    }
    
    
    ///
    /// This test validate that the Markdown DOM generated from the
    /// Markdown tokens is right.
    ///
    /// RESULT: PASS
    ///
    func testBasicBlockquote() {
        
        let src = "> block line 1\n> block line 2\n> block line 3\n\nParagraph following"
        
        // The passed options are enabling output of markdown elements i.e.
        // markdownOut = true
        let md = MarkdownParser(options: Presets.GetMarkdownDomPresets().options!)
        
        let renderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)
        
        // > block line 1
        // > block line 2
        // > block line 3
        //
        // Paragraph following
        
        // this returns the HTML Document againts which we must validate
        // it may contain invalid HTML nodes that are in the Markdown namespace.
        // It this case it not true.
        let renderResult = md.render(src: src, withRenderer: renderer)
        
        let htmlDomValidator = HtmlDomValidator()
        
        //
        //  html
        //      ->  head
        //      ->  body
        //          ->  blockquote
        //              ->  p
        //                  ->  #text
        //                  ->  #text
        //                  ->  #text
        //          ->  p
        //              ->  #text
        htmlDomValidator.pushNodeNameToValidate("html")
        htmlDomValidator.pushNodeNameToValidate("head")
        htmlDomValidator.pushNodeNameToValidate("body")
        htmlDomValidator.pushNodeNameToValidate("blockquote")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("p")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        // there is two \n added because of softbreaks
        htmlDomValidator.pushNodeNameToValidate("p")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        
        renderResult.accept(htmlDomValidator)
        
        XCTAssert(htmlDomValidator.validationStack.isEmpty)
        XCTAssert(htmlDomValidator.success)
    }

}
