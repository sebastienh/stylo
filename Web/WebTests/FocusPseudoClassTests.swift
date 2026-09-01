//
//  FocusPseudoClassTests.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-07-20.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
@testable import Web

class FocusPseudoClassTests: XCTestCase {

    func testBasicFocusPseudoClassParsing() {
        
        let cssString =
            "   body:focus {                          " +
                "       font-style : bold ;         " +
        "   }                               ";
        
        let reader = CSSReader(sourceString: cssString as NSString)
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0)
        let styleSheet = parser.parseStyleSheet()
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(computePropertyValues: false, origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
        
        let selectorList = cssStyleSheet.firstStyleRule!.selectorList!
        
        let bodySelector = selectorList.firstTypeSelector(withName: "body")
        XCTAssert(bodySelector != nil, "Should have found bodySelector.")
        
        let focusPseudoSelector = bodySelector!.associatedPseudoSelectors?.first
        XCTAssert(focusPseudoSelector != nil, "Should have found focusPseudoSelector.")
        
    }

    func testBasicFocusPseudoClassWithPseudoElementParsing() {
        
        let cssString =
            "   body::first-letter:focus {                          " +
                "       font-style : bold ;         " +
        "   }                               ";
        
        let reader = CSSReader(sourceString: cssString as NSString)
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0)
        let styleSheet = parser.parseStyleSheet()
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(computePropertyValues: false, origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
        
        let selectorList = cssStyleSheet.firstStyleRule!.selectorList!
        
        let bodySelector = selectorList.firstTypeSelector(withName: "body")
        XCTAssert(bodySelector != nil, "Should have found bodySelector.")
        
        let firstLetterPseudoSelector = bodySelector!.associatedPseudoSelectors?.first
        XCTAssert(firstLetterPseudoSelector != nil, "Should have found firstLetterPseudoSelector.")
        
        let focusPseudoSelector = bodySelector!.associatedPseudoSelectors?.last
        XCTAssert(focusPseudoSelector != nil, "Should have found focusPseudoSelector.")
        
    }
    
    func testBasicFocusPseudoClassWithPseudoElementParsing2() {
        
        let cssString =
            "   body::first-letter:focus {                          " +
                "       font-style : bold ;         " +
        "   }                               ";
        
        let reader = CSSReader(sourceString: cssString as NSString)
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0)
        let styleSheet = parser.parseStyleSheet()
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(computePropertyValues: false, origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
        
        let selectorList = cssStyleSheet.firstStyleRule!.selectorList!
        
        var found = false
        for selector in selectorList.selectorArray {
            
            if selector.containsFocusPseudoClass {
                found = true
            }
        }
        XCTAssert(found, "Should have found focusPseudoSelector.")
    }
    
    func testBasicFocusPseudoClassWithPseudoElementParsing3() {
        
        let cssString = """
               body:focus::first-letter {
                   font-style : bold ;
               }                              
            """;

        let reader = CSSReader(sourceString: cssString as NSString)
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0)
        let styleSheet = parser.parseStyleSheet()
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(computePropertyValues: false, origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
        
        let selectorList = cssStyleSheet.firstStyleRule!.selectorList!
        
        var found = false
        for selector in selectorList.selectorArray {
            
            if selector.containsFocusPseudoClass {
                found = true
            }
        }
        XCTAssert(found, "Should have found focusPseudoSelector.")
    }
    
    
}
