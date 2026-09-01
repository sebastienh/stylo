//
//  TestCascadingAndInheritanceModule.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-05.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
import Common
@testable import Web

class TestElementsApplicableStyleRules: TestCascading {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testElementTypeSelector() {
        
        let styledStyleSheetSource = """
           body {
              font-family: Arial;
           }
        """;
        
        let stylingStyleSheetSource = """
            css-declaration {
                font-family: Times New Roman;
            }
        """;
        
        let styledSourceString = styledStyleSheetSource
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let styledCssDocument = getStyledCSSDOMDocument(sourceString: styledSourceString as NSString) {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                let expectedElementsCount = 1
                
                let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
                
                let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
                
                let collection = styledCssDocument.getElementsByTagName("css-declaration")
                
                XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
                if let element = collection.elements.first {
                    
                    let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: ContiguousArray<Element>(arrayLiteral: element), filterContext: FilterContext(focusMode: .disabled))
                    
                    let styleApplicable = applicableStyleRules[element]!
                    
                    XCTAssert(styleApplicable.rules.count == expectedElementsCount, "expected: \(expectedElementsCount), received: \(applicableStyleRules.count)")
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
    
    
    
    func testElementDescendantCombinator() {
        
        let styledStyleSheetSource = """
            body {
                font-family : Arial;
            }
        """;
        
        let stylingStyleSheetSource = """
            css-declaration font-family-name {
                font-family: Times New Roman;
            }
        """;
        
        let styledSourceString = styledStyleSheetSource
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let styledCssDocument = getStyledCSSDOMDocument(sourceString: styledSourceString as NSString) {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                let expectedStyleRulesCount = 1
                
                let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
                
                let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
                
                let collection = styledCssDocument.getElementsByTagName("font-family-name")
                
                XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
                if let element = collection.elements.first {
                    
                    let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: ContiguousArray<Element>(arrayLiteral: element), filterContext: FilterContext(focusMode: .disabled))
                    
                    let styleApplicable = applicableStyleRules[element]!
                    
                    XCTAssert(styleApplicable.rules.count == expectedStyleRulesCount, "expected: \(expectedStyleRulesCount), received: \(applicableStyleRules.count)")
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
    
    func testEphemeralPseudoClassNotReturned() {
        
        let stylingSourceString = """
            body {
                color: red;
            }

            body:focus {
                font-family: Times New Roman;
            }
         """;
        
        if let styledDocument = self.buildHtmlDocument() {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                let expectedStyleRulesCount = 1
                
                let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
                
                let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
                
                let collection = styledDocument.getElementsByTagName("body")
                
                XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
                if let element = collection.elements.first {
                    
                    let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: ContiguousArray<Element>(arrayLiteral: element), filterContext: FilterContext())
                    
                    let styleApplicable = applicableStyleRules[element]!
                    
                    XCTAssert(styleApplicable.rules.count == expectedStyleRulesCount, "expected: \(expectedStyleRulesCount), received: \(applicableStyleRules.count)")
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
    
    func testOneEphemeralPseudoClassReturned() {
        
        let stylingSourceString = """

            body {
                color: red;
            }

            body:focus {
                font-family: Times New Roman;
            }
         """;
        
        let styledDocument = self.buildHtmlDocument()!
        
        let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString)!
        
        let expectedStyleRulesCount = 2
        
        let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
        
        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
        
        let collection = styledDocument.getElementsByTagName("body")
        
        XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
        if let element = collection.elements.first {
            
            var filterContext = FilterContext()
            filterContext.updatePseudoClassesOptions(forElement: element, with: .focus)
            
            let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: ContiguousArray<Element>(arrayLiteral: element), filterContext: filterContext)
            
            let styleApplicable = applicableStyleRules[element]!
            
            XCTAssert(styleApplicable.rules.count == expectedStyleRulesCount, "expected: \(expectedStyleRulesCount), received: \(applicableStyleRules.count)")
        }
    }
    
    func testOneEphemeralPseudoClassReturnedForPseudos() {
        
        let stylingSourceString = """

            body {
                color: red;
            }

            h1.test::tag {
                color: blue;
            }

            h1::tag:focus {
                color: green;
            }

         """;
        
        let styledDocument = self.buildHtmlDocument()!
        
        let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString)!
        
        let expectedStyleRulesCount = 2
        
        let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
        
        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
        
        let collection = styledDocument.getElementsByTagName("h1")
        
        XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
        if let element = collection.elements.first {
            
            var filterContext = FilterContext()
            filterContext.updatePseudoClassesOptions(forElement: element, with: .focus)
            
            let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: ContiguousArray<Element>(arrayLiteral: element), filterContext: filterContext)
            
            let styleApplicable = applicableStyleRules[element]!
            
            XCTAssert(styleApplicable.pseudoRules["tag"]?.rules.count == expectedStyleRulesCount, "expected: \(expectedStyleRulesCount), received: \(applicableStyleRules.count)")
        }
    }
    
    
    func testOneEphemeralPseudoClassReturnedForPseudos2() {
        
        let stylingSourceString = """

            body {
                color: red;
            }

            :focus {
                color: blue;
            }

            blockquote p:focus {
                color: green;
            }

         """;
        
        let styledDocument = self.buildBlockquoteHtmlDocument()!
        
        let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString)!
        
        let expectedStyleRulesCount = 2
        
        let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
        
        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
        
        let collection = styledDocument.getElementsByTagName("p")
        
        XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
        if let element = collection.elements.first {
            
            var filterContext = FilterContext()
            filterContext.updatePseudoClassesOptions(forElement: element, with: .focus)
            
            let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: ContiguousArray<Element>(arrayLiteral: element), filterContext: filterContext)
            
            let styleApplicable = applicableStyleRules[element]!
            
            XCTAssert(styleApplicable.rules.count == expectedStyleRulesCount, "expected: \(expectedStyleRulesCount), received: \(applicableStyleRules.count)")
        }
    }
    
