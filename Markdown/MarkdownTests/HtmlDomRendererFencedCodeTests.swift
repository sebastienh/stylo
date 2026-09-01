//
//  HtmlDomRendererFencedCodeTests.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-03-17.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Markdown
import Web
import Common

class HtmlDomRendererFencedCodeTests: XCTestCase {

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
    func testSimpleFencedCode() {
        
        let src = "``` js\nvar foo = function (bar) {\n    return bar++;\n};\n\nconsole.log(foo(5));\n```"
        
        // The passed options are enabling output of markdown elements i.e.
        // markdownOut = true
        let md = MarkdownParser(options: Presets.GetMarkdownDomPresets().options!)
        
        let renderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)
        
        ///
        /// ``` js
        /// var foo = function (bar) {
        ///     return bar++;
        /// };
        ///
        /// console.log(foo(5));
        /// ```
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
        //          ->  pre
        //              ->  code
        //                  ->  #text
        //
        htmlDomValidator.pushNodeNameToValidate("html")
        htmlDomValidator.pushNodeNameToValidate("head")
        htmlDomValidator.pushNodeNameToValidate("body")
        htmlDomValidator.pushNodeNameToValidate("pre")
        htmlDomValidator.pushNodeNameToValidate("code")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        
        renderResult.accept(htmlDomValidator)
        
        XCTAssert(htmlDomValidator.validationStack.isEmpty)
        XCTAssert(htmlDomValidator.success)
    }

}
