//
//  MarkdownItBig.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-10-06.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Common
import Igloo
import Markdown
import os
@testable import WriterCommon

class MarkdownItBig: MarkdownTokensTests {

    override func setUp() {
        
        filename = "markdown-it-big.md"
        super.setUp()
    }

    func testChangeAtIndex594() {
        
        // cutTokensEnd range    NSRange    location=173, length=21
        let change = StringChange(affectedRange: NSMakeRange(594, 0), replacementString: " ")
        XCTAssert(executeTests(stringChanges: [change]))
    }
    
//    func testPerformance1() {
//        
//        var sourceString = self.sourceString!
//        let count = sourceString.count
//        
//        var insertionsCount = 0
//        var changes = [SourceStringChangeDescription]()
//        
//        // create the changes
//        for i in stride(from: 0, to: count, by: 1000) {
//            
//            insertionsCount += 1
//            let index = i + insertionsCount
//            
//            let stringChange = StringChange(affectedRange: NSMakeRange(index, 0), replacementString: " ")
//            
//            let changeLength = stringChange.replacementString.utf16.count - stringChange.affectedRange.length
//            
//            let (replacement, destination) = replacementAndDestinationSubtring(fromSourceString: sourceString, range: stringChange.affectedRange, replacementString: stringChange.replacementString)
//            
//            let change = SourceStringChangeDescription(range: stringChange.affectedRange, stringReplacement: replacement, changeLength: changeLength, sourceString: NSMutableAttributedString(string: destination))
//            
//            changes.append(change)
//            
//            sourceString = destination.string
//        }
//        
//        // This is an example of a performance test case.
//        self.measure() {
//            
//            for change in changes {
//             
//                let sourceStringChangedAction = EditableStoreActionsFactory.sourceStringChangedActionSync(description: change)
//                dispatcher!.sync(store: markdownDocumentStore!, action: sourceStringChangedAction)
//            }
//        }
//    }
    
    private func replacementAndDestinationSubtring(fromSourceString sourceString: String, range: NSRange, replacementString: String) -> (replacement: String.UTF16View.SubSequence, destination: String) {
        
        var sourceString = sourceString
        let startRangeIndex = sourceString.utf16.index(sourceString.utf16.startIndex, offsetBy: range.lowerBound)
        let endRangeIndex = sourceString.utf16.index(sourceString.utf16.startIndex, offsetBy: range.upperBound)
        sourceString.replaceSubrange(startRangeIndex..<endRangeIndex, with: replacementString)
        return (replacementString.utf16[replacementString.utf16.startIndex..<replacementString.utf16.endIndex], sourceString)
    }
    
}
