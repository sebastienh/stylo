//
//  MarkdownLinkElementStylingWithClassDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-05-03.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

/*
 [text](www.link.com "title")
 [text][label]
 
 [label]: a
 */
class MarkdownLinkElementStylingWithClassDocumentStoreTests: MarkdownStylingDocumentStoreTests {

    // [text](www.link.com "title")
    // -
    func testLinkTag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 0, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text](www.link.com "title")
    //  -
    func testLinkText1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 1, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text](www.link.com "title")
    //   -
    func testLinkText2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 2, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text](www.link.com "title")
    //    -
    func testLinkText3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 3, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text](www.link.com "title")
    //     -
    func testLinkText4() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 4, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text](www.link.com "title")
    //      -
    func testLinkTag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 5, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text](www.link.com "title")
    //       -
    func testLinkTag3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 6, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text](www.link.com "title")
    //        -
    func testLinkDestination1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 7, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text](www.link.com "title")
    //         -
    func testLinkDestination2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 8, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text](www.link.com "title")
    //          -
    func testLinkDestination3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 9, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text](www.link.com "title")
    //           -
    func testLinkDestination4() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 10, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text](www.link.com "title")
    //                   -
    func testIndex18() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 18, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text](www.link.com "title")
    //                     -
    func testIndex20() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 20, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text](www.link.com "title")
    //                      -
    func testIndex21() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 21, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text](www.link.com "title")
    //                       -
    func testIndex22() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 22, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text](www.link.com "title")
    //                           -
    func testIndex26() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 26, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text](www.link.com "title")
    //                            -
    func testLinkTag4() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 27, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text][label]
    // -
    func testIndex29() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 29, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text][label]
    //  -
    func testIndex30() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 30, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text][label]
    //   -
    func testIndex31() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 31, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text][label]
    //    -
    func testIndex32() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 32, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text][label]
    //     -
    func testIndex33() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 33, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text][label]
    //      -
    func testIndex34() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 34, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text][label]
    //       -
    func testIndex35() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 35, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // [text][label]
    //        -
    func testIndex36To41() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        for i in 36..<41 {
            
            let result = WriterCommonTests.validateColor(in: compiledAttributes, at: i, expected: blue)
            
            switch result {
            case .error(let receivedColor):
                XCTAssert(false, "Received: \(receivedColor)")
            case .success:
                XCTAssert(true)
            }
        }
    }
    
    // [text][label]
    //             -
    func testIndex41() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "link-styling.md", styleFilename: "link-style-with-class-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 41, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
}
