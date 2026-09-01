//
//  MarkdownListsElementStylingTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-02-21.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

class MarkdownListsElementStylingTests: MarkdownStylingDocumentStoreTests {

    
    //    * a
    //    * b
    //    * c
    func testFirstUnorderedListFirstItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 27, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }

    func testFirstUnorderedListFirstItemTag() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 25, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFirstUnorderedListSecondItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 31, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFirstUnorderedListSecondItemTag() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 29, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFirstUnorderedListThirdItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 35, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFirstUnorderedListThirdItemTag() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 33, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    //    - d
    //    - e
    //    - f
    func testSecondUnorderedListFirstItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 40, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testSecondUnorderedListFirstItemTag() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 38, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testSecondUnorderedListSecondItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 44, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testSecondUnorderedListSecondItemTag() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 42, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testSecondUnorderedListThirdItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 48, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testSecondUnorderedListThirdItemTag() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 46, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    //    + g
    //    + h
    //    + i
    func testThirdUnorderedListFirstItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 53, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testThirdUnorderedListFirstItemTag() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 51, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testThirdUnorderedListSecondItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 57, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testThirdUnorderedListSecondItemTag() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 55, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testThirdUnorderedListThirdItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 61, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testThirdUnorderedListThirdItemTag() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 59, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    //    - i
    //    - j
    func testFourthUnorderedListFirstItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 66, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFourthUnorderedListFirstItemTag() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 64, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFourthUnorderedListSecondItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 70, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFourthUnorderedListSecondItemTag() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 68, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    //    - s
    //    - t
    func testFifthUnorderedListFirstItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 142, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFifthUnorderedListFirstItemTag() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 140, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFifthUnorderedListSecondItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 146, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }

    func testFifthUnorderedListSecondItemTag() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 144, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    //    1. k
    //    2. l
    func testFirstOrderedListFirstItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 75, expected: green)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFirstOrderedListFirstItemTag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 73, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFirstOrderedListFirstItemTag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 72, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFirstOrderedListSecondItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 80, expected: green)
        
        let character = compiledAttributes.string.charAt(80)!
        
        print("\(String(utf16CodeUnits: [character], count: 1))")
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFirstOrderedListSecondItemTag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 77, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    
    func testFirstOrderedListSecondItemTag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 78, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    //    1. m
    //    2. n
    //    3. o
    func testSecondOrderedListFirstItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 99, expected: green)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testSecondOrderedListFirstItemTag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 97, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testSecondOrderedListFirstItemTag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 96, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testSecondOrderedListSecondItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 104, expected: green)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testSecondOrderedListSecondItemTag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 102, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testSecondOrderedListSecondItemTag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 101, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testSecondOrderedListThirdItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 109, expected: green)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testSecondOrderedListThirdItemTag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 107, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testSecondOrderedListThirdItemTag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 106, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    //    1) 1
    //    2) 2
    //    3) 3
    func testThirdOrderedListFirstItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 115, expected: green)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testThirdOrderedListFirstItemTag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 113, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testThirdOrderedListFirstItemTag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 112, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testThirdOrderedListSecondItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 120, expected: green)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testThirdOrderedListSecondItemTag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 118, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testThirdOrderedListSecondItemTag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 117, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testThirdOrderedListThirdItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 125, expected: green)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testThirdOrderedListThirdItemTag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 123, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testThirdOrderedListThirdItemTag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 122, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    //    1. u
    //    2. v
    func testNestedOrderedListFirstItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 153, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testNestedOrderedListFirstItemTag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 151, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testNestedOrderedListFirstItemTag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 150, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testNestedOrderedListSecondItem() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 160, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testNestedOrderedListSecondItemTag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 158, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testNestedOrderedListSecondItemTag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "lists.md", styleFilename: "list-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 157, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
}
