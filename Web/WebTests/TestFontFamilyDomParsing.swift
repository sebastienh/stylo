//
//  TestFontFamilyDomParsing.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
import Common
@testable import Web

class TestFontFamilyDomParsing: TestCSSDOM {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    //                                                  TESTED STRUCTURE
    //
    //                                                  ::property-value
    //                                __________________________|___________________________
    //                               /                          |           				\
    //                              /			  			    |                            \
    //                    font-family-name.arial         css-token.comma       font-family-name.time-new-roman
    //                             |															|
    //                             |								 ___________________________|___________________________
    //                    css-token.ident-token.arial  			   /							|							\
    //                                                            /							    |							 \
    //                                            css-token.ident-token.time       css-token.ident-token.new 	  css-token.ident-token.roman
    //
    //
    func testBasicFontFamilyParsingPseudoTree() {
        
        let cssString =
        "   body {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        // we receive the specific property-value from this method call
        // the rest of the css-declaration has been validated by the domFromCSSProperty method.
        let fontFamilyPropertyValueElement = domFromCSSProperty(sourceString: cssString as NSString, propertyName: "font-family" )
        
        if let childList = fontFamilyPropertyValueElement.childNodes {
            
            XCTAssert(childList.length == 3, "Wrong number of children.")
            
            for var index in 0..<childList.length {
                
                let child = childList[index]
                
                switch index {
                    
                case 0:
                    
                    XCTAssert(child is CSSDOMElement, "CSSDOMElement is expected.")
                    
                    if let fontFamilyPseudoElement = child as? CSSDOMElement {
                        
                        valiateFontFamilyPseudoElement(fontFamilyPseudoElement: fontFamilyPseudoElement, expectedFontFamilyName: "arial")
                        
                        let fontFamilyPseudoElementChildList = fontFamilyPseudoElement.childNodes
                            
                        let mirrorElement = fontFamilyPseudoElementChildList!.item(0) as! CSSDOMTokenElement
                        
                        validateFontFamilyIdentToken(tokenElement: mirrorElement, expectedFontFamilyName: "arial")
                    }
                    
                case 1:
                    
                    XCTAssert(child is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
                    
                    if let child = child as? CSSDOMTokenElement {
                        
                        validateTokenElement(tokenElement: child, expectedTokenClassTypes: [§TokenClassType.CommaToken])
                    }
                    
                case 2:
                    
                    XCTAssert(child is CSSDOMElement, "CSSDOMElement is expected. \(child)")
                    
                    
                    if let fontFamilyPseudoElement = child as? CSSDOMElement {
                        
                        valiateFontFamilyPseudoElement(fontFamilyPseudoElement: fontFamilyPseudoElement, expectedFontFamilyName: "times-new-roman")
                        
                        let fontFamilyPseudoElementChildList = fontFamilyPseudoElement.childNodes
                        
                        XCTAssert(fontFamilyPseudoElementChildList!.length == 3, "Wrong number of children.")
                        
                        let firstMirrorElement = fontFamilyPseudoElementChildList!.item(0) as! CSSDOMTokenElement
                        
                        validateFontFamilyIdentToken(tokenElement: firstMirrorElement, expectedFontFamilyName: "times")
                        
                        let secondMirrorElement = fontFamilyPseudoElementChildList!.item(1) as! CSSDOMTokenElement
                        
                        validateFontFamilyIdentToken(tokenElement: secondMirrorElement, expectedFontFamilyName: "new")
                        
                        let thirdMirrorElement = fontFamilyPseudoElementChildList!.item(2) as! CSSDOMTokenElement
                        
                        validateFontFamilyIdentToken(tokenElement: thirdMirrorElement, expectedFontFamilyName: "roman")
                    }
                    
                default:
                    
                    XCTAssert(false, "wrong number of childs.")
                }
            }
        }
        else {
            XCTAssert(false, "childList is nil.")
        }
    }

    //                                                  TESTED STRUCTURE
    //
    //                                                  ::property-value
    //                                __________________________|___________________________
    //                               /                          |           				\
    //                              /			  			    |                            \
    //                    font-family-name.arial         css-token.comma       font-family-name.time-new-roman
    //                             |															|
    //                             |								 ___________________________|___________________________
    //                    css-token.ident-token.arial  			   /							|							\
    //                                                            /							    |							 \
    //                                            css-token.ident-token.time       css-token.ident-token.new 	  css-token.ident-token.roman
    //
    //
    func testBasicFontFamilyParsingPseudoTree2() {
        
        let cssString =
            "   body {                          " +
                "       font-family : arial, \"Times New Roman\";         " +
        "   }                               ";
        
//        // we receive the specific property-value from this method call
//        // the rest of the css-declaration has been validated by the domFromCSSProperty method.
//        let fontFamilyPropertyValueElement = domFromCSSProperty(sourceString: cssString as NSString, propertyName: "font-family" )
//        
//        if let childList = fontFamilyPropertyValueElement.childNodes {
//            
//            XCTAssert(childList.length == 3, "Wrong number of children.")
//            
//            for var index in 0..<childList.length {
//                
//                let child = childList[index]
//                
//                switch index {
//                    
//                case 0:
//                    
//                    XCTAssert(child is CSSDOMElement, "CSSDOMElement is expected.")
//                    
//                    if let fontFamilyPseudoElement = child as? CSSDOMElement {
//                        
//                        valiateFontFamilyPseudoElement(fontFamilyPseudoElement: fontFamilyPseudoElement, expectedFontFamilyName: "arial")
//                        
//                        let fontFamilyPseudoElementChildList = fontFamilyPseudoElement.childNodes
//                        
//                        let mirrorElement = fontFamilyPseudoElementChildList!.item(0) as! CSSDOMTokenElement
//                        
//                        validateFontFamilyIdentToken(tokenElement: mirrorElement, expectedFontFamilyName: "arial")
//                    }
//                    
//                case 1:
//                    
//                    XCTAssert(child is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
//                    
//                    if let child = child as? CSSDOMTokenElement {
//                        
//                        validateTokenElement(tokenElement: child, expectedTokenClassTypes: [§TokenClassType.CommaToken])
//                    }
//                    
//                case 2:
//                    
//                    XCTAssert(child is CSSDOMElement, "CSSDOMElement is expected. \(child)")
//                    
//                    
//                    if let fontFamilyPseudoElement = child as? CSSDOMElement {
//                        
//                        valiateFontFamilyPseudoElement(fontFamilyPseudoElement: fontFamilyPseudoElement, expectedFontFamilyName: "times-new-roman")
//                        
//                        let fontFamilyPseudoElementChildList = fontFamilyPseudoElement.childNodes
//                        
//                        XCTAssert(fontFamilyPseudoElementChildList!.length == 3, "Wrong number of children.")
//                        
//                        let firstMirrorElement = fontFamilyPseudoElementChildList!.item(0) as! CSSDOMTokenElement
//                        
//                        validateFontFamilyIdentToken(tokenElement: firstMirrorElement, expectedFontFamilyName: "times")
//                        
//                        let secondMirrorElement = fontFamilyPseudoElementChildList!.item(1) as! CSSDOMTokenElement
//                        
//                        validateFontFamilyIdentToken(tokenElement: secondMirrorElement, expectedFontFamilyName: "new")
//                        
//                        let thirdMirrorElement = fontFamilyPseudoElementChildList!.item(2) as! CSSDOMTokenElement
//                        
//                        validateFontFamilyIdentToken(tokenElement: thirdMirrorElement, expectedFontFamilyName: "roman")
//                    }
//                    
//                default:
//                    
//                    XCTAssert(false, "wrong number of childs.")
//                }
//            }
//        }
//        else {
//            XCTAssert(false, "childList is nil.")
//        }
    }

    
    //                                                  TESTED STRUCTURE
    //
    //                                                  ::property-value-block
    //                                                            |
    //                                                            |
    //                                                      css-token.colon
    //
    //
    func testBasicFontFamilyParsingPseudoTreeWithoutPropertyValue() {
        
        let cssString =
        "   body {                          " +
            "       font-family :                              ";        
        
        let domModule = CSSDOMModule.shared
        
        let cssDomDocument: CSSDOMDocument? = domModule.domFromCSSString(cssString as NSString, origin: .author )
        
        let declarations = cssDomDocument!.getElementsByTagName(§CSSElementType.Declaration)
        
        for declaration in declarations {
            
            let declarationPseudoElement = declaration as! CSSDOMElement
            
            //
            //                                    ::css-declaration
            //                                            |
            //                                ____________|____________
            //                               /                         \
            //                              /						      \
            //                    ::property-name          		::property-value-block
            //
            if let childList = declarationPseudoElement.childNodes {
                
                XCTAssert(childList.length == 2, "Wrong number of children.")
                
                XCTAssert((childList.item(0)! as! CSSDOMElement).localName == §CSSElementType.PropertyName, "childList.item(0)!.nodeName != §PseudoElementType.PropertyName")
                
                let propertyValueBlockPseudoElement = childList.item(1)! as! CSSDOMElement
                
                XCTAssert(propertyValueBlockPseudoElement.localName == §CSSElementType.PropertyValueBlock, "childList.item(1)!.nodeName != §PseudoElementType.PropertyValueBlock")
                
                if let propertyValueBlockPseudoElementChildList = propertyValueBlockPseudoElement.childNodes {
                    
                    XCTAssert(propertyValueBlockPseudoElementChildList.length == 1, "Wrong number of children.")
                    
                    for index in 0 ..< propertyValueBlockPseudoElementChildList.length {
                        
                        let child = propertyValueBlockPseudoElementChildList[index]
                        
                        switch index {
                            
                        case 0:
                            
                            XCTAssert(child is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
                            
                            if let child = child as? CSSDOMTokenElement {
                                
                                validateTokenElement(tokenElement: child, expectedTokenClassTypes: [§TokenClassType.ColonToken])
                            }
                            
                        default:
                            
                            XCTAssert(false, "wrong number of childs.")
                        }
                    }
                }
                else {
                    XCTAssert(false, "childList is nil.")
                }
            }
            else {
                
                XCTAssert(false, "declarationPseudoElement.childNodes is nil!")
            }
        }
        
    }
    
    
    func testFontFamilyParsingWrongStringTokenAfterStringToken() {
        
        // in this case we should issue a MissingCommaError, because we can
        // stringly suggest that the user missed it.
        
        let cssString =
        "   body {                          " +
        "       font-family : \" Wront Font Family \"          \" Font Family\", Times New Roman;         " +
        "   }"
        
    }
    
    func testFontFamilyParsingWrongIdentTokenAfterStringToken() {
        
        // in this case we should issue a MissingCommaError, because we can
        // stringly suggest that the user missed it.
        
        let cssString =
        "   body {                          " +
        "       font-family : \" Font Family\"      Times New Roman;         " +
        "   }"
        
    }
    
    func testFontFamilyParsingWrongIdentTokenBeforeStringToken() {
        
        // in this case we should issue a MissingCommaError, because we can
        // stringly suggest that the user missed it.
        
        let cssString =
        "   body {                          " +
        "       font-family :  Times New Roman              \" Font Family\"  ;         " +
        "   }"
        
    }
    
    
    func testFontFamilyParsingWrongTokenAfterIdent() {
        
        let cssString =
        "   body {                          " +
        "       font-family : arial 432, Times New Roman;         " +
        "   }"
        
    }
    
    func testFontFamilyParsingWrongTokenBeforeIdent() {
        
        let cssString =
        "   body {                          " +
        "       font-family : 432 arial, Times New Roman;         " +
        "   }"
        
    }
    
    func testFontFamilyParsingWrongTokenAfterString() {
        
        let cssString =
        "   body {                          " +
        "       font-family : \"Times New Roman\" 432, Times New Roman;         " +
        "   }"
        
    }
    
    func testFontFamilyParsingWrongTokenBeforeString() {
        
        let cssString =
        "   body {                          " +
        "       font-family : 432 \"Times New Roman\", Times New Roman;         " +
        "   }"
        
    }
    
//    func testArrayFontFamilyParsingWithQuotesRealTree() {
    
        
        
        
//        let cssString =
//        "   body {                          " +
//            "       font-family : \"times new roman\", Arial, fhdjskfsfs, serif ;         " +
//        "   }                               ";
//        
//         
//        
//        let sourceString = SourceString(contentString: cssString)
//        
//        let pseudoPropertyValue = domFromCSSProperty(sourceString, document: CSSDOMDocument(), propertyName: "font-family" )
//        
//        if let pseudoPropertyValue = pseudoPropertyValue {
//            
//            if let parent = pseudoPropertyValue.parentElement {
//                
//                XCTAssert(parent is CSSDOMMirrorPseudoElement , "parent is not CSSDOMMirrorPseudoElement.")
//            }
//            
//            if let propertyNameMirrorPseudoElement = pseudoPropertyValue.parentElement as? CSSDOMMirrorPseudoElement {
//            
//                if let propertyNameElement = propertyNameMirrorPseudoElement.associatedElement as? CSSDOMPropertyNameElement {
//                
//                    if let childList = propertyNameElement.childNodes {
//                    
//                        XCTAssert(childList.length == 4, "Wrong number of children.")
//                        
//                        for var index = 0; index < childList.length; index++ {
//                            
//                            let child = childList[index]
//                            
//                            switch index {
//                                
//                            case 0:
//                                XCTAssert(child is CSSDOMStringElement, "CSSDOMStringElement is expected.")
//                            case 1:
//                                XCTAssert(child is CSSDOMKeywordElement, "CSSDOMKeywordElement is expected.")
//                            case 2:
//                                XCTAssert(child is CSSDOMStringElement, "CSSDOMStringElement is expected.")
//                            case 3:
//                                XCTAssert(child is CSSDOMStringElement, "CSSDOMStringElement is expected.")
//                            default:
//                                XCTAssert(false, "wrong number of childs.")
//                            }
//                        }
//                    }
//                    else {
//                        XCTAssert(false, "childList is nil.")
//                    }
//                }
//                else {
//                    XCTAssert(false, "propertyNameElement is nil.")
//                }
//            }
//            else {
//                XCTAssert(false, "propertyNameMirrorPseudoElement is nil.")
//            }
//        }
//        else {
//            XCTAssert(false, "Font is nil.")
//        }
//    }
    
    
    // FIXME: reintroduce this test
//    func testArrayFontFamilyParsingWithQuotesRealTree() {
//        
//        let cssString =
//        "   body {                          " +
//            "       font-family : \"times new roman\", Arial, fhdjskfsfs, serif ;         " +
//        "   }                               ";
//        
//         
//        
//        let sourceString = SourceString(contentString: cssString)
//        
//        let pseudoPropertyValue = domFromCSSProperty(sourceString, document: CSSDOMDocument(), propertyName: "font-family" )
//        
//        if let pseudoPropertyValue = pseudoPropertyValue {
//            
//            if let parent = pseudoPropertyValue.parentElement {
//                
//                XCTAssert(parent is CSSDOMMirrorPseudoElement , "parent is not CSSDOMMirrorPseudoElement.")
//            }
//            
//            if let propertyNameMirrorPseudoElement = pseudoPropertyValue.parentElement as? CSSDOMMirrorPseudoElement {
//                
//                if let propertyNameElement = propertyNameMirrorPseudoElement.associatedElement as? CSSDOMPropertyNameElement {
//                    
//                    if let childList = propertyNameElement.childNodes {
//                        
//                        XCTAssert(childList.length == 4, "Wrong number of children.")
//                        
//                        for var index = 0; index < childList.length; index++ {
//                            
//                            let child = childList[index]
//                            
//                            switch index {
//                                
//                            case 0:
//                                XCTAssert(child is CSSDOMStringElement, "CSSDOMStringElement is expected.")
//                            case 1:
//                                XCTAssert(child is CSSDOMKeywordElement, "CSSDOMKeywordElement is expected.")
//                            case 2:
//                                XCTAssert(child is CSSDOMStringElement, "CSSDOMStringElement is expected.")
//                            case 3:
//                                XCTAssert(child is CSSDOMStringElement, "CSSDOMStringElement is expected.")
//                            default:
//                                XCTAssert(false, "wrong number of childs.")
//                            }
//                        }
//                    }
//                    else {
//                        XCTAssert(false, "childList is nil.")
//                    }
//                }
//                else {
//                    XCTAssert(false, "propertyNameElement is nil.")
//                }
//            }
//            else {
//                XCTAssert(false, "propertyNameMirrorPseudoElement is nil.")
//            }
//        }
//        else {
//            XCTAssert(false, "Font is nil.")
//        }
//    }

    
    
    
    /*
    
                                    VALIDATE THIS STRUCTURE
    
                                    ::font-family-name.arial
    
    */
    private func valiateFontFamilyPseudoElement(fontFamilyPseudoElement: CSSDOMElement, expectedFontFamilyName: DOMString) {
        
        XCTAssert(fontFamilyPseudoElement.localName == §CSSElementType.FontFamilyName, "fontFamilyPseudoElement.localName != §CSSElementType.FontFamilyName")
        
        validateElementClass(element: fontFamilyPseudoElement, expectedClassName: expectedFontFamilyName)
    }
    
    /*
    
                                    VALIDATE THIS STRUCTURE
    
                                    css-token.ident-token.arial
    
    */
    private func validateFontFamilyIdentToken(tokenElement: CSSDOMTokenElement, expectedFontFamilyName: DOMString) {
        
        XCTAssert(tokenElement.localName == §CSSElementType.Token, "colonTokenElement.nodeName != §CSSElementType.Token")
        
        XCTAssert(tokenElement.classList.length == 2, "Wrong number of classes.")
        
        validateElementClass(element: tokenElement, expectedClassName: §TokenClassType.IdentToken)
        
        validateElementClass(element: tokenElement, expectedClassName: expectedFontFamilyName)
    }
    
    
}
