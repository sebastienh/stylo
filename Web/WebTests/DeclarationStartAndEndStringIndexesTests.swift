//
//  DeclarationStartAndStopIndexesTests.swift
//  Web
//
//  Created by Sebastien Hamel on 2021-01-15.
//  Copyright © 2021 Textually Inc. All rights reserved.
//

import XCTest
@testable import Web
import Common

class DeclarationStartAndStopIndexesTests: CssTests {

    func testDeclarationStartAndEndIndexes1() {
        
        let stylesheetSource =
            """
            * {
                --h-t1: var(--orange-t1, yellow);
                --h-t2: var(--orange-t2, yellow);
                --h-t3: var(--orange-t3, yellow);
                --h-t4: var(--orange-t4, yellow);
            }
            """
        
        print("stylesheetSource: \(stylesheetSource)")
        
        stylesheetSource.printCharactersIndexes()
        
        let styleSheet = parseStylesheet(stylesheetString: stylesheetSource)

        guard let styleRule = styleSheet[0] as? CSSStyleRule else {
            XCTAssert(false, "styleRule is nil")
            return
        }
        
        guard let styleDeclaration = styleRule.style else {
            XCTAssert(false, "styleDeclaration is nil")
            return
        }
        
        let (property1, declaration1) = styleDeclaration.propertyStyleDeclarations[0]
        XCTAssert(property1 == "--h-t1", "Received: \(property1)")
        XCTAssert(declaration1.startStringIndex == 8)
        XCTAssert(declaration1.endSemiColonToken?.endStringIndex == 41)
        
        let (property2, declaration2) = styleDeclaration.propertyStyleDeclarations[1]
        XCTAssert(property2 == "--h-t2", "Received: \(property2)")
        XCTAssert(declaration2.startStringIndex == 46)
        XCTAssert(declaration2.endSemiColonToken?.endStringIndex == 79)
        
        let (property3, declaration3) = styleDeclaration.propertyStyleDeclarations[2]
        XCTAssert(property3 == "--h-t3", "Received: \(property3)")
        XCTAssert(declaration3.startStringIndex == 84)
        XCTAssert(declaration3.endSemiColonToken?.endStringIndex == 117)
        
        let (property4, declaration4) = styleDeclaration.propertyStyleDeclarations[3]
        XCTAssert(property4 == "--h-t4", "Received: \(property4)")
        XCTAssert(declaration4.startStringIndex == 122)
        XCTAssert(declaration4.endSemiColonToken?.endStringIndex == 155)
    }

    func testDeclarationStartAndEndIndexes2() {
        
        let stylesheetSource =
            """
            * {
                --h-t1: blue;
            }
            """
        
        print("stylesheetSource: \(stylesheetSource)")
        
        stylesheetSource.printCharactersIndexes()
        
        let styleSheet = parseStylesheet(stylesheetString: stylesheetSource)

        guard let styleRule = styleSheet[0] as? CSSStyleRule else {
            XCTAssert(false, "styleRule is nil")
            return
        }
        
        guard let styleDeclaration = styleRule.style else {
            XCTAssert(false, "styleDeclaration is nil")
            return
        }
        
        let (property1, declaration1) = styleDeclaration.propertyStyleDeclarations[0]
        XCTAssert(property1 == "--h-t1")
        XCTAssert(declaration1.startStringIndex == 8)
        XCTAssert(declaration1.endSemiColonToken?.endStringIndex == 21)
    }
    
}
