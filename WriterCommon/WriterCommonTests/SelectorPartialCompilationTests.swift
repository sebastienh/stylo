//
//  SelectorPartialCompilationTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2021-01-11.
//  Copyright © 2021 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon
import Common
import Web

class SelectorPartialCompilationTests: StylesheetDocumentStoreTests {

    func testEditSelectorsList() throws {
        
        var stylesheetSource = ""
        stylesheetSource += "body {\n"
        stylesheetSource += "   font-family: Arial;\n"
        stylesheetSource += "   color: blue;\n"
        stylesheetSource += "}"
        
        var stylesheetTarget = ""
        stylesheetTarget += "bodey {\n"
        stylesheetTarget += "   font-family: Arial;\n"
        stylesheetTarget += "   color: blue;\n"
        stylesheetTarget += "}"
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(3, 0), insertedString: "e", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }

    func testEditSelectorsList2() throws {
        
        var stylesheetSource = ""
        stylesheetSource += "body {\n"
        stylesheetSource += "   font-family: Arial;\n"
        stylesheetSource += "   color: blue;\n"
        stylesheetSource += "}"
        
        var stylesheetTarget = ""
        stylesheetTarget += "body/ {\n"
        stylesheetTarget += "   font-family: Arial;\n"
        stylesheetTarget += "   color: blue;\n"
        stylesheetTarget += "}"
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(4, 0), insertedString: "/", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }

    func testEditSelectorsList3() throws {
        
        var stylesheetSource = ""
        stylesheetSource += "body/ {\n"
        stylesheetSource += "   font-family: Arial;\n"
        stylesheetSource += "   color: blue;\n"
        stylesheetSource += "}"
        
        var stylesheetTarget = ""
        stylesheetTarget += "body/* {\n"
        stylesheetTarget += "   font-family: Arial;\n"
        stylesheetTarget += "   color: blue;\n"
        stylesheetTarget += "}"
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(5, 0), insertedString: "*", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }

    func testEditSelectorsList4() throws {
        
        var stylesheetSource = ""
        stylesheetSource += "body/* {\n"
        stylesheetSource += "   font-family: Arial;\n"
        stylesheetSource += "   color: blue;\n"
        stylesheetSource += "}"
        
        var stylesheetTarget = ""
        stylesheetTarget += "body/** {\n"
        stylesheetTarget += "   font-family: Arial;\n"
        stylesheetTarget += "   color: blue;\n"
        stylesheetTarget += "}"
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(6, 0), insertedString: "*", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }

    func testEditSelectorsList5() throws {
        
        var stylesheetSource = ""
        stylesheetSource += "body/** {\n"
        stylesheetSource += "   font-family: Arial;\n"
        stylesheetSource += "   color: blue;\n"
        stylesheetSource += "}"
        
        var stylesheetTarget = ""
        stylesheetTarget += "body/**/ {\n"
        stylesheetTarget += "   font-family: Arial;\n"
        stylesheetTarget += "   color: blue;\n"
        stylesheetTarget += "}"
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(7, 0), insertedString: "/", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }

    func testEditSelectorsList6() throws {
        
        var stylesheetSource = ""
        stylesheetSource += "body {\n"
        stylesheetSource += "   font-family: Arial;\n"
        stylesheetSource += "   color: blue;\n"
        stylesheetSource += "}\n\n"
        stylesheetSource += "body {\n"
        stylesheetSource += "   font-family: Arial;\n"
        stylesheetSource += "   color: blue;\n"
        stylesheetSource += "}"

        var stylesheetTarget = ""
        stylesheetTarget += "body {\n"
        stylesheetTarget += "   font-family: Arial;\n"
        stylesheetTarget += "   color: blue;\n"
        stylesheetTarget += "}\n\n"
        stylesheetTarget += "bodyd {\n"
        stylesheetTarget += "   font-family: Arial;\n"
        stylesheetTarget += "   color: blue;\n"
        stylesheetTarget += "}"
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(53, 0), insertedString: "d", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
    
    func testEditSelectorsList7() {
        
        let  stylesheetSource =
            """
            h1::tag,
            h2::tag,
            h3::tag,
            h4::tag,
            h5::tag,
            h6::tag {
                
                color: orange;
            }

            html-block {
                
                color: #01A8C6;
            }
            """
        
        let  stylesheetTarget =
            """
            h1::tag,
            h2::tcolor: r
            h3::tag,
            h4::tag,
            h5::tag,
            h6::tag {
                
                color: orange;
            }

            html-block {
                
                color: #01A8C6;
            }
            """
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: NSMakeRange(14, 3), insertedString: "color: r", expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
        
    }
    
    func testEditSelectorsList8() throws {
        
        let url = urlOfFile(named: "full-v2.css")!
        let stylesheetSource = try! String(contentsOf: url)

        let changeRange = NSMakeRange(420, 3)
        let insertedString = "color: r"
        var stylesheetTarget = stylesheetSource
        stylesheetTarget.update(range: changeRange, withString: insertedString)

        print("stylesheetSource: \(stylesheetSource)")
        stylesheetSource.printCharactersIndexes()
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: changeRange, insertedString: insertedString, expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
    
    
    func testEditSelectorsList9() throws {
        
        let url = urlOfFile(named: "full-v1.css")!
        let stylesheetSource = try! String(contentsOf: url)

        let changeRange = NSMakeRange(441, 3)
        let insertedString = "color: r"
        var stylesheetTarget = stylesheetSource
        stylesheetTarget.update(range: changeRange, withString: insertedString)

        print("stylesheetSource: \(stylesheetSource)")
        stylesheetSource.printCharactersIndexes()
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: changeRange, insertedString: insertedString, expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
    
    func testEditSelectorsList10() throws {
        
        let url = urlOfFile(named: "test-5.css")!
        let stylesheetSource = try! String(contentsOf: url)

        let changeRange = NSMakeRange(2, 0)
        let insertedString = "d"
        var stylesheetTarget = stylesheetSource
        stylesheetTarget.update(range: changeRange, withString: insertedString)

        print("stylesheetSource: \(stylesheetSource)")
        stylesheetSource.printCharactersIndexes()
        
        XCTAssert(validateSame(stylesheetSource: stylesheetSource, changeRange: changeRange, insertedString: insertedString, expectedStylesheetString: stylesheetTarget), "stylesheets are not same")
    }
}
