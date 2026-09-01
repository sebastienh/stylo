//
//  TestEphemeralPseudoClassesStyle.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-07-21.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Web

class TestEphemeralPseudoClassesStyle: TestCascading {
    
    func testEphemeralPseudoClass() {
        
        let stylingSourceString = """
            body {
                color: red;
            }

            body:focus {
                color: blue;
            }
         """;
        
        if let styledDocument = HtmlDocument.Create("test-document") {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
                
                let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
                
                let collection = styledDocument.getElementsByTagName("body")
                
                XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
                if let element = collection.elements.first {
                
                    var filterContext = FilterContext()
                    
                    filterContext.updatePseudoClassesOptions(forElement: element, with: [.focus])
                    
                    // we need this because we may use inherited values
                    // while evaluating style
                    resourceComputedStyle.computeElementsStyles(document: styledDocument, filterContext: filterContext)
                    
                    resourceComputedStyle.evaluateEphemeralStyle(for: element, filterContext: filterContext)
                    
                    let elementStyle = resourceComputedStyle.elementStyle(forElement: element, filterContext: filterContext)
                    let styleDeclaration = elementStyle?.rawComputedStyle
                    
                    let colorValue = styleDeclaration?.propertyValues[§CSSProperty.color]
                    let rgbBlue = NSColor(ciColor: CIColor(red: 0, green: 0, blue: 1, alpha: 1))
                    let color = colorValue!.colorValue()
                    XCTAssert(color == rgbBlue, "Expected: \(rgbBlue), received: \(color)")
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
    
    func testEphemeralPseudoClass2() {
        
        let stylingSourceString = """
            body {
                color: red;
            }

            body:focus {
                color: blue;
            }
         """;
        
        if let styledDocument = HtmlDocument.Create("test-document") {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
                
                let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
                
                let collection = styledDocument.getElementsByTagName("body")
                
                XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
                if let element = collection.elements.first {
                
                    let filterContext = FilterContext()
                    
                    // we need this because we may use inherited values
                    // while evaluating style
                    resourceComputedStyle.computeElementsStyles(document: styledDocument, filterContext: filterContext)
                    
                    let styleDeclaration = resourceComputedStyle.computedStyle(forElement: element)
                    let colorValue = styleDeclaration?.propertyValues[§CSSProperty.color]
                    
                    let rgbBlue = NSColor(ciColor: CIColor(red: 1, green: 0, blue: 0, alpha: 1))
                    let color = colorValue!.colorValue()
                    XCTAssert(color == rgbBlue, "Expected: \(rgbBlue), received: \(color)")
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
    
    func testEphemeralPseudoClassAppliedOnPseudoElement() {
        
        let stylingSourceString = """
                body {
                    color: red;
                }

                body::first-letter:focus {
                    color: blue;
                }
             """;
        
        if let styledDocument = HtmlDocument.Create("test-document") {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
                
                let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
                
                
                let collection = styledDocument.getElementsByTagName("body")
                
                XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
                if let element = collection.elements.first {
                
                    var filterContext = FilterContext()
                    
                    filterContext.updatePseudoClassesOptions(forElement: element, with: [.focus])
                    
                    // we need this because we may use inherited values
                    // while evaluating style
                    resourceComputedStyle.computeElementsStyles(document: styledDocument, filterContext: filterContext)
                    
                    resourceComputedStyle.evaluateEphemeralStyle(for: element, filterContext: filterContext)
                    
                    let elementStyle = resourceComputedStyle.elementStyle(forElement: element, filterContext: filterContext)
                    let styleDeclaration = elementStyle?.rawComputedStyle
                    
                    let bodyColorValue = styleDeclaration?.propertyValues[§CSSProperty.color]
                    
                    let rgbRed = NSColor(ciColor: CIColor(red: 1, green: 0, blue: 0, alpha: 1))
                    let bodyColor = bodyColorValue!.colorValue()
                    XCTAssert(bodyColor == rgbRed, "Expected: \(rgbRed), received: \(bodyColor)")
                    
                    let pseudoElements = resourceComputedStyle.pseudoElements(for: element, filterContext: filterContext)
                    let pseudoElement = pseudoElements!.first!
                    
                    
                    resourceComputedStyle.evaluateEphemeralStyle(for: element, filterContext: filterContext)
                    
                    let pseudoElementStyleDeclaration = resourceComputedStyle.computedStyle(forPseudoElement: pseudoElement, withElement: pseudoElement.associatedElement, filterContext: filterContext)
                    
                    let colorValue = pseudoElementStyleDeclaration?.propertyValues[§CSSProperty.color]
                    
                    let rgbBlue = NSColor(ciColor: CIColor(red: 0, green: 0, blue: 1, alpha: 1))
                    let firstLetterColor = colorValue!.colorValue()
                    XCTAssert(firstLetterColor == rgbBlue, "Expected: \(rgbBlue), received: \(firstLetterColor)")
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
    
    func testEphemeralPseudoClassReturnsNonEphemeralValuesWhenNotExisting() {
        
        let stylingSourceString = """
                body {
                    color: red;
                }
                body::first-letter {
                    font-family: Arial;
                }
             """;
        
        if let styledDocument = HtmlDocument.Create("test-document") {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
                
                let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
                
                let collection = styledDocument.getElementsByTagName("body")
                
                XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
                if let element = collection.elements.first {
                
                    var filterContext = FilterContext()
                    
                    filterContext.updatePseudoClassesOptions(forElement: element, with: [.focus])
                    
                    // we need this because we may use inherited values
                    // while evaluating style
                    resourceComputedStyle.computeElementsStyles(document: styledDocument, filterContext: filterContext)
                    
                    resourceComputedStyle.evaluateEphemeralStyle(for: element, filterContext: filterContext)
                    let elementStyle = resourceComputedStyle.elementStyle(forElement: element, filterContext: filterContext)
                    let styleDeclaration = elementStyle?.rawComputedStyle
                    let bodyColorValue = styleDeclaration?.propertyValues[§CSSProperty.color]
                    
                    let rgbRed = NSColor(ciColor: CIColor(red: 1, green: 0, blue: 0, alpha: 1))
                    let bodyColor = bodyColorValue!.colorValue()
                    XCTAssert(bodyColor == rgbRed, "Expected: \(rgbRed), received: \(bodyColor)")
                    
                    let pseudoElements = resourceComputedStyle.pseudoElements(for: element, filterContext: filterContext)
                    let pseudoElement = pseudoElements!.first!
                    
                    let pseudoElementStyleDeclaration = resourceComputedStyle.computedStyle(forPseudoElement: pseudoElement, withElement: pseudoElement.associatedElement, filterContext: filterContext)
                    
                    let colorValue = pseudoElementStyleDeclaration?.propertyValues[§CSSProperty.color]
                    let firstLetterColor = colorValue!.colorValue()
                    XCTAssert(firstLetterColor == rgbRed, "Expected: \(rgbRed), received: \(firstLetterColor)")
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
