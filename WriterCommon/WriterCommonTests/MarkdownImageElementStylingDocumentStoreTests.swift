//
//  MarkdownImageElementStylingDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-02-22.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

/*
![text](www.link.com "title")
![text][label]
[label]: a
*/
class MarkdownImageElementStylingDocumentStoreTests: MarkdownStylingDocumentStoreTests {
    
    // ![text](www.link.com "title")
    // -
    func testIndex0() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "image-styling.md", styleFilename: "image-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 0, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }

    // ![text](www.link.com "title")
    //  -
    func testIndex1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "image-styling.md", styleFilename: "image-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 1, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // ![text](www.link.com "title")
    //   -
    func testIndex2To6() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "image-styling.md", styleFilename: "image-styling-style.css")
        
        for i in 2..<6 {
        
            let result = WriterCommonTests.validateColor(in: compiledAttributes, at: i, expected: yellow)
            
            switch result {
            case .error(let receivedColor):
                XCTAssert(false, "Received: \(receivedColor)")
            case .success:
                XCTAssert(true)
        }
        }
    }
    
    // ![text](www.link.com "title")
    //       -
    func testIndex3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "image-styling.md", styleFilename: "image-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 6, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // ![text](www.link.com "title")
    //        -
    func testIndex4() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "image-styling.md", styleFilename: "image-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 7, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // ![text](www.link.com "title")
    //         ------------
    func testIndex8To20() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "image-styling.md", styleFilename: "image-styling-style.css")
        
        for i in 8..<20 {

            let result = WriterCommonTests.validateColor(in: compiledAttributes, at: i, expected: pink)

            switch result {
            case .error(let receivedColor):
                XCTAssert(false, "Received: \(receivedColor)")
            case .success:
                XCTAssert(true)
            }
        }
    }
    
    // ![text](www.link.com "title")
    //                      -------
    func testIndex21To28() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "image-styling.md", styleFilename: "image-styling-style.css")
        
        for i in 21..<28 {
            
            let result = WriterCommonTests.validateColor(in: compiledAttributes, at: i, expected: white)
            
            switch result {
            case .error(let receivedColor):
                XCTAssert(false, "Received: \(receivedColor)")
            case .success:
                XCTAssert(true)
            }
        }
    }
    
    // ![text](www.link.com "title")
    //                             -
    func testIndex28() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "image-styling.md", styleFilename: "image-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 28, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // ![text][label]
    // --
    func testIndex30To32() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "image-styling.md", styleFilename: "image-styling-style.css")
        
        for i in 30..<32 {
            
            let result = WriterCommonTests.validateColor(in: compiledAttributes, at: i, expected: blue)
            
            switch result {
            case .error(let receivedColor):
                XCTAssert(false, "Received: \(receivedColor)")
            case .success:
                XCTAssert(true)
            }
        }
    }
    
    // ![text][label]
    //   ----
    func testIndex32To36() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "image-styling.md", styleFilename: "image-styling-style.css")
        
        for i in 32..<36 {
            
            let result = WriterCommonTests.validateColor(in: compiledAttributes, at: i, expected: yellow)
            
            switch result {
            case .error(let receivedColor):
                XCTAssert(false, "Received: \(receivedColor)")
            case .success:
                XCTAssert(true)
            }
        }
    }
    
    // ![text][label]
    //       -
    func testIndex36() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "image-styling.md", styleFilename: "image-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 28, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // ![text][label]
    //        -
    func testIndex37() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "image-styling.md", styleFilename: "image-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 37, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // ![text][label]
    //         -----
    func testIndex38To43() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "image-styling.md", styleFilename: "image-styling-style.css")
        
        for i in 38..<43 {
            
            let result = WriterCommonTests.validateColor(in: compiledAttributes, at: i, expected: green)
            
            switch result {
            case .error(let receivedColor):
                print("Received: \(receivedColor) at index: \(i)")
                XCTAssert(false, "Received: \(receivedColor) at index: \(i)")
            case .success:
                XCTAssert(true)
            }
        }
    }
    
    // ![text][label]
    //              -
    func testIndex43() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "image-styling.md", styleFilename: "image-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 43, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
}
