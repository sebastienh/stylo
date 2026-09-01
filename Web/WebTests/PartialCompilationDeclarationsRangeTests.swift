//
//  PartialCompilationDeclarationsRangeTests.swift
//  Web
//
//  Created by Sebastien Hamel on 2021-01-15.
//  Copyright © 2021 Textually Inc. All rights reserved.
//

import XCTest
@testable import Web
import Common

class PartialCompilationDeclarationsRangeTests: CssTests {

    func testDeclarationsRanges1() {
        
        var stylesheetSource = ""
        stylesheetSource += "body {\n"
        stylesheetSource += "   fon-family: Arial;\n"
        stylesheetSource += "   color: blue;\n"
        stylesheetSource += "}"
        
        let styleSheet = parseStylesheet(stylesheetString: stylesheetSource)

        let description = SourceStringChangeDescription(sourceString: stylesheetSource, range: NSMakeRange(13, 0), insertedString: "t")
        
        guard let styleRule = styleSheet.firstStyleRule else {
            XCTAssert(false, "Error: styleRule is nil")
            return
        }
        
        guard let styleDeclaration = styleRule.style else {
            XCTAssert(false, "Error: styleDeclaration is nil")
            return
        }
        
        let declarationsRange = styleDeclaration.declarationsRange(aroundChangeDescription: description)
        let expectedDeclarationsRange = 0..<2
        XCTAssert(declarationsRange == expectedDeclarationsRange, "Received: \(declarationsRange), expected: \(expectedDeclarationsRange)")
    }

    
    func testDeclarationsRanges2() {
        
        let stylesheetSource =
            """
            :root {
                --h-sts1: var(--orange-sts1, yellow);
                --h-sts2: var(--orange-sts2, yellow);
                --h-sts3: var(--orange-sts3, yellow);
                --h-sts4: var(--orange-sts4, yellow);
                --h-sts4: var(--orange-sts4, yellow);
                --h-sts4: var(--orange-sts4, yellow);
                --h-sts4: var(--orange-sts4, yellow);
                --h-sts4: var(--orange-sts4, yellow);
                --h-sts4: var(--orange-sts4, yellow);
            }
            """
        
        let styleSheet = parseStylesheet(stylesheetString: stylesheetSource)

        let description = SourceStringChangeDescription(sourceString: stylesheetSource, range: NSMakeRange(17, 1), insertedString: "0")
        
        guard let styleRule = styleSheet.firstStyleRule else {
            XCTAssert(false, "Error: styleRule is nil")
            return
        }
        
        guard let styleDeclaration = styleRule.style else {
            XCTAssert(false, "Error: styleDeclaration is nil")
            return
        }
        
        let declarationsRange = styleDeclaration.declarationsRange(aroundChangeDescription: description)
        let expectedDeclarationsRange = 0..<2
        XCTAssert(declarationsRange == expectedDeclarationsRange, "Received: \(declarationsRange), expected: \(expectedDeclarationsRange)")
    }
    
    func testDeclarationsRanges3() {
        
        let stylesheetSource =
            """
            h1 {
                
                color: red;
                font-size: 12pt;
                font-style: italic;
                font-weight: 800;
                
            }
            """
        
        let styleSheet = parseStylesheet(stylesheetString: stylesheetSource)

        let description = SourceStringChangeDescription(sourceString: stylesheetSource, range: NSMakeRange(9, 4), insertedString: " red")
        
        guard let styleRule = styleSheet.firstStyleRule else {
            XCTAssert(false, "Error: styleRule is nil")
            return
        }
        
        guard let styleDeclaration = styleRule.style else {
            XCTAssert(false, "Error: styleDeclaration is nil")
            return
        }
        
        let declarationsRange = styleDeclaration.declarationsRange(aroundChangeDescription: description)
        let expectedDeclarationsRange = -1..<2
        XCTAssert(declarationsRange == expectedDeclarationsRange, "Received: \(declarationsRange), expected: \(expectedDeclarationsRange)")
    }
    
    func testDeclarationsRanges4() {
        
        let stylesheetSource =
            """
            h1 {
                
                color: red;
                font-size: 12pt;
                font-style: italic;
                font-weight: 800;
                
            }
            """
        
        stylesheetSource.printCharactersIndexes()
        
        let styleSheet = parseStylesheet(stylesheetString: stylesheetSource)

        let description = SourceStringChangeDescription(sourceString: stylesheetSource, range: NSMakeRange(93, 0), insertedString: " red")
        
        guard let styleRule = styleSheet.firstStyleRule else {
            XCTAssert(false, "Error: styleRule is nil")
            return
        }
        
        guard let styleDeclaration = styleRule.style else {
            XCTAssert(false, "Error: styleDeclaration is nil")
            return
        }
        
        let declarationsRange = styleDeclaration.declarationsRange(aroundChangeDescription: description)
        let expectedDeclarationsRange = 2..<Int.max
        XCTAssert(declarationsRange == expectedDeclarationsRange, "Received: \(declarationsRange), expected: \(expectedDeclarationsRange)")
    }
    
}