    func testOneEphemeralPseudoClassReturnedForFlash() {
        
        let stylingSourceString = """

            body {
                color: red;
            }

            :flash {
                color: blue;
            }

            blockquote p:flash {
                color: green;
            }

         """;
        
        let styledDocument = self.buildBlockquoteHtmlDocument()!
        
        let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString)!
        
        let expectedStyleRulesCount = 2
        
        let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
        
        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
        
        let collection = styledDocument.getElementsByTagName("p")
        
        XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
        if let element = collection.elements.first {
            
            var filterContext = FilterContext()
            filterContext.updatePseudoClassesOptions(forElement: element, with: .flash)
            
            let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: ContiguousArray<Element>(arrayLiteral: element), filterContext: filterContext)
            
            let styleApplicable = applicableStyleRules[element]!
            
            XCTAssert(styleApplicable.rules.count == expectedStyleRulesCount, "expected: \(expectedStyleRulesCount), received: \(applicableStyleRules.count)")
        }
    }
    
    func testOneEphemeralPseudoClassReturnedForFocusAndHighlight() {
        
        let stylingSourceString = """

            body {
                color: red;
            }

            :focus {
                color: blue;
            }

            blockquote p:highlight:focus {
                color: green;
            }

         """;
        
        let styledDocument = self.buildBlockquoteHtmlDocument()!
        
        let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString)!
        
        let expectedStyleRulesCount = 2
        
        let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
        
        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
        
        let collection = styledDocument.getElementsByTagName("p")
        
        XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
        if let element = collection.elements.first {
            
            let highlightSelectors = CSSSelectorsModule.shared.parse("p")!
            
            var filterContext: FilterContext = FilterContext(highlightSelectors: highlightSelectors)
            filterContext.updatePseudoClassesOptions(forElement: element, with: [.focus, .highlight])
            
            let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: ContiguousArray<Element>(arrayLiteral: element), filterContext: filterContext)
            
            let styleApplicable = applicableStyleRules[element]!
            
            XCTAssert(styleApplicable.rules.count == expectedStyleRulesCount, "expected: \(expectedStyleRulesCount), received: \(applicableStyleRules.count)")
        }
    }
    
    
    func testBodyHighlight() {
        
        let stylingSourceString = """

            body:highlight {
                color: red;
            }

            blockquote p:highlight:focus {
                color: green;
            }

         """;
        
        let styledDocument = self.buildBlockquoteHtmlDocument()!
        
        let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString)!
        
        let expectedStyleRulesCount = 1
        
        let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
        
        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
        
        let collection = styledDocument.getElementsByTagName("body")
        
        XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
        if let element = collection.elements.first {
            
            XCTAssert(element.localName == "body")
            let highlightSelectors = CSSSelectorsModule.shared.parse("p")!
            
            var filterContext: FilterContext = FilterContext(highlightSelectors: highlightSelectors)
            filterContext.updatePseudoClassesOptions(forElement: element, with: [.highlight])
            
            let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: ContiguousArray<Element>(arrayLiteral: element), filterContext: filterContext)
            
            let styleApplicable = applicableStyleRules[element]!
            
            XCTAssert(styleApplicable.rules.count == expectedStyleRulesCount, "expected: \(expectedStyleRulesCount), received: \(applicableStyleRules.count)")
        }
    }
    
    func testH1HighlightFade() {
        
        let stylingSourceString = """

             body:highlight {
                 color: red;
             }

             h1:fade {
                 color: green;
             }

             h1:highlight:fade {
                 color: green;
             }

          """;
        
        let styledDocument = self.buildHtmlDocument()!
        
        let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString)!
        
        let expectedStyleRulesCount = 2
        
        let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
        
        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
        
        let collection = styledDocument.getElementsByTagName("h1")
        
        XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
        if let element = collection.elements.first {
            
            let highlightSelectors = CSSSelectorsModule.shared.parse("h1")!
            
            var filterContext = FilterContext(highlightSelectors: highlightSelectors)
            filterContext.updatePseudoClassesOptions(forElement: element, with: [.fade, .highlight])
            
            let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: ContiguousArray<Element>(arrayLiteral: element), filterContext: filterContext)
            
            let styleApplicable = applicableStyleRules[element]!
            
            XCTAssert(styleApplicable.rules.count == expectedStyleRulesCount, "expected: \(expectedStyleRulesCount), received: \(applicableStyleRules.count)")
        }
    }
    
    func testRootPseudoClass() {
        
        let stylingSourceString = """

            :root {
                color: red;
            }

            blockquote p:highlight:focus {
                color: green;
            }

         """;
        
        let styledDocument = self.buildBlockquoteHtmlDocument()!
        
        let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString)!
        
        let expectedStyleRulesCount = 1
        
        let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
        
        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
        
        let documentElement = styledDocument.documentElement!
        
        XCTAssert(documentElement.localName == "html")
        
        let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: ContiguousArray<Element>(arrayLiteral: documentElement), filterContext: FilterContext())
        
        let styleApplicable = applicableStyleRules[documentElement]!
        
        XCTAssert(styleApplicable.rules.count == expectedStyleRulesCount, "expected: \(expectedStyleRulesCount), received: \(applicableStyleRules.count)")
    }
    
    func testPseudoClassDescendant() {
        
        let stylingSourceString = """

            :root {
                color: red;
            }

            body :highlight strong {
                color: green;
            }

         """;
        
        let styledDocument = self.buildHtmlDocumentWithStrong()!
        
        let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString)!
        
        let expectedStyleRulesCount = 1
        
        let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
        
        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
        
        let strongElement = styledDocument.getElementsByTagName("strong").elements.first!
        
        XCTAssert(strongElement.localName == "strong")
        
        let selectorList = CSSSelectorsModule.shared.parse(".test" as NSString)
        
        var filterContext = FilterContext(highlightSelectors: selectorList)
        filterContext.updatePseudoClassesOptions(forElement: strongElement.parentElement!, with: .highlight)
        
        let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: ContiguousArray<Element>(arrayLiteral: strongElement), filterContext: filterContext)
        
        let styleApplicable = applicableStyleRules[strongElement]!
        
        XCTAssert(styleApplicable.rules.count == expectedStyleRulesCount, "expected: \(expectedStyleRulesCount), received: \(applicableStyleRules.count)")
    }
    
    func testNotPseudoClassDescendant() {
        
        let stylingSourceString = """

            :root {
                color: red;
            }

            body :highlight strong {
                color: green;
            }

         """;
        
        let styledDocument = self.buildHtmlDocumentWithStrong()!
        
        let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString)!
        
        let expectedStyleRulesCount = 0
        
        let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
        
        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
        
        let strongElement = styledDocument.getElementsByTagName("strong").elements.first!
        
        XCTAssert(strongElement.localName == "strong")
        
        let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: ContiguousArray<Element>(arrayLiteral: strongElement), filterContext: FilterContext())
        
        XCTAssert(applicableStyleRules.isEmpty, "expected: \(expectedStyleRulesCount), received: \(applicableStyleRules.count)")
    }
    
    
    ///
    /// blockquote
    ///
    func buildBlockquoteHtmlDocument() -> HtmlDocument? {
        
        let htmlDocument = HtmlDocument.Create("test-document")
        
        if let body = htmlDocument?.body {
            
            var exception = Exception()
            
            // blockquote
            let quote = HTMLQuoteElement(document: htmlDocument)
            let p = HTMLParagraphElement(document: htmlDocument)
            quote.append(p, exception: &exception)
            body.append(quote, exception: &exception)
        }
        
        return htmlDocument
    }
    
    /// h1
    /// p
    ///    strong
    ///
    func buildHtmlDocumentWithStrong() -> HtmlDocument? {
        
        let htmlDocument = HtmlDocument.Create("test-document")
        
        if let body = htmlDocument?.body {
            
            var exception = Exception()
            
            // h1
            let h1 = HTMLHeadingElement(document: htmlDocument, localName: "h1")
            body.append(h1, exception: &exception)
            
            // p
            let p1 = HTMLParagraphElement(document: htmlDocument)
            p1.addClassAttribute("test")
            body.append(p1, exception: &exception)
            
            // h2
            let strong = HTMLElement(document: htmlDocument, localName: "strong")
            p1.append(strong, exception: &exception)
        }
        
        return htmlDocument
    }
    
    /// h1
    /// p
    /// h2
    ///
    ///
    func buildHtmlDocument() -> HtmlDocument? {
        
        let htmlDocument = HtmlDocument.Create("test-document")
        
        if let body = htmlDocument?.body {
            
            var exception = Exception()
            
            // h1
            let h1 = HTMLHeadingElement(document: htmlDocument, localName: "h1")
            body.append(h1, exception: &exception)
            h1.addClassAttribute("test")
            h1.setPseudoElementSourceStringFragment(with: "tag", to: SourceStringSegment(range: NSMakeRange(0, 1)))
            
            // p
            let p1 = HTMLParagraphElement(document: htmlDocument)
            body.append(p1, exception: &exception)
            
            // h2
            let h2 = HTMLHeadingElement(document: htmlDocument, localName: "h2")
            
            body.append(h2, exception: &exception)
            
            // p
            let p2 = HTMLParagraphElement(document: htmlDocument)
            body.append(p2, exception: &exception)
        }
        
        return htmlDocument
    }
    
    
}
