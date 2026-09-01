//
//  FlashOnInsertionsTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-07-25.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest

@testable import WriterCommon
import Web
import Common
import Igloo


class FocusTests: MarkdownRendererTests {
    
    let markdownString: String = {
        
        var value: String = "" +
            "\n" +
            "p **n** " +
        "\n"
        
        for i in 0..<100 {
            value += "\n\n"
            value += "p"
        }
        return value
    }()
    
    let styleString = """
        body {
            color: black;
        }

        strong {
            color: green;
        }

        strong::tag {
            color: blue;
        }

        :flash {
            color: purple;
        }

        strong:flash {
            color: pink;
        }

        strong::tag:flash {
            color: red;
        }

     """
    
    func testRenderingStringTagInFlashMode() throws {
        
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
        
        //        1: p
        WriterCommonTests.validateColor(in: attr, index: 1, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: *
        WriterCommonTests.validateColor(in: attr, index: 3, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: *
        WriterCommonTests.validateColor(in: attr, index: 4, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: n
        WriterCommonTests.validateColor(in: attr, index: 5, color: green) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: *
        WriterCommonTests.validateColor(in: attr, index: 6, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        7: *
        WriterCommonTests.validateColor(in: attr, index: 7, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        let flashRange = NSMakeRange(1, 7)
        
        let actionResult: ActionResult = dispatcher.sync(store: markdownDocumentStore, action: DocumentStoreAction.topElementsAroundRange(range: flashRange).syncAction)!
        
        let documentStoreActionResult: DocumentStoreActionResult = actionResult as! DocumentStoreActionResult
        
        let document = markdownDocumentStore.document.value!
        
        let topElementsAroundRange: ContiguousArray<Element> = documentStoreActionResult.topElementsAroundRange!
        let applyFlashAction = StylableStoreAction.flash(topElements: topElementsAroundRange, range: flashRange, document: document)
        
        let result: ActionResult? = dispatcher.sync(store: markdownStyleStore, action: applyFlashAction.syncAction)
        
        XCTAssert(result != nil)
        let applyFlashResult: StylableActionResult? = result as? StylableActionResult
        
        XCTAssert(applyFlashResult != nil)
        
        guard let attributes: [RenderingProcessingResult.AttributeAction: [AttributesRange]] = applyFlashResult?.attributes else {
            XCTAssert(false)
            return
        }
        
        let localTextStorage = NSTextStorage(string: self.markdownString)
        localTextStorage.applyAttributes(attributes)
        
        //        1: p
        WriterCommonTests.validateColor(in: localTextStorage, index: 1, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: *
        WriterCommonTests.validateColor(in: localTextStorage, index: 3, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: *
        WriterCommonTests.validateColor(in: localTextStorage, index: 4, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: n
        WriterCommonTests.validateColor(in: localTextStorage, index: 5, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: *
        WriterCommonTests.validateColor(in: localTextStorage, index: 6, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        7: *
        WriterCommonTests.validateColor(in: localTextStorage, index: 7, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
    }
    
    func testRenderingStringTagTwoInsertionsAfterStrong() throws {
        
        var markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        
        let visibleRange1 = NSMakeRange(0, markdownString.utf16.count+1)
        
        markdownContext.applyChange(range: NSMakeRange(9, 0), insertedString: "p", visibleRange: visibleRange1)
        
        //        body {
        //            color: black;
        //        }
        //
        //        strong {
        //            color: green;
        //        }
        //
        //        strong::tag {
        //            color: blue;
        //        }
        
        //        1: p
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 1, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: *
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 3, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: *
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 4, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: n
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 5, color: green) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: *
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 6, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        7: *
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 7, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        print(markdownContext.attributedString)
        
        
        //        9: p
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 9, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        let visibleRange2 = NSMakeRange(0, markdownString.utf16.count+1)
        
        markdownContext.applyChange(range: NSMakeRange(10, 0), insertedString: "p", visibleRange: visibleRange2)
        
        //        1: p
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 1, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: *
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 3, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: *
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 4, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: n
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 5, color: green) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: *
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 6, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        7: *
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 7, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        9: p
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 9, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        10: p
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 10, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
    
    
    func testRenderingStringTagTwoInsertionsBeforeStrong() throws {
        
        var markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        
        let visibleRange1 = NSMakeRange(0, markdownString.utf16.count+1)
        
        markdownContext.applyChange(range: NSMakeRange(2, 0), insertedString: "p", visibleRange: visibleRange1)
        
        //        1: p
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 1, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        2: p
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 2, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: *
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 4, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: *
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 5, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: n
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 6, color: green) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        7: *
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 7, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        8: *
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 8, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        let visibleRange2 = NSMakeRange(0, markdownString.utf16.count+1)
        markdownContext.applyChange(range: NSMakeRange(3, 0), insertedString: "p", visibleRange: visibleRange2)
        
        //        1: p
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 1, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        2: p
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 2, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: p
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 3, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: *
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 5, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: *
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 6, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        7: n
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 7, color: green) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        8: *
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 8, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        9: *
        WriterCommonTests.validateColor(in: markdownContext.attributedString, index: 9, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
    
    func testRenderingStringTagInBlocFocusModeTwoInsertionsAfterStrong() throws {
        
        let styleString = """
            body {
                color: black;
            }

            strong {
                color: green;
            }

            strong::tag {
                color: blue;
            }

            :focus {
                color: purple;
            }

            strong:focus {
                color: pink;
            }

            strong::tag:focus {
                color: red;
            }

         """
        
        var markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        markdownContext.setFocusMode(focusMode: FocusMode.enabled(focusType: .bloc))
        let visibleRange1 = NSMakeRange(0, markdownString.utf16.count+1)
        markdownContext.applyChange(range: NSMakeRange(9, 0), insertedString: "p", visibleRange: visibleRange1)
        
        //        1: p
        validateFocusColor(in: markdownContext, index: 1, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: *
        validateFocusColor(in: markdownContext, index: 3, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: *
        validateFocusColor(in: markdownContext, index: 4, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: n
        validateFocusColor(in: markdownContext, index: 5, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: *
        validateFocusColor(in: markdownContext, index: 6, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        7: *
        validateFocusColor(in: markdownContext, index: 7, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        9: p
        validateFocusColor(in: markdownContext, index: 9, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        let visibleRange2 = NSMakeRange(0, markdownString.utf16.count+1)
        markdownContext.applyChange(range: NSMakeRange(10, 0), insertedString: "p", visibleRange: visibleRange2)
        
        //        1: p
        validateFocusColor(in: markdownContext, index: 1, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: *
        validateFocusColor(in: markdownContext, index: 3, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: *
        validateFocusColor(in: markdownContext, index: 4, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: n
        validateFocusColor(in: markdownContext, index: 5, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: *
        validateFocusColor(in: markdownContext, index: 6, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        7: *
        validateFocusColor(in: markdownContext, index: 7, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        9: p
        validateFocusColor(in: markdownContext, index: 9, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        10: p
        validateFocusColor(in: markdownContext, index: 10, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
    
    
    func testRenderingStringTagInParagraphFocusModeTwoInsertionsBeforeStrong() throws {
        
        let styleString = """
            body {
                color: black;
            }

            strong {
                color: green;
            }

            strong::tag {
                color: blue;
            }

            :focus {
                color: purple;
            }

            strong:focus {
                color: pink;
            }

            strong::tag:focus {
                color: red;
            }

         """
        
        var markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        
        markdownContext.setFocusMode(focusMode: FocusMode.enabled(focusType: .paragraph))
        let visibleRange1 = NSMakeRange(0, markdownString.utf16.count+1)
        markdownContext.applyChange(range: NSMakeRange(2, 0), insertedString: "p", visibleRange: visibleRange1)
        
        //        1: p
        validateFocusColor(in: markdownContext, index: 1, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        2: p
        validateFocusColor(in: markdownContext, index: 2, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: *
        validateFocusColor(in: markdownContext, index: 4, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: *
        validateFocusColor(in: markdownContext, index: 5, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: n
        validateFocusColor(in: markdownContext, index: 6, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        7: *
        validateFocusColor(in: markdownContext, index: 7, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        8: *
        validateFocusColor(in: markdownContext, index: 8, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        let visibleRange2 = NSMakeRange(0, markdownString.utf16.count+1)
        markdownContext.applyChange(range: NSMakeRange(3, 0), insertedString: "p", visibleRange: visibleRange2)
        
        //        1: p
        validateFocusColor(in: markdownContext, index: 1, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        2: p
        validateFocusColor(in: markdownContext, index: 2, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: p
        validateFocusColor(in: markdownContext, index: 3, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: *
        validateFocusColor(in: markdownContext, index: 5, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: *
        validateFocusColor(in: markdownContext, index: 6, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        7: n
        validateFocusColor(in: markdownContext, index: 7, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        8: *
        validateFocusColor(in: markdownContext, index: 8, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        9: *
        validateFocusColor(in: markdownContext, index: 9, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
    
    func testImgLinkFocusInSentenceFocusMode() {
        
        let markdownString: String = {
            
            var value: String = "p\n\n" +
                "![t](l)\n\n" +
            "d\n"
            
            for i in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        let styleString = """
            body {
                color: black;
            }
            :focus {
                color: pink;
            }
         """
        
        
        markdownString.printCharactersIndexes()
        
        var markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        
        markdownContext.setFocusMode(focusMode: FocusMode.enabled(focusType: .sentence))
        let visibleRange = NSMakeRange(0, markdownString.utf16.count+1)
        markdownContext.applySelectionChange(selectionRange: NSMakeRange(6, 0), visibleRange: visibleRange)
        
        // 0: p
        validateFocusColor(in: markdownContext, index: 0, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 3: !
        validateFocusColor(in: markdownContext, index: 3, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 4: [
        validateFocusColor(in: markdownContext, index: 4, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 5: t
        validateFocusColor(in: markdownContext, index: 5, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 6: ]
        validateFocusColor(in: markdownContext, index: 6, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 7: (
        validateFocusColor(in: markdownContext, index: 7, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 8: l
        validateFocusColor(in: markdownContext, index: 8, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 9: )
        validateFocusColor(in: markdownContext, index: 9, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 12: d
        validateFocusColor(in: markdownContext, index: 12, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 16: p
        validateFocusColor(in: markdownContext, index: 16, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
    
    func testImgLinkFocusInSentenceFocusMode2() {
        
        let markdownString: String = {
            
            var value: String = "p\n\n" +
                "![test](www.link.com)\n\n" +
            "d\n"
            
            for i in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        let styleString = """
             body {
                 color: black;
             }
             :focus {
                 color: pink;
             }
          """
        
        
        markdownString.printCharactersIndexes()
        
        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        
        markdownContext.setFocusMode(focusMode: FocusMode.enabled(focusType: .sentence))
        let visibleRange = NSMakeRange(0, markdownString.utf16.count+1)
        markdownContext.applySelectionChange(selectionRange: NSMakeRange(12, 0), visibleRange: visibleRange)
        
        // 0: p
        validateFocusColor(in: markdownContext, index: 0, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 3: !
        validateFocusColor(in: markdownContext, index: 3, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 4: [
        validateFocusColor(in: markdownContext, index: 4, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 5: t
        validateFocusColor(in: markdownContext, index: 5, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 6: ]
        validateFocusColor(in: markdownContext, index: 6, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 7: (
        validateFocusColor(in: markdownContext, index: 7, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 8: l
        validateFocusColor(in: markdownContext, index: 8, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 9: )
        validateFocusColor(in: markdownContext, index: 9, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
    
    func testTagFocusOnlyAppliesToTag() {
        
        let markdownString: String = {
            
            var value: String = "p\n\n" +
                "# sss\n\n" +
            "d\n"
            
            for i in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        let styleString = """
             body {
                 color: black;
             }
             h1::tag:focus {
                 color: pink;
             }
          """
        
        
        markdownString.printCharactersIndexes()
        
        var markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        
        markdownContext.setFocusMode(focusMode: FocusMode.enabled(focusType: .sentence))
        let visibleRange = NSMakeRange(0, markdownString.utf16.count+1)
        markdownContext.applySelectionChange(selectionRange: NSMakeRange(6, 0), visibleRange: visibleRange)
        
        // 0: p
        validateFocusColor(in: markdownContext, index: 0, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 3: #
        validateFocusColor(in: markdownContext, index: 3, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 5: s
        validateFocusColor(in: markdownContext, index: 5, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 6: s
        validateFocusColor(in: markdownContext, index: 6, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 7: s
        validateFocusColor(in: markdownContext, index: 7, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 10: (
        validateFocusColor(in: markdownContext, index: 10, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
    }
    
    func testSentenceFocusInsideParagraph() {
        
        let markdownString: String = {
            
            var value: String = "a\n\n" +
                "{.test}\n" + 
                "B **c**. D **ee**\n\n" +
            "F\n"
            
            for i in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        let styleString = """
              body {
                  color: black;
              }
              :focus {
                  color: red;
              }

              :fade {
                  color: pink;
              }
           """
        
        
        markdownString.printCharactersIndexes()
        
        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        
        markdownContext.setFocusMode(focusMode: FocusMode.enabled(focusType: .sentence))
        let visibleRange = NSMakeRange(0, markdownString.utf16.count+1)
        markdownContext.applySelectionChange(selectionRange: NSMakeRange(17, 0), visibleRange: visibleRange)
        
        //        0: a
        validateFocusColor(in: markdownContext, index: 0, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
                
        //        3: {
        validateFocusColor(in: markdownContext, index: 3, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
                
        //        4: .
        validateFocusColor(in: markdownContext, index: 4, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
                
        //        5: t
        validateFocusColor(in: markdownContext, index: 5, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
                
        //        6: e
        validateFocusColor(in: markdownContext, index: 6, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
                
        //        7: s
        validateFocusColor(in: markdownContext, index: 7, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
                
        //        8: t
        validateFocusColor(in: markdownContext, index: 8, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
                
        //        9: }
        validateFocusColor(in: markdownContext, index: 9, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
                
        //        11: B
        validateFocusColor(in: markdownContext, index: 11, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
                
        //        13: *
        validateFocusColor(in: markdownContext, index: 13, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
                
        //        14: *
        validateFocusColor(in: markdownContext, index: 14, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
                
        //        15: c
        validateFocusColor(in: markdownContext, index: 15, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
                
        //        16: *
        validateFocusColor(in: markdownContext, index: 16, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
                
        //        17: *
        validateFocusColor(in: markdownContext, index: 17, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
                
        //        18: .
        validateFocusColor(in: markdownContext, index: 18, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        20: D
        validateFocusColor(in: markdownContext, index: 20, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        //        22: *
        validateFocusColor(in: markdownContext, index: 22, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        23: *
        validateFocusColor(in: markdownContext, index: 23, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        24: e
        validateFocusColor(in: markdownContext, index: 24, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        25: e
        validateFocusColor(in: markdownContext, index: 25, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        26: *
        validateFocusColor(in: markdownContext, index: 26, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        27: *
        validateFocusColor(in: markdownContext, index: 27, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        30: F
        validateFocusColor(in: markdownContext, index: 30, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        34: p
        validateFocusColor(in: markdownContext, index: 34, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
    
    
    
}
