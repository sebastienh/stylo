//
//  DeclarationsPartialCompilationTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2021-01-13.
//  Copyright © 2021 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon
import Common
import Web

class DeclarationsPartialCompilationTests: StylesheetDocumentStoreTests {

    func testEditDeclarations() throws {
        
        var stylesheetSource = ""
        stylesheetSource += "body {\n"
        stylesheetSource += "   fon-family: Arial;\n"
        stylesheetSource += "   color: blue;\n"
        stylesheetSource += "}"
        
        var stylesheetTarget = ""
        stylesheetTarget += "body {\n"
        stylesheetTarget += "   font-family: Arial;\n"
        stylesheetTarget += "   color: blue;\n"
        stylesheetTarget += "}"
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(13, 0), insertedString: "t", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }

    func testEditDeclarations2() throws {
        
        var stylesheetSource = ""
        stylesheetSource += "body {\n"
        stylesheetSource += "   font-family: Arial;\n"
        stylesheetSource += "   color: blue;\n"
        stylesheetSource += "}"
        
        var stylesheetTarget = ""
        stylesheetTarget += "body {\n"
        stylesheetTarget += "   fon-family: Arial;\n"
        stylesheetTarget += "   color: blue;\n"
        stylesheetTarget += "}"
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(13, 1), insertedString: "", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
    
    func testEditDeclarations3() throws {
        
        var stylesheetSource = ""
        stylesheetSource += "body {\n"
        stylesheetSource += "   font-family: Arial;\n"
        stylesheetSource += "   color: blue;\n"
        stylesheetSource += "}"
        
        var stylesheetTarget = ""
        stylesheetTarget += "body {\n"
        stylesheetTarget += "   -family: Arial;\n"
        stylesheetTarget += "   color: blue;\n"
        stylesheetTarget += "}"
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(10, 4), insertedString: "", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
    
    func testEditDeclarations4() throws {
        
        var stylesheetSource = ""
        stylesheetSource += "body {\n"
        stylesheetSource += "   font-family: Arial;\n"
        stylesheetSource += "   color: blue;\n"
        stylesheetSource += "}"
        
        var stylesheetTarget = ""
        stylesheetTarget += "body {\n"
        stylesheetTarget += "   font-family: rial;\n"
        stylesheetTarget += "   color: blue;\n"
        stylesheetTarget += "}"
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(23, 1), insertedString: "", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
    
    func testEditDeclarations5() throws {
        
        var stylesheetSource = ""
        stylesheetSource += "body {\n"
        stylesheetSource += "   font-family: Arial;\n"
        stylesheetSource += "   color: blue;\n"
        stylesheetSource += "}"
        
        var stylesheetTarget = ""
        stylesheetTarget += "body {\n"
        stylesheetTarget += "   font-family: \n"
        stylesheetTarget += "   color: blue;\n"
        stylesheetTarget += "}"
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(23, 6), insertedString: "", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
    
    
    
    func testEditDeclarations6() throws {
        
        let stylesheetSource =
            """
            :root {
                --h-t1: var(--orange-t1, yellow);
                --h-t2: var(--orange-t2, yellow);
                --h-t3: var(--orange-t3, yellow);
                --h-t4: var(--orange-t4, yellow);
            }
            """
        
        let stylesheetTarget =
        """
        :root {
            --h-t: var(--orange-t1, yellow);
            --h-t2: var(--orange-t2, yellow);
            --h-t3: var(--orange-t3, yellow);
            --h-t4: var(--orange-t4, yellow);
        }
        """
        
        print("stylesheetSource: \(stylesheetSource)")
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(17, 1), insertedString: "", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
    

    
    func testEditDeclarations7() throws {
        
        let stylesheetSource =
            """
            h1 {
                
                color: red;
                font-size: 12pt;
                font-style: italic;
                font-weight: 800;
                
            }
            """
        
        let stylesheetTarget =
            """
            h1 {
                 red
                color: red;
                font-size: 12pt;
                font-style: italic;
                font-weight: 800;
                
            }
            """
        
        print("stylesheetSource: \(stylesheetSource)")
        stylesheetSource.printCharactersIndexes()
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(9, 0), insertedString: " red", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
    
    func testEditDeclarations8() throws {
        
        let stylesheetSource =
            """
            h1 {
                    
                color: red;
                font-size: 12pt;
                font-style: italic;
                font-weight: 800;
                
            }
            """
        
        let stylesheetTarget =
            """
            h1 {
                 red
                color: red;
                font-size: 12pt;
                font-style: italic;
                font-weight: 800;
                
            }
            """
        
        print("stylesheetSource: \(stylesheetSource)")
        stylesheetSource.printCharactersIndexes()
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(9, 4), insertedString: " red", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
    
    func testEditDeclarations9() throws {
        
        let stylesheetSource =
            """
            h2 {
                color: red;
            }
            h1 {
                    
                color: red;
                font-size: 12pt;
                font-style: italic;
                font-weight: 800;
                
            }
            h3 {
                color: red;
            }
            """
        
        let stylesheetTarget =
            """
            h2 {
                color: red;
            }
            h1 {
                 red
                color: red;
                font-size: 12pt;
                font-style: italic;
                font-weight: 800;
                
            }
            h3 {
                color: red;
            }
            """
        
        print("stylesheetSource: \(stylesheetSource)")
        stylesheetSource.printCharactersIndexes()
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(32, 4), insertedString: " red", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
    
    func testEditDeclarations10() throws {
        
        let stylesheetSource =
            """
            h1 {
                color: red;
                font-size: 12pt;
                font-style: italic;
                font-weight: 800;
                
            }
            """
        
        let stylesheetTarget =
            """
            h1 {
                color: red;
                font-size: 12pt;
                font-style: italic;
                font-weight: 800;
                r
            }
            """
        
        print("stylesheetSource: \(stylesheetSource)")
        stylesheetSource.printCharactersIndexes()
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(92, 0), insertedString: "r", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
    

    func testEditDeclarations11() throws {
        
        let stylesheetSource =
            """
            h1 {
                
                color: red;
                font-size: 12pt;
                font-style: italic;
                font-weight: 800;
                
            }
            """
        
        let stylesheetTarget =
            """
            h1 {
                 red color: red;
                font-size: 12pt;
                font-style: italic;
                font-weight: 800;
                
            }
            """
        
        print("stylesheetSource: \(stylesheetSource)")
        stylesheetSource.printCharactersIndexes()
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(9, 4), insertedString: " red", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
    
    func testEditDeclarations12() throws {
        
        let url = urlOfFile(named: "full-v1.css")!
        let stylesheetSource = try! String(contentsOf: url)

        let changeRange = NSMakeRange(1216, 4)
        let insertedString = " red"
        var stylesheetTarget = stylesheetSource
        stylesheetTarget.update(range: changeRange, withString: insertedString)

        print("stylesheetSource: \(stylesheetSource)")
        stylesheetSource.printCharactersIndexes()
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: changeRange, insertedString: insertedString, expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
    
    func testEditDeclarations13() throws {
        
        let stylesheetSource =
            """
            code {
                color: #01A8C6;
                font-family: "Hack";
                font-size: 12pt;
            }
            """
        
        let stylesheetTarget =
            """
            code {
                color: #01A8C6;
                font-family:b(255,0,0
                font-size: 12pt;
            }
            """
        
        print("stylesheetSource: \(stylesheetSource)")
        stylesheetSource.printCharactersIndexes()
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(43, 8), insertedString: "b(255,0,0", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
    
    
    func testEditDeclarations14() throws {
        
        let stylesheetSource =
            """
            :root {
                --h-t1: var(--orange-t1, yellow);
                --h-t2: var(--orange-t2, yellow);
                --h-t3: var(--orange-t3, yellow);
                --h-t4: var(--orange-t4, yellow);
            }
            """
        
        let stylesheetTarget =
            """
            :root {
                --h-t: var(--orange-t1, yellow);
                --h-t2: var(--orange-t2, yellow);
                --h-t3: var(--orange-t3, yellow);
                --h-t4: var(--orange-t4, yellow);
            }
            """
        
        print("stylesheetSource: \(stylesheetSource)")
        stylesheetSource.printCharactersIndexes()
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(17, 1), insertedString: "", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
    
}
