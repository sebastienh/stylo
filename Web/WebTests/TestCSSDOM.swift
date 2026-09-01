//
//  TestCSSDOM.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-30.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
import Common
@testable import Web

class TestCSSDOM: CssTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /// This method should return the property-value pseudo-element
    /// All the rest of the css-declaration which should be pretty statndard should be validated here.
    func domFromCSSProperty(sourceString: NSString, propertyName: DOMString ) -> CSSDOMElement {
        
        let domModule = CSSDOMModule.shared
        
        let cssDomDocument: CSSDOMDocument? = domModule.domFromCSSString(sourceString, origin: .author )

        let declarations = cssDomDocument!.getElementsByTagName(§CSSElementType.Declaration, inclusive: false)
        
        for declaration in declarations {
        
            let declarationPseudoElement = declaration as! CSSDOMElement
            
            //
            //                                      css-declaration
            //                                            |
            //                                ____________|____________
            //                               /                         \
            //                              /						    \
            //                      property-name          	  property-value-block
            //
            if let childList = declarationPseudoElement.childNodes {
                
                for child in childList {
                    
                    debugPrint("child: \(child.nodeName)")
                    debugPrint("localName: \(String(describing: (child as? Element)?.localName))")
                }
                
                XCTAssert(childList.length == 2, "Wrong number of children: \(childList.length)")
            
                XCTAssert((childList.item(0)! as! Element).localName == §CSSElementType.PropertyName, "childList.item(0)!.nodeName != §PseudoElementType.PropertyName: \((childList.item(0)! as! Element).localName)")
                
                let propertyValueBlockPseudoElement = childList.item(1)! as! CSSDOMElement
                
                XCTAssert(propertyValueBlockPseudoElement.localName == §CSSElementType.PropertyValueBlock, "childList.item(1)!.nodeName != §PseudoElementType.PropertyValueBlock")
                
                if let propertyValuePseudoElement = validatePropertyValueBlockPseudoElement(propertyValueBlockPseudoElement: propertyValueBlockPseudoElement) {
                
                    let propertyNamePseudoElement = childList.item(0)! as! CSSDOMElement
                    
                    if validatePropertyName(propertyNamePseudoElement: propertyNamePseudoElement, expectedPropertyName: propertyName) {
                        
                        return propertyValuePseudoElement
                    }
                    else {
                        
                        XCTAssert(false, "propertyNamePseudoElement.childNodes is nil!")
                    }
                }
                else {
                    
                    XCTAssert(false, "propertyValuePseudoElement is nil!")
                }
            }
            else {
                
                XCTAssert(false, "declarationPseudoElement.childNodes is nil!")
            }
        }
        
        XCTAssert(false, "property not found.")
        
        fatalError("property not found.")
    }

    /// Method that return the ::selector-list first element, the method assume
    func domFromSelector(atIndex index: Int, sourceString: NSString) -> CSSDOMElement {
        
        let domModule = CSSDOMModule.shared
        
        let cssDomDocument: CSSDOMDocument? = domModule.domFromCSSString(sourceString, origin: .author )
        
        let selectorLists = cssDomDocument!.getElementsByTagName(§CSSElementType.SelectorList)
        
        XCTAssert(selectorLists.length > index, "selectorLists.length <= index")
        
        return selectorLists[index] as! CSSDOMElement
    }

    
    // validate this structure:
    //                                                     property-name
    //                                                            |
    //                                                            |
    //                                            css-token.string-token.<string-value>
    //
    // The method return true or not depending on if it has found the expected property name.
    private func validatePropertyName(propertyNamePseudoElement: CSSDOMElement, expectedPropertyName: DOMString) -> Bool {
    
        if let propertyNamePseudoElementChildList = propertyNamePseudoElement.childNodes {
            
            XCTAssert(propertyNamePseudoElementChildList.length == 1, "Wrong number of children.")
            
            let tokenElement = propertyNamePseudoElementChildList.item(0) as! CSSDOMTokenElement
            
            let classList = tokenElement.classList
            
            var stringTokenPresent: Bool = false
            
            var propertyNameValuePresent: Bool = false
            
            for className in classList {
                
                if className == §TokenClassType.StringToken {
                    
                    stringTokenPresent = true
                }
                if className == expectedPropertyName {
                    
                    propertyNameValuePresent = true
                }
            }
            
            XCTAssert(stringTokenPresent, "stringToken not present")
            
            
            // find the property value element and return it.
            if propertyNameValuePresent {
                
                return true
            }
        }
        else {
            
            XCTAssert(false, "propertyNamePseudoElement.childNodes is nil!")
        }
    
        return false
    }
    
    // Validate this structure:
    //
    //                                      property-value-block
    //                                               |
    //               ________________________________|______________________________________________________
    //              /                                |                           | 						    \
    //             / 								 |							 |	 					 	 \
    //        css-token.colon			  		 property-value      important-declaration	    css-token.semi-colon
    //
    //
    private func validatePropertyValueBlockPseudoElement(propertyValueBlockPseudoElement: CSSDOMElement, importantDeclarationPresent: Bool = false) -> CSSDOMElement? {
        
        var propertyValuePseudoElement: CSSDOMElement?
        
        XCTAssert(propertyValueBlockPseudoElement.localName == §CSSElementType.PropertyValueBlock, "propertyValueBlockPseudoElement.localName != §CSSElementType.PropertyValueBlock")
        
        if let childList = propertyValueBlockPseudoElement.childNodes {
            
            var semiColonChildPosition: Int = 2
            
            if !importantDeclarationPresent {
            
                XCTAssert(childList.length == 3, "Wrong number of children.")
            }
            else {
                
                semiColonChildPosition = 3
                
                XCTAssert(childList.length == 4, "Wrong number of children.")
            }
            
            let colonTokenElement = childList.item(0)! as! CSSDOMElement
            
            validateTokenElement(tokenElement: colonTokenElement, expectedTokenClassTypes: [§TokenClassType.ColonToken])
            
            propertyValuePseudoElement = childList.item(1) as? CSSDOMElement
            
            XCTAssert(propertyValuePseudoElement!.localName == §CSSElementType.PropertyValue, "propertyValuePseudoElement.pseudoElementType != PseudoElementType.PropertyValue")
            
            if importantDeclarationPresent {
                
                let importantDeclarationElement = childList.item(2)! as! CSSDOMElement
                
                validateImportantDeclaration(importantDeclarationPseudoElement: importantDeclarationElement)
            }
            
            let semiColonTokenElement = childList.item(semiColonChildPosition)! as! CSSDOMElement
            
            validateTokenElement(tokenElement: semiColonTokenElement, expectedTokenClassTypes: [§TokenClassType.SemicolonToken])
        }
        
        return propertyValuePseudoElement
    }
    
    private func validateImportantDeclaration(importantDeclarationPseudoElement: CSSDOMElement) {
        
        fatalError("Missing implementation.")
    }
    
    func validateElementName(element: CSSDOMElement, expectedName: DOMString) {
        
        XCTAssert(element.localName == expectedName, "Error: expected name: \(expectedName), received: \(element.localName).")
    }
    
    func validateTokenElement(tokenElement: CSSDOMElement, expectedTokenClassTypes: [String]) {
        
        XCTAssert(tokenElement.localName == §CSSElementType.Token, "colonTokenElement.nodeName != §CSSElementType.Token")
        
        for expectedTokenClassType in expectedTokenClassTypes {
            
            validateElementClass(element: tokenElement, expectedClassName: expectedTokenClassType)
        }
    }
    
    func validateElementClass(element: Element, expectedClassName: DOMString) {
        
        var foundExpectedClassName = false
        
        let classNameList = element.classList
        
        for className in classNameList {
            
            if className.lowercased() == expectedClassName.lowercased() {
                
                foundExpectedClassName = true
            }
        }
        
        if !foundExpectedClassName {
            
            XCTAssert(false, "Did not found \(expectedClassName) class name on pseudo element.")
        }
    }
    
}
