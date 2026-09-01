//
//  MarkdownHorizontalBarElementStylingDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-02-22.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

class MarkdownHorizontalBarElementStylingDocumentStoreTests: MarkdownStylingDocumentStoreTests {

    func testHorizontalBar1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "horizontal-bars.md", styleFilename: "horizontal-bars-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 18, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }

    func testHorizontalBar2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "horizontal-bars.md", styleFilename: "horizontal-bars-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 23, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
}
