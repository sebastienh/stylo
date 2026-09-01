//
//  MarkdownDocumentStoreSourceStringChangeTest.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2017-10-17.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import XCTest
import PromiseKit
@testable import Web
@testable import WriterCommon
@testable import Common
@testable import Markdown

class MarkdownDocumentStoreSourceStringChangeTest: WriterCommonTests {

    
    
    func test() {
        
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
        
    }
    
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUpdateStyleRootChildElements() {
        
        // self.updateStyleRootChildElements(store: markdownDocumentStore)
    }

}
