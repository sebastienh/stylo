//
//  MarkdownAttributesBlocMarkdownDomTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-05-01.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Web
@testable import Markdown


class MarkdownAttributesBlocMarkdownDomTests: MarkdownBasicTests {

    ///
    /// RESULT: TBD
    ///
    func testSimpleClassAttributeAppliedToParagraph() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "simple-class-attribute-to-paragraph.json")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        let tokens = md.parse("\n{ .className }\nsimple paragraph")
        
        let renderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)
        let document = renderer.render(tokens)
        let serializer = HTMLSerializer.createDefault()
        let string = serializer.serializeHTMLFragment(document)
        
        print("Mardkown string: \(string)")
//        let resultString = replaceAllWhitespaces(tokens.toString())
//        let expectedString = replaceAllWhitespaces(markdownItResultString)
//        
//        XCTAssert(resultString == expectedString)
//        print(tokens.toString())
    }

}
