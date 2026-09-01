//
//  MarkdownSpecTestsBase.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-05-21.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Common
@testable import Markdown

class MarkdownSpecTestsBase: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func parseToHTML(_ markdownSource: String) -> String {
        
        // The passed options are enabling output of markdown elements i.e.
        // markdownOut = true
        let md = MarkdownParser(options: Presets.GetCommonMarkPresets().options!)
        
        let renderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)
        
        // this returns the HTML Document againts which we must validate
        // it may contain invalid HTML nodes that are in the Markdown namespace.
        // It this case it not true.
        let renderResult = md.render(src: markdownSource, withRenderer: renderer)
        
        let bodyElement = renderResult.getElementsByTagName("body").namedItem("body")!
        
        let xmlSerializer = HTMLSerializer.createFlat()
        
        var serializedString = ""

        var string = xmlSerializer.serializeHTMLFragment(bodyElement)
            
        string.replaceAll(regex(" nw-element-id=\\\"[0-9A-F-]*\\\""), from: string.startIndex, withTemplate: "")
        string.replaceAll(regex("<body xmlns=\"http://www.w3.org/1999/xhtml\">"), from: string.startIndex, withTemplate: "")
        string.replaceAll(regex("\n</body>"), from: string.startIndex, withTemplate: "")
        
        if string.hasSuffix("\n</body>") {
            
            string = string.slice(0, end: -8)!
        }
        
        string.replaceAll(regex("</body>"), from: string.startIndex, withTemplate: "")
        string.replaceAll(regex("<html-block xmlns=\"\(§Namespace.MD)\">"), from: string.startIndex, withTemplate: "")
        string.replaceAll(regex("</html-block>"), from: string.startIndex, withTemplate: "")
        
        serializedString += string
        
        return serializedString
    }

}
