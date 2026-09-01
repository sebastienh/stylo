//
//  TestFontFamilyCascadedStyle.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-29.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
import Common
@testable import Web

class TestFontFamilyCascadedStyle: TestCascading {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLeftCurlyBraketAppliedStyle() {
        
        let styledStyleSheetSource =    """

                                        body {
                                            font-family : Arial;
                                        }

                                        """;
        
        
        
        let stylingStyleSheetResource = """


            @namespace "http://www.w3.org/Style/CSS/";

            /* Solarized Dark
             For use with Jekyll and Pygments
             http://ethanschoonover.com/solarized
             SOLARIZED HEX      ROLE
             --------- -------- ------------------------------------------
             - base03    #002b36  background
             - base01    #586e75  comments / secondary content
             - base1     #93a1a1  body text / default code / primary content
             orange    #cb4b16  constants
             red       #dc322f  regex, special keywords
             blue      #268bd2  reserved keywords
             - cyan      #2aa198  strings, numbers
             green     #859900  operators, other keywords
             */

            css-style-sheet {
                font-family: Menlo;
                font-size: 10pt;
                /* base1     #93a1a1  body text / default code / primary content */
                color: #93a1a1;
                /* base03    #002b36  background */
                background-color: #002b36;
                font-family: Menlo;
            }

            /*  base01    #586e75  comments / secondary content */
            .comment-token {
                color: #586e75;
            }

            /*  cyan      #2aa198  strings, numbers*/
            .number-token {
                color: #2aa198;
            }

            .string-token {
                color: #2aa198;
            }

            /*  blue      #268bd2  reserved keywords */
            property-name .string-token {
                color: #268bd2 !important;
            }

            /* green     #859900  operators, other keywords */
            complexe-selector selector-combinator {
                color: #859900 !important;
            }

            css-token[text-value="{"] {
                color: #859900;
                font-family: Arial;
            }

            css-token[text-value="}"] {
                color: #859900;
            }

            css-token[text-value="["] {
                color: #859900;
            }

            css-token[text-value="]"] {
                color: #859900;
            }

            css-token[text-value="."] {
                color: #859900;
            }

            function {
                color: #859900;
            }

            attribute-match {
                color: #859900;
            }

            pseudo-element-selector .colon-token {
                color: #859900;
            }

            /*  red       #dc322f  regex, special keywords */
            color-value color-keyword {
                color: #dc322f;
            }

            pseudo-element-selector .ident-token {
                color: #dc322f;
            }

            /* orange    #cb4b16  constants */
            attribute-name css-token.ident-token {
                color: #cb4b16;
            }

            /*  - base1     #93a1a1  body text / default code / primary content */
            [nw-message-id] {
                color: #93a1a1;
            }

            [code~="invalidDeclaration"] {
                color: #93a1a1 !important;
            }

            [code~="invalidDeclaration"] property-name .string-token {
                color: #93a1a1 !important;
            }

            [code~="invalidDeclaration"] property-value {
                color: #93a1a1 !important;
            }

            [code~="invalidDeclaration"] property-value .number-token {
                color: #93a1a1 !important;
            }

            [code~="invalidDeclaration"] color-value color-keyword {
                color: #93a1a1 !important;
            }


        """
        
        let styledSourceString = styledStyleSheetSource
        
        let stylingSourceString = stylingStyleSheetResource
        
