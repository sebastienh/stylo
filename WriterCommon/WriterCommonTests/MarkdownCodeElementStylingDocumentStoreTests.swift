//
//  MarkdownCodeElementStylingDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-02-22.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

/*
``` markdown
# a
```
A line with `code` .

    a
    b
*/
class MarkdownCodeElementStylingDocumentStoreTests: MarkdownStylingDocumentStoreTests {
    
    func testFencedCode1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 13, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }

    func testFencedCode2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 14, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFencedCode3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 15, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFencedCodeTag11() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 0, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFencedCodeTag12() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 1, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFencedCodeTag13() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 2, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFencedCodeParams1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 4, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFencedCodeParams2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 5, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFencedCodeParams3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 6, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFencedCodeParams4() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 7, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFencedCodeParams5() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 8, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFencedCodeParams6() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 9, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFencedCodeParams7() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 10, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFencedCodeParams8() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 11, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFencedCodeTag21() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 17, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFencedCodeTag22() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 18, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testFencedCodeTag23() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 19, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testBeforeInlineCode1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 21, expected: black)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testBeforeInlineCode2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 31, expected: black)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testBeforeInlineCode3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 32, expected: black)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testInlineCode1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 34, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testInlineCode2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 35, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testInlineCode3() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 36, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testInlineCode4() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 37, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    
    func testAfterInlineCode1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 39, expected: black)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testAfterInlineCode2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 40, expected: black)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testInlineCodeTag1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 33, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testInlineCodeTag2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 38, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testIndentedCode1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 47, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func testIndentedCode2() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "code.md", styleFilename: "code-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 53, expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
}
