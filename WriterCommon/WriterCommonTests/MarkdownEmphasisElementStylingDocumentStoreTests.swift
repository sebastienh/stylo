//
//  MarkdownEmphasisElementStylingDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-02-22.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

class MarkdownEmphasisElementStylingDocumentStoreTests: MarkdownStylingDocumentStoreTests {

    // *Emphasized text 1*
    func testEmphasis1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "emphasis.md", styleFilename: "emphasis-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 13, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }

    // *Emphasized text 1*
    func testEmphasis1Tag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "emphasis.md", styleFilename: "emphasis-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 12, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // *Emphasized text 1*
    func testEmphasis1Tag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "emphasis.md", styleFilename: "emphasis-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 30, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // _Emphasized text 2_
    func testEmphasis2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "emphasis.md", styleFilename: "emphasis-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 33, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // _Emphasized text 2_
    func testEmphasis2Tag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "emphasis.md", styleFilename: "emphasis-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 32, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // _Emphasized text 2_
    func testEmphasis2Tag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "emphasis.md", styleFilename: "emphasis-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 50, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // **important text**
    func testEmphasis3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "emphasis.md", styleFilename: "emphasis-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 55, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // **important text**
    func testEmphasis3Tag11() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "emphasis.md", styleFilename: "emphasis-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 53, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // **important text**
    func testEmphasis3Tag12() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "emphasis.md", styleFilename: "emphasis-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 54, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // **important text**
    func testEmphasis3Tag21() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "emphasis.md", styleFilename: "emphasis-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 69, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // **important text**
    func testEmphasis3Tag22() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "emphasis.md", styleFilename: "emphasis-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 70, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // __important text__
    func testEmphasis4() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "emphasis.md", styleFilename: "emphasis-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 74, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // __important text__
    func testEmphasis4Tag11() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "emphasis.md", styleFilename: "emphasis-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 72, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // __important text__
    func testEmphasis4Tag12() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "emphasis.md", styleFilename: "emphasis-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 73, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // __important text__
    func testEmphasis4Tag21() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "emphasis.md", styleFilename: "emphasis-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 88, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // __important text__
    func testEmphasis4Tag22() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "emphasis.md", styleFilename: "emphasis-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 89, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
}
