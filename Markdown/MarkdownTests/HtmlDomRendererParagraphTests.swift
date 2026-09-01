//
//  HtmlDomRendererParagraphTests.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-03-17.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Markdown
import Web
import Common

class HtmlDomRendererParagraphTests: XCTestCase {

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
    func testSimpleParagraph() {
        
        let src = "Working at a record store, Rosenberg developed an encyclopedic knowledge of the pop canon, listening and absorbing everything from Michael Jackson and '80s radio pop to more obscure, experimental music, such as R. Stevie Moore, Throbbing Gristle, Can and death metal. He has cited The Cure - particularly their early albums - as his favorite band of all time.[18] He started writing songs at around age 10 and has since recorded over 500 songs in various shapes and forms on hundreds of cassette tapes, the majority of which have never been released."
        
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
        //          ->  p
        //              ->  #text
        //
        htmlDomValidator.pushNodeNameToValidate("html")
        htmlDomValidator.pushNodeNameToValidate("head")
        htmlDomValidator.pushNodeNameToValidate("body")
        htmlDomValidator.pushNodeNameToValidate("p")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        
        renderResult.accept(htmlDomValidator)
        
        XCTAssert(htmlDomValidator.validationStack.isEmpty)
        XCTAssert(htmlDomValidator.success)
    }

}
