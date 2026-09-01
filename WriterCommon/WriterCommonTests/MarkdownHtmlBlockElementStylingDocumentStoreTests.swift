//
//  MarkdownHtmlBlockElementStylingDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-02-22.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

/*
string
<pre>
inside
</pre>
string
*/
class MarkdownHtmlBlockElementStylingDocumentStoreTests: MarkdownStylingDocumentStoreTests {
    
    func testBeforeHtmlBlockStart1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "html-block.md", styleFilename: "html-block-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 0, expected: black)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testBeforeHtmlBlockStart2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "html-block.md", styleFilename: "html-block-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 1, expected: black)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testBeforeHtmlBlockStart3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "html-block.md", styleFilename: "html-block-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 2, expected: black)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testBeforeHtmlBlockStart4() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "html-block.md", styleFilename: "html-block-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 3, expected: black)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testBeforeHtmlBlockStart5() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "html-block.md", styleFilename: "html-block-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 4, expected: black)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testHtmlBlockStart() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "html-block.md", styleFilename: "html-block-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 7, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }

    func testHtmlBlockeEnd() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "html-block.md", styleFilename: "html-block-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 25, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testAfterHtmlBlockEnd1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "html-block.md", styleFilename: "html-block-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 27, expected: black)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
}
