//
//  TestComplexSelectorDomParsing.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-10-03.
//  Copyright © 2015 NM. All rights reserved.
//

import XCTest
import Common
@testable import Web

final class TestComplexSelectorDomParsing: TestCSSSelectorDomParsing {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    //                                      TESTED STRUCTURE
    //
    //                                      ::selector-list
    //                                              |
    //                       _______________________|_________________________
    //                      /                       |         			      \
    //                     /						|						   \
    //          ::complex-selector			  [css-token.comma           ::complex-selector]*
    //
    func textTwoComplexSelectors() {
        
        let cssString =
        "   :whatever, body {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        let selectorList = domFromSelector(atIndex: 0, sourceString: cssString as NSString)
        
        validateElementName(element: selectorList, expectedName: §CSSElementType.SelectorList)
        
        if let selectorListChildNodes = selectorList.childNodes {
            
            XCTAssert(selectorListChildNodes.length == 3, "Wrong number of children.")
            
            let firstComplexSelector = selectorListChildNodes[0] as! CSSDOMElement
            
            validateElementName(element: firstComplexSelector, expectedName: §CSSElementType.ComplexSelector)
        
            let firstMirrorTokenElement = selectorListChildNodes[1] as! CSSDOMElement
                
            validateTokenElement(tokenElement: firstMirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.CommaToken])
            
            let secondComplexSelector = selectorListChildNodes[2] as! CSSDOMElement
            
            validateElementName(element: secondComplexSelector, expectedName: §CSSElementType.ComplexSelector)
        }
    }
    
    //                                      TESTED STRUCTURE
    //
    //                                      ::selector-list
    //                                              |
    //                       _______________________|_________________________
    //                      /                       |         			      \
    //                     /						|						   \
    //          ::complex-selector			  [css-token.comma           ::complex-selector]*
    //
    func textTreeComplexSelectors() {
        
        let cssString =
        "   :whatever, body .ctest {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        let selectorList = domFromSelector(atIndex: 0, sourceString: cssString as NSString)
        
        validateElementName(element: selectorList, expectedName: §CSSElementType.SelectorList)
        
        if let selectorListChildNodes = selectorList.childNodes {
            
            XCTAssert(selectorListChildNodes.length == 5, "Wrong number of children.")
            
            let firstComplexSelector = selectorListChildNodes[0] as! CSSDOMElement
            
            validateElementName(element: firstComplexSelector, expectedName: §CSSElementType.ComplexSelector)
            
            let firstToken = selectorListChildNodes[1]
            
            if let firstTokenElement = firstToken as? CSSDOMElement {
                
                validateTokenElement(tokenElement: firstTokenElement, expectedTokenClassTypes: [§TokenClassType.CommaToken])
            }
            
            let secondComplexSelector = selectorListChildNodes[2] as! CSSDOMElement
            
            validateElementName(element: secondComplexSelector, expectedName: §CSSElementType.ComplexSelector)
            
            let secondToken = selectorListChildNodes[3]
            
            XCTAssert(secondToken is CSSDOMElement, "CSSDOMMirrorPseudoElement is expected.")
            
            if let secondTokenElement = secondToken as? CSSDOMElement {
                
                validateTokenElement(tokenElement: secondTokenElement, expectedTokenClassTypes: [§TokenClassType.CommaToken])
            }
            
            let thirdComplexSelector = selectorListChildNodes[4] as! CSSDOMElement
            
            validateElementName(element: thirdComplexSelector, expectedName: §CSSElementType.ComplexSelector)
        }
    }
    
}
