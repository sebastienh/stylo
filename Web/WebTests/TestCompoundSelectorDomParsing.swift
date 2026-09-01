//
//  TestCompoundSelectorDomParsing.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-10-03.
//  Copyright © 2015 NM. All rights reserved.
//

import XCTest
import Common
@testable import Web

final class TestCompoundSelectorDomParsing: TestCSSSelectorDomParsing {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// case DescendantSelectorCombinator = "descendant-combinator"
    func testDescendantSelectorCombinatorWhitespaceSelectorParsing() {
        
        let cssString =
        "   body .testClassName {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        validateCombinator(cssString: cssString, combinatorType: CombinatorType.Whitespace)
    }
    
    /// case NextSiblingSelectorCombinator = "next-sibling-combinator"
    func testNextSiblingCombinatorSelectorParsing() {
        
        let cssString =
        "   body + .testClassName {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        validateCombinator(cssString: cssString, combinatorType: CombinatorType.PlusSign)
    }
    
    /// case FollowingSiblingSelectorCombinator = "following-sibling-combinator"
    func testFollowingSiblingCombinatorSelectorParsing() {
        
        let cssString =
        "   body ~ .testClassName {                          " +
            "       font-family : arial, Times New Roman;         " +
        "   }                               ";
        
        validateCombinator(cssString: cssString, combinatorType: CombinatorType.Tilde)
    }
    
    
    //                                       TESTED STRUCTURE
    //
    //                                          selector-list
    //                                                |
    //                                                |
    //                                         complex-selector
    //                                                |
    //                  ______________________________|__________________________________________________
    //                 /                              |                                                  |
    //                /                               |                                                  |
    //         compound-selector                      |                                            compound-selector
    //                |                               |                                                  |
    //                |                               |                                                  |
    //               /                                |                                                  \
    //              /                                 |                                                   \
    //  type-selector.simple-selector    selector-combinator.<combinator-type>              class-selector.simple-selector
    //             |                                  |                                                    |
    //             |                                  |                                     _______________|________________
    //     element-name.body                  <substructure>                             /                                \
    //             |                                                                      /                                  \
    //             |                                                            css-token.delim-token           css-token.ident-token.testClassName
    //    css-token.ident-token
    //
    private func validateCombinator(cssString: String, combinatorType: CombinatorType) {
        
        let selectorList = domFromSelector(atIndex: 0, sourceString: cssString as NSString)
        
        validateElementName(element: selectorList, expectedName: §CSSElementType.SelectorList)
        
        if let selectorListChildNodes = selectorList.childNodes {
            
            XCTAssert(selectorListChildNodes.length == 1, "Wrong number of children.")
            
            let complexSelector = selectorListChildNodes[0]
            
            validateElementName(element: complexSelector as! CSSDOMElement, expectedName: §CSSElementType.ComplexSelector)
            
            let complexSelectorChildNodes = complexSelector!.childNodes
            
            XCTAssert(complexSelectorChildNodes!.length == 3, "Wrong number of children.")
            
            let compoundSelector = complexSelectorChildNodes![0]
            
            validateElementName(element: compoundSelector as! CSSDOMElement, expectedName: §CSSElementType.CompoundSelector)
            
            let combinatorSelector = complexSelectorChildNodes![1] as! CSSDOMElement
            
            validateSelectorCombinator(selectorCombinatorPseudoElement: combinatorSelector, combinatorType: combinatorType)
            
            let compoundSelectorChildNodes = compoundSelector!.childNodes
            
            XCTAssert(compoundSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            // Testing compound selector childs
            let typeSelector = compoundSelectorChildNodes![0] as! CSSDOMElement
            
            validateTypeSelector(typeSelectorPseudoElement: typeSelector, typeName: "body")
            
            validateElementName(element: combinatorSelector, expectedName: §CSSElementType.SelectorCombinator)
            
            let secondCompoundSelector = complexSelectorChildNodes![2]
            
            validateElementName(element: secondCompoundSelector as! CSSDOMElement, expectedName: §CSSElementType.CompoundSelector)
            
            let secondCompoundSelectorChildNodes = secondCompoundSelector!.childNodes
            
            XCTAssert(secondCompoundSelectorChildNodes!.length == 1, "Wrong number of children.")
            
            let classSelectorCombinator = secondCompoundSelectorChildNodes![0] as! CSSDOMElement
            
            validateClassSelector(classSelectorPseudoElement: classSelectorCombinator, className: "testClassName")

        }
    }
    
    
}
