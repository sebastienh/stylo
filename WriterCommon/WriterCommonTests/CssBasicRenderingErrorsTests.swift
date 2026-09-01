//
//  CssBasicRenderingErrorsTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-12-31.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon
import Web
import Common
import os

class CssBasicRenderingErrorsTests: CssRendererTests {


    func testRemoveSecondLeftCurlyBarceFromDoubleCurlyBracesTest() throws {
        
        let cssString = """
        body {
            font-family: Menlo;
        }

        table::tag { {
            font-family: "Helvetica";
        }

        blockquote::tag {
            font-weight: 500;
        }
        """
        
        let styleString = """

            @namespace "http://www.w3.org/Style/CSS/";

            css-style-sheet {
                
                font-family: Menlo;
                font-size: 12pt
                font-style: normal;
                font-weight: normal;
                color: black;
                background-color: white;
            }

            css-style-sheet {
                
                font-family: var(--theme-foreground-fontFamily, "Noto Sans Mono");
                font-size: var(--theme-foreground-fontSize, 11pt);
                font-style: var(--theme-foreground-fontStyle, normal);
                font-weight: var(--theme-foreground-fontWeight, normal);
                color: var(--theme-foreground-color, black);
                background-color: var(--theme-background-color, white);
                caret-color: var(--theme-caret-color, black);
            }

            at-rule-name {
                
                color: var(--theme-atRuleName-color, black);
            }

            namespace-prefix {
                
                color: var(--theme-namespacePrefix-color, black);
            }

            namespace-uri {
                
                color: var(--theme-namespaceUri-color, black);
            }



            type-selector {

                color: var(--theme-typeSelector-color, black);
                font-style: var(--theme-typeSelector-fontStyle, normal);
            }

            .comment-token {

                color: var(--theme-comment-color, black);
                font-style: var(--theme-comment-fontStyle, normal);
            }

            .ident-token {

                color: var(--theme-ident-token-color, black);
                font-style: var(--theme-ident-fontStyle, normal);
            }

            .ident-token.custom-variable {

                color: var(--theme-custom-var-color, black);
                font-style: var(--theme-custom-var-fontStyle, normal);
            }

            .number-token {

                color: var(--theme-number-color, black);
                font-style: var(--theme-number-fontStyle, normal);
            }

            .string-token {

                color: var(--theme-string-color, black);
                font-style: var(--theme-string-fontStyle, normal);
            }

            complexe-selector selector-combinator {

                color: var(--theme-combinator-color, black);
                font-style: var(--theme-combinator-fontStyle, normal);
            }

            css-token.left-curly-brace-token, css-token.right-curly-brace-token {

                color: var(--theme-foreground-color, black);
                font-style: var(--theme-foreground-fontStyle, normal);
            }
            css-token.left-square-bracket-token, css-token.right-square-bracket-token {

                color: var(--theme-foreground-color, black);
                font-style: var(--theme-foreground-fontStyle, normal);
            }

            css-token.delim-token {

                color: var(--theme-foreground-color, black);
                font-style: var(--theme-foreground-fontStyle, normal);
            }

            function {

                color: var(--theme-function-color, black);
                font-style: var(--theme-function-fontStyle, normal);
            }

            function-start, function .left-parenthesis-token, function .comma-token {

                color: var(--theme-function-tag-color, black);
            }

            font-style-value css-token.ident-token {
                color: var(--theme-fontStyle-color, black);
            }

            attribute-match {

                color: var(--theme-attributeMatch-color, black);
                font-style: var(--theme-attributeMatch-fontStyle, normal);
            }

            pseudo-element-selector .colon-token {

                color: var(--theme-pseudoSelectorOperator-color, black);
                font-style: var(--theme-pseudoSelectorOperator-fontStyle, normal);
            }

            pseudo-element-selector .ident-token {

                color: var(--theme-pseudoSelectorValue-color, black);
                font-style: var(--theme-pseudoSelectorValue-fontStyle, normal);
            }

            color-value color-keyword {

                color: var(--theme-colorKeyword-color, black);
                font-style: var(--theme-colorKeyword-fontStyle, normal);
            }

            color-value color-hash {

                color: var(--theme-colorHash-color, black);
                font-style: var(--theme-colorHash-fontStyle, normal);
            }

            css-token.dimension-token {

                color: var(--theme-dimension-color, black);
                font-style: var(--theme-dimension-fontStyle, normal);
                
            }

            attribute-name css-token.ident-token {

                color: var(--theme-attributeName-color, black);
                font-style: var(--theme-attributeName-fontStyle, normal);
                
            }

            class-selector css-token.delim-token, class-selector css-token.ident-token {
                color: var(--theme-classSelector-color, black);
                font-style: var(--theme-classSelector-fontStyle, normal);
                
            }

            property-name .string-token {

                color: var(--theme-propertyName-color, red) !important;
                font-style: var(--theme-propertyName-fontStyle, normal);
                
            }

            important-declaration css-token.delim-token {

                color: var(--theme-importantExclamationPoint-color, red) !important;
                font-style: var(--theme-importantExclamationPoint-fontStyle, normal);
                
            }

            important-declaration css-token.identToken {

                color: var(--theme-importantText-color, red) !important;
                font-style: var(--theme-importantText-fontStyle, normal);
                
            }

            [nw-message-id] {

                color: var(--theme-invalid-color, red) !important;
                font-style: var(--theme-invalid-fontStyle, normal);
                
            }

            [code~="invalidDeclaration"] {

                color: var(--theme-invalid-color, red) !important;
                font-style: var(--theme-invalid-fontStyle, normal);
                
            }

            [code~="invalidDeclaration"] property-name .string-token {

                color: var(--theme-invalid-color, red) !important;
                font-style: var(--theme-invalid-fontStyle, normal);
                
            }

            [code~="invalidDeclaration"] property-value {

                color: var(--theme-invalid-color, red) !important;
                font-style: var(--theme-invalid-fontStyle, normal);
                
            }

            [code~="invalidDeclaration"] property-value .number-token {

                color: var(--theme-invalid-color, red) !important;
                font-style: var(--theme-invalid-fontStyle, normal);
                
            }

            [code~="invalidDeclaration"] property-value .dimension-token {

                color: var(--theme-invalid-color, red) !important;
                font-style: var(--theme-invalid-fontStyle, normal);
                
            }

            [code~="invalidDeclaration"] color-value color-keyword {

                color: var(--theme-invalid-color, red) !important;
                font-style: var(--theme-invalid-fontStyle, normal);
                
            }

            :root {
                
                --theme-caret-color: black;
                --theme-foreground-color: black;
                --theme-background-color: white;
                --theme-atRuleName-color: black;
                --theme-namespacePrefix-color: black;
                --theme-namespaceUri-color: black;
                --theme-typeSelector-color: black;
                --theme-comment-color: black;
                --theme-number-color: black;
                --theme-string-color: black;
                --theme-combinator-color: black;
                --theme-function-color: black;
                --theme-fontStyle-color: black;
                --theme-attributeMatch-color: black;
                --theme-pseudoSelectorOperator-color: black;
                --theme-pseudoSelectorValue-color: black;
                --theme-colorKeyword-color: black;
                --theme-colorHash-color: black;
                --theme-dimension-color: black;
                --theme-attributeName-color: black;
                --theme-classSelector-color: black;
                --theme-propertyName-color: black;
                --theme-importantExclamationPoint-color: black;
                --theme-importantText-color: black;
                --theme-invalid-color: red;
                --theme-function-tag-color: black;
                --theme-ident-token-color: black;
                --theme-ident-fontStyle: normal;
                --theme-custom-var-color: black;
                --theme-custom-var-fontStyle: italic;
                

            }

        """
        
        let indexedCharacters = cssString.indexedCharacters
        
        let indexedCharactersString = indexedCharacters.map { (arg) -> String in
            return "\(arg.key): \(arg.value)\n"
        }
        for indexedCharacterString in indexedCharactersString {
            print("\(indexedCharacterString)")
        }
        
        var cssContext = self.createInitialContext(cssString: cssString, styleString: styleString)

        //        0: b
        WriterCommonTests.validateColor(in: cssContext, index: 0, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        1: o
        WriterCommonTests.validateColor(in: cssContext, index: 1, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        2: d
        WriterCommonTests.validateColor(in: cssContext, index: 2, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: y
        WriterCommonTests.validateColor(in: cssContext, index: 3, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: {
        WriterCommonTests.validateColor(in: cssContext, index: 5, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        11: f
        WriterCommonTests.validateColor(in: cssContext, index: 11, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        12: o
        WriterCommonTests.validateColor(in: cssContext, index: 12, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        13: n
        WriterCommonTests.validateColor(in: cssContext, index: 13, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        14: t
        WriterCommonTests.validateColor(in: cssContext, index: 14, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        15: -
        WriterCommonTests.validateColor(in: cssContext, index: 15, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        16: f
        WriterCommonTests.validateColor(in: cssContext, index: 16, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        17: a
        WriterCommonTests.validateColor(in: cssContext, index: 17, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        18: m
        WriterCommonTests.validateColor(in: cssContext, index: 18, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        19: i
        WriterCommonTests.validateColor(in: cssContext, index: 19, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        20: l
        WriterCommonTests.validateColor(in: cssContext, index: 20, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        //        21: y
        WriterCommonTests.validateColor(in: cssContext, index: 21, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        //        22: :
        WriterCommonTests.validateColor(in: cssContext, index: 22, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        24: M
        WriterCommonTests.validateColor(in: cssContext, index: 24, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        25: e
        WriterCommonTests.validateColor(in: cssContext, index: 25, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        26: n
        WriterCommonTests.validateColor(in: cssContext, index: 26, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        27: l
        WriterCommonTests.validateColor(in: cssContext, index: 27, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        28: o
        WriterCommonTests.validateColor(in: cssContext, index: 28, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        29: ;
        WriterCommonTests.validateColor(in: cssContext, index: 29, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        31: }
        WriterCommonTests.validateColor(in: cssContext, index: 31, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        34: t
        WriterCommonTests.validateColor(in: cssContext, index: 34, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        35: a
        WriterCommonTests.validateColor(in: cssContext, index: 35, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        36: b
        WriterCommonTests.validateColor(in: cssContext, index: 36, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        37: l
        WriterCommonTests.validateColor(in: cssContext, index: 37, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        38: e
        WriterCommonTests.validateColor(in: cssContext, index: 38, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        39: :
        WriterCommonTests.validateColor(in: cssContext, index: 39, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        40: :
        WriterCommonTests.validateColor(in: cssContext, index: 40, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        41: t
        WriterCommonTests.validateColor(in: cssContext, index: 41, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        42: a
        WriterCommonTests.validateColor(in: cssContext, index: 42, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        43: g
        WriterCommonTests.validateColor(in: cssContext, index: 43, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        44:
        WriterCommonTests.validateColor(in: cssContext, index: 44, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        45: {
        WriterCommonTests.validateColor(in: cssContext, index: 45, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        46:
        WriterCommonTests.validateColor(in: cssContext, index: 46, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        47: {
        WriterCommonTests.validateColor(in: cssContext, index: 47, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        53: f
        WriterCommonTests.validateColor(in: cssContext, index: 53, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        54: o
        WriterCommonTests.validateColor(in: cssContext, index: 54, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        55: n
        WriterCommonTests.validateColor(in: cssContext, index: 55, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        56: t
        WriterCommonTests.validateColor(in: cssContext, index: 56, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        57: -
        WriterCommonTests.validateColor(in: cssContext, index: 57, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        58: f
        WriterCommonTests.validateColor(in: cssContext, index: 58, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        59: a
        WriterCommonTests.validateColor(in: cssContext, index: 59, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        60: m
        WriterCommonTests.validateColor(in: cssContext, index: 60, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        61: i
        WriterCommonTests.validateColor(in: cssContext, index: 61, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        62: l
        WriterCommonTests.validateColor(in: cssContext, index: 62, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        63: y
        WriterCommonTests.validateColor(in: cssContext, index: 63, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        64: :
        WriterCommonTests.validateColor(in: cssContext, index: 64, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        66: I
        WriterCommonTests.validateColor(in: cssContext, index: 66, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        67: n
        WriterCommonTests.validateColor(in: cssContext, index: 67, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        68: c
        WriterCommonTests.validateColor(in: cssContext, index: 68, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        69: o
        WriterCommonTests.validateColor(in: cssContext, index: 69, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        70: n
        WriterCommonTests.validateColor(in: cssContext, index: 70, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        71: s
        WriterCommonTests.validateColor(in: cssContext, index: 71, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        72: o
        WriterCommonTests.validateColor(in: cssContext, index: 72, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        73: l
        WriterCommonTests.validateColor(in: cssContext, index: 73, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        74: a
        WriterCommonTests.validateColor(in: cssContext, index: 74, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        75: t
        WriterCommonTests.validateColor(in: cssContext, index: 75, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        76: a
        WriterCommonTests.validateColor(in: cssContext, index: 76, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        77: ;
        WriterCommonTests.validateColor(in: cssContext, index: 77, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        79: }
        WriterCommonTests.validateColor(in: cssContext, index: 79, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        82: b
        WriterCommonTests.validateColor(in: cssContext, index: 82, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        83: l
        WriterCommonTests.validateColor(in: cssContext, index: 83, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        84: o
        WriterCommonTests.validateColor(in: cssContext, index: 84, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        85: c
        WriterCommonTests.validateColor(in: cssContext, index: 85, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        86: k
        WriterCommonTests.validateColor(in: cssContext, index: 86, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        87: q
        WriterCommonTests.validateColor(in: cssContext, index: 87, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        88: u
        WriterCommonTests.validateColor(in: cssContext, index: 88, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        89: o
        WriterCommonTests.validateColor(in: cssContext, index: 89, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        90: t
        WriterCommonTests.validateColor(in: cssContext, index: 90, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        91: e
        WriterCommonTests.validateColor(in: cssContext, index: 91, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        92: :
        WriterCommonTests.validateColor(in: cssContext, index: 92, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        93: :
        WriterCommonTests.validateColor(in: cssContext, index: 93, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        94: t
        WriterCommonTests.validateColor(in: cssContext, index: 94, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        95: a
        WriterCommonTests.validateColor(in: cssContext, index: 95, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        96: g
        WriterCommonTests.validateColor(in: cssContext, index: 96, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        98: {
        WriterCommonTests.validateColor(in: cssContext, index: 98, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        104: f
        WriterCommonTests.validateColor(in: cssContext, index: 104, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        105: o
        WriterCommonTests.validateColor(in: cssContext, index: 105, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        106: n
        WriterCommonTests.validateColor(in: cssContext, index: 106, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        107: t
        WriterCommonTests.validateColor(in: cssContext, index: 107, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        108: -
        WriterCommonTests.validateColor(in: cssContext, index: 108, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        109: w
        WriterCommonTests.validateColor(in: cssContext, index: 109, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        110: e
        WriterCommonTests.validateColor(in: cssContext, index: 110, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        111: i
        WriterCommonTests.validateColor(in: cssContext, index: 111, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        112: g
        WriterCommonTests.validateColor(in: cssContext, index: 112, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        113: h
        WriterCommonTests.validateColor(in: cssContext, index: 113, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        114: t
        WriterCommonTests.validateColor(in: cssContext, index: 114, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        115: :
        WriterCommonTests.validateColor(in: cssContext, index: 115, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        116:
        WriterCommonTests.validateColor(in: cssContext, index: 116, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        117: 5
        WriterCommonTests.validateColor(in: cssContext, index: 117, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        118: 0
        WriterCommonTests.validateColor(in: cssContext, index: 118, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        119: 0
        WriterCommonTests.validateColor(in: cssContext, index: 119, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        120: ;
        WriterCommonTests.validateColor(in: cssContext, index: 120, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        122: }
        WriterCommonTests.validateColor(in: cssContext, index: 122, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }

        cssContext.applyChange(range: NSMakeRange(47, 1), insertedString: " ", visibleRange: nil)
        
        //        0: b
        WriterCommonTests.validateColor(in: cssContext, index: 0, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        1: o
        WriterCommonTests.validateColor(in: cssContext, index: 1, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        2: d
        WriterCommonTests.validateColor(in: cssContext, index: 2, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: y
        WriterCommonTests.validateColor(in: cssContext, index: 3, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        5: {
        WriterCommonTests.validateColor(in: cssContext, index: 5, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        11: f
        WriterCommonTests.validateColor(in: cssContext, index: 11, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        12: o
        WriterCommonTests.validateColor(in: cssContext, index: 12, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        13: n
        WriterCommonTests.validateColor(in: cssContext, index: 13, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        14: t
        WriterCommonTests.validateColor(in: cssContext, index: 14, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        15: -
        WriterCommonTests.validateColor(in: cssContext, index: 15, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        16: f
        WriterCommonTests.validateColor(in: cssContext, index: 16, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        17: a
        WriterCommonTests.validateColor(in: cssContext, index: 17, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        18: m
        WriterCommonTests.validateColor(in: cssContext, index: 18, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        19: i
        WriterCommonTests.validateColor(in: cssContext, index: 19, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        20: l
        WriterCommonTests.validateColor(in: cssContext, index: 20, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        //        21: y
        WriterCommonTests.validateColor(in: cssContext, index: 21, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        //        22: :
        WriterCommonTests.validateColor(in: cssContext, index: 22, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        24: M
        WriterCommonTests.validateColor(in: cssContext, index: 24, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        25: e
        WriterCommonTests.validateColor(in: cssContext, index: 25, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        26: n
        WriterCommonTests.validateColor(in: cssContext, index: 26, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        27: l
        WriterCommonTests.validateColor(in: cssContext, index: 27, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        28: o
        WriterCommonTests.validateColor(in: cssContext, index: 28, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        29: ;
        WriterCommonTests.validateColor(in: cssContext, index: 29, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        31: }
        WriterCommonTests.validateColor(in: cssContext, index: 31, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        34: t
        WriterCommonTests.validateColor(in: cssContext, index: 34, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        35: a
        WriterCommonTests.validateColor(in: cssContext, index: 35, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        36: b
        WriterCommonTests.validateColor(in: cssContext, index: 36, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        37: l
        WriterCommonTests.validateColor(in: cssContext, index: 37, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        38: e
        WriterCommonTests.validateColor(in: cssContext, index: 38, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        39: :
        WriterCommonTests.validateColor(in: cssContext, index: 39, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        40: :
        WriterCommonTests.validateColor(in: cssContext, index: 40, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        41: t
        WriterCommonTests.validateColor(in: cssContext, index: 41, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        42: a
        WriterCommonTests.validateColor(in: cssContext, index: 42, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        43: g
        WriterCommonTests.validateColor(in: cssContext, index: 43, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        44:
        WriterCommonTests.validateColor(in: cssContext, index: 44, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        45: {
        WriterCommonTests.validateColor(in: cssContext, index: 45, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        46:
        WriterCommonTests.validateColor(in: cssContext, index: 46, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        47: {
        WriterCommonTests.validateColor(in: cssContext, index: 47, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        53: f
        WriterCommonTests.validateColor(in: cssContext, index: 53, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        54: o
        WriterCommonTests.validateColor(in: cssContext, index: 54, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        55: n
        WriterCommonTests.validateColor(in: cssContext, index: 55, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        56: t
        WriterCommonTests.validateColor(in: cssContext, index: 56, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        57: -
        WriterCommonTests.validateColor(in: cssContext, index: 57, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        58: f
        WriterCommonTests.validateColor(in: cssContext, index: 58, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        59: a
        WriterCommonTests.validateColor(in: cssContext, index: 59, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        60: m
        WriterCommonTests.validateColor(in: cssContext, index: 60, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        61: i
        WriterCommonTests.validateColor(in: cssContext, index: 61, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        62: l
        WriterCommonTests.validateColor(in: cssContext, index: 62, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        63: y
        WriterCommonTests.validateColor(in: cssContext, index: 63, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        64: :
        WriterCommonTests.validateColor(in: cssContext, index: 64, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        66: "
        WriterCommonTests.validateColor(in: cssContext, index: 66, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        67: H
        WriterCommonTests.validateColor(in: cssContext, index: 67, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        68: e
        WriterCommonTests.validateColor(in: cssContext, index: 68, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        69: l
        WriterCommonTests.validateColor(in: cssContext, index: 69, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        70: v
        WriterCommonTests.validateColor(in: cssContext, index: 70, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        71: e
        WriterCommonTests.validateColor(in: cssContext, index: 71, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        72: t
        WriterCommonTests.validateColor(in: cssContext, index: 72, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        73: i
        WriterCommonTests.validateColor(in: cssContext, index: 73, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        74: c
        WriterCommonTests.validateColor(in: cssContext, index: 74, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        75: a
        WriterCommonTests.validateColor(in: cssContext, index: 75, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        76: "
        WriterCommonTests.validateColor(in: cssContext, index: 76, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        77: ;
        WriterCommonTests.validateColor(in: cssContext, index: 77, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        79: }
        WriterCommonTests.validateColor(in: cssContext, index: 79, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        82: b
        WriterCommonTests.validateColor(in: cssContext, index: 82, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        83: l
        WriterCommonTests.validateColor(in: cssContext, index: 83, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        84: o
        WriterCommonTests.validateColor(in: cssContext, index: 84, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        85: c
        WriterCommonTests.validateColor(in: cssContext, index: 85, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        86: k
        WriterCommonTests.validateColor(in: cssContext, index: 86, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        87: q
        WriterCommonTests.validateColor(in: cssContext, index: 87, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        88: u
        WriterCommonTests.validateColor(in: cssContext, index: 88, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        89: o
        WriterCommonTests.validateColor(in: cssContext, index: 89, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        90: t
        WriterCommonTests.validateColor(in: cssContext, index: 90, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        91: e
        WriterCommonTests.validateColor(in: cssContext, index: 91, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        92: :
        WriterCommonTests.validateColor(in: cssContext, index: 92, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        93: :
        WriterCommonTests.validateColor(in: cssContext, index: 93, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        94: t
        WriterCommonTests.validateColor(in: cssContext, index: 94, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        95: a
        WriterCommonTests.validateColor(in: cssContext, index: 95, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        96: g
        WriterCommonTests.validateColor(in: cssContext, index: 96, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        98: {
        WriterCommonTests.validateColor(in: cssContext, index: 98, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        104: f
        WriterCommonTests.validateColor(in: cssContext, index: 104, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        105: o
        WriterCommonTests.validateColor(in: cssContext, index: 105, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        106: n
        WriterCommonTests.validateColor(in: cssContext, index: 106, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        107: t
        WriterCommonTests.validateColor(in: cssContext, index: 107, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        108: -
        WriterCommonTests.validateColor(in: cssContext, index: 108, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        109: w
        WriterCommonTests.validateColor(in: cssContext, index: 109, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        110: e
        WriterCommonTests.validateColor(in: cssContext, index: 110, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        111: i
        WriterCommonTests.validateColor(in: cssContext, index: 111, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        112: g
        WriterCommonTests.validateColor(in: cssContext, index: 112, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        113: h
        WriterCommonTests.validateColor(in: cssContext, index: 113, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        114: t
        WriterCommonTests.validateColor(in: cssContext, index: 114, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        115: :
        WriterCommonTests.validateColor(in: cssContext, index: 115, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        116:
        WriterCommonTests.validateColor(in: cssContext, index: 116, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        117: 5
        WriterCommonTests.validateColor(in: cssContext, index: 117, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        118: 0
        WriterCommonTests.validateColor(in: cssContext, index: 118, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        119: 0
        WriterCommonTests.validateColor(in: cssContext, index: 119, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        120: ;
        WriterCommonTests.validateColor(in: cssContext, index: 120, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        122: }
        WriterCommonTests.validateColor(in: cssContext, index: 122, color: black) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        
    }



}
