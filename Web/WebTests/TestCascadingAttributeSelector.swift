//
//  TestCascadingAttributeSelector.swift
//  Web
//
//  Created by Sebastien hamel on 2019-10-29.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Web

class TestCascadingAttributeSelector: TestCascading {

    let attributeName = "ttly-highlight"
    
    /// test for NW-697
    func testAttributeSelectorCascading() {
        
        let stylingStyleSheetSource =   """

                                            body {
                                                font-size: 10px;
                                                font-size: 12px;
                                                color: black;
                                            }
                                            [\(attributeName)] {
                                                color: red;
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
                
                // style-declaration assertions
                let h1Elements = styledDocument.getElementsByTagName("h1")
                let h1Element = h1Elements.namedItem("h1")!
                let p1Element = h1Element.followingNode() as! HTMLParagraphElement
                
                let h2Elements = styledDocument.getElementsByTagName("h2")
                let h2Element = h2Elements.namedItem("h2")!
                let p2Element = h2Element.followingNode() as! HTMLParagraphElement
                
                // h1 font-size should be 12px
                let h1ElementRawComputedStyle = computedStyle.computedStyle(forElement: h1Element)!  // h1Element.rawComputedStyle
                if let fontSizeValue = h1ElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                    validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 12)
                }
                else {
                    XCTAssert(false, "fontSizeValue is nil")
                }
                
                if let colorValue = h1ElementRawComputedStyle.propertyValues[§CSSProperty.color] {
                    debugPrint("Color: \(colorValue)")
                    let color = colorValue.colorValue()
                    XCTAssert(color == PlateformColorType(deviceRed: 1, green: 0, blue: 0, alpha: 1), "received: \(color)")
                }
                else {
                    XCTAssert(false, "colorValue is nil")
                }
                
                // p1 font-size should be 12px
                let p1ElementRawComputedStyle = computedStyle.computedStyle(forElement: p1Element)!  //p1Element.rawComputedStyle
                if let fontSizeValue = p1ElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                    validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 12)
                }
                else {
                    XCTAssert(false, "fontSizeValue is nil")
                }
                
                // h2 font-size should be 12px
                let h2ElementRawComputedStyle = computedStyle.computedStyle(forElement: h2Element)! //h2Element.rawComputedStyle
                if let fontSizeValue = h2ElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                    validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: 12)
                }
                else {
                    XCTAssert(false, "fontSizeValue is nil")
                }
                
                // p2 font-size should be 12px
                let p2ElementRawComputedStyle = computedStyle.computedStyle(forElement: p2Element)! // p2Element.rawComputedStyle
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

    
    override func buildBasicHtmlDocument() -> HtmlDocument? {
        
        let htmlDocument = HtmlDocument.Create("test-document")
        
        if let body = htmlDocument?.body {
            
            var exception = Exception()
            
            // h1
            let h1 = HTMLHeadingElement(document: htmlDocument, localName: "h1")
            let attribute = Attr(localName: attributeName)
            h1.appendAttribute(attribute)
            
            body.append(h1, exception: &exception)
            
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
