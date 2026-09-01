//
//  DeclarationsStopIndexTests.swift
//  WebTests
//
//  Created by Sebastien Hamel on 2021-01-13.
//  Copyright © 2021 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Common

class DeclarationsStopIndexTests: CssTests {

    func testDeclarationsStopIndex1() {
        
        var stylesheetSource = ""
        stylesheetSource += "body {\n"
        stylesheetSource += "   fon-family: Arial;\n"
        stylesheetSource += "   color: blue;\n"
        stylesheetSource += "}"
        
        let styleSheet = parseStylesheet(stylesheetString: stylesheetSource)

        let change = SourceStringChangeDescription(sourceString: stylesheetSource, range: NSMakeRange(13, 0), insertedString: "t")
        
        guard let rulesAdjacency = styleSheet.rulesAdjacency(change.range) else {
            XCTAssert(false, "rulesAdjacency is nil")
            return
        }
        
        let stylesheetRecompilationType = styleSheet.stylesheetRecompilationType(fromRulesAdjacency: rulesAdjacency, description: change)
        
        switch stylesheetRecompilationType {
        case .rules:
            XCTAssert(false, "unexpected stylesheetRecompilationType: \(stylesheetRecompilationType)")
        case .selectorList:
            XCTAssert(false, "unexpected stylesheetRecompilationType: \(stylesheetRecompilationType)")
        case .declarations(_/*stringExtract*/, _, _, _, let declarationStopIndex, _):
            let expectedStopIndex = 33 + change.changeLength
            XCTAssert(declarationStopIndex.index == expectedStopIndex, "Expected: \(expectedStopIndex), received: \(declarationStopIndex.index)")
        }
    }
    
    func testDeclarationsStopIndex2() {
        
        let stylesheetSource =
            """
            :root {
                --h-t1: var(--orange-t1, yellow);
                --h-t2: var(--orange-t2, yellow);
                --h-t3: var(--orange-t3, yellow);
                --h-t4: var(--orange-t4, yellow);
            }
            """
        
        print("stylesheetSource: \(stylesheetSource)")
        
        stylesheetSource.printCharactersIndexes()
        
        let styleSheet = parseStylesheet(stylesheetString: stylesheetSource)

        let change = SourceStringChangeDescription(sourceString: stylesheetSource, range: NSMakeRange(17, 1), insertedString: "")
        
        guard let rulesAdjacency = styleSheet.rulesAdjacency(change.range) else {
            XCTAssert(false, "rulesAdjacency is nil")
            return
        }
        
        let stylesheetRecompilationType = styleSheet.stylesheetRecompilationType(fromRulesAdjacency: rulesAdjacency, description: change)
        
        switch stylesheetRecompilationType {
        case .rules:
            XCTAssert(false, "unexpected stylesheetRecompilationType: \(stylesheetRecompilationType)")
        case .selectorList:
            XCTAssert(false, "unexpected stylesheetRecompilationType: \(stylesheetRecompilationType)")
        case .declarations(let stringExtract, _, _, _, let declarationStopIndex, _):
            print("stringExtract: \(stringExtract)")
            stringExtract?.printCharactersIndexes()
            let expectedStopIndex = 70 + change.changeLength
            XCTAssert(declarationStopIndex.index == expectedStopIndex, "Expected: \(expectedStopIndex), received: \(declarationStopIndex.index)")
        }
    }
    
    func testDeclarationsStopIndex3() {
        
        let stylesheetSource =
            """
            h1 {
                color: red;
                font-size: 12pt;
                
            }
            """
        
        print("stylesheetSource: \(stylesheetSource)")
        
        stylesheetSource.printCharactersIndexes()
        
        let styleSheet = parseStylesheet(stylesheetString: stylesheetSource)

        let change = SourceStringChangeDescription(sourceString: stylesheetSource, range: NSMakeRange(42, 0), insertedString: "r")
        
        guard let rulesAdjacency = styleSheet.rulesAdjacency(change.range) else {
            XCTAssert(false, "rulesAdjacency is nil")
            return
        }
        
        let stylesheetRecompilationType = styleSheet.stylesheetRecompilationType(fromRulesAdjacency: rulesAdjacency, description: change)
        
        switch stylesheetRecompilationType {
        case .rules:
            XCTAssert(false, "unexpected stylesheetRecompilationType: \(stylesheetRecompilationType)")
        case .selectorList:
            XCTAssert(false, "unexpected stylesheetRecompilationType: \(stylesheetRecompilationType)")
        case .declarations(_/*stringExtract*/, _, _, _, let declarationStopIndex, _):
            let expectedStopIndex = 39 + change.changeLength
            XCTAssert(declarationStopIndex.index == expectedStopIndex, "Expected: \(expectedStopIndex), received: \(declarationStopIndex.index)")
        }
    }
    
}
