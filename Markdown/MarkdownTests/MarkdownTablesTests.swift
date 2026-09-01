//
//  MarkdownTablesTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-02-06.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest

class MarkdownTablesTests: MarkdownSpecTestsBase {

    func testSimple() {
        let parseResult = parseToHTML("\tfoo\tbaz\t\tbim\n")
        XCTAssert("<pre><code>foo\tbaz\t\tbim\n</code></pre>\n" == parseResult)
    }

}
