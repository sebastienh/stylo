//
//  TopElementsAroundRangeTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-07-22.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon
import Web
import Common
import Igloo

class TopElementsAroundRangeTests: MarkdownRendererTests {
    
    func testTopElements() throws {
        
        var markdownString = "\n# 12\n"
        markdownString += "\n"
        markdownString += "p1"
        markdownString += "\n"
        markdownString += "## 2\n"
        markdownString += "\n"
        markdownString += "p2\n"
        markdownString += "\n"
        
        let styleString = """
           body {
               color: blue;
           }

           :focus {
               color: red;
           }

           h1::first-letter:focus {
               color: green;
           }

       """
        
        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        
        
        let dispatcher = markdownContext.dispatcher
        let markdownDocumentStore = markdownContext.markdownDocumentStore
        
        let focusRange = NSMakeRange(1, 4)
        
        let actionResult: ActionResult = dispatcher.sync(store: markdownDocumentStore, action: DocumentStoreAction.topElementsAroundRange(range: focusRange).syncAction)!
        
        let documentStoreActionResult: DocumentStoreActionResult = actionResult as! DocumentStoreActionResult
        
        let topElementsAroundRange: ContiguousArray<Element> = documentStoreActionResult.topElementsAroundRange!
        
        XCTAssert(!topElementsAroundRange.isEmpty)
        
        XCTAssert(topElementsAroundRange.first?.textChilds.first?.data == "12")
        XCTAssert(topElementsAroundRange.last?.textChilds.first?.data == "p1")
        
    }
    
}
