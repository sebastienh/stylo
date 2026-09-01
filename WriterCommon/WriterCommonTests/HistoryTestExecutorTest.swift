//
//  HistoryTestExecutorTest.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-05-05.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Common
import Igloo
import Markdown
import os
@testable import WriterCommon


fileprivate extension EditRange {
    
    var range: NSRange {
        
        return NSMakeRange(Int(self.location), Int(self.length))
    }
}

fileprivate extension EditHistory {
    
    var stringChanges: [StringChange] {
        
        var stringChanges = [StringChange]()
        
        for edit in self.edits {
            
            stringChanges.append(StringChange(affectedRange: edit.range.range, replacementString: edit.replacementString))
        }
        return stringChanges
    }
}

class HistoryTestExecutorTest: HistoryTest {
    
    func testFollowingSiblingNotColoring1() {
        
        // { affectedRange: {3, 0}, replacementString: ->{<-}
        let stringChange = StringChange(affectedRange: NSMakeRange(3,0), replacementString: "{")
        
        XCTAssert(executeTest(markdown: "following-sibling-not-coloring.md", css: "following-sibling-not-coloring.css", stringChange: stringChange), "failed history test!")
    }
    
    func testFollowingSiblingNotColoring2() {
        
        // { affectedRange: {7, 0}, replacementString: ->}<-}
        let stringChange = StringChange(affectedRange: NSMakeRange(7,0), replacementString: "}")
        
        XCTAssert(executeTest(markdown: "following-sibling-not-coloring-2.md", css: "following-sibling-not-coloring.css", stringChange: stringChange), "failed history test!")
    }
    
    func testFollowingSiblingNotColoringSamll() {
        
        // { affectedRange: {7, 0}, replacementString: ->}<-}
        let stringChange = StringChange(affectedRange: NSMakeRange(7,0), replacementString: "}")
        
        XCTAssert(executeTest(markdown: "small-following-sibling-source.md", css: "following-sibling-not-coloring.css", stringChange: stringChange), "failed history test!")
    }
    
    func testFollowingSiblingNotColoringReallySmall() {
        
        // { affectedRange: {7, 0}, replacementString: ->}<-}
        let stringChange = StringChange(affectedRange: NSMakeRange(7,0), replacementString: "}")
        
        XCTAssert(executeTest(markdown: "really-small-following-sibling-source.md", css: "following-sibling-not-coloring.css", stringChange: stringChange), "failed history test!")
    }
    
    func testAttributesBlocWrongStylesRulePriority() {
        
        // { affectedRange: {40, 0}, replacementString: ->s<-}
        let stringChange = StringChange(affectedRange: NSMakeRange(40,0), replacementString: "}")
        
        XCTAssert(executeTest(markdown: "style-rules-priority-problem.md", css: "style-rules-priority-problem.css", stringChange: stringChange), "failed history test!")
    }
    
    
    func testWrongEmphasisTagStyling() {
        
        // { affectedRange: {2736, 0}, replacementString: -> <-}
        let stringChange = StringChange(affectedRange: NSMakeRange(2736,0), replacementString: " ")
        
        XCTAssert(executeTest(markdown: "wrong-emphasis-styling.md", css: "wrong-emphasis-styling.css", stringChange: stringChange), "failed history test!")
    }
    
    func testWrongEmphasisTagStyling1() {
        
        // { affectedRange: {38, 0}, replacementString: -> <-}
        let stringChange = StringChange(affectedRange: NSMakeRange(41,0), replacementString: " ")
        
        XCTAssert(executeTest(markdown: "wrong-emphasis-styling-2.md", css: "wrong-emphasis-styling.css", stringChange: stringChange), "failed history test!")
    }
    
    func testWrongEmphasisTagStyling2() {
        
        // { affectedRange: {38, 0}, replacementString: -> <-}
        let stringChange = StringChange(affectedRange: NSMakeRange(2745,0), replacementString: "&")
        
        XCTAssert(executeTest(markdown: "wrong-emphasis-styling-blockquote-tag.md", css: "wrong-emphasis-styling-test.css", stringChange: stringChange), "failed history test!")
    }
    
    func testWrongEmphasisTagStyling3() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(2745,0), replacementString: "&")
        
        XCTAssert(executeTest(markdown: "wrong-emphasis-styling-blockquote-tag-smaller.md", css: "simple-wrong-emphasis-styling-test.css", stringChange: stringChange), "failed history test!")
    }
    
    func executeTest(markdown filename: String, css styleFilename: String, stringChange: StringChange) -> Bool {
        
        let url = urlOfFile(named: filename)
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        self.dispatcher = createDispatcher()
        self.markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher!.register(store: markdownDocumentStore!)
        self.style = createStyle(authorStylesheetFilename: styleFilename)
        
        var markdownStyleStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore!, dispatcher: dispatcher!, with: style!)!
        
        let changeLength = stringChange.replacementString.utf16.count - stringChange.affectedRange.length
        
        let (replacement, destination) = replacementAndDestinationSubtring(fromSourceString: sourceString, range: stringChange.affectedRange, replacementString: stringChange.replacementString)
        
        let change = SourceStringChangeDescription(range: stringChange.affectedRange, stringReplacement: replacement, changeLength: changeLength, targetString: destination)
        
        return compare(change: change, fromSourceString: sourceString, to: destination, markdownStyleStore: &markdownStyleStore)
    }
}

