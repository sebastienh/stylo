//
//  FirstLetterPseudoElementParsingTest.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-05-14.
//  Copyright © 2017 NM. All rights reserved.
//

import XCTest
@testable import Web

class FirstLetterPseudoElementParsingTest: XCTestCase {

    func testBasicFirstLetterPseudoElementParsing() {
        
        let cssString =
            "   body::first-letter {                          " +
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
        
    }

    func testBasicFirstLetterPseudoElementParsingWithError() {
        
        let cssString =
            "   body::first-letter p {                          " +
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
        
        XCTAssert(firstLetterPseudoSelector!.hasWarnings())
    }
    
}
