//
//  PseudoElementCascadingTests.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-07-18.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
@testable import Web
import Common

class PseudoElementCascadingTests: TestCascading {

    /// test first letter of title inside div is blue.
    func testFirstLetterPseudoElementCascading() {
        
        let stylingStyleSheetSource = """
            body {
                color: red;
            }
            h1::first-letter {
                color: green;
            }
            div.highlight h1::first-letter {
              color: blue;
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
                
                
                validateH1Title(named: "1", colorIs: CIColor(red: 0, green: 0, blue: 1), in: styledDocument, resourceComputedStyle: computedStyle, filterContext: filterContext)
                
                validateH1Title(named: "2", colorIs: CIColor(red: 0, green: 128/255, blue: 0), in: styledDocument, resourceComputedStyle: computedStyle, filterContext: filterContext)
            }
            else {
                XCTAssert(false, "stylingCssStyleSheet is nil")
            }
        }
        else {
            XCTAssert(false, "styledCssDocument is nil")
        }
    }

    /// test first letter of title inside div is blue.
    /// with sibling selector
    func testFirstLetterPseudoElementCascadingWithFollowingSiblingSelector() {
        
        let stylingStyleSheetSource = """
            body {
                color: red;
            }
            h1::first-letter {
                color: green;
            }
            div.highlight h1::first-letter {
              color: blue;
            }
            p + h1 {
                color:red;
            }
        """;
        
        ///
        /// <html>
        ///   <body>
        ///     <div class="highlight">
        ///       <h1>title 1</h1>
        ///     </div>
        ///     <h1>title 2</h1>
        ///   </body>
        /// </html>
        ///
        
        let stylingSourceString = stylingStyleSheetSource
        
        if let styledDocument = buildBasicHtmlDocument() {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                var style = CSSStyle(id: "test-style")
                style.addStyleSheet(stylingCssStyleSheet)
                
                var filterContext = FilterContext()
                let divElement = styledDocument.getElementsByTagName("div").elements.first!
                filterContext.updatePseudoClassesOptions(forElement: divElement, with: .highlight)
                
                let computedStyle = ResourceComputedStyle(styleDefinition: style)
                computedStyle.computeElementsStyles(document: styledDocument, filterContext: filterContext)
                
                
                validateH1Title(named: "1", colorIs: CIColor(red: 0, green: 0, blue: 1), in: styledDocument, resourceComputedStyle: computedStyle, filterContext: filterContext)
                
                validateH1Title(named: "2", colorIs: CIColor(red: 0, green: 128/255, blue: 0), in: styledDocument, resourceComputedStyle: computedStyle, filterContext: filterContext)
            }
            else {
                XCTAssert(false, "stylingCssStyleSheet is nil")
            }
        }
        else {
            XCTAssert(false, "styledCssDocument is nil")
        }
    }
    
    private func validateH1Title(named name: String, colorIs color: CIColor, in document: HtmlDocument, resourceComputedStyle: ResourceComputedStyle, filterContext: FilterContext) {
        
        let h1Elements = document.getElementsByTagName("h1")
        let h1Element = h1Elements.namedItem(name)!
        XCTAssert(h1Element.length == 1)
        let child = h1Element.childAtIndex(0)
        XCTAssert(child != nil)
        let text = child as! CharacterData
        print("text.data: \(text.data)")
        
        
        let pseudoElements = resourceComputedStyle.pseudoElements(for: h1Element, filterContext: filterContext)!
        XCTAssert(!pseudoElements.isEmpty)
        
        let pseudoElement = pseudoElements.first!
        let pseudoElementStyle = resourceComputedStyle.computedStyle(forPseudoElement: pseudoElement, withElement: h1Element, filterContext: filterContext)
        
        let colorValue = pseudoElementStyle!.propertyValues["color"]!
        let ciColorValue = colorValue.ciColorValue()

        print("ciColorValue: \(name)")
        
        // [0,0,255,1]
        // This confirms that the blue color wins with the !important keyword
        XCTAssert(color == ciColorValue, "Expected: \(color), received: \(ciColorValue!)")
    }
    
    ///
    /// <html>
    ///   <body>
    ///     <div class="highlight">
    ///       <h1>title 1</h1>
    ///     </div>
    ///     <h1>title 2</h1>
    ///   </body>
    /// </html>
    ///
    override func buildBasicHtmlDocument() -> HtmlDocument? {
        
        let htmlDocument = HtmlDocument.Create("test-document")
        
        if let body = htmlDocument?.body {
            
            var exception = Exception()
            
            // div
            let div = HTMLDivElement(document: htmlDocument)
            div.addClassAttribute("highlight")
            body.append(div, exception: &exception)
            
            // h1: "title 1"
            let h1 = HTMLHeadingElement(document: htmlDocument, localName: "h1")
            h1.setAttributeValue("id", value: "1")
            let text = Text(document: htmlDocument, data: "title 1")
            h1.append(text, exception: &exception)
            div.append(h1, exception: &exception)
            
            
            // h12
            let h12 = HTMLHeadingElement(document: htmlDocument, localName: "h1")
            h12.setAttributeValue("id", value: "2")
            let text2 = Text(document: htmlDocument, data: "title 2")
            h12.append(text2, exception: &exception)
            body.append(h12, exception: &exception)
        }
        return htmlDocument
    }
}
