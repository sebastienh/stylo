//
//  FlashOnStrongTagEphemeralPseudoClassesTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-07-24.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest

@testable import WriterCommon
import Web
import Common
import Igloo

class FlashOnStrongTagEphemeralPseudoClassesTests: MarkdownRendererTests {
    
    let markdownString = "\n" +
        "{.t}\n" +
    "> F **n** E\n"
    
    func testRenderingString() throws {
        
        let styleString = """
            body {
                color: black;
            }

            .t {
                color: yellow;
            }

            .t strong::tag, .t emphasis::tag {
                color: red;
            }

            blockquote::tag {
                color: pink;
            }

        """
        
        let indexedCharacters = markdownString.indexedCharacters
        
        let indexedCharactersString = indexedCharacters.map { (arg) -> String in
            return "\(arg.key): \(arg.value)\n"
        }
        for indexedCharacterString in indexedCharactersString {
            print("\(indexedCharacterString)")
        }
        
        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        let dispatcher = markdownContext.dispatcher
        let markdownDocumentStore = markdownContext.markdownDocumentStore
        let markdownStyleStore = markdownContext.markdownStyleStore
        
        print(HTMLSerializer.createDefault().serializeHTMLFragment(markdownDocumentStore.document.value!))
        let attr = markdownStyleStore.attributesStore.attributedString
        
        
        //        1: {
        WriterCommonTests.validateColor(in: attr, index: 1, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        2: .
        WriterCommonTests.validateColor(in: attr, index: 2, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: t
        WriterCommonTests.validateColor(in: attr, index: 3, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: }
        WriterCommonTests.validateColor(in: attr, index: 4, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: >
        WriterCommonTests.validateColor(in: attr, index: 6, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        8: F
        WriterCommonTests.validateColor(in: attr, index: 8, color: yellow) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        10: *
        WriterCommonTests.validateColor(in: attr, index: 10, color: red) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        11: *
        WriterCommonTests.validateColor(in: attr, index: 11, color: red) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        12: n
        WriterCommonTests.validateColor(in: attr, index: 12, color: yellow) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        13: *
        WriterCommonTests.validateColor(in: attr, index: 13, color: red) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        14: *
        WriterCommonTests.validateColor(in: attr, index: 14, color: red) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        16: E
        WriterCommonTests.validateColor(in: attr, index: 16, color: yellow) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        let flashRange = NSMakeRange(6, 11)
        
        let actionResult: ActionResult = dispatcher.sync(store: markdownDocumentStore, action: DocumentStoreAction.topElementsAroundRange(range: flashRange).syncAction)!
        
        let documentStoreActionResult: DocumentStoreActionResult = actionResult as! DocumentStoreActionResult
        let document = markdownDocumentStore.document.value!
        let topElementsAroundRange: ContiguousArray<Element> = documentStoreActionResult.topElementsAroundRange!
        let flashAction = StylableStoreAction.flash(topElements: topElementsAroundRange, range: flashRange, document: document)
        
        let result: ActionResult? = dispatcher.sync(store: markdownStyleStore, action: flashAction.syncAction)
        
        XCTAssert(result != nil)
        let flashResult: StylableActionResult? = result as? StylableActionResult
        
        XCTAssert(flashResult != nil)
        
        let attributes: [RenderingProcessingResult.AttributeAction: [AttributesRange]]? = flashResult?.attributes
        
        XCTAssert(attributes != nil)
        if let attributes = attributes {
            XCTAssert(!attributes.isEmpty)
        }
    }
    
    
    func testRenderingStringTagInFlashMode() throws {
        
        let styleString = """
            body {
                color: black;
            }

            .t {
                color: yellow;
            }

            .t strong::tag, .t emphasis::tag {
                color: green;
            }

            blockquote::tag {
                color: pink;
            }

            .t + p strong::tag {
                color: red;
            }

            blockquote.t::tag {
                color: pink;
            }

            :flash {
                color: purple;
            }

            :flash strong::tag, :flash emphasis::tag {
                color: blue;
            }

            blockquote::tag:flash {
                color: red;
            }

        """
        
        let indexedCharacters = markdownString.indexedCharacters
        
        let indexedCharactersString = indexedCharacters.map { (arg) -> String in
            return "\(arg.key): \(arg.value)\n"
        }
        for indexedCharacterString in indexedCharactersString {
            print("\(indexedCharacterString)")
        }
        
        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        let dispatcher = markdownContext.dispatcher
        let markdownDocumentStore = markdownContext.markdownDocumentStore
        let markdownStyleStore = markdownContext.markdownStyleStore
        
        print(HTMLSerializer.createDefault().serializeHTMLFragment(markdownDocumentStore.document.value!))
        
        let attr = markdownStyleStore.attributesStore.attributedString
        
        
        //        1: {
        WriterCommonTests.validateColor(in: attr, index: 1, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        2: .
        WriterCommonTests.validateColor(in: attr, index: 2, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: t
        WriterCommonTests.validateColor(in: attr, index: 3, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: }
        WriterCommonTests.validateColor(in: attr, index: 4, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: >
        WriterCommonTests.validateColor(in: attr, index: 6, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        8: F
        WriterCommonTests.validateColor(in: attr, index: 8, color: yellow) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        10: *
        WriterCommonTests.validateColor(in: attr, index: 10, color: green) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        11: *
        WriterCommonTests.validateColor(in: attr, index: 11, color: green) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        12: n
        WriterCommonTests.validateColor(in: attr, index: 12, color: yellow) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        13: *
        WriterCommonTests.validateColor(in: attr, index: 13, color: green) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        14: *
        WriterCommonTests.validateColor(in: attr, index: 14, color: green) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        16: E
        WriterCommonTests.validateColor(in: attr, index: 16, color: yellow) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        
        let flashRange = NSMakeRange(6, 12)
        
        let actionResult: ActionResult = dispatcher.sync(store: markdownDocumentStore, action: DocumentStoreAction.topElementsAroundRange(range: flashRange).syncAction)!
        
        let documentStoreActionResult: DocumentStoreActionResult = actionResult as! DocumentStoreActionResult
        let document = markdownDocumentStore.document.value!
        let topElementsAroundRange: ContiguousArray<Element> = documentStoreActionResult.topElementsAroundRange!
        let flashAction = StylableStoreAction.flash(topElements: topElementsAroundRange, range: flashRange, document: document)
        
        let result: ActionResult? = dispatcher.sync(store: markdownStyleStore, action: flashAction.syncAction)
        
        XCTAssert(result != nil)
        let flashResult: StylableActionResult? = result as? StylableActionResult
        
        XCTAssert(flashResult != nil)
        
        guard let attributes: [RenderingProcessingResult.AttributeAction: [AttributesRange]] = flashResult?.attributes else {
            XCTAssert(false)
            return
        }

        let localTextStorage = NSTextStorage(string: self.markdownString)
        localTextStorage.applyAttributes(attributes)
        
        //        1: {
        WriterCommonTests.validateColor(in: localTextStorage, index: 1, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        2: .
        WriterCommonTests.validateColor(in: localTextStorage, index: 2, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: t
        WriterCommonTests.validateColor(in: localTextStorage, index: 3, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: }
        WriterCommonTests.validateColor(in: localTextStorage, index: 4, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: >
        WriterCommonTests.validateColor(in: localTextStorage, index: 6, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        8: F
        WriterCommonTests.validateColor(in: localTextStorage, index: 8, color: purple) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        10: *
        WriterCommonTests.validateColor(in: localTextStorage, index: 10, color: blue) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        11: *
        WriterCommonTests.validateColor(in: localTextStorage, index: 11, color: blue) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        12: n
        WriterCommonTests.validateColor(in: localTextStorage, index: 12, color: purple) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        13: *
        WriterCommonTests.validateColor(in: localTextStorage, index: 13, color: blue) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        14: *
        WriterCommonTests.validateColor(in: localTextStorage, index: 14, color: blue) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
        //        16: E
        WriterCommonTests.validateColor(in: localTextStorage, index: 16, color: purple) { (expected, received, index) in
            XCTAssert(false, "Expected: \(expected), received: \(received) at index: \(index)")
        }
        
    }
    
 
    
    
}
