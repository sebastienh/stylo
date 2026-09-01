//
//  TestSimpleSelectorDomParsing.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-10-03.
//  Copyright © 2015 NM. All rights reserved.
//

import XCTest
import Common
@testable import Web

class TestSimpleSelectorDomParsing: TestCSSSelectorDomParsing {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    //                                       TESTED STRUCTURE
    //
    //                                        ::selector-list
    //                                                |
    //                                                |
    //                                       ::complex-selector
    //                                                |
    //                                                |
    //                                      ::compound-selector
    //                                                |
    //                                                |
    //                                 ::type-selector.simple-selector
    //                                                |
    //                                                |
    //                                      ::element-name
    //                                                |
    //                                                |
    //                                      css-token.ident-token.body
    //
    func testTypeSelectorParsing() {
        
        
        let cssString =
        "   body {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        let selectorList = domFromSelector(atIndex: 0, sourceString: cssString as NSString)
        
        validateElementName(element: selectorList, expectedName: §CSSElementType.SelectorList)
        
        if let selectorListChildNodes = selectorList.childNodes {
            
            XCTAssert(selectorListChildNodes.length == 1, "Wrong number of children.")
            
            let complexSelector = selectorListChildNodes[0]
            
            validateElementName(element: complexSelector as! CSSDOMElement, expectedName: §CSSElementType.ComplexSelector)
            
            let complexSelectorChildNodes = complexSelector!.childNodes
            
            XCTAssert(complexSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let compoundSelector = complexSelectorChildNodes![0]
            
            let compoundSelectorChildNodes = compoundSelector!.childNodes
            
            XCTAssert(compoundSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let typeSelector = compoundSelectorChildNodes![0]
            
            validateTypeSelector(typeSelectorPseudoElement: typeSelector as! CSSDOMElement, typeName: "body")
        }
    }
    
    //                                       TESTED STRUCTURE
    //
    //                                        ::selector-list
    //                                                |
    //                                                |
    //                                       ::complex-selector
    //                                                |
    //                                                |
    //                                      ::compound-selector
    //                                                |
    //                                                |
    //                                 ::type-selector.simple-selector
    //                                                |
    //                                                |
    //                                      ::element-name
    //                                                |
    //                                                |
    //                                      css-token.ident-token.body
    //
    func testTypeSelectorPreceededByCommentParsing() {
        
        
        let cssString =
        "/*                         " +
        "   Comment string                         " +
        "   */                         " +
        "       body {" +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        let selectorList = domFromSelector(atIndex: 0, sourceString: cssString as NSString)
        
        validateElementName(element: selectorList, expectedName: §CSSElementType.SelectorList)
        
        if let selectorListChildNodes = selectorList.childNodes {
            
            XCTAssert(selectorListChildNodes.length == 1, "Wrong number of children.")
            
            let complexSelector = selectorListChildNodes[0]
            
            validateElementName(element: complexSelector as! CSSDOMElement, expectedName: §CSSElementType.ComplexSelector)
            
            let complexSelectorChildNodes = complexSelector!.childNodes
            
            XCTAssert(complexSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let compoundSelector = complexSelectorChildNodes![0]
            
            let compoundSelectorChildNodes = compoundSelector!.childNodes
            
            XCTAssert(compoundSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let typeSelector = compoundSelectorChildNodes![0]
            
            validateTypeSelector(typeSelectorPseudoElement: typeSelector as! CSSDOMElement, typeName: "body")
        }
    }

    
    
    //                                       TESTED STRUCTURE
    //
    //                                        ::selector-list
    //                                                |
    //                                                |
    //                                       ::complex-selector
    //                                                |
    //                                                |
    //                                      ::compound-selector
    //                                                |
    //                                                |
    //                                 ::id-selector.simple-selector
    //                                                |
    //                                                |
    //                           css-token.hash-token.<formatted-string-value>
    //
    func testIdSelectorParsing() {
        
        let cssString =
        "   #testid {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        let selectorList = domFromSelector(atIndex: 0, sourceString: cssString as NSString)
        
        validateElementName(element: selectorList, expectedName: §CSSElementType.SelectorList)
        
        if let selectorListChildNodes = selectorList.childNodes {
            
            XCTAssert(selectorListChildNodes.length == 1, "Wrong number of children.")
            
            let complexSelector = selectorListChildNodes[0]
            
            validateElementName(element: complexSelector as! CSSDOMElement, expectedName: §CSSElementType.ComplexSelector)
            
            let complexSelectorChildNodes = complexSelector!.childNodes
            
            XCTAssert(complexSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let compoundSelector = complexSelectorChildNodes![0]
            
            let compoundSelectorChildNodes = compoundSelector!.childNodes
            
            XCTAssert(compoundSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let idSelector = compoundSelectorChildNodes![0]
            
            validateIdSelector(idSelectorPseudoElement: idSelector as! CSSDOMElement, className: "testid")
        }
    }
    
    //                                       TESTED STRUCTURE
    //
    //                                        ::selector-list
    //                                                |
    //                                                |
    //                                       ::complex-selector
    //                                                |
    //                                                |
    //                                      ::compound-selector
    //                                                |
    //                                                |
    //                                 ::attribute-selector.simple-selector
    //                                                |
    //                ________________________________|_______________________________
    //               /                                |                               \
    //              /                                 |                                \
    // css-token.left-square-bracket-token    ::attribute-name    css-token.right-square-bracket-token
    //                                                |
    //                                                |
    //                              css-token.ident-token.<ident-string-value>
    //
    func testAttributeNameSelectorParsing() {
        
        let cssString =
        "   [testAttributeName] {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        let selectorList = domFromSelector(atIndex: 0, sourceString: cssString as NSString)
        
        validateElementName(element: selectorList, expectedName: §CSSElementType.SelectorList)
        
        if let selectorListChildNodes = selectorList.childNodes {
            
            XCTAssert(selectorListChildNodes.length == 1, "Wrong number of children.")
            
            let complexSelector = selectorListChildNodes[0]
            
            validateElementName(element: complexSelector as! CSSDOMElement, expectedName: §CSSElementType.ComplexSelector)
            
            let complexSelectorChildNodes = complexSelector!.childNodes
            
            XCTAssert(complexSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let compoundSelector = complexSelectorChildNodes![0]
            
            let compoundSelectorChildNodes = compoundSelector!.childNodes
            
            XCTAssert(compoundSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let attributeSelector = compoundSelectorChildNodes![0] as! CSSDOMElement
            
            validateAttributeSelector(attributeSelectorPseudoElement: attributeSelector, expectedAttributeName: "testAttributeName", expectedAttribMatchType: nil, expectedAttribValue: nil, expectedAttributeValueTokenClass: nil, expectedFlags: false)
        }
    }
    
    
    func testAttributeExactMatchSelectorWithStringTokenValueParsing() {
        
        let cssString =
        "   [testAttributeName=\"attributeValue\"] {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        let selectorList = domFromSelector(atIndex: 0, sourceString: cssString as NSString)
        
        validateElementName(element: selectorList, expectedName: §CSSElementType.SelectorList)
        
        if let selectorListChildNodes = selectorList.childNodes {
            
            XCTAssert(selectorListChildNodes.length == 1, "Wrong number of children.")
            
            let complexSelector = selectorListChildNodes[0]
            
            validateElementName(element: complexSelector as! CSSDOMElement, expectedName: §CSSElementType.ComplexSelector)
            
            let complexSelectorChildNodes = complexSelector!.childNodes
            
            XCTAssert(complexSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let compoundSelector = complexSelectorChildNodes![0]
            
            let compoundSelectorChildNodes = compoundSelector!.childNodes
            
            XCTAssert(compoundSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let attributeSelector = compoundSelectorChildNodes![0] as! CSSDOMElement
            
            validateAttributeSelector(attributeSelectorPseudoElement: attributeSelector, expectedAttributeName: "testAttributeName", expectedAttribMatchType: MatchType.EqualMatch, expectedAttribValue: "attributeValue", expectedAttributeValueTokenClass: TokenClassType.StringToken, expectedFlags: false)
        }
    }
    
    func testAttributeExactMatchSelectorWithStringTokenValueWithSpacesParsing() {
        
        let cssString =
        "   [    testAttributeName=    \"attributeValue\"     ] {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        let selectorList = domFromSelector(atIndex: 0, sourceString: cssString as NSString)
        
        validateElementName(element: selectorList, expectedName: §CSSElementType.SelectorList)
        
        if let selectorListChildNodes = selectorList.childNodes {
            
            XCTAssert(selectorListChildNodes.length == 1, "Wrong number of children.")
            
            let complexSelector = selectorListChildNodes[0]
            
            validateElementName(element: complexSelector as! CSSDOMElement, expectedName: §CSSElementType.ComplexSelector)
            
            let complexSelectorChildNodes = complexSelector!.childNodes
            
            XCTAssert(complexSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let compoundSelector = complexSelectorChildNodes![0]
            
            let compoundSelectorChildNodes = compoundSelector!.childNodes
            
            XCTAssert(compoundSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let attributeSelector = compoundSelectorChildNodes![0] as! CSSDOMElement
            
            validateAttributeSelector(attributeSelectorPseudoElement: attributeSelector, expectedAttributeName: "testAttributeName", expectedAttribMatchType: MatchType.EqualMatch, expectedAttribValue: "attributeValue", expectedAttributeValueTokenClass: TokenClassType.StringToken, expectedFlags: false)
        }
    }
    
    
    func testAttributeExactMatchSelectorWithIdentTokenValueParsing() {
        
        let cssString =
        "   [testAttributeName=attributeValue] {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        let selectorList = domFromSelector(atIndex: 0, sourceString: cssString as NSString)
        
        validateElementName(element: selectorList, expectedName: §CSSElementType.SelectorList)
        
        if let selectorListChildNodes = selectorList.childNodes {
            
            XCTAssert(selectorListChildNodes.length == 1, "Wrong number of children.")
            
            let complexSelector = selectorListChildNodes[0]
            
            validateElementName(element: complexSelector as! CSSDOMElement, expectedName: §CSSElementType.ComplexSelector)
            
            let complexSelectorChildNodes = complexSelector!.childNodes
            
            XCTAssert(complexSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let compoundSelector = complexSelectorChildNodes![0]
            
            let compoundSelectorChildNodes = compoundSelector!.childNodes
            
            XCTAssert(compoundSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let attributeSelector = compoundSelectorChildNodes![0] as! CSSDOMElement
            
            validateAttributeSelector(attributeSelectorPseudoElement: attributeSelector, expectedAttributeName: "testAttributeName", expectedAttribMatchType: MatchType.EqualMatch, expectedAttribValue: "attributeValue", expectedAttributeValueTokenClass: TokenClassType.IdentToken, expectedFlags: false)
        }
    }
    
    func testAttributeExactMatchSelectorWithIdentTokenValueAndFlagsParsing() {
        
        let cssString =
        "   [testAttributeName=attributeValue i] {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        let selectorList = domFromSelector(atIndex: 0, sourceString: cssString as NSString)
        
        validateElementName(element: selectorList, expectedName: §CSSElementType.SelectorList)
        
        if let selectorListChildNodes = selectorList.childNodes {
            
            XCTAssert(selectorListChildNodes.length == 1, "Wrong number of children.")
            
            let complexSelector = selectorListChildNodes[0]
            
            validateElementName(element: complexSelector as! CSSDOMElement, expectedName: §CSSElementType.ComplexSelector)
            
            let complexSelectorChildNodes = complexSelector!.childNodes
            
            XCTAssert(complexSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let compoundSelector = complexSelectorChildNodes![0]
            
            let compoundSelectorChildNodes = compoundSelector!.childNodes
            
            XCTAssert(compoundSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let attributeSelector = compoundSelectorChildNodes![0] as! CSSDOMElement
            
            validateAttributeSelector(attributeSelectorPseudoElement: attributeSelector, expectedAttributeName: "testAttributeName", expectedAttribMatchType: MatchType.EqualMatch, expectedAttribValue: "attributeValue", expectedAttributeValueTokenClass: TokenClassType.IdentToken, expectedFlags: true)
        }
    }
    
    //                                       TESTED STRUCTURE
    //
    //                                        ::selector-list
    //                                                |
    //                                                |
    //                                       ::complex-selector
    //                                                |
    //                                                |
    //                                      ::compound-selector
    //                                                |
    //                                                |
    //                                 ::class-selector.simple-selector
    //
    func testClassSelectorParsing() {
        
        let cssString =
        "   .className {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        let selectorList = domFromSelector(atIndex: 0, sourceString: cssString as NSString)
        
        validateElementName(element: selectorList, expectedName: §CSSElementType.SelectorList)
        
        if let selectorListChildNodes = selectorList.childNodes {
            
            XCTAssert(selectorListChildNodes.length == 1, "Wrong number of children.")
            
            let complexSelector = selectorListChildNodes[0]
            
            validateElementName(element: complexSelector as! CSSDOMElement, expectedName: §CSSElementType.ComplexSelector)
            
            let complexSelectorChildNodes = complexSelector!.childNodes
            
            XCTAssert(complexSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let compoundSelector = complexSelectorChildNodes![0]
            
            let compoundSelectorChildNodes = compoundSelector!.childNodes
            
            XCTAssert(compoundSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let classSelector = compoundSelectorChildNodes![0] as! CSSDOMElement
            
            validateClassSelector(classSelectorPseudoElement: classSelector, className: "className")
        }
    }
    
    /*
                                           TESTED STRUCTURE
    
                                            ::selector-list
                                                    |
                                                    |
                                           ::complex-selector
                                                    |
                                                    |
                                          ::compound-selector
                                                    |
                                                    |
                                ::type-selector.simple-selector.universal-selector
                                                    |
                                                    |
                                            ::element-name
                                                    |
                                                    |
                                        css-token.delim-token.*
    
    */
    func testUniversalSelectorParsing() {
        
        let cssString =
        "   * {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        let selectorList = domFromSelector(atIndex: 0, sourceString: cssString as NSString)
        
        validateElementName(element: selectorList, expectedName: §CSSElementType.SelectorList)
        
        if let selectorListChildNodes = selectorList.childNodes {
            
            XCTAssert(selectorListChildNodes.length == 1, "Wrong number of children.")
            
            let complexSelector = selectorListChildNodes[0]
            
            validateElementName(element: complexSelector as! CSSDOMElement, expectedName: §CSSElementType.ComplexSelector)
            
            let complexSelectorChildNodes = complexSelector!.childNodes
            
            XCTAssert(complexSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let compoundSelector = complexSelectorChildNodes![0]
            
            let compoundSelectorChildNodes = compoundSelector!.childNodes
            
            XCTAssert(compoundSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let universalSelector = compoundSelectorChildNodes![0] as! CSSDOMElement
            
            validateUniversalSelector(universalSelectorPseudoElement: universalSelector)
        }
    }
    
    
    //                                       TESTED STRUCTURE
    //
    //                                        ::selector-list
    //                                                |
    //                                                |
    //                                       ::complex-selector
    //                                                |
    //                                                |
    //                                      ::compound-selector
    //                                                |
    //                                                |
    //                                 ::pseudo-class-selector.simple-selector
    //
    func testPseudoClassSelectorParsing() {
        
        let cssString =
        "   :whatever {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        let selectorList = domFromSelector(atIndex: 0, sourceString: cssString as NSString)
        
        validateElementName(element: selectorList, expectedName: §CSSElementType.SelectorList)
        
        if let selectorListChildNodes = selectorList.childNodes {
            
            XCTAssert(selectorListChildNodes.length == 1, "Wrong number of children.")
            
            let complexSelector = selectorListChildNodes[0]
            
            validateElementName(element: complexSelector as! CSSDOMElement, expectedName: §CSSElementType.ComplexSelector)
            
            let complexSelectorChildNodes = complexSelector!.childNodes
            
            XCTAssert(complexSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let compoundSelector = complexSelectorChildNodes![0]
            
            let compoundSelectorChildNodes = compoundSelector!.childNodes
            
            XCTAssert(compoundSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let pseudoClassSelector = compoundSelectorChildNodes![0] as! CSSDOMElement
            
            validatePseudoClassSelector(pseudoClassSelectorPseudoElement: pseudoClassSelector, className: "whatever")
        }
    }
    
    //                                       TESTED STRUCTURE
    //
    //                                        ::selector-list
    //                                                |
    //                                                |
    //                                       ::complex-selector
    //                                                |
    //                                                |
    //                                      ::compound-selector
    //                                                |
    //                                                |
    //                                 ::pseudo-element-selector.simple-selector
    //
    func testPseudoElementSelectorParsing() {
        
        let cssString =
        "   ::whatever {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        let selectorList = domFromSelector(atIndex: 0, sourceString: cssString as NSString)
        
        validateElementName(element: selectorList, expectedName: §CSSElementType.SelectorList)
        
        if let selectorListChildNodes = selectorList.childNodes {
            
            XCTAssert(selectorListChildNodes.length == 1, "Wrong number of children.")
            
            let complexSelector = selectorListChildNodes[0]
            
            validateElementName(element: complexSelector as! CSSDOMElement, expectedName: §CSSElementType.ComplexSelector)
            
            let complexSelectorChildNodes = complexSelector!.childNodes
            
            XCTAssert(complexSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let compoundSelector = complexSelectorChildNodes![0]
            
            let compoundSelectorChildNodes = compoundSelector!.childNodes
            
            XCTAssert(compoundSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let pseudoElementSelector = compoundSelectorChildNodes![0] as! CSSDOMElement
            
            validatePseudoElementSelector(pseudoElementSelectorPseudoElement: pseudoElementSelector, pseudoElementName: "whatever")
        }
    }


}
