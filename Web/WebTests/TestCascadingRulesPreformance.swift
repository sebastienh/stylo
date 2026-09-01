//
//  TestCascadingRulesPreformance.swift
//  Web
//
//  Created by Sebastien hamel on 2019-01-08.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Web

class TestCascadingRulesPreformance: TestCascading {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// test for NW-697
    func testTwoTimesSameProperty() {
        
        let stylingStyleSheetSource =   """

                                            body {
                                                font-size: 10px;
                                                font-size: 12px;
                                            }

                                        """;
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let styledDocument = buildBasicHtmlDocument() {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                var style = CSSStyle(id: "test-style")
                style.addStyleSheet(stylingCssStyleSheet)
                
                let computedStyle = ResourceComputedStyle(styleDefinition: style)
                
                computedStyle.computeElementsStyles(document: styledDocument, filterContext: FilterContext())
                
                // we should iterate in the document to find all the applicable (actual styles)
                
                // style-declaration assertions
                let h1Elements = styledDocument.getElementsByTagName("h1")
                let h1Element = h1Elements.namedItem("h1")!
                let p1Element = h1Element.followingNode() as! HTMLParagraphElement
                
                let h2Elements = styledDocument.getElementsByTagName("h2")
                let h2Element = h2Elements.namedItem("h2")!
                let p2Element = h2Element.followingNode() as! HTMLParagraphElement
                
                // h1 font-size should be 12px
                let h1ElementRawComputedStyle = computedStyle.computedStyle(forElement: h1Element)! //h1Element.rawComputedStyle
                if let fontSizeValue = h1ElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                    validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 12)
                }
                else {
                    XCTAssert(false, "fontSizeValue is nil")
                }
                
