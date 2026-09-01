//
//  TestCSSSelectorsModule.swift
//  CSSKit
//
//  Created by Sébastien Hamel on 2015-02-23.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
@testable import Web

class TestCSSSelectorsModule: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testParseEmptyAttributeSelector() {
        
        
        let selectorModule = CSSSelectorsModule.shared
        
        let sourceString = "[attribute-name]"
        
        let selectors = selectorModule.parse(sourceString as NSString )
        
        if let selectors = selectors {
            
            if let selector = selectors.selectorArray[0] as? ComplexSelector {
                
                let compoundSelectorList = selector.compoundSelectorList
                
                XCTAssert(compoundSelectorList.count == 1, "There should have been one selectors.")
                
                // [attribute-name]
                let firstSelector = compoundSelectorList[0]
                
                XCTAssert(firstSelector.simpleSelectorSequence.count == 1, "Should be one simpleselector")
                
                if let attribSelector = firstSelector.simpleSelectorSequence[0] as? AttribSelector {
                    
                    XCTAssert(attribSelector.attribName!.ident!.identString == "attribute-name", "attribName not valid")
                    XCTAssert(attribSelector.attribMatch?.matchType == nil)
                }
                else {
                    XCTAssert(false, "selector should be AttribSelector")
                }
            }
            else {
                XCTAssert(false, "First selector should be ComplexSelector")
            }
        }
    }
    
    func testParseSelector() {

        
        let selectorModule = CSSSelectorsModule.shared
        
        let sourceString = "body .testClass#testId"
        
        let selectors = selectorModule.parse(sourceString as NSString )
        
        if let selectors = selectors {
            
            if let selector = selectors.selectorArray[0] as? ComplexSelector {
                
                let compoundSelectorList = selector.compoundSelectorList
                
                XCTAssert(compoundSelectorList.count == 2, "There should have been two selectors.")
                
                // body
                let firstSelector = compoundSelectorList[0]
                
                XCTAssert(firstSelector.simpleSelectorSequence.count == 1, "Should be one simpleselector")
                
                if let typeSelector = firstSelector.simpleSelectorSequence[0] as? TypeSelector {
                
                    XCTAssert(typeSelector.elementName.ident!.rawIdent == "body", "selector is not body")
                }
                else {
                    XCTAssert(false, "selector should be TypeSelector")
                }
                
                // .testClass#testId"
                let secondSelector = compoundSelectorList[1]
                
                XCTAssert(secondSelector.simpleSelectorSequence.count == 2, "Should be one simpleselector")
                
                if let classSelector = secondSelector.simpleSelectorSequence[0] as? ClassSelector {
                    
                    XCTAssert(classSelector.ident.rawIdent == "testClass", "selector is not testClass")
                }
                else {
                    XCTAssert(false, "selector should be TypeSelector")
                }
                if let idSelector = secondSelector.simpleSelectorSequence[1] as? IdSelector {
                    
                    if let formattedHash = idSelector.formattedHash {
                    
                        XCTAssert(formattedHash == "testId", "selector is not testId")
                    }
                }
                else {
                    XCTAssert(false, "selector should be TypeSelector")
                }
                
            }
            else {
                XCTAssert(false, "First selector should be ComplexSelector")
            }
        }
    }
    
    func testParseSelectorWithIdentClass() {
        
        
        let selectorModule = CSSSelectorsModule.shared
        
         
        
        let sourceString = ":root"
        
        let selectors = selectorModule.parse(sourceString as NSString )
        
        if let selectors = selectors {
            
            let selectorList = selectors.selectorArray
            
            let selector = selectorList[0]
                
                let compoundSelectorList = selector.compoundSelectorList
                
                XCTAssert(compoundSelectorList.count == 1, "There should have been two selectors.")
                
                // :root
                let firstSelector = compoundSelectorList[0]
                
                XCTAssert(firstSelector.simpleSelectorSequence.count == 1, "Should be one simpleselector")
                
                if let identPseudoClass = firstSelector.simpleSelectorSequence[0] as? IdentPseudoClass {
                    
                    XCTAssert(identPseudoClass.ident.rawIdent == "root", "selector is not root")
                }
                else {
                    XCTAssert(false, "selector should be IdentPseudoClass")
                }
//            }
//            else {
//                XCTAssert(false, "First selector should be ComplexSelector")
//            }
        }
    }
    
    

}
