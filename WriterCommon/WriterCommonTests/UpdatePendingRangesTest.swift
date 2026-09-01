//
//  UpdatePendingRangesTest.swift
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

class UpdatePendingRangesTest: WriterCommonTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUpdatePendingRanges() {
        
        
        //
        //        firstly {
        //            updateSourceString(in: markdownDocumentStore, string: description.sourceString.string)
        //        }.then {
        //
        //            if markdownDocumentStore.attributesStore.value != nil {
        //                return self.updateAttributesStore(in: markdownDocumentStore, with: description)
        //            }
        //            else {
        //                return self.createAttributesStore(store: markdownDocumentStore)
        //            }
        //
        //        }.then {
        //
        //            return self.associatedOpenTokenIndex(markdownDocumentStore: markdownDocumentStore, sourceStringChangeDescription: description)
        //
        //        }.then { (deletedNodes, tokens) -> Promise<DocumentFragment?> in
        //
        //            self.createOrUpdateDocument(in: markdownDocumentStore, deletedNodes: deletedNodes, tokens: tokens, description: description)
        //
        //        }.then { documentFragment -> Promise<Void> in
        //            // set the ranges from the new elements to pending
        //            self.updatePendingRanges(in: markdownDocumentStore, with: documentFragment)
        //        }.then { () -> Promise<Void> in
        //            self.updateStyleRootChildElements(store: markdownDocumentStore)
        //        }.then { () -> Promise<Void> in
        //            self.updateLoadingValue(store: markdownDocumentStore)
        //        }.then {
        //            fulfill(())
        //        }.catch { error in
        //            reject(error )
        //        }
        
        
//
//
//        // self.updatePendingRanges(in: markdownDocumentStore, with: documentFragment)
//
//        let documentState = DocumentState()
//        let dispatcher = StyloDocumentDispatcher(state: documentState)
//        let markdownDocumentStore = MarkdownDocumentStore()
//
//        // delete the 1 value inside the heading 1
//        let expectation: XCTestExpectation = self.expectation(description: "file loaded")
//
//        var description: SourceStringChangeDescription?
//
//        firstly {
//            loadMarkdownDocumentStore(filename: "markdown-partial-compilation.md", store: markdownDocumentStore, dispatcher: dispatcher)
//        }.then { (store) -> Promise<Void> in
//            markdownDocumentStore.reducer.createAttributesStore(store: markdownDocumentStore)
//        }.then { () -> Promise<Void> in
//            let markdownString = markdownDocumentStore.sourceString.value!
//            let newMarkdownString = (markdownString as NSString).replacingOccurrences(of: "2", with:"")
//            description = SourceStringChangeDescription(range: NSMakeRange(3, 1), stringReplacement: "", changeLength: -1, sourceString: NSMutableAttributedString(string: newMarkdownString))
//            return markdownDocumentStore.reducer.updateAttributesStore(in: markdownDocumentStore, with: description!)
//        }.then { _ -> Promise<(ContiguousArray<Node>?, Tokens)> in
//            markdownDocumentStore.reducer.associatedOpenTokenIndex(markdownDocumentStore: markdownDocumentStore, sourceStringChangeDescription: description!)
//        }.then { (deletedNodes, tokens) -> Promise<DocumentFragment?> in
//            markdownDocumentStore.reducer.createOrUpdateDocument(in: markdownDocumentStore, deletedNodes: deletedNodes, tokens: tokens, description: description!)
//        }.then { documentFragment -> Promise<Void> in
//            // set the ranges from the new elements to pending
//            markdownDocumentStore.reducer.updatePendingRanges(in: markdownDocumentStore, with: documentFragment)
//        }.then {
//            expectation.fulfill()
//        }.catch { error in
//            XCTAssert(false, "Error: \(error)")
//        }
//
//        self.waitForExpectations(timeout: 5) { (error) in
//
//            XCTAssert(markdownDocumentStore.attributesStore.value != nil)
//            let debugString = markdownDocumentStore.attributesStore.value!.debugPrintAttributesString()
//            debugPrint(debugString)
//        }
    }

}
