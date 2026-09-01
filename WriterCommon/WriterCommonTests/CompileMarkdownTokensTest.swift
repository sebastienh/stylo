//
//  MarkdownTokensCreateOperationTest.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-08-20.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Foundation
import PromiseKit
@testable import Web
@testable import WriterCommon
@testable import Common
@testable import Markdown

class CompileMarkdownTokensTest: WriterCommonTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
 
    func testCompileTokens() {
        
//        let documentState = DocumentState()
//        let dispatcher = StyloDocumentDispatcher(state: documentState)
//        let markdownDocumentStore = MarkdownDocumentStore()
//        let description = SourceStringChangeDescription(range: NSMakeRange(0,0), stringReplacement: "#", changeLength: 1, sourceString: NSMutableAttributedString(string: "#" + self.testFileString))
//
//        var deletedNodeTokens: (ContiguousArray<Node>?, Tokens)? = nil
//
//        let expectation: XCTestExpectation = self.expectation(description: "file loaded")
//
//        firstly {
//            loadMarkdownDocumentStore(filename: "test-file.md", store: markdownDocumentStore, dispatcher: dispatcher)
//            }.then { (store) -> Promise<Void> in
//                markdownDocumentStore.reducer.createAttributesStore(store: markdownDocumentStore)
//            }.then { _ -> Promise<Void> in
//                markdownDocumentStore.reducer.updateAttributesStore(in: markdownDocumentStore, with: description)
//            }.then { _ -> Promise<(ContiguousArray<Node>?, Tokens)> in
//                markdownDocumentStore.reducer.associatedOpenTokenIndex(markdownDocumentStore: markdownDocumentStore, sourceStringChangeDescription: description)
//            }.then { (value) -> Void in
//                deletedNodeTokens = value
//                expectation.fulfill()
//            }.catch { error in
//                XCTAssert(false, "Error: \(error)")
//        }
//
//        self.waitForExpectations(timeout: 5) { (error) in
//            XCTAssert(error == nil)
//            XCTAssert(markdownDocumentStore.attributesStore.value != nil)
//            XCTAssert(markdownDocumentStore.attributesStore.value!.string == "#" + self.testFileString)
//
//            XCTAssert(deletedNodeTokens != nil)
//            XCTAssert(deletedNodeTokens!.0 == nil)
//
//        }
    }
    
    func testMarkdownPartialCompilation() {
        
//        let documentState = DocumentState()
//        let dispatcher = StyloDocumentDispatcher(state: documentState)
//        let markdownDocumentStore = MarkdownDocumentStore()
//
//        var deletedNodeTokens: (ContiguousArray<Node>?, Tokens)? = nil
//
//        let expectation: XCTestExpectation = self.expectation(description: "file loaded")
//
//        firstly {
//            loadMarkdownDocumentStore(filename: "markdown-partial-compilation.md", store: markdownDocumentStore, dispatcher: dispatcher)
//        }.then { (store) -> Promise<Void> in
//            markdownDocumentStore.reducer.createAttributesStore(store: markdownDocumentStore)
//        }.then { _ -> Promise<(ContiguousArray<Node>?, Tokens)> in
//            let string = markdownDocumentStore.sourceString.value!
//            let description = SourceStringChangeDescription(range: NSMakeRange(0,0), stringReplacement: "", changeLength: 0, sourceString: NSMutableAttributedString(string: string))
//            return markdownDocumentStore.reducer.associatedOpenTokenIndex(markdownDocumentStore: markdownDocumentStore, sourceStringChangeDescription: description)
//        }.then { (value) -> Void in
//            deletedNodeTokens = value
//            expectation.fulfill()
//        }.catch { error in
//            XCTAssert(false, "Error: \(error)")
//        }
//
//        self.waitForExpectations(timeout: 5) { (error) in
//            XCTAssert(error == nil)
//            XCTAssert(markdownDocumentStore.attributesStore.value != nil)
//            XCTAssert(deletedNodeTokens != nil)
//            XCTAssert(deletedNodeTokens!.0 == nil)
//
//            let tokens = deletedNodeTokens!.1
//            let tokenValues = tokens.tokenValues
//
//            debugPrint("Tokens: \(tokens.toString())")
//
//
//            XCTAssert(tokenValues[0].sourceFragments[.All]!.startFragmentIndex!.integerValue == 0,
//                      "value was \(tokenValues[0].sourceFragments[.All]!.startFragmentIndex!.integerValue )")
//            XCTAssert(tokenValues[0].sourceFragments[.All]!.endFragmentIndex!.integerValue == 4,
//                      "value was \(tokenValues[0].sourceFragments[.All]!.endFragmentIndex!.integerValue )")
//            XCTAssert(tokenValues[3].sourceFragments[.All]!.startFragmentIndex!.integerValue == 5,
//                      "value was \(tokenValues[3].sourceFragments[.All]!.startFragmentIndex!.integerValue )")
//            XCTAssert(tokenValues[3].sourceFragments[.All]!.endFragmentIndex!.integerValue == 10,
//                      "value was \(tokenValues[3].sourceFragments[.All]!.endFragmentIndex!.integerValue )")
//            XCTAssert(tokenValues[6].sourceFragments[.All]!.startFragmentIndex!.integerValue == 11,
//                      "value was \(tokenValues[6].sourceFragments[.All]!.startFragmentIndex!.integerValue )")
//            XCTAssert(tokenValues[6].sourceFragments[.All]!.endFragmentIndex!.integerValue == 18,
//                      "value was \(tokenValues[6].sourceFragments[.All]!.endFragmentIndex!.integerValue)")
//        }
    }
    
    
    func testMarkdownPartialCompilation2() {
        
//        let documentState = DocumentState()
//        let dispatcher = StyloDocumentDispatcher(state: documentState)
//        let markdownDocumentStore = MarkdownDocumentStore()
//        var deletedNodeTokens: (ContiguousArray<Node>?, Tokens)? = nil
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
//        }.then { (value) -> Void in
//            deletedNodeTokens = value
//            expectation.fulfill()
//        }.catch { error in
//            XCTAssert(false, "Error: \(error)")
//        }
//
//        self.waitForExpectations(timeout: 5) { (error) in
//
//            let tokens = deletedNodeTokens!.1
//            let finalTokenValues = tokens.tokenValues
//
//            XCTAssert(finalTokenValues[0].sourceFragments[.All]!.startFragmentIndex!.integerValue == 0,
//                      "value was \(finalTokenValues[0].sourceFragments[.All]!.startFragmentIndex!.integerValue )")
//            XCTAssert(finalTokenValues[0].sourceFragments[.All]!.endFragmentIndex!.integerValue == 3,
//                      "value was \(finalTokenValues[0].sourceFragments[.All]!.endFragmentIndex!.integerValue )")
//            XCTAssert(finalTokenValues[3].sourceFragments[.All]!.startFragmentIndex!.integerValue == 4,
//                      "value was \(finalTokenValues[3].sourceFragments[.All]!.startFragmentIndex!.integerValue )")
//            XCTAssert(finalTokenValues[3].sourceFragments[.All]!.endFragmentIndex!.integerValue == 9,
//                      "value was \(finalTokenValues[3].sourceFragments[.All]!.endFragmentIndex!.integerValue )")
//            XCTAssert(finalTokenValues[6].sourceFragments[.All]!.startFragmentIndex!.integerValue == 10,
//                      "value was \(finalTokenValues[6].sourceFragments[.All]!.startFragmentIndex!.integerValue )")
//            XCTAssert(finalTokenValues[6].sourceFragments[.All]!.endFragmentIndex!.integerValue == 17,
//                      "value was \(finalTokenValues[6].sourceFragments[.All]!.endFragmentIndex!.integerValue)")
//        }
//
    }
    
    func testMarkdownPartialCompilation3() {
        
//        
//        let documentState = DocumentState()
//        let dispatcher = StyloDocumentDispatcher(state: documentState)
//        let markdownDocumentStore = MarkdownDocumentStore()
//        var deletedNodeTokens: (ContiguousArray<Node>?, Tokens)? = nil
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
//            let newMarkdownString = (markdownString as NSString).replacingOccurrences(of: "## 34", with:"# 34")
//            description = SourceStringChangeDescription(range: NSMakeRange(6, 1), stringReplacement: "", changeLength: -1, sourceString: NSMutableAttributedString(string: newMarkdownString))
//            return markdownDocumentStore.reducer.updateAttributesStore(in: markdownDocumentStore, with: description!)
//        }.then { _ -> Promise<(ContiguousArray<Node>?, Tokens)> in
//            markdownDocumentStore.reducer.associatedOpenTokenIndex(markdownDocumentStore: markdownDocumentStore, sourceStringChangeDescription: description!)
//        }.then { (value) -> Void in
//            deletedNodeTokens = value
//            expectation.fulfill()
//        }.catch { error in
//            XCTAssert(false, "Error: \(error)")
//        }
//        
//        self.waitForExpectations(timeout: 5) { (error) in
//            
//            let tokens = deletedNodeTokens!.1
//            let finalTokenValues = tokens.tokenValues
//
//            XCTAssert(finalTokenValues[3].markup == "#")
//            
//            XCTAssert(finalTokenValues[0].sourceFragments[.All]!.startFragmentIndex!.integerValue == 0,
//                      "value was \(finalTokenValues[0].sourceFragments[.All]!.startFragmentIndex!.integerValue )")
//            XCTAssert(finalTokenValues[0].sourceFragments[.All]!.endFragmentIndex!.integerValue == 4,
//                      "value was \(finalTokenValues[0].sourceFragments[.All]!.endFragmentIndex!.integerValue )")
//            XCTAssert(finalTokenValues[3].sourceFragments[.All]!.startFragmentIndex!.integerValue == 5,
//                      "value was \(finalTokenValues[3].sourceFragments[.All]!.startFragmentIndex!.integerValue )")
//            XCTAssert(finalTokenValues[3].sourceFragments[.All]!.endFragmentIndex!.integerValue == 9,
//                      "value was \(finalTokenValues[3].sourceFragments[.All]!.endFragmentIndex!.integerValue )")
//            XCTAssert(finalTokenValues[6].sourceFragments[.All]!.startFragmentIndex!.integerValue == 10,
//                      "value was \(finalTokenValues[6].sourceFragments[.All]!.startFragmentIndex!.integerValue )")
//            XCTAssert(finalTokenValues[6].sourceFragments[.All]!.endFragmentIndex!.integerValue == 17,
//                      "value was \(finalTokenValues[6].sourceFragments[.All]!.endFragmentIndex!.integerValue)")
//        }
    }

    func testMarkdownPartialCompilation4() {

//        
//        let documentState = DocumentState()
//        let dispatcher = StyloDocumentDispatcher(state: documentState)
//        let markdownDocumentStore = MarkdownDocumentStore()
//        var deletedNodeTokens: (ContiguousArray<Node>?, Tokens)? = nil
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
//            let newMarkdownString = (markdownString as NSString).replacingOccurrences(of: "## 34", with:"")
//            description = SourceStringChangeDescription(range: NSMakeRange(5, 5), stringReplacement: "", changeLength: -5, sourceString: NSMutableAttributedString(string: newMarkdownString))
//            return markdownDocumentStore.reducer.updateAttributesStore(in: markdownDocumentStore, with: description!)
//        }.then { _ -> Promise<(ContiguousArray<Node>?, Tokens)> in
//            markdownDocumentStore.reducer.associatedOpenTokenIndex(markdownDocumentStore: markdownDocumentStore, sourceStringChangeDescription: description!)
//        }.then { (value) -> Void in
//            deletedNodeTokens = value
//            expectation.fulfill()
//        }.catch { error in
//            XCTAssert(false, "Error: \(error)")
//        }
//        
//        self.waitForExpectations(timeout: 5) { (error) in
//            
//            let tokens = deletedNodeTokens!.1
//            let finalTokenValues = tokens.tokenValues
//            
//            XCTAssert(finalTokenValues[3].markup == "###", "value was \(finalTokenValues[3].markup)")
//            
//            XCTAssert(finalTokenValues[0].sourceFragments[.All]!.startFragmentIndex!.integerValue == 0,
//                      "value was \(finalTokenValues[0].sourceFragments[.All]!.startFragmentIndex!.integerValue )")
//            XCTAssert(finalTokenValues[0].sourceFragments[.All]!.endFragmentIndex!.integerValue == 4,
//                      "value was \(finalTokenValues[0].sourceFragments[.All]!.endFragmentIndex!.integerValue )")
//            XCTAssert(finalTokenValues[3].sourceFragments[.All]!.startFragmentIndex!.integerValue == 6,
//                      "value was \(finalTokenValues[3].sourceFragments[.All]!.startFragmentIndex!.integerValue )")
//            XCTAssert(finalTokenValues[3].sourceFragments[.All]!.endFragmentIndex!.integerValue == 13,
//                      "value was \(finalTokenValues[3].sourceFragments[.All]!.endFragmentIndex!.integerValue )")
//
//        }
    }

    func testPerformanceMarkdownTokensCreate() {
        let url = WriterCommonTests.urlOfFile(named: "john-grubber-markdown-spec.md")
        let markdownString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        let mardownParser = MarkdownParser(presetName: "commonmark")
        
        self.measure {

            for _ in 1...10 {
                
                mardownParser.parse(markdownString)
            }
        }
    }

}
