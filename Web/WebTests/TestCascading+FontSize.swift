//
//  TestCascading+FontSize.swift
//  Web
//
//  Created by Sebastien hamel on 2019-02-03.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common
import XCTest
@testable import Web

extension TestCascading {
    
    func fontSizeComputedValueExpectation(baseValue: String = "34px", declaredValue: String, expectedValue: CGFloat) {
        
        let styledStyleSheetSource = """
                              
                              body {
                                  font-family : Arial;
                              }

                              """;
        
        let stylingStyleSheetSource = """
        
        css-style-sheet {
            font-size: \(baseValue);
        }
        property-value {
            font-size: \(declaredValue);
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
                
                let propertyValueElements = styledCssDocument.getElementsByTagName("property-value", inclusive: true)
                
                if let propertyValueElement = propertyValueElements.namedItem("property-value") {
                    
                    let stylesheetsElementRawComputedStyle = computedStyle.computedStyle(forElement: propertyValueElement)!
                        
                        
                    
                    if let fontSizeValue = stylesheetsElementRawComputedStyle.propertyValues[§CSSProperty.fontSize] {
                        
                        validateFontSizeActualValue(fontSizeValue: fontSizeValue, expectedValue: expectedValue)
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
    
}
