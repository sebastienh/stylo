//
//  HtmlDomRendererTableTests.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-05-19.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Markdown
import Web
import Common

class HtmlDomRendererTableTests: XCTestCase {
    
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
    func testBasicTable() {
        
        let src = "| Option | Description |\n| ------ | ----------- |\n| data   | path to data files to supply the data that will be passed into templates. |\n| engine | engine to be used for processing templates. Handlebars is the default. |"
        
        // The passed options are disabling output of markdown elements i.e.
        // markdownOut = false, this option is false by default.
        let md = MarkdownParser()
        
        let renderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)
        
        // this returns the HTML Document againts which we must validate
        // it may contain invalid HTML nodes that are in the Markdown namespace.
        // It this case it not true.
        let renderResult = md.render(src: src, withRenderer: renderer)
        
        let htmlDomValidator = HtmlDomValidator()
        
        // <html>
        //  <table>
        //      <thead>
        //          <tr>
        //              <th>Option</th>
        //              <th>Description</th>
        //          </tr>
        //      </thead>
        //      <tbody>
        //          <tr>
        //              <td>data</td>
        //              <td>path to data files to supply the data that will be passed into templates.</td>
        //          </tr>
        //          <tr>
        //              <td>engine</td>
        //              <td>engine to be used for processing templates. Handlebars is the default.</td>
        //          </tr>
        //      </tbody>
        //  </table>
        // </html>
        
        htmlDomValidator.pushNodeNameToValidate("html")
        htmlDomValidator.pushNodeNameToValidate("head")
        htmlDomValidator.pushNodeNameToValidate("body")
        htmlDomValidator.pushNodeNameToValidate("table")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("thead")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("tr")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("th")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("th")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("tbody")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("tr")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("td")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("td")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("tr")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("td")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("td")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        htmlDomValidator.pushNodeNameToValidate("#text")
        
        renderResult.accept(htmlDomValidator)
        
        XCTAssert(htmlDomValidator.validationStack.isEmpty)
        XCTAssert(htmlDomValidator.success)
        
        
    }
    
}














