//
//  MarkdownHtmlDocumentLoadingTests.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-07-13.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Common
import Igloo
import Markdown
@testable import WriterCommon

class MarkdownHtmlDocumentLoadingTests: MarkdownDocumentStoreTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBlockquoteLoading() {
        
        let url = urlOfFile(named: "simple-blockquote.md")
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        let style = createBasicStyle()
        let markdownStyleStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        let compiledAttributes = markdownStyleStore!.attributesStore.attributedString
        
        let attributes1 = compiledAttributes.attributes(at: 2, effectiveRange: nil)
        
        let expectedColor1 = NSColor(deviceRed: 0, green: 1, blue: 0, alpha: 1)
        let compiledColor1 = attributes1[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor1 != nil)
        
        XCTAssert(expectedColor1 == compiledColor1, "Received: \(compiledColor1!)")
        
        let attributes = compiledAttributes.attributes(at: 36, effectiveRange: nil)
        
        let expectedColor = NSColor(deviceRed: 0, green: 1, blue: 0, alpha: 1)
        let compiledColor = attributes[NSAttributedString.Key.foregroundColor] as? NSColor
        XCTAssert(compiledColor != nil)
        XCTAssert(expectedColor == compiledColor, "Received: \(compiledColor!)")
    }

}
