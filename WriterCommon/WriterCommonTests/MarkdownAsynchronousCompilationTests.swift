//
//  MarkdownAsynchronousCompilationTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-07-18.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Common
import Igloo
import Markdown
import os
@testable import WriterCommon

class MarkdownAsynchronousCompilationTests: MarkdownDocumentStoreTests {
    
    var filename = "two-tables.md"
    
    var sourceString: String?
    
    var dispatcher: MarkdownDocumentDispatcher?
    
    var markdownDocumentStore: MarkdownDocumentStore?
    
    var style: CSSStyle?
    
    override func setUp() {
        
        super.setUp()
        
        self.sourceString = """
        # 1
        
        ## 3
        """

        let destinationSourceString = """
        # 1
        
        ## 3
        """
        
        self.dispatcher = createDispatcher()
        self.markdownDocumentStore = nil
        self.markdownDocumentStore = MarkdownDocumentStore(identifier: UUID().uuidString, name: "test-store", parentId: "")
        self.dispatcher!.register(store: markdownDocumentStore!)
        self.style = createBasicStyle()
        compileMarkdownTokens(fromSourceString: self.sourceString!, in: markdownDocumentStore!, dispatcher: dispatcher!, with: style!)
    }
    
    override func tearDown() {
        super.tearDown()
        
        self.sourceString = nil
        self.dispatcher = nil
        self.markdownDocumentStore = nil
        self.style = nil
    }
    
    func testBasic() {
        
        var stringChanges = [StringChange]()
        stringChanges.append(StringChange(affectedRange: NSMakeRange(4, 0), replacementString: "d"))
        stringChanges.append(StringChange(affectedRange: NSMakeRange(5, 0), replacementString: "d"))
        stringChanges.append(StringChange(affectedRange: NSMakeRange(6, 0), replacementString: "d"))
        stringChanges.append(StringChange(affectedRange: NSMakeRange(7, 0), replacementString: "d"))
        stringChanges.append(StringChange(affectedRange: NSMakeRange(8, 0), replacementString: "d"))
        stringChanges.append(StringChange(affectedRange: NSMakeRange(9, 0), replacementString: "d"))
        stringChanges.append(StringChange(affectedRange: NSMakeRange(10, 0), replacementString: "d"))
        stringChanges.append(StringChange(affectedRange: NSMakeRange(11, 0), replacementString: "d"))
        stringChanges.append(StringChange(affectedRange: NSMakeRange(12, 0), replacementString: "d"))
        
        
    }
    
    private func pendingRequests(with stringChanges: [StringChange]) -> Queue<SourceStringChangeDescription> {
        
        var queue = Queue<SourceStringChangeDescription>()
        
        var string = sourceString!
        
        for stringChange in stringChanges {
        
            let changeLength = stringChange.replacementString.utf16.count - stringChange.affectedRange.length
            
            let (replacement, destination) = replacementAndDestinationSubtring(fromSourceString: string, range: stringChange.affectedRange, replacementString: stringChange.replacementString)
            
            let change = SourceStringChangeDescription(range: stringChange.affectedRange, stringReplacement: replacement, changeLength: changeLength, targetString: destination)
        
            queue.enqueue(change)
            string = destination
        }
        
        return queue
    }
    
    private func udpateSourceString(with stringChanges: [StringChange]) -> String {
        
        var string = sourceString!
        
        for stringChange in stringChanges {

            let (_, destination) = replacementAndDestinationSubtring(fromSourceString: string, range: stringChange.affectedRange, replacementString: stringChange.replacementString)

            string = destination
        }
        
        return string
    }
    
    private func replacementAndDestinationSubtring(fromSourceString string: String, range: NSRange, replacementString: String) -> (replacement: String.UTF16View.SubSequence, destination: String) {
        
        var _string = string
        
        let startRangeIndex = _string.utf16.index(_string.utf16.startIndex, offsetBy: range.lowerBound)
        let endRangeIndex = _string.utf16.index(_string.utf16.startIndex, offsetBy: range.upperBound)
        _string.replaceSubrange(startRangeIndex..<endRangeIndex, with: replacementString)
        return (replacementString.utf16[replacementString.utf16.startIndex..<replacementString.utf16.endIndex], _string)
    }

}
