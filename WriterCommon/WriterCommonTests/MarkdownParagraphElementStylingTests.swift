//
//  MarkdownParagraphElementStylingTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-02-21.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

class MarkdownParagraphElementStylingTests: MarkdownDocumentStoreTests {

    func testParagraphContentStyling() {
        
        let url = urlOfFile(named: "paragraph.md")
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilename: "paragraph-style.css")
        
        let markdownStyleStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        let compiledAttributes = markdownStyleStore!.attributesStore.attributedString
        
        // # 1
        let attributes1 = compiledAttributes.attributes(at: 5, effectiveRange: nil)
        
        let expectedColor1 = NSColor(deviceRed: 0, green: 0, blue: 1, alpha: 1)
        let compiledColor1 = attributes1[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor1 != nil)
        XCTAssert(expectedColor1 == compiledColor1, "Received: \(compiledColor1!)")
    }

}
