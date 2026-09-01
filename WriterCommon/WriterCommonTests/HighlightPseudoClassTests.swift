//
//  HighlightPseudoClassTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-07-30.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest

@testable import WriterCommon
import Web
import Common
import Igloo

class HighlightPseudoClassTests: MarkdownRendererTests {
    
    let markdownString: String = {
        
        var value: String = "\n" +
            "\n" +
            "{.test}\n" +
            "p **n**. 1 2 3. 1 2 3. " +
        "\n"
        
        for i in 0..<100 {
            value += "\n\n"
            value += "p"
        }
        return value
    }()
    
    
    func testNoHighlight() throws {
        
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

            attr-bloc::tag {
                color: orange;
            }

            p:highlight {
                color: purple;
            }

            p:highlight ::tag {
                color: red;
            }

            attr-bloc::tag:highlight {
                color: blue;
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
        
        print(HTMLSerializer.createDefault().serializeHTMLFragment(markdownContext.markdownDocumentStore.document.value!))
        
        //        0: d
        WriterCommonTests.validateColor(in: markdownContext, index: 0, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        2: {
        WriterCommonTests.validateColor(in: markdownContext, index: 2, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: .
        WriterCommonTests.validateColor(in: markdownContext, index: 3, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: t
        WriterCommonTests.validateColor(in: markdownContext, index: 4, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: e
        WriterCommonTests.validateColor(in: markdownContext, index: 5, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: s
        WriterCommonTests.validateColor(in: markdownContext, index: 6, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        7: t
        WriterCommonTests.validateColor(in: markdownContext, index: 7, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        8: }
        WriterCommonTests.validateColor(in: markdownContext, index: 8, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        10: p
        WriterCommonTests.validateColor(in: markdownContext, index: 10, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        12: *
        WriterCommonTests.validateColor(in: markdownContext, index: 12, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        
        //        13: *
        WriterCommonTests.validateColor(in: markdownContext, index: 13, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        14: n
        WriterCommonTests.validateColor(in: markdownContext, index: 14, color: green) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        15: *
        WriterCommonTests.validateColor(in: markdownContext, index: 15, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        16: *
        WriterCommonTests.validateColor(in: markdownContext, index: 16, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        17: .
        WriterCommonTests.validateColor(in: markdownContext, index: 17, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        19: 1
        WriterCommonTests.validateColor(in: markdownContext, index: 19, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        21: 2
        WriterCommonTests.validateColor(in: markdownContext, index: 21, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        23: 3
        WriterCommonTests.validateColor(in: markdownContext, index: 23, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        24: .
        WriterCommonTests.validateColor(in: markdownContext, index: 24, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        26: 1
        WriterCommonTests.validateColor(in: markdownContext, index: 26, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        28: 2
        WriterCommonTests.validateColor(in: markdownContext, index: 28, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        30: 3
        WriterCommonTests.validateColor(in: markdownContext, index: 30, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        31: .
        WriterCommonTests.validateColor(in: markdownContext, index: 31, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        36: p
        WriterCommonTests.validateColor(in: markdownContext, index: 36, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        39: p
        WriterCommonTests.validateColor(in: markdownContext, index: 39, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
    
    func testHighlight() throws {
        
        let markdownString: String = {
            
            var value: String = "\n" +
                "\n" +
                "{.test}\n" +
                "p **n**. 1 2 3. 1 2 3. " +
            "\n"
            
            for _ in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        let styleString = """
            body {
                color: black;
            }

            p:fade {
                color: purple;
            }

            strong {
                color: green;
            }

            strong::tag {
                color: blue;
            }

            attr-bloc::tag {
                color: orange;
            }

            body:highlight {
                color: red;
            }

            body :highlight p,
            body p:highlight {
                color: orange;
            }

            body :highlight strong::tag {
                color: yellow;
            }

            body :highlight strong {
                color: pink;
            }

            body :highlight attr-bloc::tag {
                color: blue;
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
        
        markdownContext.highlight(with: ".test")
        
        //        0: d
        WriterCommonTests.validateColor(in: markdownContext, index: 0, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        2: {
        WriterCommonTests.validateColor(in: markdownContext, index: 2, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: .
        WriterCommonTests.validateColor(in: markdownContext, index: 3, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: t
        WriterCommonTests.validateColor(in: markdownContext, index: 4, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: e
        WriterCommonTests.validateColor(in: markdownContext, index: 5, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: s
        WriterCommonTests.validateColor(in: markdownContext, index: 6, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        7: t
        WriterCommonTests.validateColor(in: markdownContext, index: 7, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        8: }
        WriterCommonTests.validateColor(in: markdownContext, index: 8, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        10: p
        WriterCommonTests.validateColor(in: markdownContext, index: 10, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        12: *
        WriterCommonTests.validateColor(in: markdownContext, index: 12, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        
        //        13: *
        WriterCommonTests.validateColor(in: markdownContext, index: 13, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        14: n
        WriterCommonTests.validateColor(in: markdownContext, index: 14, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        15: *
        WriterCommonTests.validateColor(in: markdownContext, index: 15, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        16: *
        WriterCommonTests.validateColor(in: markdownContext, index: 16, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        17: .
        WriterCommonTests.validateColor(in: markdownContext, index: 17, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        19: 1
        WriterCommonTests.validateColor(in: markdownContext, index: 19, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        21: 2
        WriterCommonTests.validateColor(in: markdownContext, index: 21, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        23: 3
        WriterCommonTests.validateColor(in: markdownContext, index: 23, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        24: .
        WriterCommonTests.validateColor(in: markdownContext, index: 24, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        26: 1
        WriterCommonTests.validateColor(in: markdownContext, index: 26, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        28: 2
        WriterCommonTests.validateColor(in: markdownContext, index: 28, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        30: 3
        WriterCommonTests.validateColor(in: markdownContext, index: 30, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        31: .
        WriterCommonTests.validateColor(in: markdownContext, index: 31, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        36: p
        WriterCommonTests.validateColor(in: markdownContext, index: 36, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        39: p
        WriterCommonTests.validateColor(in: markdownContext, index: 39, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        42: p
        WriterCommonTests.validateColor(in: markdownContext, index: 42, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        45: p
        WriterCommonTests.validateColor(in: markdownContext, index: 45, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
    
    func testHighlightWithNoHighlightedParent() throws {
        
        let markdownString: String = {
            
            var value: String = "\n" +
                "\n" +
                "{.test}\n" +
                "p **n**. 1 2 3. 1 2 3. " +
            "\n"
            
            for _ in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        let styleString = """
            body {
                color: black;
            }

            p:fade {
                color: purple;
            }

            strong {
                color: green;
            }

            strong::tag {
                color: blue;
            }

            attr-bloc::tag {
                color: orange;
            }

            body:highlight {
                color: red;
            }

            body :highlight p,
            body p:highlight {
                color: orange;
            }

            body :highlight strong::tag {
                color: yellow;
            }

            body :highlight strong {
                color: pink;
            }

            body :highlight attr-bloc::tag {
                color: blue;
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
        
        markdownContext.highlight(with: ".wrong-test")
        
        //        0: d
        WriterCommonTests.validateColor(in: markdownContext, index: 0, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        2: {
        WriterCommonTests.validateColor(in: markdownContext, index: 2, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: .
        WriterCommonTests.validateColor(in: markdownContext, index: 3, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: t
        WriterCommonTests.validateColor(in: markdownContext, index: 4, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: e
        WriterCommonTests.validateColor(in: markdownContext, index: 5, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: s
        WriterCommonTests.validateColor(in: markdownContext, index: 6, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        7: t
        WriterCommonTests.validateColor(in: markdownContext, index: 7, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        8: }
        WriterCommonTests.validateColor(in: markdownContext, index: 8, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        10: p
        WriterCommonTests.validateColor(in: markdownContext, index: 10, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        12: *
        WriterCommonTests.validateColor(in: markdownContext, index: 12, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        
        //        13: *
        WriterCommonTests.validateColor(in: markdownContext, index: 13, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        14: n
        WriterCommonTests.validateColor(in: markdownContext, index: 14, color: green) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        15: *
        WriterCommonTests.validateColor(in: markdownContext, index: 15, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        16: *
        WriterCommonTests.validateColor(in: markdownContext, index: 16, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        17: .
        WriterCommonTests.validateColor(in: markdownContext, index: 17, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        19: 1
        WriterCommonTests.validateColor(in: markdownContext, index: 19, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        21: 2
        WriterCommonTests.validateColor(in: markdownContext, index: 21, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        23: 3
        WriterCommonTests.validateColor(in: markdownContext, index: 23, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        24: .
        WriterCommonTests.validateColor(in: markdownContext, index: 24, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        26: 1
        WriterCommonTests.validateColor(in: markdownContext, index: 26, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        28: 2
        WriterCommonTests.validateColor(in: markdownContext, index: 28, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        30: 3
        WriterCommonTests.validateColor(in: markdownContext, index: 30, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        31: .
        WriterCommonTests.validateColor(in: markdownContext, index: 31, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        36: p
        WriterCommonTests.validateColor(in: markdownContext, index: 36, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        39: p
        WriterCommonTests.validateColor(in: markdownContext, index: 39, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        42: p
        WriterCommonTests.validateColor(in: markdownContext, index: 42, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        45: p
        WriterCommonTests.validateColor(in: markdownContext, index: 45, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
    
    func testHighlightWithNoHighlightedParent2() throws {
        
        let markdownString: String = {
            
            var value: String = "\n" +
                "\n" +
                "{.no-highlight}\n" +
                "> {.highlight}\n" +
                "> p **n**. 1 2 3. 1 2 3. " +
            "\n"
            
            for _ in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        let styleString = """
            body {
                color: black;
            }

            p:fade {
                color: purple;
            }

            strong {
                color: green;
            }

            strong::tag {
                color: blue;
            }

            attr-bloc::tag {
                color: orange;
            }

            body:highlight {
                color: red;
            }

            body :highlight p,
            body p:highlight {
                color: orange;
            }

            body :highlight p:highlight {
                color: pink;
            }

            body :highlight strong::tag {
                color: yellow;
            }

            body :highlight strong {
                color: pink;
            }

            body :highlight attr-bloc::tag {
                color: blue;
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
        
        markdownContext.highlight(with: ".highlight")

        //        2: {
        WriterCommonTests.validateColor(in: markdownContext, index: 2, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: .
        WriterCommonTests.validateColor(in: markdownContext, index: 3, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: n
        WriterCommonTests.validateColor(in: markdownContext, index: 4, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: o
        WriterCommonTests.validateColor(in: markdownContext, index: 5, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: -
        WriterCommonTests.validateColor(in: markdownContext, index: 6, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        7: h
        WriterCommonTests.validateColor(in: markdownContext, index: 7, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        8: i
        WriterCommonTests.validateColor(in: markdownContext, index: 8, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        9: g
        WriterCommonTests.validateColor(in: markdownContext, index: 9, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        10: h
        WriterCommonTests.validateColor(in: markdownContext, index: 10, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        11: l
        WriterCommonTests.validateColor(in: markdownContext, index: 11, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        12: i
        WriterCommonTests.validateColor(in: markdownContext, index: 12, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        13: g
        WriterCommonTests.validateColor(in: markdownContext, index: 13, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        14: h
        WriterCommonTests.validateColor(in: markdownContext, index: 14, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        15: t
        WriterCommonTests.validateColor(in: markdownContext, index: 15, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        16: }
        WriterCommonTests.validateColor(in: markdownContext, index: 16, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        18: >
        WriterCommonTests.validateColor(in: markdownContext, index: 18, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        19:
        WriterCommonTests.validateColor(in: markdownContext, index: 19, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        20: {
        WriterCommonTests.validateColor(in: markdownContext, index: 20, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        21: .
        WriterCommonTests.validateColor(in: markdownContext, index: 21, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        22: h
        WriterCommonTests.validateColor(in: markdownContext, index: 22, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        23: i
        WriterCommonTests.validateColor(in: markdownContext, index: 23, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        24: g
        WriterCommonTests.validateColor(in: markdownContext, index: 24, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        25: h
        WriterCommonTests.validateColor(in: markdownContext, index: 25, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        26: l
        WriterCommonTests.validateColor(in: markdownContext, index: 26, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        27: i
        WriterCommonTests.validateColor(in: markdownContext, index: 27, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        28: g
        WriterCommonTests.validateColor(in: markdownContext, index: 28, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        29: h
        WriterCommonTests.validateColor(in: markdownContext, index: 29, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        30: t
        WriterCommonTests.validateColor(in: markdownContext, index: 30, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        31: }
        WriterCommonTests.validateColor(in: markdownContext, index: 31, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        33: >
        WriterCommonTests.validateColor(in: markdownContext, index: 33, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        35: p
        WriterCommonTests.validateColor(in: markdownContext, index: 35, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        37: *
        WriterCommonTests.validateColor(in: markdownContext, index: 37, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        38: *
        WriterCommonTests.validateColor(in: markdownContext, index: 38, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        39: n
        WriterCommonTests.validateColor(in: markdownContext, index: 39, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        40: *
        WriterCommonTests.validateColor(in: markdownContext, index: 40, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        41: *
        WriterCommonTests.validateColor(in: markdownContext, index: 41, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        42: .
        WriterCommonTests.validateColor(in: markdownContext, index: 42, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        44: 1
        WriterCommonTests.validateColor(in: markdownContext, index: 44, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        46: 2
        WriterCommonTests.validateColor(in: markdownContext, index: 46, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        48: 3
        WriterCommonTests.validateColor(in: markdownContext, index: 48, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        49: .
        WriterCommonTests.validateColor(in: markdownContext, index: 49, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        51: 1
        WriterCommonTests.validateColor(in: markdownContext, index: 51, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        53: 2
        WriterCommonTests.validateColor(in: markdownContext, index: 53, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        55: 3
        WriterCommonTests.validateColor(in: markdownContext, index: 55, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        56: .
        WriterCommonTests.validateColor(in: markdownContext, index: 56, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        61: p
        WriterCommonTests.validateColor(in: markdownContext, index: 61, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        64: p
        WriterCommonTests.validateColor(in: markdownContext, index: 64, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        67: p
        WriterCommonTests.validateColor(in: markdownContext, index: 67, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
    
    func testHighlightWithNoHighlightedParent3() throws {
        
        let markdownString: String = {
            
            var value: String = "\n" +
                "\n" +
                "{.no-highlight}\n" +
                "> {.highlight}\n" +
                "> p **n**. 1 2 3. 1 2 3. " +
            "\n"
            
            for _ in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        let styleString = """
            body {
                color: black;
            }

            p:fade {
                color: purple;
            }

            strong {
                color: green;
            }

            strong::tag {
                color: blue;
            }

            attr-bloc::tag {
                color: orange;
            }

            body:highlight {
                color: red;
            }

            body :highlight p,
            body p:highlight {
                color: orange;
            }

            body :highlight p:highlight {
                color: pink;
            }

            body :highlight strong::tag {
                color: yellow;
            }

            body :highlight strong {
                color: pink;
            }

            body :highlight attr-bloc::tag {
                color: blue;
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
        
        markdownContext.highlight(with: ".highlight, .no-highlight")

        //        2: {
        WriterCommonTests.validateColor(in: markdownContext, index: 2, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: .
        WriterCommonTests.validateColor(in: markdownContext, index: 3, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: n
        WriterCommonTests.validateColor(in: markdownContext, index: 4, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: o
        WriterCommonTests.validateColor(in: markdownContext, index: 5, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: -
        WriterCommonTests.validateColor(in: markdownContext, index: 6, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        7: h
        WriterCommonTests.validateColor(in: markdownContext, index: 7, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        8: i
        WriterCommonTests.validateColor(in: markdownContext, index: 8, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        9: g
        WriterCommonTests.validateColor(in: markdownContext, index: 9, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        10: h
        WriterCommonTests.validateColor(in: markdownContext, index: 10, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        11: l
        WriterCommonTests.validateColor(in: markdownContext, index: 11, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        12: i
        WriterCommonTests.validateColor(in: markdownContext, index: 12, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        13: g
        WriterCommonTests.validateColor(in: markdownContext, index: 13, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        14: h
        WriterCommonTests.validateColor(in: markdownContext, index: 14, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        15: t
        WriterCommonTests.validateColor(in: markdownContext, index: 15, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        16: }
        WriterCommonTests.validateColor(in: markdownContext, index: 16, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        18: >
        WriterCommonTests.validateColor(in: markdownContext, index: 18, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        19:
        WriterCommonTests.validateColor(in: markdownContext, index: 19, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        20: {
        WriterCommonTests.validateColor(in: markdownContext, index: 20, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        21: .
        WriterCommonTests.validateColor(in: markdownContext, index: 21, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        22: h
        WriterCommonTests.validateColor(in: markdownContext, index: 22, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        23: i
        WriterCommonTests.validateColor(in: markdownContext, index: 23, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        24: g
        WriterCommonTests.validateColor(in: markdownContext, index: 24, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        25: h
        WriterCommonTests.validateColor(in: markdownContext, index: 25, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        26: l
        WriterCommonTests.validateColor(in: markdownContext, index: 26, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        27: i
        WriterCommonTests.validateColor(in: markdownContext, index: 27, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        28: g
        WriterCommonTests.validateColor(in: markdownContext, index: 28, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        29: h
        WriterCommonTests.validateColor(in: markdownContext, index: 29, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        30: t
        WriterCommonTests.validateColor(in: markdownContext, index: 30, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        31: }
        WriterCommonTests.validateColor(in: markdownContext, index: 31, color: blue) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        33: >
        WriterCommonTests.validateColor(in: markdownContext, index: 33, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        35: p
        WriterCommonTests.validateColor(in: markdownContext, index: 35, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        37: *
        WriterCommonTests.validateColor(in: markdownContext, index: 37, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        38: *
        WriterCommonTests.validateColor(in: markdownContext, index: 38, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        39: n
        WriterCommonTests.validateColor(in: markdownContext, index: 39, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        40: *
        WriterCommonTests.validateColor(in: markdownContext, index: 40, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        41: *
        WriterCommonTests.validateColor(in: markdownContext, index: 41, color: yellow) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        42: .
        WriterCommonTests.validateColor(in: markdownContext, index: 42, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        44: 1
        WriterCommonTests.validateColor(in: markdownContext, index: 44, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        46: 2
        WriterCommonTests.validateColor(in: markdownContext, index: 46, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        48: 3
        WriterCommonTests.validateColor(in: markdownContext, index: 48, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        49: .
        WriterCommonTests.validateColor(in: markdownContext, index: 49, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        51: 1
        WriterCommonTests.validateColor(in: markdownContext, index: 51, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        53: 2
        WriterCommonTests.validateColor(in: markdownContext, index: 53, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        55: 3
        WriterCommonTests.validateColor(in: markdownContext, index: 55, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        56: .
        WriterCommonTests.validateColor(in: markdownContext, index: 56, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        61: p
        WriterCommonTests.validateColor(in: markdownContext, index: 61, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        64: p
        WriterCommonTests.validateColor(in: markdownContext, index: 64, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        67: p
        WriterCommonTests.validateColor(in: markdownContext, index: 67, color: purple) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
    
    func testHighlightFade() throws {
        
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

            :highlight {
                color: yellow;
            }

            :fade {
                color: white;
            }

            :highlight:fade,
            :highlight :fade {
                color: pink;
            }

            :highlight strong {
                color: purple;
            }

            :highlight strong::tag {
                color: red;
            }

            strong:highlight:fade,
            em:highlight:fade,
            :highlight strong:fade,
            :highlight em:fade {
                color: orange;
            }

         """
        
        let indexedCharacters = markdownString.indexedCharacters
        
        let indexedCharactersString = indexedCharacters.map { (arg) -> String in
            return "\(arg.key): \(arg.value)\n"
        }
        for indexedCharacterString in indexedCharactersString {
            print("\(indexedCharacterString)")
        }
        
        var markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        
        markdownContext.highlight(with: ".test")
        markdownContext.setFocusMode(focusMode: .enabled(focusType: .sentence))
        markdownContext.applySelectionChange(selectionRange: NSMakeRange(42, 0), visibleRange: NSMakeRange(0, 70))
        
        //        2: {
        validateFocusColor(in: markdownContext, index: 2, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: .
        validateFocusColor(in: markdownContext, index: 3, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: t
        validateFocusColor(in: markdownContext, index: 4, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: e
        validateFocusColor(in: markdownContext, index: 5, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        6: s
        validateFocusColor(in: markdownContext, index: 6, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        7: t
        validateFocusColor(in: markdownContext, index: 7, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        8: }
        validateFocusColor(in: markdownContext, index: 8, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        //        10: p
        validateFocusColor(in: markdownContext, index: 10, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        12: *
        validateFocusColor(in: markdownContext, index: 12, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        
        //        13: *
        validateFocusColor(in: markdownContext, index: 13, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        14: n
        validateFocusColor(in: markdownContext, index: 14, color: orange) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        15: *
        validateFocusColor(in: markdownContext, index: 15, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        16: *
        validateFocusColor(in: markdownContext, index: 16, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        17: .
        validateFocusColor(in: markdownContext, index: 17, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        19: 1
        validateFocusColor(in: markdownContext, index: 19, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        21: 2
        validateFocusColor(in: markdownContext, index: 21, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        23: 3
        validateFocusColor(in: markdownContext, index: 23, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        24: .
        validateFocusColor(in: markdownContext, index: 24, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        26: 1
        validateFocusColor(in: markdownContext, index: 26, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        28: 2
        validateFocusColor(in: markdownContext, index: 28, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        30: 3
        validateFocusColor(in: markdownContext, index: 30, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        31: .
        validateFocusColor(in: markdownContext, index: 31, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        36: p
        validateFocusColor(in: markdownContext, index: 36, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
    
    func testConcurentHighlight() {
        
        let markdownTextContext = self.createInitialContext(markdownFilename: "highlight-md-test-1.md", stylesheetsName: [
            "highlight-common.css",
            "highlight-colors-selectors.css",
            "highlight-source-dark.css"
        ])
        
        DispatchQueue.concurrentPerform(iterations: 10) { _ in 
            markdownTextContext.highlight(with: ".hesiod, .hesiod-2, .test")
        }
    }
    
    func testHighlightPerformance() {
        
        let markdownTextContext = self.createInitialContext(markdownFilename: "highlight-md-test-1.md", stylesheetsName: [
            "highlight-common.css",
            "highlight-colors-selectors.css",
            "highlight-source-dark.css"
        ])
        
        self.measure() {
            markdownTextContext.highlight(with: ".hesiod, .hesiod-2, .test")
        }
    }
    
}