        if let styledCssDocument = getStyledCSSDOMDocument(sourceString: styledSourceString as NSString) {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                var style = CSSStyle(id: "test-style")
                style.addStyleSheet(stylingCssStyleSheet)
                
                let computedStyle = ResourceComputedStyle(styleDefinition: style)
                
                computedStyle.computeElementsStyles(document: styledCssDocument, filterContext: FilterContext())
                
                let tokenElements = styledCssDocument.getElementsByTagName("css-token")
                
                for tokenElement in tokenElements {
                    
                    if let element = tokenElement as? Element {
                        debugPrint("tokenElement classes: \(element.classListString)")
                    }
                }
                
                if let leftCurlyBraketElement = tokenElements[1] as? Element {
                    
                    debugPrint("leftCurlyBraketElement classes: \(leftCurlyBraketElement.classListString)")
                    
                    let leftCurlyBraketElementElementRawComputedStyle = computedStyle.computedStyle(forElement: leftCurlyBraketElement)! //
//                        leftCurlyBraketElement.rawComputedStyle
                    
                    if let fontFamilyValue = leftCurlyBraketElementElementRawComputedStyle.propertyValues[§CSSProperty.fontFamily] {
                        
                        XCTAssert(validateFontFamilyActualValue(fontFamilyValue: fontFamilyValue, expectedValue: CSSFontFamily.custom("Menlo")), "")
                    }
                    else {
                        XCTAssert(false, "fontSizeValue is nil")
                    }
                }
                else {
                    XCTAssert(false, "leftCurlyBraketElement is nil")
                }
            }
            else {
                XCTAssert(false, "stylingCssStyleSheet is nil")
            }
        }
        else {
            XCTAssert(false, "styledCssDocument is nil")
        }
        
    }
    
    
    func testFontFamilyCascadingComputedValueClassSelector() {
        
        let styledStyleSheetSource =    """

                                        body {
                                            font-family : Arial;
                                        }

                                        """;
        
        let stylingStyleSheetSource =   """

                                        font-family-name {
                                            font-family: Palatino;
                                        }
                                                           
                                        """;
        
        let styledSourceString = styledStyleSheetSource
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let styledCssDocument = getStyledCSSDOMDocument(sourceString: styledSourceString as NSString) {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                var style = CSSStyle(id: "test-style")
                style.addStyleSheet(stylingCssStyleSheet)
                
                let computedStyle = ResourceComputedStyle(styleDefinition: style)
                
                computedStyle.computeElementsStyles(document: styledCssDocument, filterContext: FilterContext())
                
                let expectedStyleRulesCount = 1
                
                // we should iterate in the document to find all the applicable (actual styles)
                
                let allDescendingNodes = styledCssDocument.descendants()
                
                let arialElements = styledCssDocument.getElementsByTagName("font-family-name")
                
                if let arialElement = arialElements.namedItem("font-family-name") {
                    
                    let arialElementElementRawComputedStyle = computedStyle.computedStyle(forElement: arialElement)! //
                        
//                        arialElement.rawComputedStyle
                    
                    if let fontFamilyValue = arialElementElementRawComputedStyle.propertyValues[§CSSProperty.fontFamily] {
                        
                        XCTAssert(validateFontFamilyActualValue(fontFamilyValue: fontFamilyValue, expectedValue: CSSFontFamily.custom("Palatino")), "")
                    }
                    else {
                        XCTAssert(false, "fontSizeValue is nil")
                    }
                }
                else {
                    XCTAssert(false, "arialElement is nil")
                }
            }
            else {
                XCTAssert(false, "stylingCssStyleSheet is nil")
            }
        }
        else {
            XCTAssert(false, "styledCssDocument is nil")
        }
    }

    func testFontFamilyCascadingComputedValueTypeSelector() {
        
        let styledStyleSheetSource =
        "                                                                                           " +
            "                  body {                                                                   " +
            "                      font-family : Arial;                                                 " +
        "                  }                                                                        ";
        
        let stylingStyleSheetSource =
        "                                                                                           " +
            "                  .ident-token {                                                     " +
            "                      font-family: Palatino;                                               " +
            "                  }                                                                        " +
            "                                                                                           " +
            "                                                                                           " +
        "                                                                                           ";
        
        let styledSourceString = styledStyleSheetSource
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let styledCssDocument = getStyledCSSDOMDocument(sourceString: styledSourceString as NSString) {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                var style = CSSStyle(id: "test-style")
                style.addStyleSheet(stylingCssStyleSheet)
                
                let computedStyle = ResourceComputedStyle(styleDefinition: style)
                
                computedStyle.computeElementsStyles(document: styledCssDocument, filterContext: FilterContext())
                
                let expectedStyleRulesCount = 1
                
                // we should iterate in the document to find all the applicable (actual styles)
                
                let allDescendingNodes = styledCssDocument.descendants()
                
                let arialElements = styledCssDocument.getElementsByTagName("font-family-name")
                
                if let arialElement = arialElements.namedItem("font-family-name") {
                    
                    let children = arialElement.children
                    
                    let tokenElement = children.namedItem("css-token")
                    
                    let tokenElementElementRawComputedStyle = computedStyle.computedStyle(forElement: tokenElement!)! //tokenElement!.rawComputedStyle
                    
                    if let fontFamilyValue = tokenElementElementRawComputedStyle.propertyValues[§CSSProperty.fontFamily] {
                        
                        XCTAssert(validateFontFamilyActualValue(fontFamilyValue: fontFamilyValue, expectedValue: CSSFontFamily.custom("Palatino")), "")
                    }
                    else {
                        XCTAssert(false, "fontSizeValue is nil")
                    }
                }
                else {
                    XCTAssert(false, "arialElement is nil")
                }
            }
            else {
                XCTAssert(false, "stylingCssStyleSheet is nil")
            }
        }
        else {
            XCTAssert(false, "styledCssDocument is nil")
        }
    }

    func testFontFamilyCascadingComputedValueStyleSheetSelector() {
        
        let styledStyleSheetSource =
        "                                                                                           " +
            "                  body {                                                                   " +
            "                      font-family : Arial;                                                 " +
        "                  }                                                                        ";
        
        let stylingStyleSheetSource =
        "                                                                                           " +
            "                  css-style-sheet {                                                     " +
            "                      font-family: Palatino;                                               " +
            "                  }                                                                        " +
            "                                                                                           " +
            "                                                                                           " +
        "                                                                                           ";
        
        let styledSourceString = styledStyleSheetSource
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let styledCssDocument = getStyledCSSDOMDocument(sourceString: styledSourceString as NSString) {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                var style = CSSStyle(id: "test-style")
                style.addStyleSheet(stylingCssStyleSheet)
                
                let computedStyle = ResourceComputedStyle(styleDefinition: style)
                
                computedStyle.computeElementsStyles(document: styledCssDocument, filterContext: FilterContext())
                
                let expectedStyleRulesCount = 1
                
                // we should iterate in the document to find all the applicable (actual styles)
                
                let allDescendingNodes = styledCssDocument.descendants()
                
                let arialElements = styledCssDocument.getElementsByTagName("font-family-name")
                
                if let arialElement = arialElements.namedItem("font-family-name") {
                    
                    let arialElementElementRawComputedStyle = computedStyle.computedStyle(forElement: arialElement)!//arialElement.rawComputedStyle
                    
                    if let fontFamilyValue = arialElementElementRawComputedStyle.propertyValues[§CSSProperty.fontFamily] {
                        
                        XCTAssert(validateFontFamilyActualValue(fontFamilyValue: fontFamilyValue, expectedValue: CSSFontFamily.custom("Palatino")), "")
                    }
                    else {
                        XCTAssert(false, "fontSizeValue is nil")
                    }
                }
                else {
                    XCTAssert(false, "arialElement is nil")
                }
            }
            else {
                XCTAssert(false, "stylingCssStyleSheet is nil")
            }
        }
        else {
            XCTAssert(false, "styledCssDocument is nil")
        }
    }

    func testGenericFontFamilySerif() {

        
        let styledStyleSheetSource =
        "                                                                                           " +
            "                  body {                                                                   " +
            "                      font-family : Arial;                                                 " +
        "                  }                                                                        ";
        
        let stylingStyleSheetSource =
        "                                                                                           " +
            "                  css-style-sheet {                                                     " +
            "                      font-family: Serif;                                               " +
            "                  }                                                                        " +
            "                                                                                           " +
            "                                                                                           " +
        "                                                                                           ";
        
        let styledSourceString = styledStyleSheetSource
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let styledCssDocument = getStyledCSSDOMDocument(sourceString: styledSourceString as NSString) {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                var style = CSSStyle(id: "test-style")
                style.addStyleSheet(stylingCssStyleSheet)
                
                let computedStyle = ResourceComputedStyle(styleDefinition: style)
                
                computedStyle.computeElementsStyles(document: styledCssDocument, filterContext: FilterContext())
                
                let expectedStyleRulesCount = 1
                
                // we should iterate in the document to find all the applicable (actual styles)
                
                let allDescendingNodes = styledCssDocument.descendants()
                
                let arialElements = styledCssDocument.getElementsByTagName("font-family-name")
                
                if let arialElement = arialElements.namedItem("font-family-name") {
                    
                    let arialElementElementRawComputedStyle = computedStyle.computedStyle(forElement: arialElement)!//arialElement.rawComputedStyle
                    
                    if let fontFamilyValue = arialElementElementRawComputedStyle.propertyValues[§CSSProperty.fontFamily] {
                        
                        XCTAssert(validateFontFamilyActualValue(fontFamilyValue: fontFamilyValue, expectedValue: CSSFontFamily.custom(§CSSFontFamilyKeyword.TimesNewRoman)), "")
                    }
                    else {
                        XCTAssert(false, "fontSizeValue is nil")
                    }
                }
                else {
                    XCTAssert(false, "arialElement is nil")
                }
            }
            else {
                XCTAssert(false, "stylingCssStyleSheet is nil")
            }
        }
        else {
            XCTAssert(false, "styledCssDocument is nil")
        }
    }
    
    /// Failing test
    func testCascadingPerformance2() {

        self.measure() {
            
            for _ in 1 ..< 20 {
                self.testFontFamilyCascadingComputedValueClassSelector()
                self.testFontFamilyCascadingComputedValueTypeSelector()
                self.testFontFamilyCascadingComputedValueStyleSheetSelector()
                self.testGenericFontFamilySerif()
            }
        }
    }

}
