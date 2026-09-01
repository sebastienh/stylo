//
//  CustomPropertyEvaluationTest.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-08-13.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Web

class CustomPropertyEvaluationTest: TestCascading {
    
    func testBasicCustomPropertyResolution() {
        
        let stylingSourceString = """
             :root {
                 --main-color: blue;
             }

             body {
                 color: var(--main-color);
             }
          """;
        
        if let styledDocument = HtmlDocument.Create("test-document") {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
                
                let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
                
                let filterContext = FilterContext()
                
                // we need this because we may use inherited values
                // while evaluating style
                resourceComputedStyle.computeElementsStyles(document: styledDocument, filterContext: filterContext)
                
                let collection = styledDocument.getElementsByTagName("body")
                
                XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
                if let element = collection.elements.first {
                    
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
    
    
    func testBasicDefaultingCustomPropertyResolution() {
        
        let stylingSourceString = """
              :root {
                  --main-color-1: blue;
              }

              body {
                  color: var(--main-color, blue);
              }
           """;
        
        if let styledDocument = HtmlDocument.Create("test-document") {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
                
                let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
                
                let filterContext = FilterContext()
                
                // we need this because we may use inherited values
                // while evaluating style
                resourceComputedStyle.computeElementsStyles(document: styledDocument, filterContext: filterContext)
                
                let collection = styledDocument.getElementsByTagName("body")
                
                XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
                if let element = collection.elements.first {
                    
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
    
    func testBasicInheritedWithTwoCustomProperty() {
        
        let stylingSourceString = """
               :root {
                    --main-color: red;
                    --main-color: blue;
               }

               body {
                    color: var(--main-color);
               }
            """;
        
        if let styledDocument = HtmlDocument.Create("test-document") {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
                
                let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
                
                let filterContext = FilterContext()
                
                // we need this because we may use inherited values
                // while evaluating style
                resourceComputedStyle.computeElementsStyles(document: styledDocument, filterContext: filterContext)
                
                let collection = styledDocument.getElementsByTagName("body")
                
                XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
                if let element = collection.elements.first {
                    
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
    
    func testBasicInheritedWithTwoCustomPropertyAndDefaulting() {
        
        let stylingSourceString = """
               :root {
                    --main-color: red;
                    --main-color: blue;
               }

               body {
                    color: var(--main-color-1, var(--main-color));
               }
            """;
        
        if let styledDocument = HtmlDocument.Create("test-document") {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
                
                let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
                
                let filterContext = FilterContext()
                
                // we need this because we may use inherited values
                // while evaluating style
                resourceComputedStyle.computeElementsStyles(document: styledDocument, filterContext: filterContext)
                
                let collection = styledDocument.getElementsByTagName("body")
                
                XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
                if let element = collection.elements.first {
                    
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
    
    func testBasicInheritedWithTwoCustomPropertyAndLocalIndirection() {
        
        let stylingSourceString = """
               :root {
                    --main-color-2: red;
                    --main-color-2: blue;
               }

               body {
                    color: var(--main-color-1, var(--main-color));
                    --main-color: var(--main-color-2);
               }
            """;
        
        if let styledDocument = HtmlDocument.Create("test-document") {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
                
                let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
                
                let filterContext = FilterContext()
                
                // we need this because we may use inherited values
                // while evaluating style
                resourceComputedStyle.computeElementsStyles(document: styledDocument, filterContext: filterContext)
                
                let collection = styledDocument.getElementsByTagName("body")
                
                XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
                if let element = collection.elements.first {
                    
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
    
    func testCustomValueReferingToCustomPropertyInCycle() {
        
        let stylingSourceString = """
                 :root {
                      --main-color-2: red;
                      --main-color-2: blue;
                 }

                 body {
                      color: var(--main-color-1, var(--main-color));
                      --main-color: var(--main-color-3);
                      --main-color-3: var(--main-color);
                 }
              """;
        
        if let styledDocument = HtmlDocument.Create("test-document") {
            
            if let stylingCssStyleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
                
                let style = CSSStyle(id: "test", authorStyleSheets: [stylingCssStyleSheet])
                
                let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
                
                let filterContext = FilterContext()
                
                // we need this because we may use inherited values
                // while evaluating style
                resourceComputedStyle.computeElementsStyles(document: styledDocument, filterContext: filterContext)
                
                let collection = styledDocument.getElementsByTagName("body")
                
                XCTAssert(collection.elements.count == 1, "expected: \(1), received: \(collection.elements.count)")
                if let element = collection.elements.first {
                    
                    resourceComputedStyle.evaluateEphemeralStyle(for: element, filterContext: filterContext)
                    
                    let elementStyle = resourceComputedStyle.elementStyle(forElement: element, filterContext: filterContext)
                    let styleDeclaration = elementStyle?.rawComputedStyle
                    
                    let initialValue = CSSPropertyDefinitionTable.shared.initialValueForProperty(CSSProperty.color)
                    
                    let colorValue = styleDeclaration?.propertyValues[§CSSProperty.color]
                    XCTAssert(colorValue?.colorValue() == initialValue.colorValue(), "Expected: nil, received: \(colorValue)")
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
