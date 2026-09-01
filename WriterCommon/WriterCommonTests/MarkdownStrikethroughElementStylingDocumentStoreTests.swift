//
//  MarkdownStrikethroughElementStylingDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-02-22.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

class MarkdownStrikethroughElementStylingDocumentStoreTests: MarkdownStylingDocumentStoreTests {

    // ~~strikethrough text~~
    func testStrikethrough() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "strikethrough.md", styleFilename: "strikethrough-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 19, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }

    // ~~strikethrough text~~
    func testStrikethroughTag11() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "strikethrough.md", styleFilename: "strikethrough-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 18, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // ~~strikethrough text~~
    func testStrikethroughTag12() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "strikethrough.md", styleFilename: "strikethrough-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 17, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // ~~strikethrough text~~
    func testStrikethroughTag21() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "strikethrough.md", styleFilename: "strikethrough-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 37, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // ~~strikethrough text~~
    func testStrikethroughTag22() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "strikethrough.md", styleFilename: "strikethrough-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 38, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
}
