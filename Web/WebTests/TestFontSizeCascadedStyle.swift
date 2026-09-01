//
//  TestFontSizeCascadedStyle.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-28.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
import Common
@testable import Web

class TestFontSizeCascadedStyle: TestCascading {

    func testFontSizeNegativeValue() {
        
        let styledStyleSheetSource = """
                              
                              body {
                                  font-family : Arial;
                              }

                              """;
        
        let stylingStyleSheetSource = """

                              css-style-sheet {
                                  font-size: -10px;
                              }
                              
                              style-declaration-block {
                                   font-size: 12px;
                              }
                              
                              .font-family {
                                  font-size: 6px;
                              }
                              
                              .font-family {
                                  font-size: 8px;
                              }
                              
                              property-value {
                                  font-size: 12px;
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
                
                // we should iterate in the document to find all the applicable (actual styles)
                
                // body element assertions
                let stylesheetsElements = styledCssDocument.getElementsByTagName("css-style-sheet", inclusive: true)
                
                if let stylesheetsElement = stylesheetsElements.namedItem("css-style-sheet") {
                    
                    let stylesheetsElementRawComputedStyle = computedStyle.computedStyle(forElement: stylesheetsElement)!//stylesheetsElement.rawComputedStyle  //computedStyle.computedStyle(forElement:bodyElement)!
                    
                    if let fontSizeValue = stylesheetsElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                        
                        validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 0)
                    }
                    else {
                        XCTAssert(false, "fontSizeDeclaration is nil")
                    }
                }
                else {
                    XCTAssert(false, "bodyElement is nil")
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
    
    
    
    
    func testFontSizeComputedValue() {
        
        let styledStyleSheetSource = """
                              
                              body {
                                  font-family : Arial;
                              }

                              """;
        
        let stylingStyleSheetSource = """

                              css-style-sheet {
                                  font-size: 34px;
                              }
                              
                              style-declaration-block {
                                   font-size: 12px;
                              }
                              
                              .font-family {
                                  font-size: 6px;
                              }
                              
                              .font-family {
                                  font-size: 8px;
                              }
                              
                              property-value {
                                  font-size: 12px;
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
                
                // we should iterate in the document to find all the applicable (actual styles)
                
                // body element assertions
                let stylesheetsElements = styledCssDocument.getElementsByTagName("css-style-sheet", inclusive: true)
                
                if let stylesheetsElement = stylesheetsElements.namedItem("css-style-sheet") {
                    
                    let stylesheetsElementRawComputedStyle = computedStyle.computedStyle(forElement: stylesheetsElement)!//stylesheetsElement.rawComputedStyle  //computedStyle.computedStyle(forElement:bodyElement)!
                    
                    if let fontSizeValue = stylesheetsElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                        
                        validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 34)
                    }
                    else {
                        XCTAssert(false, "fontSizeDeclaration is nil")
                    }
                }
                else {
                    XCTAssert(false, "bodyElement is nil")
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
    
 
    
    
    
    func testFontSizeCascadingComputedValue() {
        
        let styledStyleSheetSource = """
                              
                              body {
                                  font-family : Arial;
                              }

                              """;
        
        let stylingStyleSheetSource = """

                              css-style-sheet {
                                  font-size: 34px;
                              }
                              
                              style-declaration-block {
                                   font-size: 12px;
                              }
                              
                              .font-family {
                                  font-size: 6px;
                              }
                              
                              .font-family {
                                  font-size: 8px;
                              }
                              
                              property-value {
                                  font-size: 12px;
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
                
                let expectedStyleRulesCount = 5
                
                // we should iterate in the document to find all the applicable (actual styles)
                
                // body element assertions
                let bodyElements = styledCssDocument.getElementsByTagName("type-selector")
                
                if let bodyElement = bodyElements.namedItem("type-selector") {
                    
                    let bodyElementRawComputedStyle = computedStyle.computedStyle(forElement:bodyElement)!
                    
                    if let fontSizeValue = bodyElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                        
                        validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 34)
                    }
                    else {
                        XCTAssert(false, "fontSizeDeclaration is nil")
                    }
                }
                else {
                    XCTAssert(false, "bodyElement is nil")
                }
                
                // font-family assertions
                let fontFamilyElements = styledCssDocument.getElementsByTagName("property-name")
                
                if let fontFamilyElement = fontFamilyElements.namedItem("property-name") {
                
                    let fontFamilyElementRawComputedStyle = computedStyle.computedStyle(forElement: fontFamilyElement)!
//                        fontFamilyElement.rawComputedStyle
                    
                    if let fontSizeValue = fontFamilyElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                        
                        validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 12)
                    }
                    else {
                        XCTAssert(false, "fontSizeValue is nil")
                    }
                    
                    // digg a little deeper for the token
                    let children = fontFamilyElement.children
                    
                    if let tokenElement = children.namedItem("css-token") {
                        
                        let tokenElementRawComputedStyle = computedStyle.computedStyle(forElement: tokenElement)!
//                            tokenElement.rawComputedStyle
                        
                        if let fontSizeValue = tokenElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                            
                            validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 8)
                        }
                        else {
                            
                            XCTAssert(false, "fontSizeValue is nil")
                        }
                    }
                    else {
                        XCTAssert(false, "tokenElement is nil")
                    }
                }
                else {
                    XCTAssert(false, "fontFamilyElement is nil")
                }
                
                
                let allDescendingNodes = styledCssDocument.descendants()
                
                let arialElements = styledCssDocument.getElementsByTagName("font-family-name")
                
                if let arialElement = arialElements.namedItem("font-family-name") {
                    
                    // digg a little deeper for the token
                    let children = arialElement.children
                    
                    if let tokenElement = children.namedItem("css-token") {
                    
                        let arialElementElementRawComputedStyle = computedStyle.computedStyle(forElement: tokenElement)!
//                            tokenElement.rawComputedStyle
                        
                        if let fontSizeValue = arialElementElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                            
                            validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 12)
                        }
                        else {
                            XCTAssert(false, "fontSizeValue is nil")
                        }
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
    
    func testFontSizeCascadingComputedValueFromCmAndAdjacentSiblingSelector() {
        
        let styledStyleSheetSource =    """
                                            body {
                                                font-family : Arial;
                                            }
                                        """;
        
        let stylingStyleSheetSource =   """
                                            style-declaration-block {
                                                font-size: 2cm;
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
                
                // we should iterate in the document to find all the applicable (actual styles)
                
                // style-declaration assertions
                let styleDeclarationElements = styledCssDocument.getElementsByTagName("style-declaration-block")
                
                if let styleDeclarationElement = styleDeclarationElements.namedItem("style-declaration-block") {
                    
                    let styleDeclarationElementRawComputedStyle = computedStyle.computedStyle(forElement: styleDeclarationElement)!
//                        styleDeclarationElement.rawComputedStyle
                    
                    if let fontSizeValue = styleDeclarationElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                        
                        validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 96*2/2.54)
                    }
                    else {
                        XCTAssert(false, "fontSizeValue is nil")
                    }
                }
                else {
                    XCTAssert(false, "fontFamilyElement is nil")
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

    ///
    /// validate the two attributes selector together e.g. [nw-message-id="test"][severity="error"]
    ///
    func testTwoAttributesSelection() {
        
        let styledStyleSheetSource =    """
                                            body {
                                                color : blues;
                                            }
                                        """;
        
        let stylingStyleSheetSource =   """

                                            css-style-sheet {
                                                font-size: 14px;
                                            }

                                            [nw-element-id][text-value="blues"] {
                                                font-size: 2cm;
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
                
                // we should iterate in the document to find all the applicable (actual styles)
                
                // style-declaration assertions
                let colorValueElements = styledCssDocument.getElementsByTagName("color-value")
                
                if let colorValueElement = colorValueElements.namedItem("color-value") {
                    
                    let children = colorValueElement.children
                    
                    XCTAssert(children.length == 1)
                    
                    if let tokenElement = children.namedItem("css-token") {
                        
                        let arialElementElementRawComputedStyle = computedStyle.computedStyle(forElement: tokenElement)!
//                            tokenElement.rawComputedStyle
                        
                        if let fontSizeValue = arialElementElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                            
                            validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 96*2/2.54)
                        }
                        else {
                            XCTAssert(false, "fontSizeValue is nil")
                        }
                    }
                }
                else {
                    XCTAssert(false, "fontFamilyElement is nil")
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
    
    ///
    /// validate attribute and class selector together e.g. [nw-message-id="test"].error
    ///
    func testAttributeAndClassSelection() {
        
        let styledStyleSheetSource =    """
                                            body {
                                                color : blues;
                                            }
                                        """;
        
        let stylingStyleSheetSource =   """

                                            css-style-sheet {
                                                font-size: 14px;
                                            }

                                            [nw-element-id].ident-token {
                                                font-size: 2cm;
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
                
                // we should iterate in the document to find all the applicable (actual styles)
                
                // style-declaration assertions
                let colorValueElements = styledCssDocument.getElementsByTagName("color-value")
                
                if let colorValueElement = colorValueElements.namedItem("color-value") {
                    
                    let children = colorValueElement.children
                    
                    XCTAssert(children.length == 1)
                    
                    if let tokenElement = children.namedItem("css-token") {
                        
                        let arialElementElementRawComputedStyle = computedStyle.computedStyle(forElement: tokenElement)!//tokenElement.rawComputedStyle
                        
                        if let fontSizeValue = arialElementElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                            
                            validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 96*2/2.54)
                        }
                        else {
                            XCTAssert(false, "fontSizeValue is nil")
                        }
                    }
                }
                else {
                    XCTAssert(false, "fontFamilyElement is nil")
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
    
    /// test for NW-291
    func testAdjacentSibling() {
        
        let stylingStyleSheetSource =   """

            h1 {
                font-size: 14px;
            }

            h2 {
                font-size: 10px;
            }

            h1+p {
                font-size: 12px;
            }

            h2+p {
                font-size: 8px;
            }

        """;
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let styledDocument = buildBasicHtmlDocument() {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                var style = CSSStyle(id: "test-style")
                style.addStyleSheet(stylingCssStyleSheet)
                
                let computedStyle = ResourceComputedStyle(styleDefinition: style)
                
                let filterContext = FilterContext()
                
                computedStyle.computeElementsStyles(document: styledDocument, filterContext: filterContext)
                
                // we should iterate in the document to find all the applicable (actual styles)
                
                // style-declaration assertions
                let h1Elements = styledDocument.getElementsByTagName("h1")
                let h1Element = h1Elements.namedItem("h1")!
                let p1Element = h1Element.followingNode() as! HTMLParagraphElement
                
                let h2Elements = styledDocument.getElementsByTagName("h2")
                let h2Element = h2Elements.namedItem("h2")!
                let p2Element = h2Element.followingNode() as! HTMLParagraphElement
                
                // h1 font-size should be 14px
                let h1ElementRawComputedStyle = computedStyle.computedStyle(forElement: h1Element, filterContext: filterContext)
                if let fontSizeValue = h1ElementRawComputedStyle!.propertyValues[§CSSProperty.fontSize] {
                    validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 14)
                }
                else {
                    XCTAssert(false, "fontSizeValue is nil")
                }
                
                // h1+p font-size should be 12px
                let p1ElementRawComputedStyle = computedStyle.computedStyle(forElement: p1Element, filterContext: filterContext)
                if let fontSizeValue = p1ElementRawComputedStyle!.propertyValues[§CSSProperty.fontSize] {
                    validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 12)
                }
                else {
                    XCTAssert(false, "fontSizeValue is nil")
                }

                // h2 font-size should be 10px
                let h2ElementRawComputedStyle = computedStyle.computedStyle(forElement: h2Element, filterContext: filterContext)
                if let fontSizeValue = h2ElementRawComputedStyle!.propertyValues[§CSSProperty.fontSize] {
                    validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 10)
                }
                else {
                    XCTAssert(false, "fontSizeValue is nil")
                }

                // h2+p font-size should be 8px
                let p2ElementRawComputedStyle = computedStyle.computedStyle(forElement: p2Element, filterContext: filterContext)
                if let fontSizeValue = p2ElementRawComputedStyle!.propertyValues[§CSSProperty.fontSize] {
                    validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 8)
                }
                else {
                    XCTAssert(false, "fontSizeValue is nil")
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
    
    func testFontSizeCascadedValue() {
        
        let styledStyleSheetSource = """
                              
                              body {
                                  font-family : Arial;
                              }

                              """;
        
        let stylingStyleSheetSource = """

                              css-style-sheet,
                              style-declaration-block::first-letter,
                              .font-family css-token {
                                  font-size: 14px;
                              }
                              
                              style-declaration-block {
                                   font-size: 12px;
                              }
                              
                              .font-family {
                                  font-size: 6px;
                              }
                              
                              .font-family {
                                  font-size: 8px;
                              }
                              
                              property-value {
                                  font-size: 12px;
                              }

                              css-style-sheet {
                                  font-size: 34px;
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
                
                // we should iterate in the document to find all the applicable (actual styles)
                
                // body element assertions
                let stylesheetsElements = styledCssDocument.getElementsByTagName("css-style-sheet", inclusive: true)
                
                if let stylesheetsElement = stylesheetsElements.namedItem("css-style-sheet") {
                    
                    let stylesheetsElementRawComputedStyle = computedStyle.computedStyle(forElement: stylesheetsElement)!
                    
                    if let fontSizeValue = stylesheetsElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                        
                        validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 34)
                    }
                    else {
                        XCTAssert(false, "fontSizeDeclaration is nil")
                    }
                }
                else {
                    XCTAssert(false, "bodyElement is nil")
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
    
    
    func testPerformance() {

        self.measure() {
            self.testFontSizeCascadingComputedValue()
        }
    }
 
 
    
    
}
