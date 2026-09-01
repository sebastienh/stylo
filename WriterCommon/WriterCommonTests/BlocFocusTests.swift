//
//  BlocFocusTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-07-27.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest

@testable import WriterCommon
import Web
import Common
import Igloo

class BlocFocusTests: MarkdownRendererTests {

    let markdownString: String = {

        var value: String = "d" +
            "\n" +
            "p **n**. 1 2 3. 1 2 3. " +
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

        :fade {
            color: yellow;
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

    
    func testNoFocusOnEmptySelection() throws {

        let indexedCharacters = markdownString.indexedCharacters

        let indexedCharactersString = indexedCharacters.map { (arg) -> String in
            return "\(arg.key): \(arg.value)\n"
        }
        for indexedCharacterString in indexedCharactersString {
            print("\(indexedCharacterString)")
        }

        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)

        print(HTMLSerializer.createDefault().serializeHTMLFragment(markdownContext.markdownDocumentStore.document.value!))

        //        0: d
        WriterCommonTests.validateColor(in: markdownContext, index: 0, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        2: p
        WriterCommonTests.validateColor(in: markdownContext, index: 2, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        4: *
        WriterCommonTests.validateColor(in: markdownContext, index: 4, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        5: *
        WriterCommonTests.validateColor(in: markdownContext, index: 5, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        6: n
        WriterCommonTests.validateColor(in: markdownContext, index: 6, color: green) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        7: *
        WriterCommonTests.validateColor(in: markdownContext, index: 7, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        8: *
        WriterCommonTests.validateColor(in: markdownContext, index: 8, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 9: .
        WriterCommonTests.validateColor(in: markdownContext, index: 9, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 11: 1
        WriterCommonTests.validateColor(in: markdownContext, index: 11, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 13: 2
        WriterCommonTests.validateColor(in: markdownContext, index: 13, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 15: 3
        WriterCommonTests.validateColor(in: markdownContext, index: 15, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 16: .
        WriterCommonTests.validateColor(in: markdownContext, index: 16, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 18: 1
        WriterCommonTests.validateColor(in: markdownContext, index: 18, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 20: 2
        WriterCommonTests.validateColor(in: markdownContext, index: 20, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 22: 3
        WriterCommonTests.validateColor(in: markdownContext, index: 22, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 23: .
        WriterCommonTests.validateColor(in: markdownContext, index: 23, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 28: p
        WriterCommonTests.validateColor(in: markdownContext, index: 28, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 31: p
        WriterCommonTests.validateColor(in: markdownContext, index: 31, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
    
    
    func testFocusBlocOnSelectionChange() {
        
        let markdownString: String = {

             var value: String = "d" +
                 "\n" +
                 "p **n**. 1 2 3. 1 2 3. " +
                 "\n"

             for i in 0..<100 {
                 value += "\n\n"
                 value += "z"
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

             :fade {
                 color: yellow;
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
        
        
        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        
        markdownContext.setFocusMode(focusMode: .enabled(focusType: .bloc))
        XCTAssert(markdownContext.markdownStyleStore.focusMode.value == FocusMode.enabled(focusType: .bloc))
        
        markdownContext.applySelectionChange(selectionRange: NSMakeRange(6, 0), visibleRange: NSMakeRange(0, 32))
        
        //        0: d
        validateFocusColor(in: markdownContext, index: 0, color: purple) { (e, r, i) in
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
        
        // 9: .
        validateFocusColor(in: markdownContext, index: 9, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 11: 1
        validateFocusColor(in: markdownContext, index: 11, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 13: 2
        validateFocusColor(in: markdownContext, index: 13, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 15: 3
        validateFocusColor(in: markdownContext, index: 15, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 16: .
        validateFocusColor(in: markdownContext, index: 16, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 18: 1
        validateFocusColor(in: markdownContext, index: 18, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 20: 2
        validateFocusColor(in: markdownContext, index: 20, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 22: 3
        validateFocusColor(in: markdownContext, index: 22, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 23: .
        validateFocusColor(in: markdownContext, index: 23, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 28: p
        validateFocusColor(in: markdownContext, index: 28, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 31: p
        validateFocusColor(in: markdownContext, index: 31, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 34: p
        validateFocusColor(in: markdownContext, index: 34, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 37: p
        WriterCommonTests.validateColor(in: markdownContext, index: 37, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
    }
    
    
    
    func testFocusBlocOnSelectionChange2() {
        
        let markdownString: String = {

            var value: String = "\n" +
                "p" +
                "\n" +
                "\n" +
                "p **n**. 1 2 3. 1 2 3. " +
                "\n"

            for _ in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        
        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        
        let indexedCharacters = markdownString.indexedCharacters
        
        let indexedCharactersString = indexedCharacters.map { (arg) -> String in
            return "\(arg.key): \(arg.value)\n"
        }
        for indexedCharacterString in indexedCharactersString {
            print("\(indexedCharacterString)")
        }
        
        
        markdownContext.setFocusMode(focusMode: .enabled(focusType: .bloc))
        XCTAssert(markdownContext.markdownStyleStore.focusMode.value == FocusMode.enabled(focusType: .bloc))
        
        markdownContext.applySelectionChange(selectionRange: NSMakeRange(6, 0), visibleRange: NSMakeRange(0, 32))
        
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
        //
        //        :fade {
        //            color: yellow;
        //        }
        //
        //        :focus {
        //            color: purple;
        //        }
        //
        //        strong:focus {
        //            color: pink;
        //        }
        //
        //        strong::tag:focus {
        //            color: red;
        //        }
        
        
        //        0: p
        validateFocusColor(in: markdownContext, index: 1, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        2: p
        validateFocusColor(in: markdownContext, index: 4, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        4: *
        validateFocusColor(in: markdownContext, index: 6, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        5: *
        validateFocusColor(in: markdownContext, index: 7, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        6: n
        validateFocusColor(in: markdownContext, index: 8, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        7: *
        validateFocusColor(in: markdownContext, index: 9, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        8: *
        validateFocusColor(in: markdownContext, index: 10, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 9: .
        validateFocusColor(in: markdownContext, index: 11, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 11: 1
        validateFocusColor(in: markdownContext, index: 12, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 13: 2
        validateFocusColor(in: markdownContext, index: 15, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 15: 3
        validateFocusColor(in: markdownContext, index: 17, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 16: .
        validateFocusColor(in: markdownContext, index: 18, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 18: 1
        validateFocusColor(in: markdownContext, index: 20, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 20: 2
        validateFocusColor(in: markdownContext, index: 22, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 22: 3
        validateFocusColor(in: markdownContext, index: 24, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 23: .
        validateFocusColor(in: markdownContext, index: 25, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 28: p
        validateFocusColor(in: markdownContext, index: 30, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 31: p
        validateFocusColor(in: markdownContext, index: 33, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 34: p
        WriterCommonTests.validateColor(in: markdownContext, index: 36, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 37: p
        WriterCommonTests.validateColor(in: markdownContext, index: 39, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
    }
    
    
    func testFocusBlocOnSelectionAndScroll() {
    
        let markdownString: String = {

            var value: String = "\n" +
                "p" +
                "\n" +
                "\n" +
                "p **n**. 1 2 3. 1 2 3. " +
                "\n"

            for _ in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        
        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        
        let indexedCharacters = markdownString.indexedCharacters
        
        let indexedCharactersString = indexedCharacters.map { (arg) -> String in
            return "\(arg.key): \(arg.value)\n"
        }
        for indexedCharacterString in indexedCharactersString {
            print("\(indexedCharacterString)")
        }
        
        
        markdownContext.setFocusMode(focusMode: .enabled(focusType: .bloc))
        XCTAssert(markdownContext.markdownStyleStore.focusMode.value == FocusMode.enabled(focusType: .bloc))
        
        markdownContext.applySelectionChange(selectionRange: NSMakeRange(6, 0), visibleRange: NSMakeRange(0, 32))!
        markdownContext.scroll(focusMode: FocusMode.enabled(focusType: .bloc))
        
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

        
        
        //        0: p
        WriterCommonTests.validateColor(in: markdownContext, index: 1, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        2: p
        WriterCommonTests.validateColor(in: markdownContext, index: 4, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        4: *
        WriterCommonTests.validateColor(in: markdownContext, index: 6, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        5: *
        WriterCommonTests.validateColor(in: markdownContext, index: 7, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        6: n
        WriterCommonTests.validateColor(in: markdownContext, index: 8, color: green) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        7: *
        WriterCommonTests.validateColor(in: markdownContext, index: 9, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        8: *
        WriterCommonTests.validateColor(in: markdownContext, index: 10, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 9: .
        WriterCommonTests.validateColor(in: markdownContext, index: 11, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 11: 1
        WriterCommonTests.validateColor(in: markdownContext, index: 12, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 13: 2
        WriterCommonTests.validateColor(in: markdownContext, index: 15, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 15: 3
        WriterCommonTests.validateColor(in: markdownContext, index: 17, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 16: .
        WriterCommonTests.validateColor(in: markdownContext, index: 18, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 18: 1
        WriterCommonTests.validateColor(in: markdownContext, index: 20, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 20: 2
        WriterCommonTests.validateColor(in: markdownContext, index: 22, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 22: 3
        WriterCommonTests.validateColor(in: markdownContext, index: 24, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 23: .
        WriterCommonTests.validateColor(in: markdownContext, index: 25, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 28: p
        WriterCommonTests.validateColor(in: markdownContext, index: 30, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 31: p
        WriterCommonTests.validateColor(in: markdownContext, index: 33, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        // 34: p
        WriterCommonTests.validateColor(in: markdownContext, index: 36, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        // 37: p
        WriterCommonTests.validateColor(in: markdownContext, index: 39, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        
    }

}
