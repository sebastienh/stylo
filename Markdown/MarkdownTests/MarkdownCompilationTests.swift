//
//  MarkdownCompilationTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-10-29.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Markdown

class MarkdownCompilationTests: MarkdownBasicTests {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCompileMarkdownItDemo() {
        let string = try! String(contentsOf: urlOfFile(named: "markdown-it-load-test.md")!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        let tokens = md.parse(string)
    }
}
