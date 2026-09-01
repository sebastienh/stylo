//
//  HistoryTestGenerator.swift
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

class HistoryTestGenerator: HistoryTest {
    
    func testFollowingSiblingNotColoring() {

        XCTAssert(executeTest(markdown: "following-sibling-not-coloring.history", css: "following-sibling-not-coloring.css"), "failed history test!")
    }


    func testSmallFollowingSiblingNotColoring() {

        XCTAssert(executeTest(markdown: "small-following-sibling-error.history", css: "following-sibling-not-coloring.css"), "failed small history test!")
    }

    func testReallySmallFollowingSiblingNotColoring() {

        XCTAssert(executeTest(markdown: "really-small-following-error.history", css: "following-sibling-not-coloring.css"), "failed small history test!")
    }

    func testWrongClassAttRenderingInsideInvalidAttributesBloc() {

        XCTAssert(executeTest(markdown: "wrong-class-attr-rendering-in-invalid-bloc-attributes.history", css: "wrong-class-attr-rendering.css"), "failed small history test!")
    }

    func testAttributesBlocWrongStylesRulePriority() {

        XCTAssert(executeTest(markdown: "style-rules-priority-problem.history", css: "style-rules-priority-problem.css"), "failed small history test!")
    }

//    func testWrongEmphasisStyling() {
//
//        XCTAssert(executeTest(markdown: "wrong-emphasis-styling.history", css: "wrong-emphasis-styling.css"), "failed small history test!")
//    }
//
//    func testWrongEmphasisStyling2() {
//
//        XCTAssert(executeTest(markdown: "wrong-emphasis-styling.history", css: "wrong-emphasis-styling-test.css"), "failed small history test!")
//    }
//
//    func testInlineAttributesProblem() {
//
//        XCTAssert(executeTest(markdown: "inline-attributes-problem.history", css: "inline-attributes-problem.css"), "failed small history test!")
//    }
    
    
    private func executeTest(markdown filename: String, css styleFilename: String) -> Bool {
        
        let url = urlOfFile(named: filename)
        let utf8String = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        let editHistory = try! EditHistory(jsonString: utf8String)
        var stringChanges = editHistory.stringChanges
        let firstStringChange = stringChanges.removeFirst()
        let sourceString = firstStringChange.replacementString
        
        self.dispatcher = createDispatcher()
        self.markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher!.register(store: markdownDocumentStore!)
        self.style = createStyle(authorStylesheetFilename: styleFilename)
        var markdownStyleStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore!, dispatcher: dispatcher!, with: style!)!
        
        var result = true
        
        var markdownString = sourceString
        
        for (index, stringChange) in stringChanges.enumerated() {
            
            let changeLength = stringChange.replacementString.utf16.count - stringChange.affectedRange.length
            
            let (replacement, destination) = replacementAndDestinationSubtring(fromSourceString: markdownString, range: stringChange.affectedRange, replacementString: stringChange.replacementString)
            
            let change = SourceStringChangeDescription(range: stringChange.affectedRange, stringReplacement: replacement, changeLength: changeLength, targetString: destination)
            
            result = result && compare(change: change, fromSourceString: markdownString, to: destination, markdownStyleStore: &markdownStyleStore)
            
            if !result {
                
                writeTestSource(content: markdownString)
                writeChange(change: stringChange)
                return false
            }
            
            markdownString = destination
        }
        return result
    }
    
    private func writeTestSource(content: String) {
        
        write(content, with: "source.md")
    }
    
    private func writeChange(change: StringChange) {
        
        write("\(change)", with: "change.txt")
    }
    
    private func write(_ string: String, with name: String) {
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(name)
            
            //writing
            do {
                try string.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}
        }
    }
}
