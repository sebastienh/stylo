//
//  TestCascading+CustomProperty.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-08-11.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Cocoa
import XCTest
import Common
@testable import Web

class TestCascading_CustomProperty: TestCascading {
    
    func testRootPseudoClass() {
        
        let stylingSourceString = """

            :root {
                --my-color: red;
            }

            blockquote {
                color: var(--my-color);
            }

         """;

        let styledDocument = self.buildBlockquoteHtmlDocument()!

        let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString)!


        let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])

        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)

        let collection = styledDocument.getElementsByTagName("blockquote")

        XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
        if let element = collection.elements.first {

            XCTAssert(element.localName == "blockquote")

            resourceComputedStyle.computeElementsStyles(document: styledDocument, filterContext: FilterContext())

            let computedStyle = resourceComputedStyle.computedStyle(forElement:element)

            XCTAssert(computedStyle != nil)
            if let computedStyle = computedStyle {
                print("computedStyle: \(computedStyle.propertyValues)")
            }
        }
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
