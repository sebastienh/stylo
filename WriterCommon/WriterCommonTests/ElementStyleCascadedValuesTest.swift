//
//  ElementStyleCascadedValuesTest.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-04-01.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import XCTest
import Web
@testable import WriterCommon

class ElementStyleCascadedValuesTest: WriterCommonCssTests {

//    func testElementApplicableRules0ApplicableRules() {
//
//        // create the document to test
//        let cssDocument = compileCssSourceFile(from: "source.css")!
//
//        let domDocument = cssDocument as! CSSDOMDocument?
//        XCTAssert(domDocument != nil)
//
//        let dom = serializeCssDom(cssDomDocument: domDocument!)
//
//        debugPrint(dom)
//
//        // find the element with the error
//        let element = getElement(in: domDocument!, tagName: "css-token", classes: ["number-token"], attributes: ["text-value": "1940"])!
//
//        // create the style
//        let cssStyle = createStyle(from: ["source-author.css", "user.css"], with: "css-ua.css")
//
//        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: cssStyle!, document: domDocument!)
//
//        let applicableStyleRules: [Element: [CSSStyleRule]] = resourceComputedStyle.rootElementsApplicableStyleRules(cssStyle!.userAgentStyleSheet!, rootElements: [domDocument!.rootDocumentElement])
//
//        XCTAssert(applicableStyleRules[element] == nil)
//    }
//
//    func testStylesheetElementApplicableRules() {
//        
//        // create the document to test
//        let cssChangeRequest = compileCssSourceFile(from: "source.css")!
//        
//        
//        let domDocument = cssChangeRequest.renderableDocument as! CSSDOMDocument!
//        XCTAssert(domDocument != nil)
//        
//        let dom = serializeCssDom(cssDomDocument: domDocument!)
//        
//        debugPrint(dom)
//        
//        // find the element with the error
//        
//        let stylesheetElement = getElement(in: domDocument!, tagName: "css-style-sheet")!
//        
//        // create the style
//        let cssStyle = createStyle(from: ["source-author.css", "user.css"], with: "css-ua.css")
//        
//        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: cssStyle!, document: domDocument!)
//        
//        var inOrderElements = [Element]()
//        
//        let _elements = resourceComputedStyle.populateElements(inOrderElements: &inOrderElements)
//        
//        let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: _elements, inOrderElements: &inOrderElements)
//        
//        
//        XCTAssert(applicableStyleRules[stylesheetElement]!.count == 3, "Received: \(applicableStyleRules[stylesheetElement]!.count)")
//    }
//    
//    func testCascadedColorPropertyValue() {
//        
//        // create the document to test
//        let cssChangeRequest = compileCssSourceFile(from: "source.css")!
//        
//        
//        let domDocument = cssChangeRequest.renderableDocument as! CSSDOMDocument!
//        XCTAssert(domDocument != nil)
//        
//        let dom = serializeCssDom(cssDomDocument: domDocument!)
//        
//        debugPrint(dom)
//        
//        // find the element with the error
//        
//        let stylesheetElement = getElement(in: domDocument!, tagName: "css-style-sheet")!
//        
//        // create the style
//        let cssStyle = createStyle(from: ["source-author.css", "user.css"], with: "css-ua.css")
//        
//        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: cssStyle!, document: domDocument!)
//        
//        var inOrderElements = [Element]()
//        
//        let _elements = resourceComputedStyle.populateElements(inOrderElements: &inOrderElements)
//        
//        let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: _elements, inOrderElements: &inOrderElements)
//        
//        XCTAssert(applicableStyleRules[stylesheetElement]!.count == 3, "Received: \(applicableStyleRules[stylesheetElement]!.count)")
//        
//        for matchedElement in inOrderElements {
//            
//            // applicableRules could be nil since it's possible to have no rules
//            // sepcifically pointing at it.
//            let applicableRules = applicableStyleRules[matchedElement]
//            
//            let elementStyle = ElementStyle(associatedElement: matchedElement, styleRules: applicableRules, resourceComputedStyle: resourceComputedStyle, temporary: cssStyle!.temporary)
//            
//            /// At this step
//            elementStyle.computeCascadedValues()
//            
//            if matchedElement == stylesheetElement {
//             
//                let value = elementStyle.cascadedStyle.propertyValues["color"]!
//                
//                let ciColorValue = value.ciColorValue()
//                
//                // [0,0,255,1]
//                // This confirms that the blue color wins with the !important keyword
//                XCTAssert(CIColor(red: 0, green: 0, blue: 1) == ciColorValue)
//            }
//        }
//    }
//
//    func testInheritedColorPropertyValue() {
//        
//        // create the document to test
//        let cssChangeRequest = compileCssSourceFile(from: "source.css")!
//        
//        let domDocument = cssChangeRequest.renderableDocument as! CSSDOMDocument!
//        XCTAssert(domDocument != nil)
//        
//        let dom = serializeCssDom(cssDomDocument: domDocument!)
//        
//        debugPrint(dom)
//        
//        // find the element with the error
//        
//        let stylesheetElement = getElement(in: domDocument!, tagName: "css-style-sheet")!
//        
//        let element = getElement(in: domDocument!, tagName: "css-token", classes: ["number-token"], attributes: ["text-value": "1940"])!
//        
//        // create the style
//        let cssStyle = createStyle(from: ["source-author.css", "user.css"], with: "css-ua.css")
//        
//        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: cssStyle!, document: domDocument!)
//        
//        var inOrderElements = [Element]()
//        
//        let _elements = resourceComputedStyle.populateElements(inOrderElements: &inOrderElements)
//        
//        let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: _elements, inOrderElements: &inOrderElements)
//        
//        XCTAssert(applicableStyleRules[stylesheetElement]!.count == 3, "Received: \(applicableStyleRules[stylesheetElement]!.count)")
//        
//        for matchedElement in inOrderElements {
//            
//            // applicableRules could be nil since it's possible to have no rules
//            // sepcifically pointing at it.
//            let applicableRules = applicableStyleRules[matchedElement]
//            
//            let elementStyle = ElementStyle(associatedElement: matchedElement, styleRules: applicableRules, resourceComputedStyle: resourceComputedStyle, temporary: cssStyle!.temporary)
//            
//            /// At this step
//            elementStyle.computeCascadedValues()
//            
//            if matchedElement == stylesheetElement {
//                
//                let value = elementStyle.cascadedStyle.propertyValues["color"]!
//                
//                let ciColorValue = value.ciColorValue()
//                
//                // [0,0,255,1]
//                // This confirms that the blue color wins with the !important keyword
//                XCTAssert(CIColor(red: 0, green: 0, blue: 1) == ciColorValue, "Received: \(ciColorValue)")
//            }
//            
//            // after this all inherited properties are filled
//            // only (maybe) left some relative properties
//            // inserted in the cascading process which we will
//            // solve at the next step.
//            elementStyle.computeSpecifiedValues()
//            
//            if matchedElement == element {
//                
//                let value = elementStyle.specifiedValues.propertyValues["color"]!
//                
//                let ciColorValue = value.ciColorValue()
//                
//                // [0,0,255,1]
//                // This confirms that the blue color wins with the !important keyword
//                XCTAssert(CIColor(red: 1, green: 0, blue: 0) == ciColorValue, "Received: \(ciColorValue)")
//            }
//            
//            // resolve all remaining relative values.
//            elementStyle.computeRawComputedStyle()
//            
//            if matchedElement == element {
//                
//                let value = elementStyle.rawComputedStyle.propertyValues["color"]!
//                
//                let ciColorValue = value.ciColorValue()
//                
//                // [0,0,255,1]
//                // This confirms that the blue color wins with the !important keyword
//                XCTAssert(CIColor(red: 1, green: 0, blue: 0) == ciColorValue, "Received: \(ciColorValue)")
//            }
//            
//            // compute the used style
//            //            computeUsedStyle()
//            
//            // compute actual style
//            // the actual style should be computed by the render
//            // object based on rendering and layout information.
//            //            computeActualStyle()
//            
//            elementStyle.evaluatedStyle = true
//            
//            resourceComputedStyle.elementStyleCache.updateElementStyleForElement(matchedElement, elementStyle: elementStyle)
//        }
//    }
}
