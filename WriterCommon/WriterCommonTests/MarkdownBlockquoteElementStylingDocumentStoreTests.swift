//
//  MarkdownBlockquoteElementStylingDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-02-22.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

class MarkdownBlockquoteElementStylingDocumentStoreTests: MarkdownStylingDocumentStoreTests {

    // > > a
    func testBlockquote1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "blockquote.md", styleFilename: "blockquote-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 4, expected: green)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Expected: \(green), received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }

    // > > a
    func testBlockquote1Tag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "blockquote.md", styleFilename: "blockquote-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 0, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // > > a
    func testBlockquote1Tag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "blockquote.md", styleFilename: "blockquote-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 2, expected: yellow)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // > b
    func testBlockquote2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "blockquote.md", styleFilename: "blockquote-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 8, expected: green)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // > b
    func testBlockquote2Tag() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "blockquote.md", styleFilename: "blockquote-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 6, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // > c
    func testBlockquote3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "blockquote.md", styleFilename: "blockquote-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 12, expected: green)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // > c
    func testBlockquote3Tag() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "blockquote.md", styleFilename: "blockquote-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 10, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // d
    func testBlockquote4() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "blockquote.md", styleFilename: "blockquote-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 14, expected: green)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
}
