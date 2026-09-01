//
//  TestCSSSelectorDomParsing.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-10-01.
//  Copyright © 2015 NM. All rights reserved.
//

import XCTest
import Common
@testable import Web

class TestCSSSelectorDomParsing: TestCSSDOM {

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
    func validateSelectorCombinator(selectorCombinatorPseudoElement: CSSDOMElement, combinatorType: CombinatorType) {
        
        validateElementName(element: selectorCombinatorPseudoElement, expectedName: §CSSElementType.SelectorCombinator)
        
        switch combinatorType {
            
        //                      ::selector-combinator.descendant-combinator
        //                                          |
        //                                          |
        //                              ::css-token.whitespace-token
        //
        case .Whitespace:
        
            validateElementClass(element: selectorCombinatorPseudoElement, expectedClassName: §SelectorCombinatorClass.DescendantSelectorCombinator)
            
            selectorCombinatorPseudoElement
            
            // get the second child, after the first left square bracket.
            let selectorCombinatorPseudoElementChildNodes = selectorCombinatorPseudoElement.childNodes
            
            XCTAssert(selectorCombinatorPseudoElementChildNodes!.length == 0, "Wrong number of children.")
//
//            let firstMirrorTokenElement = selectorCombinatorPseudoElementChildNodes![0]
//            
//            XCTAssert(firstMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
//            
//            if let firstMirrorTokenElement = firstMirrorTokenElement as? CSSDOMTokenElement {
//                
//                validateTokenElement(firstMirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.WhitespaceToken])
//            }
        
            
        //                      ::selector-combinator.child-combinator
        //                                          |
        //                                          |
        //                      css-token.delim-token.greater-than-sign
        //
        case .GreaterThanSign:
        
            validateElementClass(element: selectorCombinatorPseudoElement, expectedClassName: §SelectorCombinatorClass.ChildSelectorCombinator)
            
            // get the second child, after the first left square bracket.
            let selectorCombinatorPseudoElementChildNodes = selectorCombinatorPseudoElement.childNodes
            
            XCTAssert(selectorCombinatorPseudoElementChildNodes!.length == 1, "Wrong number of children.")
            
            let firstToken = selectorCombinatorPseudoElementChildNodes![0]
            
            XCTAssert(firstToken is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
            
            if let firstTokenElement = firstToken as? CSSDOMTokenElement {
                
                validateTokenElement(tokenElement: firstTokenElement, expectedTokenClassTypes: [§TokenClassType.DelimToken, UnicodeCharacter.greaterThanSign.descriptionString()])
            }
            
        
        //                      ::selector-combinator.descendant-combinator
        //                                          |
        //                    ______________________|______________________
        //                   /                                             \
        //                  /						                        \
        // css-token.delim-token.greater-than-sign			    css-token.delim-token.greater-than-sign
        //
        case .DoubleGreaterSign:
        
            validateElementClass(element: selectorCombinatorPseudoElement, expectedClassName: §SelectorCombinatorClass.DescendantSelectorCombinator)
            
            // get the second child, after the first left square bracket.
            let selectorCombinatorPseudoElementChildNodes = selectorCombinatorPseudoElement.childNodes
            
            XCTAssert(selectorCombinatorPseudoElementChildNodes!.length == 2, "Wrong number of children.")
            
            let firstMirrorTokenElement = selectorCombinatorPseudoElementChildNodes![0]
            
            XCTAssert(firstMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
            
            if let firstMirrorTokenElement = firstMirrorTokenElement as? CSSDOMTokenElement {
                
                validateTokenElement(tokenElement: firstMirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.DelimToken, UnicodeCharacter.greaterThanSign.descriptionString()])
            }
        
            let secondMirrorTokenElement = selectorCombinatorPseudoElementChildNodes![1]
            
            XCTAssert(firstMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
            
            if let secondMirrorTokenElement = secondMirrorTokenElement as? CSSDOMTokenElement {
                
                validateTokenElement(tokenElement: secondMirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.DelimToken, UnicodeCharacter.greaterThanSign.descriptionString()])
            }
            
        //                      ::selector-combinator.next-sibling-combinator
        //                                          |
        //                                          |
        //                          css-token.delim-token.plus-sign
        //
        case .PlusSign:
        
            validateElementClass(element: selectorCombinatorPseudoElement, expectedClassName: §SelectorCombinatorClass.NextSiblingSelectorCombinator)
            
            // get the second child, after the first left square bracket.
            let selectorCombinatorPseudoElementChildNodes = selectorCombinatorPseudoElement.childNodes
            
            XCTAssert(selectorCombinatorPseudoElementChildNodes!.length == 1, "Wrong number of children.")
            
            let firstMirrorTokenElement = selectorCombinatorPseudoElementChildNodes![0]
            
            XCTAssert(firstMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
            
            if let firstMirrorTokenElement = firstMirrorTokenElement as? CSSDOMTokenElement {
                
                validateTokenElement(tokenElement: firstMirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.DelimToken, UnicodeCharacter.plusSign.descriptionString()])
            }
            
            
        //                      ::selector-combinator.following-sibling-combinator
        //                                          |
        //                                          |
        //                              css-token.delim-token.tilde
        //
        case .Tilde:
        
            validateElementClass(element: selectorCombinatorPseudoElement, expectedClassName: §SelectorCombinatorClass.FollowingSiblingSelectorCombinator)
            
            // get the second child, after the first left square bracket.
            let selectorCombinatorPseudoElementChildNodes = selectorCombinatorPseudoElement.childNodes
            
            XCTAssert(selectorCombinatorPseudoElementChildNodes!.length == 1, "Wrong number of children.")
            
            let firstMirrorTokenElement = selectorCombinatorPseudoElementChildNodes![0]
            
            XCTAssert(firstMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
            
            if let firstMirrorTokenElement = firstMirrorTokenElement as? CSSDOMTokenElement {
                
                validateTokenElement(tokenElement: firstMirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.DelimToken, UnicodeCharacter.tilde.descriptionString()])
            }
        }
    }
    
    
    //                                      TESTED STRUCTURE
    //
    //                              ::attribute-selector.simple-selector
    //                                               |
    //              _________________________________|______________________________
    //             /                                 |         			            \
    //            /       				     		 | 						         \
    //  css-token.left-square-bracket-token    ::attribute-name    css-token.right-square-bracket-token
    //
    //
    //                                               or
    //
    //                                                      ::attribute-selector.simple-selector
    //                                                                      |
    //          ____________________________________________________________|__________________________________________________________________________
    //         /                                        |         			|        				|				       |                           \
    //        /       				     		        |	 				|	        			|				       |                            \
    //   css-token.left-square-bracket-token  ::attribute-name     ::attribute-match	    ::attribute-value	 	::attribute-flags    css-token.right-square-bracket-token
    //
    func validateAttributeSelector(attributeSelectorPseudoElement: CSSDOMElement, expectedAttributeName: DOMString, expectedAttribMatchType: MatchType?, expectedAttribValue: DOMString?, expectedAttributeValueTokenClass: TokenClassType?, expectedFlags: Bool) {
        
        validateElementName(element: attributeSelectorPseudoElement, expectedName: §CSSElementType.AttributeSelector)
        
        validateAtributeSelectorSquareBrackets(attributeSelectorPseudoElement: attributeSelectorPseudoElement)
        
        let attributeNamePseudoElement = attributeNameFromAttributeSelector(attributeSelectorPseudoElement: attributeSelectorPseudoElement)
        
        validateAttribName(attribNameSelectorPseudoElement: attributeNamePseudoElement, expectedAttributeName: expectedAttributeName)
        
        if let expectedAttribMatchType = expectedAttribMatchType {
        
            let attributeMatchPseudoSelector = attributeMatchFromAttributeSelector(attributeSelectorPseudoElement: attributeSelectorPseudoElement)
            
            validateAttribMatch(attribMatchSelectorPseudoElement: attributeMatchPseudoSelector, matchType: expectedAttribMatchType)
            
            XCTAssert(expectedAttribValue != nil, "expectedAttribValue == nil")
                
            let attributeValueSelectorPseudoElement = attributeValueFromAttributeSelector(attributeSelectorPseudoElement: attributeSelectorPseudoElement)
                
            validateAttributeValue(attribValueSelectorPseudoElement: attributeValueSelectorPseudoElement, expectedTokenClass: expectedAttributeValueTokenClass!, stringValue: expectedAttribValue!)
                
            if expectedFlags {
                
                let attributeFlagsSelectorPseudoElement = attributeFlagsFromAttributeSelector(attributeSelectorPseudoElement: attributeSelectorPseudoElement)
                
                validateAttribFlags(attribFlagsSelectorPseudoElement: attributeFlagsSelectorPseudoElement)
            }
        }
    }
    
    func attributeFlagsFromAttributeSelector(attributeSelectorPseudoElement: CSSDOMElement) ->  CSSDOMElement {

        validateElementName(element: attributeSelectorPseudoElement, expectedName: §CSSElementType.AttributeSelector)
        
        // get the second child, after the first left square bracket.
        let attributeSelectorPseudoElementChildNodes = attributeSelectorPseudoElement.childNodes
        
        XCTAssert(attributeSelectorPseudoElementChildNodes!.length > 5, "Wrong number of children.")
        
        let attributeFlagsSelector: CSSDOMElement = attributeSelectorPseudoElementChildNodes![4] as! CSSDOMElement
        
        validateElementName(element: attributeFlagsSelector, expectedName: §CSSElementType.AttributeFlags)
        
        return attributeFlagsSelector
    }
    
    func attributeValueFromAttributeSelector(attributeSelectorPseudoElement: CSSDOMElement) ->  CSSDOMElement {
        
        validateElementName(element: attributeSelectorPseudoElement, expectedName: §CSSElementType.AttributeSelector)
        
        // get the second child, after the first left square bracket.
        let attributeSelectorPseudoElementChildNodes = attributeSelectorPseudoElement.childNodes
        
        XCTAssert(attributeSelectorPseudoElementChildNodes!.length > 4, "Wrong number of children.")
        
        let attributeValueSelector: CSSDOMElement = attributeSelectorPseudoElementChildNodes![3] as! CSSDOMElement
        
        validateElementName(element: attributeValueSelector, expectedName: §CSSElementType.AttributeValue)
        
        return attributeValueSelector
        
    }
    
    func attributeMatchFromAttributeSelector(attributeSelectorPseudoElement: CSSDOMElement) ->  CSSDOMElement {
        
        validateElementName(element: attributeSelectorPseudoElement, expectedName: §CSSElementType.AttributeSelector)
        
        // get the second child, after the first left square bracket.
        let attributeSelectorPseudoElementChildNodes = attributeSelectorPseudoElement.childNodes
        
        XCTAssert(attributeSelectorPseudoElementChildNodes!.length >= 4, "Wrong number of children.")
        
        let attributeMatchSelector: CSSDOMElement = attributeSelectorPseudoElementChildNodes![2] as! CSSDOMElement
        
        validateElementName(element: attributeMatchSelector, expectedName: §CSSElementType.AttributeMatch)
        
        return attributeMatchSelector
    }
    
    /// Method that takes an attribute selector pseudo element
    func attributeNameFromAttributeSelector(attributeSelectorPseudoElement: CSSDOMElement) ->  CSSDOMElement {
        
        validateElementName(element: attributeSelectorPseudoElement, expectedName: §CSSElementType.AttributeSelector)
        
        // get the second child, after the first left square bracket.
        let attributeSelectorPseudoElementChildNodes = attributeSelectorPseudoElement.childNodes
        
        XCTAssert(attributeSelectorPseudoElementChildNodes!.length >= 3, "Wrong number of children.")
        
        let attributeNameSelector: CSSDOMElement = attributeSelectorPseudoElementChildNodes![1] as! CSSDOMElement
        
        validateElementName(element: attributeNameSelector, expectedName: §CSSElementType.AttributeName)
        
        return attributeNameSelector
    }
    
    
    func validateAtributeSelectorSquareBrackets(attributeSelectorPseudoElement: CSSDOMElement) {
        
        validateElementName(element: attributeSelectorPseudoElement, expectedName: §CSSElementType.AttributeSelector)
        
        let attributeSelectorPseudoElementChildNodes = attributeSelectorPseudoElement.childNodes
        
        XCTAssert(attributeSelectorPseudoElementChildNodes!.length >= 3, "Wrong number of children.")
        
        let firstBracketMirrorToken = attributeSelectorPseudoElementChildNodes![0]
        
        XCTAssert(firstBracketMirrorToken is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
        
        if let firstBracketMirrorToken = firstBracketMirrorToken as? CSSDOMTokenElement {
            
            validateTokenElement(tokenElement: firstBracketMirrorToken, expectedTokenClassTypes: [§TokenClassType.LeftSquareBraquetToken])
        }
        
        // get the last element
        let secondBracketMirrorToken = attributeSelectorPseudoElementChildNodes![attributeSelectorPseudoElementChildNodes!.length - 1]
        
        XCTAssert(secondBracketMirrorToken is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
        
        if let secondBracketMirrorToken = secondBracketMirrorToken as? CSSDOMTokenElement {
            
            validateTokenElement(tokenElement: secondBracketMirrorToken, expectedTokenClassTypes: [§TokenClassType.RightSquareBraquetToken])
        }
        
    }
    
    
    //                                      TESTED STRUCTURE
    //
    //                                      ::attribute-name
    //                                              |
    //                                              |
    //                          css-token.ident-token.<ident-string-value>
    //
    func validateAttribName(attribNameSelectorPseudoElement: CSSDOMElement, expectedAttributeName: DOMString) {
        
        validateElementName(element: attribNameSelectorPseudoElement, expectedName: §CSSElementType.AttributeName)
        
        let attribNameSelectorChildNodes = attribNameSelectorPseudoElement.childNodes
        
        XCTAssert(attribNameSelectorChildNodes!.length == 1, "Wrong number of children.")
        
        let firstMirrorTokenElement = attribNameSelectorChildNodes![0]
        
        XCTAssert(firstMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
        
        if let firstMirrorTokenElement = firstMirrorTokenElement as? CSSDOMTokenElement {
            
            validateTokenElement(tokenElement: firstMirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.IdentToken, expectedAttributeName])
        }
    }
    
    //                                      TESTED STRUCTURE
    //
    //                                      ::attribute-value
    //                                              |
    //                                              |
    //                              css-token.string-token.<string-value>
    //
    //                                              Or
    //
    //                                      ::attribute-value
    //                                              |
    //                                              |
    //                          css-token.ident-token.<ident-string-value>
    //
    func validateAttributeValue(attribValueSelectorPseudoElement: CSSDOMElement, expectedTokenClass: TokenClassType, stringValue: DOMString) {
    
//        validateElementName(attribValueSelectorPseudoElement, expectedName: §CSSElementType.AttributeValue)
        
        let attribValueSelectorChildNodes = attribValueSelectorPseudoElement.childNodes
        
        XCTAssert(attribValueSelectorChildNodes!.length == 1, "Wrong number of children.")
        
        let firstMirrorTokenElement = attribValueSelectorChildNodes![0]
        
        XCTAssert(firstMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
        
        if let firstMirrorTokenElement = firstMirrorTokenElement as? CSSDOMTokenElement {
            
            validateTokenElement(tokenElement: firstMirrorTokenElement, expectedTokenClassTypes: [§expectedTokenClass, stringValue])
        }
    }
    
    //                                      TESTED STRUCTURE
    //
    //                                      ::attribute-flags
    //                                              |
    //                                              |
    //                                    css-token.ident-token
    //
    func validateAttribFlags(attribFlagsSelectorPseudoElement: CSSDOMElement) {
        
        validateElementName(element: attribFlagsSelectorPseudoElement, expectedName: §CSSElementType.AttributeFlags)
        
        let attribFlagsSelectorChildNodes = attribFlagsSelectorPseudoElement.childNodes
        
        XCTAssert(attribFlagsSelectorChildNodes!.length == 1, "Wrong number of children.")
        
        let firstMirrorTokenElement = attribFlagsSelectorChildNodes![0]
        
        XCTAssert(firstMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
        
        if let firstMirrorTokenElement = firstMirrorTokenElement as? CSSDOMTokenElement {
            
            validateTokenElement(tokenElement: firstMirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.IdentToken])
        }
    }
    
    
    //                                      TESTED STRUCTURE
    //
    //                                      ::attribute-match
    //                                              |
    //                                              |
    //                                    css-token.<match-type>
    //
    func validateAttribMatch(attribMatchSelectorPseudoElement: CSSDOMElement, matchType: MatchType) {
        
        validateElementName(element: attribMatchSelectorPseudoElement, expectedName: §CSSElementType.AttributeMatch)
        
        let attribMatchSelectorChildNodes = attribMatchSelectorPseudoElement.childNodes
        
        XCTAssert(attribMatchSelectorChildNodes!.length == 1, "Wrong number of children.")
        
        let firstMirrorTokenElement = attribMatchSelectorChildNodes![0]
        
        XCTAssert(firstMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
        
        if let firstMirrorTokenElement = firstMirrorTokenElement as? CSSDOMTokenElement {
        
            validateTokenElement(tokenElement: firstMirrorTokenElement, expectedTokenClassTypes: [§matchType.tokenClassTypeValue])
        }
        
    }
    
    
    
    //                                      TESTED STRUCTURE
    //
    //                          ::pseudo-element-selector.simple-selector
    //                                              |
    //                                  ____________|____________
    //                                 /                         \
    //                                /						      \
    //                  css-token.colon-token		css-token.ident-token.<raw-string-value>
    //
    func validatePseudoClassSelector(pseudoClassSelectorPseudoElement: CSSDOMElement, className:DOMString) {
        
        validateElementName(element: pseudoClassSelectorPseudoElement, expectedName: §CSSElementType.PseudoClassSelector)
        
        validateElementClass(element: pseudoClassSelectorPseudoElement, expectedClassName: §CSSDOMCommonClassType.SimpleSelector)
        
        let pseudoClassSelectorChildNodes = pseudoClassSelectorPseudoElement.childNodes
        
        XCTAssert(pseudoClassSelectorChildNodes!.length == 2, "Wrong number of children.")
        
        let firstMirrorTokenElement = pseudoClassSelectorChildNodes![0]
        
        XCTAssert(firstMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
        
        if let firstMirrorTokenElement = firstMirrorTokenElement as? CSSDOMTokenElement {
            
            validateTokenElement(tokenElement: firstMirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.ColonToken])
        }
        
        let secondMirrorTokenElement = pseudoClassSelectorChildNodes![1]
        
        XCTAssert(secondMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
        
        if let secondMirrorTokenElement = secondMirrorTokenElement as? CSSDOMTokenElement {
            
            validateTokenElement(tokenElement: secondMirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.IdentToken, className])
        }
    }
    
    
    
    //                                      TESTED STRUCTURE
    //
    //                          ::pseudo-element-selector.simple-selector
    //                                              |
    //                   ___________________________|________________________
    //                  /                           |         			     \
    //                 /				     		|						  \
    //      css-token.colon-token         css-token.colon-token   css-token.ident-token.<raw-string-value>
    //
    func validatePseudoElementSelector(pseudoElementSelectorPseudoElement: CSSDOMElement, pseudoElementName:DOMString) {
        
        validateElementName(element: pseudoElementSelectorPseudoElement, expectedName: §CSSElementType.PseudoElementSelector)
        
        validateElementClass(element: pseudoElementSelectorPseudoElement, expectedClassName: §CSSDOMCommonClassType.SimpleSelector)
        
        let pseudoElementSelectorChildNodes = pseudoElementSelectorPseudoElement.childNodes
        
        XCTAssert(pseudoElementSelectorChildNodes!.length == 3, "Wrong number of children.")
        
        let firstMirrorTokenElement = pseudoElementSelectorChildNodes![0]
        
        XCTAssert(firstMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
        
        if let firstMirrorTokenElement = firstMirrorTokenElement as? CSSDOMTokenElement {
            
            validateTokenElement(tokenElement: firstMirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.ColonToken])
        }
        
        let secondMirrorTokenElement = pseudoElementSelectorChildNodes![1]
        
        XCTAssert(secondMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
        
        if let secondMirrorTokenElement = secondMirrorTokenElement as? CSSDOMTokenElement {
            
            validateTokenElement(tokenElement: secondMirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.ColonToken])
        }
        
        let thirdMirrorTokenElement = pseudoElementSelectorChildNodes![2]
        
        XCTAssert(thirdMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
        
        if let thirdMirrorTokenElement = thirdMirrorTokenElement as? CSSDOMTokenElement {
            
            validateTokenElement(tokenElement: thirdMirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.IdentToken, pseudoElementName])
        }
    }

    /*
            ::type-selector.simple-selector.universal-selector
                            |
                            |
                    ::element-name
                            |
                            |
                css-token.delim-token.*
    
    */
    
    
    func validateUniversalSelector(universalSelectorPseudoElement: CSSDOMElement) {
        
        validateElementName(element: universalSelectorPseudoElement, expectedName: §CSSElementType.TypeSelector)
        
        validateElementClass(element: universalSelectorPseudoElement, expectedClassName: §CSSDOMCommonClassType.SimpleSelector)
        
        validateElementClass(element: universalSelectorPseudoElement, expectedClassName: §CSSDOMCommonClassType.UniversalSelector)
        
        let univeralSelectorChildNodes = universalSelectorPseudoElement.childNodes
        
        let elementName = univeralSelectorChildNodes![0]
        
        validateElementName(element: elementName as! CSSDOMElement, expectedName: §CSSElementType.ElementName)
        
        let elementNameChildNodes = elementName!.childNodes
        
        XCTAssert(elementNameChildNodes!.length == 1, "Wrong number of children.")
        
        let mirrorTokenElement = elementNameChildNodes![0]
        
        XCTAssert(mirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
        
        if let mirrorTokenElement = mirrorTokenElement as? CSSDOMTokenElement {
            
            validateTokenElement(tokenElement: mirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.DelimToken, "*"])
        }
    }
    
    
    
    //                                      TESTED STRUCTURE
    //
    //                              ::id-selector.simple-selector
    //                                              |
    //                                              |
    //                          css-token.hash-token.<formatted-string-value>
    //
    func validateIdSelector(idSelectorPseudoElement: CSSDOMElement, className:DOMString) {
        
        validateElementName(element: idSelectorPseudoElement, expectedName: §CSSElementType.IdSelector)
        
        validateElementClass(element: idSelectorPseudoElement, expectedClassName: "simple-selector")
        
        let idSelectorChildNodes = idSelectorPseudoElement.childNodes
        
        XCTAssert(idSelectorChildNodes!.length == 1, "Wrong number of children.")
        
        let firstMirrorTokenElement = idSelectorChildNodes![0]
        
        XCTAssert(firstMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
        
        if let firstMirrorTokenElement = firstMirrorTokenElement as? CSSDOMTokenElement {
            
            validateTokenElement(tokenElement: firstMirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.HashToken, className])
        }
        
    }
    
    //                                      TESTED STRUCTURE
    //
    //
    //                              ::class-selector.simple-selector
    //                                              |
    //                                  ____________|____________
    //                                 /                         \
    //                                /						      \
    //                    css-token.delim-token	      css-token.ident-token.<raw-string-value>
    //
    func validateClassSelector(classSelectorPseudoElement: CSSDOMElement, className: DOMString) {
        
        validateElementName(element: classSelectorPseudoElement, expectedName: §CSSElementType.ClassSelector)
        
        validateElementClass(element: classSelectorPseudoElement, expectedClassName: "simple-selector")
        
        let classSelectorChildNodes = classSelectorPseudoElement.childNodes
        
        XCTAssert(classSelectorChildNodes!.length == 2, "Wrong number of children.")
        
        let firstMirrorTokenElement = classSelectorChildNodes![0]
        
        XCTAssert(firstMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
        
        if let firstMirrorTokenElement = firstMirrorTokenElement as? CSSDOMTokenElement {
            
            validateTokenElement(tokenElement: firstMirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.DelimToken])
        }
        
        let secondMirrorTokenElement = classSelectorChildNodes![1]
        
        XCTAssert(secondMirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
        
        if let secondMirrorTokenElement = secondMirrorTokenElement as? CSSDOMTokenElement {
            
            validateTokenElement(tokenElement: secondMirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.IdentToken, className])
        }
    }
    
    //                                      TESTED STRUCTURE
    //
    //
    //                                 ::type-selector.simple-selector
    //                                                |
    //                                                |
    //                                      ::element-name.<typeName>
    //                                                |
    //                                                |
    //                                      css-token.ident-token
    //
    func validateTypeSelector(typeSelectorPseudoElement: CSSDOMElement, typeName: DOMString) {
        
        validateElementName(element: typeSelectorPseudoElement, expectedName: §CSSElementType.TypeSelector)
        
        validateElementClass(element: typeSelectorPseudoElement, expectedClassName: "simple-selector")
        
        let typeSelectorChildNodes = typeSelectorPseudoElement.childNodes
        
        XCTAssert(typeSelectorChildNodes!.length == 1, "Wrong number of children.")
        
        let elementName = typeSelectorChildNodes![0]
        
        validateElementName(element: elementName as! CSSDOMElement, expectedName: §CSSElementType.ElementName)
        
        let elementNameChildNodes = elementName!.childNodes
        
        XCTAssert(elementNameChildNodes!.length == 1, "Wrong number of children.")
        
        let mirrorTokenElement = elementNameChildNodes![0]
        
        XCTAssert(mirrorTokenElement is CSSDOMTokenElement, "CSSDOMTokenElement is expected.")
        
        if let mirrorTokenElement = mirrorTokenElement as? CSSDOMTokenElement {
            
            validateTokenElement(tokenElement: mirrorTokenElement, expectedTokenClassTypes: [§TokenClassType.IdentToken, "body"])
        }
    }
    
}
