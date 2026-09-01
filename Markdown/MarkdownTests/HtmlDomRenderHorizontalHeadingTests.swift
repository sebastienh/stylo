//
//  HtmlDomRenderHorizontalHeadingTests.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-03-15.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Markdown
import Web
import Common

class HtmlDomRenderHorizontalHeadingTests: XCTestCase {

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
    func testHorizontalHeadingLevel1() {
        
        let src = "Un titre de niveau 1\n=============="
        
        // The passed options are enabling output of markdown elements i.e.
        // markdownOut = true
        let md = MarkdownParser(options: Presets.GetMarkdownDomPresets().options!)
        
        let renderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)
        
        // this returns the HTML Document againts which we must validate
        // it may contain invalid HTML nodes that are in the Markdown namespace.
        // It this case it not true.
        let renderResult = md.render(src: src, withRenderer: renderer)
        
        let htmlDomValidator = HtmlDomValidator()
        
        //
        //  html
        //      ->  head
        //      ->  body
        //          ->  h1
        //              ->  #text
        //
        htmlDomValidator.pushNodeNameToValidate("html")
        htmlDomValidator.pushNodeNameToValidate("head")
        htmlDomValidator.pushNodeNameToValidate("body")
        htmlDomValidator.pushNodeNameToValidate("h1")
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
    func testHorizontalHeadingLevel2() {
        
        let src = "Un titre de niveau 2\n-------------"
        
        // The passed options are enabling output of markdown elements i.e.
        // markdownOut = true
        let md = MarkdownParser(options: Presets.GetMarkdownDomPresets().options!)
        
        let renderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)
        
        // this returns the HTML Document againts which we must validate
        // it may contain invalid HTML nodes that are in the Markdown namespace.
        // It this case it not true.
        let renderResult = md.render(src: src, withRenderer: renderer)
        
        let htmlDomValidator = HtmlDomValidator()
        
        //
        //  html
        //      ->  head
        //      ->  body
        //          ->  h2
        //              ->  #text
        //
        htmlDomValidator.pushNodeNameToValidate("html")
        htmlDomValidator.pushNodeNameToValidate("head")
        htmlDomValidator.pushNodeNameToValidate("body")
        htmlDomValidator.pushNodeNameToValidate("h2")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        
        renderResult.accept(htmlDomValidator)
        
        XCTAssert(htmlDomValidator.validationStack.isEmpty)
        XCTAssert(htmlDomValidator.success)
    }
    
}
