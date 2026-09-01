//
//  CSDeclarationTests.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-06-21.
//  Copyright © 2018 NM. All rights reserved.
//

import XCTest
import Common
import XCTest
@testable import Web

class CSDeclarationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    func testCSDeclarationClone1() {
        
        
        let cssString =
            "   body {                          " +
                "       font-family: arial !important;         " +
        "   }                               "
        
        let reader = CSSReader(sourceString: cssString as NSString )
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
        let parsedDeclaration = declaration(from: styleSheet)
        
        let declarationClone = parsedDeclaration.clone()
        
        XCTAssert(parsedDeclaration.equals(to: declarationClone, comparePositions: true))
    }
    
    func testCSDeclarationClone2() {
        
        
        let cssString =
            "   body {                          " +
                "       color: rgb(123,34,245) !important;         " +
        "   }                               "
        
        let reader = CSSReader(sourceString: cssString as NSString )
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
        let parsedDeclaration = declaration(from: styleSheet)
        
        let declarationClone = parsedDeclaration.clone()
        
        XCTAssert(parsedDeclaration.equals(to: declarationClone, comparePositions: true))
    }
    

    func testCSDeclarationClone3() {
        
        
        let cssString =
            "   body {                          " +
                "       color :rgb();         " +
        "   }                               ";
        
        
        let reader = CSSReader(sourceString: cssString as NSString )
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
        let parsedDeclaration = declaration(from: styleSheet)
        
        let declarationClone = parsedDeclaration.clone()
        
        XCTAssert(parsedDeclaration.equals(to: declarationClone, comparePositions: true))
    }
    
    func testCustomPropertyDeclaration() {
        
        let cssString = """
            body {
                --my-color: val(--test);
            }
        """;
        
        
        let reader = CSSReader(sourceString: cssString as NSString )
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
        let parsedDeclaration = declaration(from: styleSheet)
        
        XCTAssert(parsedDeclaration.propertyName == "--my-color")
        print("parsedDeclaration: \(parsedDeclaration)")
    }
    
    private func declaration(from stylesheet: CSStyleSheet) -> CSDeclaration {
        
        let rule: CSQualifiedRule = stylesheet.cssRules.first as! CSQualifiedRule
        let (declarationList, _) = CSParser.consumeAListOfDeclarations(rule.block!.componentValueList, cssStyleDeclaration: nil, declarationStopIndex: nil)
        return declarationList.declarations.first! as! CSDeclaration
    }

}
