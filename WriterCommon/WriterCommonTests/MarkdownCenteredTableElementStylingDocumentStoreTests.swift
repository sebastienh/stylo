//
//  MarkdownTableElementStylingDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-02-22.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
/*
| 1 | 2 |
| - |--|
| ab  | cd
| ef | gh |
ij | kl
|mn|op|
|q| r s |
*/
class MarkdownCenteredTableElementStylingDocumentStoreTests: MarkdownStylingDocumentStoreTests {
    
    // | 1 | 2 |
    func testTableTag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 0, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | 1 | 2 |
    func testTableHeadContent1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 2, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }

    // | 1 | 2 |
    func testTableTag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 4, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | 1 | 2 |
    func testTableHeadContent2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 6, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | - |--|
    func testTableSeparatorTag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 10, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | - |--|
    func testTableSeparatorContent1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 12, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | - |--|
    func testTableSeparatorTag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 14, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | - |--|
    func testTableSeparatorContent2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 15, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | - |--|
    func testTableSeparatorContent3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 16, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | - |--|
    func testTableSeparatorTag3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 17, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | ab  | cd
    func testTableBody1Tag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 19, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | ab  | cd
    func testTableBody1Content1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 21, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | ab  | cd
    func testTableBody1Content2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 22, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | ab  | cd
    func testTableBody1Tag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 25, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | ab  | cd
    func testTableBody1Content3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 27, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | ab  | cd
    func testTableBody1Content4() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 28, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | ef | gh |
    func testTableBody2Tag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 30, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | ef | gh |
    func testTableBody2Content1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 32, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | ef | gh |
    func testTableBody2Content2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 33, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | ef | gh |
    //      -
    func testTableBody2Tag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 35, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | ef | gh |
    //        -
    func testTableBody2Content3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 37, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | ef | gh |
    //         -
    func testTableBody2Content4() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 38, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // | ef | gh |
    //           -
    func testTableBody2Tag3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 40, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // ij | kl
    // -
    func testTableBody3Content1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 42, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // ij | kl
    //  -
    func testTableBody3Content2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 43, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // ij | kl
    //    -
    func testTableBody3Tag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 45, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // ij | kl
    //      -
    func testTableBody3Content3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 47, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // ij | kl
    //       -
    func testTableBody3Content4() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 48, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // |mn|op|
    // -
    func testTableBody4Tag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 50, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // |mn|op|
    //  -
    func testTableBody4Content1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 51, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // |mn|op|
    //   -
    func testTableBody4Content2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 52, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // |mn|op|
    //    -
    func testTableBody4Tag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 53, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // |mn|op|
    //     -
    func testTableBody4Content3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 54, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // |mn|op|
    //      -
    func testTableBody4Content4() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 55, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // |mn|op|
    //       -
    func testTableBody4Tag3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 56, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // |q| r s |
    // -
    func testTableBody5Tag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 58, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // |q| r s |
    //  -
    func testTableBody5Content1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 59, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // |q| r s |
    //   -
    func testTableBody5Tag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 60, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // |q| r s |
    //     -
    func testTableBody5Content2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 62, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // |q| r s |
    //       -
    func testTableBody5Content3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 64, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    // |q| r s |
    //         -
    func testTableBody5Tag3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "centered-table.md", styleFilename: "table-styling-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 66, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
}
