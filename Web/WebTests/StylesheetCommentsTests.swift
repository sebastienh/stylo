//
//  StylesheetCommentsTests.swift
//  Web
//
//  Created by Sebastien hamel on 2019-01-05.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

class StylesheetCommentsTests: CssTests {

    func testCommentAtStartOfDocument() {
        
        let styleSheet = parseStylesheet(named: "comment-at-start.css")
        XCTAssert(styleSheet.commentsCount == 1, "Expected: 1, received: \(styleSheet.commentsCount)")
    }

}
