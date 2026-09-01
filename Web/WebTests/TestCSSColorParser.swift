//
//  TestCSSColorParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-17.
//  Copyright (c) 2015 NM. All rights reserved.
//

import XCTest
import Common
import Cocoa
@testable import Web

class TestCSSColorParser: TestCSSDOM {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    func testKeywordBlueColorParsing() {
        
        let cssString =
        "   body {                          " +
            "       color :blue;         " +
            "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            let blueColor = CIColor(red: 0, green: 0, blue: 255/255, alpha: 1)
            
            XCTAssert(color ==  blueColor, "Color is not blue.")
        }
        else {
            
            XCTAssert(false, "Color is nil.")
        }
    }
    
    func testKeywordBlueWithSpacesColorParsing() {
        
        let cssString =
        "   body {                          " +
            "       color :        blue;         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            let blueColor = CIColor(red: 0, green: 0, blue: 255/255, alpha: 1)
            
            XCTAssert(color ==  blueColor, "Color is not blue.")
        }
        else {
            
            XCTAssert(false, "Color is nil.")
        }
    }
    
    
    func testHash3ColorParsing() {
        
        // 204 221 221
        let cssString =
        "   body {                          " +
            "       color :#CDD;         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            let expectedColor = NSColor(hex: "#CDD")
            
            let nsColor = NSColor(ciColor: color)
            
            let colorSpacedColor = nsColor.usingColorSpace(NSColorSpace.sRGB)!
            
            XCTAssert(colorSpacedColor.isEqual(expectedColor), "Color is not expected.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    func testHash4ColorParsing() {
        
        let cssString =
        "   body {                          " +
            "       color :#CDD4;         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            let expectedColor = NSColor(hex: "#CDD4")
            
            let nsColor = NSColor(ciColor: color)
            
            let colorSpacedColor = nsColor.usingColorSpace(NSColorSpace.sRGB)!
            
            XCTAssert(colorSpacedColor.isEqual(expectedColor), "Color is not expected, received: \(nsColor), expected: \(expectedColor)")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    func testHash6ColorParsing() {
        
        let cssString =
        "   body {                          " +
            "       color :#CDD433;         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            let expectedColor = NSColor(hex: "#CDD433")
            
            let nsColor = NSColor(ciColor: color)
            
            let colorSpacedColor = nsColor.usingColorSpace(NSColorSpace.sRGB)!
            
            XCTAssert(colorSpacedColor.isEqual(expectedColor), "Color is not expected.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    func testHash8ColorParsing() {
        
        let cssString =
        "   body {                          " +
            "       color :#CDD43344;         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            let expectedColor = NSColor(hex: "#CDD43344")
            
            let nsColor = NSColor(ciColor: color)
            
            let colorSpacedColor = nsColor.usingColorSpace(NSColorSpace.sRGB)!
            
            XCTAssert(colorSpacedColor.isEqual(expectedColor), "Color is not expected.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    func testFailHash7ColorParsing() {
        
        let cssString =
        "   body {                          " +
            "       color :#CDD4334;         " +
        "   }                               ";
        
        if let _ = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            XCTAssert(false, "Color should be nil.")
        }
        else {
            
            XCTAssert(true, "Pass.")
        }
    }
    
    //                                                                               ::color-value
    //                                                                                     |
    //                                                                                     |
    //                                                                              ::function.rsb
    //                                                                                     |
    //                                                              _______________________|______________________
    //                                                             /                       |                      \
    //                                                            /                        |                       \
    //                                                    ::function-start         ::function-param    css-token.right-parenthesis
    //                                                           |                         |
    //                                                           |                         |
    //                                            css-token.function-token.rsb      css-token.number
    //
    func testWrongFunctionColorParsing() {
        
        let cssString =
        "   body {                          " +
            "       color :rsb(23);         " +
        "   }                               ";
        
        // ::property-value pseudo element
        let propertyValuePseudoElement = domFromCSSProperty(sourceString: cssString as NSString, propertyName: "color" )
        
        let propertyValuePseudoElementChildList = propertyValuePseudoElement.childNodes!
        
        // we should only have the funcion element
        XCTAssert(propertyValuePseudoElementChildList.length == 1, "Wrong number of children.")
        
        let colorValueElement = propertyValuePseudoElementChildList.item(0)!  as! CSSDOMElement
        
        validateElementName(element: colorValueElement, expectedName: §CSSElementType.ColorValue)
        
        if let childList = colorValueElement.childNodes {
            
            // we should only have the funcion element
            XCTAssert(childList.length == 1, "Wrong number of children.")
            
            let functionElement = childList.item(0) as! CSSDOMElement
            
            validateElementName(element: functionElement, expectedName: §CSSElementType.Function)
            
            validateElementClass(element: functionElement, expectedClassName: "rsb")
            
            if let functionChildNodes = functionElement.childNodes {
                
                // we should only have the funcion-start pseudo element, the function param pseudo element and the css-token mirror
                XCTAssert(functionChildNodes.length == 3, "Wrong number of children.")
                
                // Validate fucntion-start pseudo-element
                let functionStartPseudoElement = functionChildNodes.item(0) as! CSSDOMElement
                
                validateElementName(element: functionStartPseudoElement, expectedName: §CSSElementType.FunctionStart)
                
                XCTAssert(functionStartPseudoElement.messageWithCode(MessageCode.unsupportedFunction) != nil, "Missing error in DOM element.")
                
                if let functionStartPseudoElementChildNodes = functionStartPseudoElement.childNodes {
                    
                    XCTAssert(functionStartPseudoElementChildNodes.length == 1, "Wrong number of children.")
                    
                    validateFunctionStartPseudoElement(functionStartPseudoElement: functionStartPseudoElement, functionName: "rsb")
                }
                else {
                    
                    XCTAssert(false, "functionStartPseudoElementChildNodes is nil.")
                }
                
                // validate function-param
                let functionParamPseudoElement = functionChildNodes.item(1) as! CSSDOMElement
                
                validateNumberFunctionParam(functionParamPseudoElement: functionParamPseudoElement)
                
                // validate css-token.right-parenthesis
                
                let mirrorElement = functionChildNodes.item(2) as! CSSDOMTokenElement
                
                validateTokenElement(tokenElement: mirrorElement, expectedTokenClassTypes: [§TokenClassType.RightParenthesisToken])
                

                
            }
            else {
                
                XCTAssert(false, "functionChildNodes is nil.")
            }
        }
        else {
            
            XCTAssert(false, "childNodes is nil.")
        }
        
        // validate color value
        if let _ = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            XCTAssert(false, "Color is not nil.")
        }

    }
    
    //                                                                               ::color-value
    //                                                                                     |
    //                                                                                     |
    //                                                                              ::function.rgb
    //                                                                                     |
    //                                                                    _________________|________________
    //                                                                   /                                  \
    //                                                                  /   		    					 \
    //                                                        ::function-start                css-token.right-parenthesis
    //                                                                |
    //                                                                |
    //                                                css-token.function-token.rgb
    //
    func testNoArgumentsToFunctionErrorColorParsing() {
        
        let cssString =
        "   body {                          " +
            "       color :rgb();         " +
        "   }                               ";
        
        // property-value element
        let propertyValuePseudoElement = domFromCSSProperty(sourceString: cssString as NSString, propertyName: "color" )
        
        let propertyValuePseudoElementChildList = propertyValuePseudoElement.childNodes!
        
        // we should only have the funcion element
        XCTAssert(propertyValuePseudoElementChildList.length == 1, "Wrong number of children.")
        
        let colorValueElement = propertyValuePseudoElementChildList.item(0)!  as! CSSDOMElement
        
        validateElementName(element: colorValueElement, expectedName: §CSSElementType.ColorValue)
        
        if let childList = colorValueElement.childNodes {
            
            // we should only have the funcion element
            XCTAssert(childList.length == 1, "Wrong number of children.")
            
            let functionElement = childList.item(0) as! CSSDOMElement
            
            validateElementName(element: functionElement, expectedName: §CSSElementType.Function)
            
            validateElementClass(element: functionElement, expectedClassName: "rgb")
            
            XCTAssert(functionElement.messageWithCode(MessageCode.notEnoughArgumentsPassedToFunction) != nil, "Missing error in DOM element.")
            
            if let functionChildNodes = functionElement.childNodes {
                
                // we should only have the funcion-start pseudo element and the css-token mirror
                XCTAssert(functionChildNodes.length == 2, "Wrong number of children.")
                
                // Validate fucntion-start pseudo-element
                let functionStartPseudoElement = functionChildNodes.item(0) as! CSSDOMElement
                
                validateElementName(element: functionStartPseudoElement, expectedName: §CSSElementType.FunctionStart)
                
                if let functionStartPseudoElementChildNodes = functionStartPseudoElement.childNodes {
                    
                    XCTAssert(functionStartPseudoElementChildNodes.length == 1, "Wrong number of children.")
                    
                    validateFunctionStartPseudoElement(functionStartPseudoElement: functionStartPseudoElement, functionName: "rgb")
                }
                else {
                    
                    XCTAssert(false, "functionStartPseudoElementChildNodes is nil.")
                }
                
                // validate css-token.right-parenthesis
                
                let mirrorElement = functionChildNodes.item(1) as! CSSDOMTokenElement
                
                validateTokenElement(tokenElement: mirrorElement, expectedTokenClassTypes: [§TokenClassType.RightParenthesisToken])
            }
            else {
                
                XCTAssert(false, "functionChildNodes is nil.")
            }
        }
        else {
            
            XCTAssert(false, "childNodes is nil.")
        }
        
        // validate color value
        if let _ = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            XCTAssert(false, "Color is not nil.")
        }
    }
    
    
    //                                                                                           ::color-value
    //                                                                                                 |
    //                                                                                                 |
    //                                                                                          ::function.rgb
    //                                                                                                 |
    //                            _____________________________________________________________________|_____________________________________________________________________________
    //                           /                      |               |                  |                 |                |                     |               |                \
    //                          /   					|               |				   |				 |				  |						|               |                 \
    //                  ::function-start	   ::function-param   css-token.comma   ::function-param  css-token.comma  ::function-param     css-token.comma  ::function-param css-token.right-parenthesis
    //                          |						|									|                                   |                                   |
    //                          |						|									|									|                                   |
    //          css-token.function-token.rgb	css-token.number 					 css-token.number                   css-token.number                    css-token.number
    //
    func testTooManyArgumentsToFunctionErrorColorParsing() {
        
        let cssString =
        "   body {                          " +
            "       color :rgb(43,43,43,43);         " +
        "   }                               ";
        
        // ::property-value pseudo element
        let propertyValuePseudoElement = domFromCSSProperty(sourceString: cssString as NSString, propertyName: "color" )
        
        let propertyValuePseudoElementChildList = propertyValuePseudoElement.childNodes!
        
        // we should only have the funcion element
        XCTAssert(propertyValuePseudoElementChildList.length == 1, "Wrong number of children.")
        
        let colorValueElement = propertyValuePseudoElementChildList.item(0)!  as! CSSDOMElement
        
        validateElementName(element: colorValueElement, expectedName: §CSSElementType.ColorValue)
        
        if let childList = colorValueElement.childNodes {
            
            // we should only have the funcion element
            XCTAssert(childList.length == 1, "Wrong number of children.")
            
            let functionElement = childList.item(0) as! CSSDOMElement
            
            validateElementName(element: functionElement, expectedName: §CSSElementType.Function)
            
            validateElementClass(element: functionElement, expectedClassName: "rgb")
            
            if let functionChildNodes = functionElement.childNodes {
                
                // we should only have the funcion-start pseudo element, the function param pseudo element and the css-token mirror
                XCTAssert(functionChildNodes.length == 9, "Wrong number of children.")
                
                // Validate fucntion-start pseudo-element
                let functionStartPseudoElement = functionChildNodes.item(0) as! CSSDOMElement
                
                validateElementName(element: functionStartPseudoElement, expectedName: §CSSElementType.FunctionStart)
                
                if let functionStartPseudoElementChildNodes = functionStartPseudoElement.childNodes {
                    
                    XCTAssert(functionStartPseudoElementChildNodes.length == 1, "Wrong number of children.")
                    
                    validateFunctionStartPseudoElement(functionStartPseudoElement: functionStartPseudoElement, functionName: "rgb")
                }
                else {
                    
                    XCTAssert(false, "functionStartPseudoElementChildNodes is nil.")
                }
                
                ///////////////////////////////////////////////////////////////////
                // validate function-param
                var functionParamPseudoElement = functionChildNodes.item(1) as! CSSDOMElement
                
                validateNumberFunctionParam(functionParamPseudoElement: functionParamPseudoElement)
                
                var commaTokenMirrorPseudoElement = functionChildNodes.item(2) as! CSSDOMTokenElement
                
                validateCommaToken(tokenElement: commaTokenMirrorPseudoElement)
                
                ///////////////////////////////////////////////////////////////////
                // validate function-param
                functionParamPseudoElement = functionChildNodes.item(3) as! CSSDOMElement
                
                validateNumberFunctionParam(functionParamPseudoElement: functionParamPseudoElement)
                
                commaTokenMirrorPseudoElement = functionChildNodes.item(4) as! CSSDOMTokenElement
                
                validateCommaToken(tokenElement: commaTokenMirrorPseudoElement)
                
                ///////////////////////////////////////////////////////////////////
                // validate function-param
                functionParamPseudoElement = functionChildNodes.item(5) as! CSSDOMElement
                
                validateNumberFunctionParam(functionParamPseudoElement: functionParamPseudoElement)
                
                commaTokenMirrorPseudoElement = functionChildNodes.item(6) as! CSSDOMTokenElement
                
                validateCommaToken(tokenElement: commaTokenMirrorPseudoElement)
                
                ///////////////////////////////////////////////////////////////////
                // validate function-param
                functionParamPseudoElement = functionChildNodes.item(7) as! CSSDOMElement
                
                validateNumberFunctionParam(functionParamPseudoElement: functionParamPseudoElement, tokenElementClassesLength: 1)
                
                // validate css-token.right-parenthesis
                
                let mirrorElement = functionChildNodes.item(8) as! CSSDOMTokenElement
                
                validateTokenElement(tokenElement: mirrorElement, expectedTokenClassTypes: [§TokenClassType.RightParenthesisToken])
                
                XCTAssert(functionElement.messageWithCode(MessageCode.tooManyArgumentsPassedToFunction) != nil, "Missing error in DOM element.")
                
            }
            else {
                
                XCTAssert(false, "functionChildNodes is nil.")
            }
        }
        else {
            
            XCTAssert(false, "childNodes is nil.")
        }
        
        // validate color value
        if let _ = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            XCTAssert(false, "Color is not nil.")
        }

    }
    
    //                                                                                           ::color-value
    //                                                                                                 |
    //                                                                                                 |
    //                                                                                          ::function.rgb
    //                                                                                                 |
    //                            _____________________________________________________________________|____
    //                           /                      |               |                  |                \
    //                          /   					|               |				   |				 \
    //                  ::function-start	   ::function-param   css-token.comma   ::function-param   css-token.right-parenthesis
    //                          |						|									|
    //                          |						|									|
    //          css-token.function-token.rgb	css-token.number 					 css-token.number
    //
    func testNotEnoughArgumentsToFunctionErrorColorParsing() {
        
        let cssString =
        "   body {                          " +
            "       color :rgb(43,43);         " +
        "   }                               ";
        
        // ::property-value pseudo element
        let propertyValuePseudoElement = domFromCSSProperty(sourceString: cssString as NSString, propertyName: "color" )
        
        let propertyValuePseudoElementChildList = propertyValuePseudoElement.childNodes!
        
        // we should only have the funcion element
        XCTAssert(propertyValuePseudoElementChildList.length == 1, "Wrong number of children.")
        
        let colorValueElement = propertyValuePseudoElementChildList.item(0)!  as! CSSDOMElement
        
        validateElementName(element: colorValueElement, expectedName: §CSSElementType.ColorValue)
        
        if let childList = colorValueElement.childNodes {
            
            // we should only have the funcion element
            XCTAssert(childList.length == 1, "Wrong number of children.")
            
            let functionElement = childList.item(0) as! CSSDOMElement
            
            validateElementName(element: functionElement, expectedName: §CSSElementType.Function)
            
            validateElementClass(element: functionElement, expectedClassName: "rgb")
            
            if let functionChildNodes = functionElement.childNodes {
                
                // we should only have the funcion-start pseudo element, the function param pseudo element and the css-token mirror
                XCTAssert(functionChildNodes.length == 5, "Wrong number of children.")
                
                // Validate fucntion-start pseudo-element
                let functionStartPseudoElement = functionChildNodes.item(0) as! CSSDOMElement
                
                validateElementName(element: functionStartPseudoElement, expectedName: §CSSElementType.FunctionStart)
                
                if let functionStartPseudoElementChildNodes = functionStartPseudoElement.childNodes {
                    
                    XCTAssert(functionStartPseudoElementChildNodes.length == 1, "Wrong number of children.")
                    
                    validateFunctionStartPseudoElement(functionStartPseudoElement: functionStartPseudoElement, functionName: "rgb")
                }
                else {
                    
                    XCTAssert(false, "functionStartPseudoElementChildNodes is nil.")
                }
                
                ///////////////////////////////////////////////////////////////////
                // validate function-param
                var functionParamPseudoElement = functionChildNodes.item(1) as! CSSDOMElement
                
                validateNumberFunctionParam(functionParamPseudoElement: functionParamPseudoElement)
                
                let commaTokenMirrorPseudoElement = functionChildNodes.item(2) as! CSSDOMTokenElement
                
                validateCommaToken(tokenElement: commaTokenMirrorPseudoElement)
                
                ///////////////////////////////////////////////////////////////////
                // validate function-param
                functionParamPseudoElement = functionChildNodes.item(3) as! CSSDOMElement
                
                validateNumberFunctionParam(functionParamPseudoElement: functionParamPseudoElement)
                
                
                // validate css-token.right-parenthesis
                
                let mirrorElement = functionChildNodes.item(4) as! CSSDOMTokenElement
                
                validateTokenElement(tokenElement: mirrorElement, expectedTokenClassTypes: [§TokenClassType.RightParenthesisToken])
                
                XCTAssert(functionElement.messageWithCode(MessageCode.notEnoughArgumentsPassedToFunction) != nil, "Missing error in DOM element.")
                
            }
            else {
                
                XCTAssert(false, "functionChildNodes is nil.")
            }
        }
        else {
            
            XCTAssert(false, "childNodes is nil.")
        }
        
        // validate color value
        if let _ = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            XCTAssert(false, "Color is not nil.")
        }

    }
    
    
    func testRGBColorParsing1() {
        
        let cssString =
        "   body {                          " +
            "       color :rgb(0,0,255);         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            debugPrint("Parsed color: \(color)")
            
            let expectedColor = NSColor(red: 0, green: 0, blue: 255/255, alpha: 1)
            
            let nsColor = NSColor(ciColor: color)
            
            let colorSpacedColor = nsColor.usingColorSpace(NSColorSpace.sRGB)!
            
            XCTAssert(colorSpacedColor.isEqual(expectedColor), "Color is not expected.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    func testRGBColorParsing2() {
        
        let cssString =
        "   body {                          " +
            "       color :rgb(0,34,255);         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            let expectedColor = NSColor(red: 0, green: 34/255, blue: 255/255, alpha: 1)
            
            let nsColor = NSColor(ciColor: color)
            
            let colorSpacedColor = nsColor.usingColorSpace(NSColorSpace.sRGB)!
            
            XCTAssert(colorSpacedColor.isEqual(expectedColor), "Color is not expected.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    func testRGBColorParsing3() {
        
        let cssString =
        "   body {                          " +
            "       color :rgb(0,34,3255);         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            let expectedColor = NSColor(red: 0, green: 34/255, blue: 255/255, alpha: 1)
            
            let nsColor = NSColor(ciColor: color)
            
            let colorSpacedColor = nsColor.usingColorSpace(NSColorSpace.sRGB)!
            
            XCTAssert(colorSpacedColor.isEqual(expectedColor), "Color is not expected.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    func testRGBColorParsing4() {
        
        let cssString =
        "   body {                          " +
            "       color :rgb(-47,34,3255);         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            let expectedColor = NSColor(red: 0, green: 34/255, blue: 255/255, alpha: 1)
            
            let nsColor = NSColor(ciColor: color)
            
            let colorSpacedColor = nsColor.usingColorSpace(NSColorSpace.sRGB)!
            
            XCTAssert(colorSpacedColor.isEqual(expectedColor), "Color is not expected.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    func testRGBPercentageColorParsing() {
        
        let cssString =
        "   body {                          " +
            "       color :rgb(0%,0%,100%);         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            let expectedColor = NSColor(red: 0, green: 0, blue: 255/255, alpha: 1)
            
            let nsColor = NSColor(ciColor: color)
            
            let colorSpacedColor = nsColor.usingColorSpace(NSColorSpace.sRGB)!
            
            XCTAssert(colorSpacedColor.isEqual(expectedColor), "Color is not expected.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    func testRGBPercentageColorWithSpaceParsing() {
        
        let cssString =
        "   body {                          " +
            "       color :rgb(0%       ,0%   ,   100%);         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            let expectedColor = CIColor(red: 0, green: 0, blue: 255/255, alpha: 1)
            
            XCTAssert(color ==  expectedColor, "Color is not expected.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    
    func testRGBAPercentageColorParsing() {
        
        let cssString =
        "   body {                          " +
            "       color :rgba(0%, 0% , 100%, 0.5);         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            let expectedColor = CIColor(red: 0, green: 0, blue: 255/255, alpha: 0.5)
            
            XCTAssert(color ==  expectedColor, "Color is not expected.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    func testHSLAColorIllegalPercentageHUEParsing() {
        
        let cssString =
        "   body {                          " +
            "       color :hsla(0%, 0% , 100%, 0.5);         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            let expectedColor = ColorUtils.convertHSLAToCIColor(0, s: 0, l: 1.0, a: 0.5)
            
            XCTAssert(color ==  expectedColor, "Color is not expected.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    func testHSLAColorParsing() {
        
        let cssString =
        "   body {                          " +
            "       color :hsla(4324, 0% , 100%, 0.5);         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            let expectedColor = ColorUtils.convertHSLAToCIColor(4324, s: 0, l: 1.0, a: 0.5)
            
            XCTAssert(color.isEqual(expectedColor), "Color is not expected.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    //                  ::function-param
    //                          |
    //                          |
    //                  css-token.number
    //
    private func validateNumberFunctionParam(functionParamPseudoElement: CSSDOMElement, tokenElementClassesLength: Int = 1) {
        
        validateElementName(element: functionParamPseudoElement, expectedName: §CSSElementType.FunctionParameter)
        
        if let functionParamPseudoElementChildNodes = functionParamPseudoElement.childNodes {
        
            XCTAssert(functionParamPseudoElementChildNodes.length == 1, "Wrong number of children expected 1 received: \(functionParamPseudoElementChildNodes.length)")
            
            let mirrorElement = functionParamPseudoElementChildNodes.item(0) as! CSSDOMTokenElement
            
            validateNumberToken(tokenElement: mirrorElement, numberOfClasses: tokenElementClassesLength)
        }
        else {
            
            XCTAssert(false, "functionStartPseudoElementChildNodes is nil.")
        }
        
    }
    
    
    /*
                VALIDATE THIS STRUCTURE:
    
                css-token.comma
    
    */
    private func validateCommaToken(tokenElement: CSSDOMTokenElement) {
        
        XCTAssert(tokenElement.localName == §CSSElementType.Token, "colonTokenElement.nodeName != §CSSElementType.Token")
        
        XCTAssert(tokenElement.classList.length == 1, "Wrong number of classes.")
        
        validateElementClass(element: tokenElement, expectedClassName: §TokenClassType.CommaToken)
    }
    
    /*
            VALIDATE THIS STRUCTURE:
    
            css-token.number
    
    */
    private func validateNumberToken(tokenElement: CSSDOMTokenElement, numberOfClasses classListLength: Int = 1) {
        
        XCTAssert(tokenElement.localName == §CSSElementType.Token, "colonTokenElement.nodeName != §CSSElementType.Token")
            
        XCTAssert(tokenElement.classList.length == classListLength, "Wrong number of classes: \(tokenElement.classListString)")
        
        validateElementClass(element: tokenElement, expectedClassName: §TokenClassType.NumberToken)
    }
    
    
    //                  ::function-start
    //                          |
    //                          |
    //             css-token.function-token.rgb
    //
    private func validateFunctionStartPseudoElement(functionStartPseudoElement: CSSDOMElement, functionName: String) {
        
        validateElementName(element: functionStartPseudoElement, expectedName: §CSSElementType.FunctionStart)
        
        if let functionStartPseudoElementChildNodes = functionStartPseudoElement.childNodes {
            
            XCTAssert(functionStartPseudoElementChildNodes.length == 1, "Wrong number of children.")
            
            let mirrorElement = functionStartPseudoElementChildNodes.item(0) as! CSSDOMTokenElement
            
            validateFunctionToken(tokenElement: mirrorElement, expectedFunctionName: functionName)
            
        }
        else {
            
            XCTAssert(false, "functionStartPseudoElementChildNodes is nil.")
        }
    }
    

    
    /*
    
    VALIDATE THIS STRUCTURE
    
    css-token.function-token.<function name>
    
    */
    private func validateFunctionToken(tokenElement: CSSDOMTokenElement, expectedFunctionName: DOMString) {
        
        XCTAssert(tokenElement.localName == §CSSElementType.Token, "colonTokenElement.nodeName != §CSSElementType.Token")
        
        XCTAssert(tokenElement.classList.length == 2, "Wrong number of classes.")
        
        validateElementClass(element: tokenElement, expectedClassName: §TokenClassType.FunctionToken)
        
        validateElementClass(element: tokenElement, expectedClassName: expectedFunctionName)
    }
}
