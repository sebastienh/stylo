//
//  MarkdownAttributesBlocElementStylingTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-05-04.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Web

class MarkdownAttributesBlocElementStylingTests: MarkdownStylingDocumentStoreTests {
    
    //    {.lu}
    //    U **l**{.lu}
    //
    //    C **e**{.lu}
    func testFirstAttributes() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "attributes-bloc.md", styleFilename: "attributes-bloc-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, over: [0,1,2,3,4] , expected: black)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    //    {.lu}
    //    U **l**{.lu}
    //
    //    C **e**{.lu}
    func testFirstParagraph1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "attributes-bloc.md", styleFilename: "attributes-bloc-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, over: [6,8,9,10,11,12,13,14,15,16,17], expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    //{.lu}
    //U **l**{.lu}
    //
    //C **e**{.lu}
    func testSecondParagraph1() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "attributes-bloc.md", styleFilename: "attributes-bloc-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 20, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    //{.lu}
    //U **l**{.lu}
    //
    //C **e**{.lu}
    func testSecondParagraphBold() {
        
        let (markdownDocumentStore, markdownStyleStore) = computeAttributesInMarkdownStyleStore(markdownFileName: "attributes-bloc.md", styleFilename: "attributes-bloc-style.css")
        
        let htmlDocument = markdownDocumentStore.document.value as! HtmlDocument
        
        let uP = htmlDocument.getElementsByTagName("p").elements.first
        let cP = htmlDocument.getElementsByTagName("p").elements.last
        
        XCTAssert(uP?.textValue?.starts(with: "U") == true, "Received: \(uP?.textValue)")
        XCTAssert(cP?.textValue?.starts(with: "C") == true, "Received: \(cP?.textValue)")
        
        XCTAssert(uP?.classList.contains("lu") == true)
        XCTAssert(cP?.classList.isEmpty == true)
        
        let strongL = htmlDocument.getElementsByTagName("strong").elements.first
        let strongE = htmlDocument.getElementsByTagName("strong").elements.last
        
        XCTAssert(strongL?.textValue?.starts(with: "l") == true, "Received: \(strongL?.textValue)")
        XCTAssert(strongE?.textValue?.starts(with: "e") == true, "Received: \(strongE?.textValue)")
        
        XCTAssert(strongL?.classList.contains("lu") == true)
        XCTAssert(strongE?.classList.contains("lu") == true)
        
        let compiledAttributes = markdownStyleStore.attributesStore.attributedString
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, over: [22,23,24,25,26], expected: red)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    
    //
    // > {.blue}
    // > p **s**
    func testInline() {
        
        let (markdownDocumentStore, markdownStyleStore) = computeAttributesInMarkdownStyleStore(markdownFileName: "attributes-bloc-2.md", styleFilename: "attributes-bloc-2-style.css")
        
        let htmlDocument = markdownDocumentStore.document.value as! HtmlDocument
        
        guard let p = htmlDocument.getElementsByTagName("p").elements.first else {
            XCTAssert(false, "p is nil")
            return
        }
        
        guard let pTextValue = p.textValue else {
            XCTAssert(false, "pTextValue is nil")
            return
        }
        
        XCTAssert(pTextValue.starts(with: "p") == true, "Received: \(pTextValue)")
        
        XCTAssert(p.classList.contains("blue") == true)
        
        let strong = htmlDocument.getElementsByTagName("strong").elements.first
        
        XCTAssert(strong?.textValue?.starts(with: "s") == true, "Received: \(strong?.textValue)")
        
        XCTAssert(strong?.classList.isEmpty == true)
        
        let compiledAttributes = markdownStyleStore.attributesStore.attributedString
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, over: [13], expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    
    //{.lu}
    //U **l**{.lu}
    //
    //C **e**{.lu}
    func testSecondParagraphAttributes() {
        
        let compiledAttributes = computeAttributes(markdownFileName: "attributes-bloc.md", styleFilename: "attributes-bloc-style.css")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, over: [27,28,29,30,31], expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
}
