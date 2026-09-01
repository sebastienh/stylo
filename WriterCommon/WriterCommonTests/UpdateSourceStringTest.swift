//
//  UpdateSourceStringTest.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-10-18.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import XCTest
import PromiseKit
@testable import Web
@testable import WriterCommon
@testable import Common
@testable import Markdown

class UpdateSourceStringTest: WriterCommonTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUpdateSourceString() {
        
        let documentState = DocumentState()
        let dispatcher = StyloDocumentDispatcher(state: documentState)
        let markdownDocumentStore = MarkdownDocumentStore(identifier: UUID().uuidString, name: "test-store", parentId: "")
        
        loadMarkdownDocumentStore(filename: "test-file.md", store: markdownDocumentStore, dispatcher: dispatcher)
        markdownDocumentStore.reducer.updateSourceString(in: markdownDocumentStore, string: self.testFileString + "tetststst")

        XCTAssert(markdownDocumentStore.sourceString.value != nil)
        XCTAssert(markdownDocumentStore.sourceString.value! == self.testFileString + "tetststst")
    }

}
