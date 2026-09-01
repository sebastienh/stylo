//
//  AttributesStoreTest.swift
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

class AttributesStoreTest: WriterCommonTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCreateAttributesStore() {
        
//        let documentState = DocumentState()
//        let dispatcher = StyloDocumentDispatcher(state: documentState)
//        let markdownDocumentStore = MarkdownDocumentStore()
//        
//        let expectation: XCTestExpectation = self.expectation(description: "file loaded")
//        
//        firstly {
//            load(filename: "test-file.md", store: markdownDocumentStore, dispatcher: dispatcher)
//            }.then { (store) -> Promise<Void> in
//                store.reducer.createAttributesStore(store: markdownDocumentStore)
//            }.then { () -> Void in
//                expectation.fulfill()
//            }.catch { error in
//                XCTAssert(false, "Error: \(error)")
//        }
//        
//        self.waitForExpectations(timeout: 5) { (error) in
//            XCTAssert(error == nil)
//            XCTAssert(markdownDocumentStore.attributesStore.value != nil)
//            XCTAssert(markdownDocumentStore.attributesStore.value!.string == self.testFileString)
//        }
    }
    
    func testUpdateAttributesStore() {
        
//        let documentState = DocumentState()
//        let dispatcher = StyloDocumentDispatcher(state: documentState)
//        let markdownDocumentStore = MarkdownDocumentStore()
//
//        
//        let expectation: XCTestExpectation = self.expectation(description: "file loaded")
//        
//        firstly {
//            loadMarkdownDocumentStore(filename: "test-file.md", store: markdownDocumentStore, dispatcher: dispatcher)
//            }.then { (store) -> Promise<Void> in
//                markdownDocumentStore.reducer.createAttributesStore(store: markdownDocumentStore)
//            }.then { _ -> Promise<Void> in
//                let description = SourceStringChangeDescription(range: NSMakeRange(0,0), stringReplacement: "at start", changeLength: 8, sourceString: NSMutableAttributedString(string: "at start" + self.testFileString))
//                return markdownDocumentStore.reducer.updateAttributesStore(in: markdownDocumentStore, with: description)
//            }.then { () -> Void in
//                expectation.fulfill()
//            }.catch { error in
//                XCTAssert(false, "Error: \(error)")
//        }
//        
//        self.waitForExpectations(timeout: 5) { (error) in
//            XCTAssert(error == nil)
//            XCTAssert(markdownDocumentStore.attributesStore.value != nil)
//            XCTAssert(markdownDocumentStore.attributesStore.value!.string == "at start" + self.testFileString)
//        }
    }
    

}
