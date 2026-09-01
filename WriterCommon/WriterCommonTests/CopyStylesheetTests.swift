//
//  CopyStylesheetTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2019-12-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Common
@testable import WriterCommon

class CopyStylesheetTests: FullStylesheetTests {

    // copy complete stylesheet
    func testChange100() {
        
        let url = urlOfFile(named: "copy-stylesheet.css")
        let copiedString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(0, 0), replacementString: copiedString)
        XCTAssert(executeTest(sourceFilename: "copied-over-stylesheet.css", stringChange: stringChange), "failed")
    }
}
