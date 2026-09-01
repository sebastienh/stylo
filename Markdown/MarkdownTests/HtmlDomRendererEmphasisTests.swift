//
//  HtmlDomRendererEmphasisTests.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-03-15.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Markdown
import Web
import Common

class HtmlDomRendererEmphasisTests: XCTestCase {

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
    func testComplexEmphasisInsideBlockquote1() {
        
        let src = "> first text **strong text** second text *emphased text* third text"
        
        // The passed options are enabling output of markdown elements i.e.
        // markdownOut = true
        let md = MarkdownParser(options: Presets.GetMarkdownDomPresets().options!)
        
        let renderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)

        ///
        /// > blockquote value blockquote value **blockquote** value blockquote *value* blockquote
        ///
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
        //                  ->  strong
        //                      ->  #text
        //                  ->  #text
        //                  ->  em
        //                      ->  #text
        //                  ->  #text
        //
        htmlDomValidator.pushNodeNameToValidate("html")
        htmlDomValidator.pushNodeNameToValidate("head")
        htmlDomValidator.pushNodeNameToValidate("body")
        htmlDomValidator.pushNodeNameToValidate("blockquote")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("p")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("strong")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("em")
        htmlDomValidator.pushNodeNameToValidate("#text")
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
    func testBasicEmphasisInsideBlockquote() {
        
        let src = "> *Text in bold*"
        
        // The passed options are enabling output of markdown elements i.e.
        // markdownOut = true
        let md = MarkdownParser(options: Presets.GetMarkdownDomPresets().options!)
        
        let renderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)
        
        // *Text in bold*
        
        // this returns the HTML Document againts which we must validate
        // it may contain invalid HTML nodes that are in the Markdown namespace.
        // It this case it not true.
        let renderResult = md.render(src: src, withRenderer: renderer)
        
        let htmlDomValidator = HtmlDomValidator()
        
        //
        //  html
        //      ->  head
        //      ->  body
        //          -> blockquote
        //              ->  p
        //                  ->  em
        //                      ->  #text
        //
        htmlDomValidator.pushNodeNameToValidate("html")
        htmlDomValidator.pushNodeNameToValidate("head")
        htmlDomValidator.pushNodeNameToValidate("body")
        htmlDomValidator.pushNodeNameToValidate("blockquote")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("p")
        htmlDomValidator.pushNodeNameToValidate("em")
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
    func testBasicEmphasis() {
        
        let src = "*Text in bold*"
        
        // The passed options are enabling output of markdown elements i.e.
        // markdownOut = true
        let md = MarkdownParser(options: Presets.GetMarkdownDomPresets().options!)
        
        let renderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)
        
        // *Text in bold*
        
        // this returns the HTML Document againts which we must validate
        // it may contain invalid HTML nodes that are in the Markdown namespace.
        // It this case it not true.
        let renderResult = md.render(src: src, withRenderer: renderer)
        
        let htmlDomValidator = HtmlDomValidator()
        
        //
        //  html
        //      ->  head
        //      ->  body
        //          ->  p
        //              ->  em
        //                  ->  #text
        //
        htmlDomValidator.pushNodeNameToValidate("html")
        htmlDomValidator.pushNodeNameToValidate("head")
        htmlDomValidator.pushNodeNameToValidate("body")
        htmlDomValidator.pushNodeNameToValidate("p")
        htmlDomValidator.pushNodeNameToValidate("em")
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
    func testBasicStrongEmphasis() {
        
        let src = "**Text in bold**"
        
        // The passed options are enabling output of markdown elements i.e.
        // markdownOut = true
        let md = MarkdownParser(options: Presets.GetMarkdownDomPresets().options!)
        
        let renderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)
        
        // **Text in bold**
        
        // this returns the HTML Document againts which we must validate
        // it may contain invalid HTML nodes that are in the Markdown namespace.
        // It this case it not true.
        let renderResult = md.render(src: src, withRenderer: renderer)
        
        let htmlDomValidator = HtmlDomValidator()
        
        //
        //  html
        //      ->  head
        //      ->  body
        //          ->  p
        //              ->  strong
        //                  ->  #text
        //      ->  #text
        htmlDomValidator.pushNodeNameToValidate("html")
        htmlDomValidator.pushNodeNameToValidate("head")
        htmlDomValidator.pushNodeNameToValidate("body")
        htmlDomValidator.pushNodeNameToValidate("p")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("strong")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        
        renderResult.accept(htmlDomValidator)
        
        XCTAssert(htmlDomValidator.validationStack.isEmpty)
        XCTAssert(htmlDomValidator.success)
    }

}
