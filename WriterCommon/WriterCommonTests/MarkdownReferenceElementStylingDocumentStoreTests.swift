//
//  MarkdownReferenceElementStylingDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-02-22.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

class MarkdownReferenceElementStylingDocumentStoreTests: MarkdownStylingDocumentStoreTests {
    
    // [idImage]: http://www.textually.net/stylo/images/logo.png "Logo"
    // -
    func testIndex0() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "reference-styling.md", styleFilename: "reference-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 0, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }

    // [idImage]: http://www.textually.net/stylo/images/logo.png "Logo"
    //  -------
    func testReferenceLabel() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "reference-styling.md", styleFilename: "reference-styling-style.css")
        
        for i in 1..<8 {
        
            let result = WriterCommonTests.validateColor(in: compiledAttributes, at: i, expected: yellow)
            
            switch result {
            case .error(let receivedColor):
                XCTAssert(false, "Received: \(receivedColor)")
            case .success:
                XCTAssert(true)
            }
        }
    }
    
    // [idImage]: http://www.textually.net/stylo/images/logo.png "Logo"
    //         --
    func testReferenceTag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "reference-styling.md", styleFilename: "reference-styling-style.css")
        
        for i in 8..<10 {
            
            let result = WriterCommonTests.validateColor(in: compiledAttributes, at: i, expected: blue)
            
            switch result {
            case .error(let receivedColor):
                XCTAssert(false, "Received: \(receivedColor)")
            case .success:
                XCTAssert(true)
            }
        }
    }
    
    // [idImage]: http://www.textually.net/stylo/images/logo.png "Logo"
    //            ----------------------------------------------
    func testReferenceDestination() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "reference-styling.md", styleFilename: "reference-styling-style.css")
        
        for i in 11..<57 {
            
            let result = WriterCommonTests.validateColor(in: compiledAttributes, at: i, expected: red)
            
            switch result {
            case .error(let receivedColor):
                XCTAssert(false, "Received: \(receivedColor) at: \(i)")
            case .success:
                XCTAssert(true)
            }
        }
    }
    
    // [idImage]: http://www.textually.net/stylo/images/logo.png "Logo"
    //                                                           ------
    func testReferenceTitle() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "reference-styling.md", styleFilename: "reference-styling-style.css")
        
        for i in 58..<64 {
            
            let result = WriterCommonTests.validateColor(in: compiledAttributes, at: i, expected: pink)
            
            switch result {
            case .error(let receivedColor):
                XCTAssert(false, "Received: \(receivedColor)")
            case .success:
                XCTAssert(true)
            }
        }
    }
}
