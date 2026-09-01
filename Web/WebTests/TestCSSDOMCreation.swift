//
//  TestCSSDOMCreation.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-30.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
@testable import Web

class TestCSSDOMCreation: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBasicCSSDOMCreation() {

        /*
            p {
                font-size : larger;
            }
        
            Derived tree:
        
                                                    ::css-style-sheet
                                                            |
                                                            |
                                                    ::css-style-rule
                                                            |
                            ________________________________|______________________________
                           /                                                               \
                          /                                                                 \
                ::selector-list                                                     ::style-declaration
                         |                                                                  |
                         |                                  ________________________________|______________________________
                ::complex-selector                         /                                |                              \
                         |                                / 								|					     		\
                         |                      css-token.left-curly-brace		  ::css-declaration-block       css-token.right-curly-brace
               ::compound-selector                                                          |
                         |                                                                  |
                         |                                                          ::css-declaration
                 ::type-selector                                                            |
                         |                                                      ____________|____________
                         |                                                     /                         \
              css-token.ident-token                                           /						      \
                                                            ::property-name.<name-of-property>       ::property-value
                                                                              |                             |
                                                                              |                             |
                                                                    css-token.string-token                  |
                                                                                                            |
                                                                                                            |
                                                                            ________________________________|___________________________
                                                                           /                                |                           \
                                                                          / 								|							 \
                                                                css-token.colon			     ::property-value-declaration         css-token.semi-colon
                                                                                                            |
                                                                                                            |
                                                                                            ::keyword.font-size-value.larger
                                                                                                            |
                                                                                                            |
                                                                                                 css-token.string-token
        
        
        So, the list of elements in the real tree is (visting the tree in-order):
        
        
        css-token.ident-token               --> p
        
        css-token.left-curly-brace          --> {
        
        css-token.string-token              --> font-size
        
        css-token.colon                     --> :
        
        css-token.string-token              --> larger
        
        css-token.semi-colon                --> ;
        
        css-token.right-curly-brace         --> }
        
        */
        
        
        
        
        let cssDomModule = CSSDOMModule.shared
         
        let cssString = getBasicCSS()
        
        if let cssDomDocument = cssDomModule.domFromCSSString(cssString as NSString, origin: .author) {
            
            let length = cssDomDocument.length
            
            // the document should contain the documenttype 
            // and the stylesheet
            let expectedLength = 2
            
            XCTAssert(length == expectedLength, "CSSDOMDocument lenght is not \(expectedLength) but \(length).")
            
            let descendants = cssDomDocument.descendants()
            
            XCTAssert(descendants.length == 30, "Error: descendants.length != 30, got \(descendants.length)")
            
            for node in descendants {
                
                print("Desendant : \(node)")
            }
        }
        else {
            XCTAssert(false, "CSSDOMDocument is nil.")
        }
    }

    func testTwoRulesCSSDOMCreation() {
        
        let cssDomModule = CSSDOMModule.shared
         
        let cssString = getTwoStyleRulesCSS()
        
        if let cssDomDocument = cssDomModule.domFromCSSString(cssString as NSString, origin: .author) {
            
            let length = cssDomDocument.length
            
            // the document should contain the documenttype
            // and the stylesheet
            let expectedLength = 2
            
            XCTAssert(length == expectedLength, "CSSDOMDocument lenght is not \(expectedLength) but \(length).")
            
            let descendants = cssDomDocument.descendants()
            
            XCTAssert(descendants.length == 76, "should have 54 descendants got \(descendants.length)")
            
        }
        else {
            XCTAssert(false, "CSSDOMDocument is nil.")
        }
    }
    
    func testComplexCSSDOMCreation() {
        
        let cssDomModule = CSSDOMModule.shared
         
        let cssString = getCSS()
        
        if let cssDomDocument = cssDomModule.domFromCSSString(cssString as NSString, origin: .author) {
            
            let length = cssDomDocument.length
            
            // the document should contain the documenttype
            // and the stylesheet
            let expectedLength = 2
            
            XCTAssert(length == expectedLength, "CSSDOMDocument lenght is not \(expectedLength) but \(length).")
            
            let descendants = cssDomDocument.descendants()
            
            XCTAssert(descendants.length == 187, "Expected 132, got \(descendants.length)")
            
        }
        else {
            XCTAssert(false, "CSSDOMDocument is nil.")
        }
    }
    
    
    func getBasicCSS() -> DOMString {
        
        let cssString =
            "   p {                                             " +
            "       font-size : larger;                         " +
            "   }                                               "
        
        return cssString
        
    }
    
    func getTwoStyleRulesCSS() -> DOMString {
        
        let cssString =
            "   body {                                          " +
            "       font-family: arial, times, serif;           " +
            "   }                                               " +
            "   p {                                             " +
            "       font-family: arial, times, serif;                       " +
            "   }                                               "
        
        return cssString
        
    }
    
    
    func getCSS() -> DOMString {
        
        let cssString =
            "   body {                                          " +
            "       font-family: arial, times, serif;           " +
            "   }                                               " +
            "   h1 {                                            " +
            "       font-family: arial, times, serif;           " +
            "   }                                               " +
            "   table {                                         " +
            "       font-family: arial, times, serif;           " +
            "   }                                               " +
            "   td {                                            " +
            "       font-family: arial, times, serif;           " +
            "   }                                               " +
            "   p {                                             " +
            "       font-family: arial, times, serif;           " +
            "   }                                               "
        
        return cssString
        
    }
    
}