                // p1 font-size should be 12px
                let p1ElementRawComputedStyle = computedStyle.computedStyle(forElement: p1Element)! //p1Element.rawComputedStyle
                if let fontSizeValue = p1ElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                    validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 12)
                }
                else {
                    XCTAssert(false, "fontSizeValue is nil")
                }
                
                // h2 font-size should be 12px
                let h2ElementRawComputedStyle = computedStyle.computedStyle(forElement: h2Element)! // h2Element.rawComputedStyle
                if let fontSizeValue = h2ElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                    validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 12)
                }
                else {
                    XCTAssert(false, "fontSizeValue is nil")
                }
                
                // p2 font-size should be 12px
                let p2ElementRawComputedStyle = computedStyle.computedStyle(forElement: p2Element)! //p2Element.rawComputedStyle
                if let fontSizeValue = p2ElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                    validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 12)
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
    
    func testCascadingPerformanceForLongDocumentWithoutFollowingSiblingSelector() {
        
        let htmlDocument = HtmlDocument.Create("test-document")!
        var exception = Exception()
        
        var queries: [ContiguousArray<Element>]? = [ContiguousArray<Element>]()
        
        if let body = htmlDocument.body {
            
            // it must stay at 800
            for _ in 0..<800 {
                
                let elements = buildParagraphPartDocument(htmlDocument: htmlDocument)
                for element in elements {
                    body.append(element, exception: &exception)
                }
                queries!.append(elements)
            }
        }
        
        let stylingStyleSheetSource =   """

                                            body {
                                                background-color: pink;
                                            }
                                                
                                            h1 {
                                                font-size: 14px;
                                                color: red;
                                            }

                                            h2 {
                                                font-size: 10px;
                                                color: blue;
                                            }

                                            span {
                                                font-size: 10px;
                                                color: blue;
                                            }

                                        """;
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
            
            var style = CSSStyle(id: "test-style")
            style.addStyleSheet(stylingCssStyleSheet)
            
            let computedStyle = ResourceComputedStyle(styleDefinition: style)
            
            self.measure() {
                for query in queries! {
                    computedStyle.computeElementsStyles(forRootElements: query, document: htmlDocument, filterContext: FilterContext())
                }
            }
            queries = nil
        }
    }
    
    func testCascadingPerformanceForLongDocumentWithoutFollowingSiblingSelector2() {
        
        let htmlDocument = HtmlDocument.Create("test-document")!
        var exception = Exception()
        
        var queries: [ContiguousArray<Element>]? = [ContiguousArray<Element>]()
        
        if let body = htmlDocument.body {
            
            // it must stay at 800
            for _ in 0..<800 {
                
                let elements = buildParagraphPartDocument(htmlDocument: htmlDocument)
                
                for element in elements {
                    body.append(element, exception: &exception)
                }
                queries!.append(elements)
            }
        }
        
        let stylingStyleSheetSource =   """

                                            body {
                                                background-color: pink;
                                            }
                                                
                                            h1 {
                                                font-size: 14px;
                                                color: red;
                                            }

                                            h2 {
                                                font-size: 10px;
                                                color: blue;
                                            }

                                            span {
                                                font-size: 10px;
                                                color: blue;
                                            }

                                        """;
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
            
            var style = CSSStyle(id: "test-style")
            style.addStyleSheet(stylingCssStyleSheet)
            
            let computedStyle = ResourceComputedStyle(styleDefinition: style)
            
            self.measure() {
                for query in queries! {
                    computedStyle.computeElementsStyles(forRootElements: query, document: htmlDocument, filterContext: FilterContext())
                }
            }
            queries = nil
        }
    }

    func testCascadingPerformanceForLongDocumentWithoutFollowingSiblingSelector3() {
        
        let htmlDocument = HtmlDocument.Create("test-document")!
        var exception = Exception()
        
        var query: ContiguousArray<Element> = ContiguousArray<Element>()
        
        if let body = htmlDocument.body {
        
            // it must stay at 800
            for _ in 0..<800 {
                
                let elements = buildParagraphPartDocument(htmlDocument: htmlDocument)
                
                for element in elements {
                    body.append(element, exception: &exception)
                }
                query.append(contentsOf: elements)
            }
        }
        
        let stylingStyleSheetSource =   """

                                            body {
                                                background-color: pink;
                                            }
                                                
                                            h1 {
                                                font-size: 14px;
                                                color: red;
                                            }

                                            h2 {
                                                font-size: 10px;
                                                color: blue;
                                            }

                                            span {
                                                font-size: 10px;
                                                color: blue;
                                            }

                                        """;
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
            
            var style = CSSStyle(id: "test-style")
            style.addStyleSheet(stylingCssStyleSheet)
            
            let computedStyle = ResourceComputedStyle(styleDefinition: style)
            
            self.measure() {
                //                for query in queries! {
                computedStyle.computeElementsStyles(forRootElements: query, document: htmlDocument, filterContext: FilterContext())
                //                }
            }
        }
    }
    
    func testCascadingPerformanceForLongDocumentWithFollowingSiblingSelector() {
        
        let htmlDocument = HtmlDocument.Create("test-document")!
        var exception = Exception()
        
        var queries: [ContiguousArray<Element>]? = [ContiguousArray<Element>]()
        
        if let body = htmlDocument.body {
            
            // it must stay at 100
            for _ in 0..<100 {
                
                let elements = buildParagraphPartDocument(htmlDocument: htmlDocument)
                for element in elements {
                    body.append(element, exception: &exception)
                }
                queries!.append(elements)
            }
        }
        
        let stylingStyleSheetSource =   """

                                            body {
                                                background-color: pink;
                                            }
                                                
                                            p ~ h1 {
                                                font-size: 14px;
                                                color: red;
                                            }

                                            h2 {
                                                font-size: 10px;
                                                color: blue;
                                            }

                                            span {
                                                font-size: 10px;
                                                color: blue;
                                            }

                                        """;
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
            
            var style = CSSStyle(id: "test-style")
            style.addStyleSheet(stylingCssStyleSheet)
            
            let computedStyle = ResourceComputedStyle(styleDefinition: style)
            
            self.measure() {
                for query in queries! {
                    computedStyle.computeElementsStyles(forRootElements: query, document: htmlDocument, filterContext: FilterContext())
                }
            }
            queries = nil
        }
    }
    
    func testCascadingPerformanceForLongDocumentWithFollowingSiblingSelector2() {
        
        let htmlDocument = HtmlDocument.Create("test-document")!
        var exception = Exception()
        
        var queries: [ContiguousArray<Element>]? = [ContiguousArray<Element>]()
        
        if let body = htmlDocument.body {
            
            // it must stay at 500
            for _ in 0..<500 {
                
                let elements = buildParagraphPartDocument(htmlDocument: htmlDocument)
                for element in elements {
                    body.append(element, exception: &exception)
                }
                queries!.append(elements)
            }
        }
        
        let stylingStyleSheetSource =   """

                                            body {
                                                background-color: pink;
                                            }
                                                
                                            p ~ h1 {
                                                font-size: 14px;
                                                color: red;
                                            }

                                            h2 {
                                                font-size: 10px;
                                                color: blue;
                                            }

                                            span {
                                                font-size: 10px;
                                                color: blue;
                                            }

                                        """;
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
            
            var style = CSSStyle(id: "test-style")
            style.addStyleSheet(stylingCssStyleSheet)
            
            let computedStyle = ResourceComputedStyle(styleDefinition: style)
            let filterContext = FilterContext()
            self.measure() {
                for query in queries! {
                    computedStyle.computeElementsStyles(forRootElements: query, document: htmlDocument, filterContext: filterContext)
                }
            }
            queries = nil
        }
    }
    
    private func buildParagraphPartDocument(htmlDocument: HtmlDocument) -> ContiguousArray<Element> {
        
        var elements = ContiguousArray<Element>()
        
        // h1
        elements.append(HTMLHeadingElement(document: htmlDocument, localName: "h1"))
        
        // p
        elements.append(buildParagraphElement(htmlDocument: htmlDocument))
        
        // h2
        elements.append(HTMLHeadingElement(document: htmlDocument, localName: "h2"))
        
        // p
        elements.append(buildParagraphElement(htmlDocument: htmlDocument))
        
        // p
        elements.append(buildParagraphElement(htmlDocument: htmlDocument))
        
        // p
        elements.append(buildParagraphElement(htmlDocument: htmlDocument))
        
        // h2
        elements.append(HTMLHeadingElement(document: htmlDocument, localName: "h2"))
        
        // p
        elements.append(buildParagraphElement(htmlDocument: htmlDocument))
        
        // p
        elements.append(buildParagraphElement(htmlDocument: htmlDocument))
        
        // h2
        elements.append(HTMLHeadingElement(document: htmlDocument, localName: "h2"))
        
        // p
        elements.append(buildParagraphElement(htmlDocument: htmlDocument))
        
        // p
        elements.append(buildParagraphElement(htmlDocument: htmlDocument))
        
        // p
        elements.append(buildParagraphElement(htmlDocument: htmlDocument))
        
        // h2
        elements.append(HTMLHeadingElement(document: htmlDocument, localName: "h2"))
        
        // p
        elements.append(buildParagraphElement(htmlDocument: htmlDocument))
        
        // p
        elements.append(buildParagraphElement(htmlDocument: htmlDocument))
        
        // p
        elements.append(buildParagraphElement(htmlDocument: htmlDocument))
        
        return elements
    }
    
    func buildParagraphElement(htmlDocument: HtmlDocument) -> HTMLParagraphElement {
        
        let p = HTMLParagraphElement(document: htmlDocument)
        var exception = Exception()
        
        let strong1 = HTMLSpanElement(document: htmlDocument)
        p.append(strong1, exception: &exception)
        
        let strong2 = HTMLSpanElement(document: htmlDocument)
        p.append(strong2, exception: &exception)
        
        return p
    }
    
}
