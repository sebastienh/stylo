//
//  TextDecorationLineTests.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-06-26.
//  Copyright © 2018 NM. All rights reserved.
//

import XCTest
import Common
@testable import Web

class TextDecorationLineTests: TestCascading {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /// Validate that the element h2 does not inherit value for text-decoration-line
    /// from the body since text-decoration-line is not an inherited value.
    func testTextDecorationLineAttributeCascading1() {
        
        let stylingStyleSheetSource =   """
            [code="invalidDeclaration"] {
                text-decoration-line: line-through !important;
                text-decoration-style: solid !important;
                text-decoration-color: red !important;
            }
            """;
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let styledDocument = buildBasicHtmlDocument() {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                var style = CSSStyle(id: "test-style")
                style.addStyleSheet(stylingCssStyleSheet)
                
                let computedStyle = ResourceComputedStyle(styleDefinition: style)
                
                computedStyle.computeElementsStyles(document: styledDocument, filterContext: FilterContext(focusMode: .disabled))
                
                // we should iterate in the document to find all the applicable (actual styles)
                let h2Elements = styledDocument.getElementsByTagName("h2")
                let h2Element = h2Elements.namedItem("h2")!
                let h2ElementRawComputedStyle = computedStyle.computedStyle(forElement: h2Element)! // h2Element.rawComputedStyle
                
                // h2 text-decoration-line should be CSSTextDecorationLineType.noUnderline
                // since text-decoration-line is not an inherited property
                if let textDecorationLineValue = h2ElementRawComputedStyle.propertyValues[§CSSProperty.textDecorationLine] {
                    
                    validateTextDecorationLineActualValue(textDecorationLineValue: textDecorationLineValue, expectedValue: CSSTextDecorationLineType.noUnderline)
                }
                else {
                    XCTAssert(false, "textDecorationLineValue is nil")
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

    /// Validate that the element h2 does not inherit value for text-decoration-line
    /// from the body since text-decoration-line is not an inherited value.
    func testTextDecorationLineClassCascading1() {
        
        let stylingStyleSheetSource =   """

            .invalidDeclaration {
                text-decoration-line: line-through !important;
                text-decoration-style: solid !important;
                text-decoration-color: red !important;
            }

            """;
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let styledDocument = buildBasicHtmlDocument2() {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                var style = CSSStyle(id: "test-style")
                style.addStyleSheet(stylingCssStyleSheet)
                
                let computedStyle = ResourceComputedStyle(styleDefinition: style)
                
                computedStyle.computeElementsStyles(document: styledDocument, filterContext: FilterContext(focusMode: .disabled))
                
                // we should iterate in the document to find all the applicable (actual styles)

                let h2Elements = styledDocument.getElementsByTagName("h2")
                let h2Element = h2Elements.namedItem("h2")!
                let h2ElementRawComputedStyle = computedStyle.computedStyle(forElement: h2Element)!// h2Element.rawComputedStyle
                
                // h2 text-decoration-line should be CSSTextDecorationLineType.noUnderline
                // since text-decoration-line is not an inherited property
                if let textDecorationLineValue = h2ElementRawComputedStyle.propertyValues[§CSSProperty.textDecorationLine] {
                    
                    validateTextDecorationLineActualValue(textDecorationLineValue: textDecorationLineValue, expectedValue: CSSTextDecorationLineType.noUnderline)
                }
                else {
                    XCTAssert(false, "textDecorationLineValue is nil")
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
    
    /// Validate that the element h2 does not inherit value for text-decoration-line
    /// from the body since text-decoration-line is not an inherited value.
    func testTextDecorationLineAttributeCascading2() {
        
        let stylingStyleSheetSource =   """
            p {
                text-decoration-color: blueviolet;
                text-decoration-line: underline;
                text-decoration-style: solid;
            }

            blockquote p {
                color: red;
                text-decoration-line: none;
            }
            """;
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let styledDocument = buildBasicHtmlDocument3() {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                var style = CSSStyle(id: "test-style")
                style.addStyleSheet(stylingCssStyleSheet)
                
                let computedStyle = ResourceComputedStyle(styleDefinition: style)
                
                computedStyle.computeElementsStyles(document: styledDocument, filterContext: FilterContext(focusMode: .disabled))
                
                // we should iterate in the document to find all the applicable (actual styles)
                let pElements = styledDocument.getElementsByTagName("p")
                let pElement = pElements.namedItem("p")!
                let pElementRawComputedStyle = computedStyle.computedStyle(forElement: pElement)! //pElement.rawComputedStyle
                
                // h2 text-decoration-line should be CSSTextDecorationLineType.noUnderline
                // since text-decoration-line is not an inherited property
                if let textDecorationLineValue = pElementRawComputedStyle.propertyValues[§CSSProperty.textDecorationLine] {
                    
                    validateTextDecorationLineActualValue(textDecorationLineValue: textDecorationLineValue, expectedValue: CSSTextDecorationLineType.noUnderline)
                }
                else {
                    XCTAssert(false, "textDecorationLineValue is nil")
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
    
    override func buildBasicHtmlDocument() -> HtmlDocument? {
        
        let htmlDocument = HtmlDocument.Create("test-document")
        
        if let body = htmlDocument?.body {
            
            var exception = Exception()

            // h2
            let h2 = HTMLHeadingElement(document: htmlDocument, localName: "h2")
            
            body.append(h2, exception: &exception)
            body.setAttributeValue("code", value: "invalidDeclaration")
        }
        
        return htmlDocument
    }
    
    func buildBasicHtmlDocument2() -> HtmlDocument? {
        
        let htmlDocument = HtmlDocument.Create("test-document")
        
        if let body = htmlDocument?.body {
            
            var exception = Exception()

            // h2
            let h2 = HTMLHeadingElement(document: htmlDocument, localName: "h2")
            
            body.append(h2, exception: &exception)
            body.addClassAttribute("invalidDeclaration")
        }
        
        return htmlDocument
    }
    
    func buildBasicHtmlDocument3() -> HtmlDocument? {
        
        let htmlDocument = HtmlDocument.Create("test-document")
        
        if let body = htmlDocument?.body {
            
            var exception = Exception()
            
            // h2
            let quote = HTMLQuoteElement(document: htmlDocument)
            
            let paragraphaElement = HTMLParagraphElement(document: htmlDocument)
            
            quote.append(paragraphaElement, exception: &exception)
            
            body.append(quote, exception: &exception)
        }
        
        return htmlDocument
    }
    
}
