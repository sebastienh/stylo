//
//  RangeOfBlockTokensAroundTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-02-19.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Common
import Markdown

fileprivate let traceEnabled = false

class RangeOfBlockTokensAroundTests: MarkdownBasicTests {

    func testEditBetweenListsCreatingNewItem() {
        
        let change = StringChange(affectedRange: NSMakeRange(67, 0), replacementString: "2")
        let expectedBlockTokenRangeAroundChange = 0..<54
        let stopped = evaluate(change: change, tokenRange: expectedBlockTokenRangeAroundChange, in: "lists.md")
        
        XCTAssert(stopped != nil)
        if let stopped = stopped {
            
            XCTAssert(stopped)
        }
    }
    
    func testEditBetweenListsNotCreatingNewItem() {
        
        let change = StringChange(affectedRange: NSMakeRange(67, 0), replacementString: "-")
        let expectedBlockTokenRangeAroundChange = 0..<54
        let stopped = evaluate(change: change, tokenRange: expectedBlockTokenRangeAroundChange, in: "lists.md")
        
        XCTAssert(stopped != nil)
        if let stopped = stopped {
            
            XCTAssert(stopped)
        }
    }
    
    func testRemoveBetweenListsDeletingItem() {
        
        let change = StringChange(affectedRange: NSMakeRange(77, 1), replacementString: "")
        let expectedBlockTokenRangeAroundChange = 0..<63
        let stopped = evaluate(change: change, tokenRange: expectedBlockTokenRangeAroundChange, in: "3-items-list.md")
        
        XCTAssert(stopped != nil)
        if let stopped = stopped {
            
            XCTAssert(stopped)
        }
    }
    
    func testRemoveBetweenListsAddingItem() {
        
        let change = StringChange(affectedRange: NSMakeRange(78, 1), replacementString: "")
        let expectedBlockTokenRangeAroundChange = 0..<57
        let stopped = evaluate(change: change, tokenRange: expectedBlockTokenRangeAroundChange, in: "2-items-list-potential-middle.md")
        
        XCTAssert(stopped != nil)
        if let stopped = stopped {
            
            XCTAssert(stopped)
        }
    }
    
    func testRemoveBetweenListsAddingItemToSecondList() {
        
        let change = StringChange(affectedRange: NSMakeRange(78, 1), replacementString: "")
        let expectedBlockTokenRangeAroundChange = 0..<57
        let stopped = evaluate(change: change, tokenRange: expectedBlockTokenRangeAroundChange, in: "2-items-list-no-potential-middle.md")
        
        XCTAssert(stopped != nil)
        if let stopped = stopped {
            
            XCTAssert(stopped)
        }
    }
    
    func testAdditionAtEndOfParagraphBeforeList() {
        
        let change = StringChange(affectedRange: NSMakeRange(363, 0), replacementString: "d")
        let expectedBlockTokenRangeAroundChange = 9..<32
        let stopped = evaluate(change: change, tokenRange: expectedBlockTokenRangeAroundChange, in: "long-list.md")
        
        XCTAssert(stopped != nil)
        if let stopped = stopped {
            
            XCTAssert(stopped)
        }
    }
    
    func testEditAfterHeading() {
        
        let change = StringChange(affectedRange: NSMakeRange(41, 0), replacementString: " ")
        let expectedBlockTokenRangeAroundChange = 3..<12
        let stopped = evaluate(change: change, tokenRange: expectedBlockTokenRangeAroundChange, in: "heading.md")
        
        XCTAssert(stopped != nil)
        if let stopped = stopped {
            
            XCTAssert(stopped)
        }
    }
    
    func testEditRemoveHeading() {
        
        let change = StringChange(affectedRange: NSMakeRange(26, 1), replacementString: " ")
        let expectedBlockTokenRangeAroundChange = 0..<15
        let stopped = evaluate(change: change, tokenRange: expectedBlockTokenRangeAroundChange, in: "heading.md")
        
        XCTAssert(stopped != nil)
        if let stopped = stopped {
            
            XCTAssert(stopped)
        }
    }
    
    func testEditAddHeading() {
        
        let change = StringChange(affectedRange: NSMakeRange(26, 0), replacementString: "#")
        let expectedBlockTokenRangeAroundChange = 0..<12
        let stopped = evaluate(change: change, tokenRange: expectedBlockTokenRangeAroundChange, in: "to-become-header.md")
        
        XCTAssert(stopped != nil)
        if let stopped = stopped {
            
            XCTAssert(stopped)
        }
    }
    
    func testEditAfterTable() {
        
        let change = StringChange(affectedRange: NSMakeRange(101, 0), replacementString: "|")
        let expectedBlockTokenRangeAroundChange = 3..<31
        let stopped = evaluate(change: change, tokenRange: expectedBlockTokenRangeAroundChange, in: "table.md")
        
        XCTAssert(stopped != nil)
        if let stopped = stopped {
            
            XCTAssert(stopped)
        }
    }
    
    func testEditWithBlockquoteContinuation() {
        
        let change = StringChange(affectedRange: NSMakeRange(30, 0), replacementString: "k")
        let expectedBlockTokenRangeAroundChange = 0..<16
        let stopped = evaluate(change: change, tokenRange: expectedBlockTokenRangeAroundChange, in: "blockquote-range.md")
        
        XCTAssert(stopped != nil)
        if let stopped = stopped {
            
            XCTAssert(stopped)
        }
    }
    
    func testCreateFencedCodeBlock() {
        
        let change = StringChange(affectedRange: NSMakeRange(2, 0), replacementString: "`")
        let expectedBlockTokenRangeAroundChange = 0..<6
        let stopped = evaluate(change: change, tokenRange: expectedBlockTokenRangeAroundChange, in: "partial-fence.md")
        
        XCTAssert(stopped != nil)
        if let stopped = stopped {
            
            XCTAssert(!stopped)
        }
    }
    
    func testEditInsideParagraphBlock() {
        
        let change = StringChange(affectedRange: NSMakeRange(11, 0), replacementString: "1")
        let expectedBlockTokenRangeAroundChange = 0..<6
        let stopped = evaluate(change: change, tokenRange: expectedBlockTokenRangeAroundChange, in: "partial-fence.md")
        
        XCTAssert(stopped != nil)
        if let stopped = stopped {
            
            XCTAssert(stopped)
        }
    }
    
    func testEditAtEndOfParagraphBlock() {
        
        let change = StringChange(affectedRange: NSMakeRange(13, 0), replacementString: "1")
        let expectedBlockTokenRangeAroundChange = 0..<6
        let stopped = evaluate(change: change, tokenRange: expectedBlockTokenRangeAroundChange, in: "partial-fence.md")
        
        XCTAssert(stopped != nil)
        if let stopped = stopped {
            
            XCTAssert(stopped)
        }
    }
    
    func testEditAtStartOfParagraphBlock() {
        
        let change = StringChange(affectedRange: NSMakeRange(1, 0), replacementString: "1")
        let expectedBlockTokenRangeAroundChange = 0..<6
        let stopped = evaluate(change: change, tokenRange: expectedBlockTokenRangeAroundChange, in: "partial-fence.md")
        
        XCTAssert(stopped != nil)
        if let stopped = stopped {
            
            XCTAssert(stopped)
        }
    }
    
    func testBugCrash() {
        
        let string = try! String(contentsOf: urlOfFile(named: "range-crash.md")!, encoding: String.Encoding.utf8)
        let md = MarkdownParser()
        let tokens = md.parse(string)
        
        let stringChangeRange = NSMakeRange(2754, 163655)
        var sourceString = string
        sourceString.removeSubstring(2754, count: 163655)
        
        let sourceStringChangeDescription = SourceStringChangeDescription(range: stringChangeRange, stringReplacement: "", changeLength: -163655, targetString: NSMutableAttributedString(string: sourceString))
        
        let range = tokens.rangeOfBlockTokensAround(changeDescription: sourceStringChangeDescription)
        XCTAssert(range != nil)
    }

//    // This test is really long, used only to reproduce a crash
//    func testReproduceCrash() {
//
//        let string = try! String(contentsOf: urlOfFile(named: "range-crash.md")!, encoding: String.Encoding.utf8)
//        let md = MarkdownParser()
//        let tokens = md.parse(string)
//
//        for i in stride(from: string.utf16.count, to: 0, by: -1) {
//
//            let changeLocation = string.utf16.count-i
//            let changeLenght = string.utf16.count-changeLocation
//            let stringChangeRange = NSMakeRange(changeLocation, changeLenght)
//
//            var sourceString = string
//            sourceString.removeSubstring(changeLocation, count: changeLenght)
//
//            let sourceStringChangeDescription = SourceStringChangeDescription(range: stringChangeRange, stringReplacement: "", changeLength: -changeLenght, sourceString: NSMutableAttributedString(string: sourceString))
//
//            let range = tokens.rangeOfBlockTokensAround(changeDescription: sourceStringChangeDescription)
//            if i != 0 {
//                XCTAssert(range != nil, "index \(i) failed")
//            }
//            else {
//                XCTAssert(range == nil, "index \(i) failed")
//            }
//        }
//    }
    
    func testReproduceCrash3248() {
        
        let string = try! String(contentsOf: urlOfFile(named: "range-crash.md")!, encoding: String.Encoding.utf8)
        let md = MarkdownParser()
        let tokens = md.parse(string)
        
        let i = 3248
        let changeLocation = string.utf16.count-i
        let changeLenght = string.utf16.count-changeLocation
        let stringChangeRange = NSMakeRange(changeLocation, changeLenght)
        
        var sourceString = string
        sourceString.removeSubstring(changeLocation, count: changeLenght)
        
        let sourceStringChangeDescription = SourceStringChangeDescription(range: stringChangeRange, stringReplacement: "", changeLength: -changeLenght, targetString: NSMutableAttributedString(string: sourceString))
        
        let range = tokens.rangeOfBlockTokensAround(changeDescription: sourceStringChangeDescription)
        XCTAssert(range != nil)
    }
    
    
//    func testRandom() {
//
//        let string = try! String(contentsOf: urlOfFile(named: "range-crash.md")!, encoding: String.Encoding.utf8)
//        let md = MarkdownParser()
//        let tokens = md.parse(string)
//
//        var failedChanges = [StringChange]()
//        var count = 0
//
//        while failedChanges.count < 10 {
//
//            if let randomChangeType = self.randomChangeType {
//
//                if let stringChange = randomStringChange(from: string, changeType: randomChangeType) {
//
//                    let changeLength = stringChange.replacementString.utf16.count - stringChange.affectedRange.length
//
//                    if let (replacement, destination) = replacementAndDestinationSubtring(fromSourceString: string, range: stringChange.affectedRange, replacementString: stringChange.replacementString) {
//
//                        count += 1
//
//                        let change = SourceStringChangeDescription(range: stringChange.affectedRange, stringReplacement: replacement, changeLength: changeLength, sourceString: NSMutableAttributedString(string: destination))
//
//                        let range = tokens.rangeOfBlockTokensAround(changeDescription: change)
//                        if range == nil {
//
//                            failedChanges.append(stringChange)
//                            print("failure: \(count)")
//                        }
//                        else {
//
//                            print("success: \(count)")
//                        }
//                    }
//                }
//            }
//        }
//        XCTAssert(false, "failedChanges: \(failedChanges)")
//    }
    
    private func evaluate(change: StringChange, tokenRange: Range<Int>, in filename: String) -> Bool? {
        
        let string = try! String(contentsOf: urlOfFile(named: filename)!, encoding: String.Encoding.utf8)
        let md = MarkdownParser()
        let tokens = md.parse(string)
        
        let changeLength = change.replacementString.utf16.count - change.affectedRange.length
        
        if let strings = replacementAndDestinationSubtring(fromSourceString: string, range: change.affectedRange, replacementString: change.replacementString) {
        
            let sourceStringChangeDescription = SourceStringChangeDescription(range: change.affectedRange, stringReplacement: strings.replacement, changeLength: changeLength, targetString: strings.destination)
            
            let range = tokens.rangeOfBlockTokensAround(changeDescription: sourceStringChangeDescription)
            XCTAssert(range != nil)
            if let range = range {
                
                XCTAssert(range == tokenRange, "Expected: \(tokenRange), received: \(range)")
                return partialCompilationStopped(originalTokenRange: range, markdownTokens: tokens, description: sourceStringChangeDescription)
            }
        }
        return nil
    }
    
    private func replacementAndDestinationSubtring(fromSourceString string: String, range: NSRange, replacementString: String) -> (replacement: String.UTF16View.SubSequence, destination: String)? {
        
        var string = string
        
        let startRangeIndex = string.utf16.index(string.utf16.startIndex, offsetBy: range.lowerBound)
        let endRangeIndex = string.utf16.index(string.utf16.startIndex, offsetBy: range.upperBound)
        if string.startIndex <= startRangeIndex && endRangeIndex <= string.endIndex {
            string.replaceSubrange(startRangeIndex..<endRangeIndex, with: replacementString)
            return (replacementString.utf16[replacementString.utf16.startIndex..<replacementString.utf16.endIndex], string)
        }
        return nil
    }
    
    private func partialCompilationStopped(originalTokenRange: Range<Int>, markdownTokens: Tokens, description: SourceStringChangeDescription) -> Bool {
        
        let startBlock = markdownTokens[originalTokenRange.lowerBound]!
        let globalStartIndex = startBlock.startStringIndex
        
        // get the range from it
        // this is the range we should try to stop at
        // This range is the range start of the token after
        // the range we really want to compile
        let range = markdownTokens.computeOptimisticStopRange(originalTokenRange: originalTokenRange, description: description)
        
        var stopped: Bool = false
        
        if let range = range {
            
            // the string extract always return from the startToken index until the end
            if let stringExtract = markdownTokens.optimisticStringExtract(optimisticTokenRange: originalTokenRange, description: description) {
                
                if traceEnabled {
                    print("stringExtract:\n\(stringExtract)")
                    let stopString = stringExtract.substring(range.location, length: range.length)!
                    print("stop string:\n\(stopString)")
                }
                
                let mardownParser = MarkdownParser(options: Presets.GetCommonMarkPresets().options!, stopOpeningTokenRange: range, cleanReferencesAsParsing: true, globalPositionOffset: globalStartIndex)
                
                // parse the extracted range
                mardownParser.parse(stringExtract as String, stopped: &stopped)
            }
        }
        else {
            // when the range returned is nil, it means we compile until the end
            return true
        }
        
        return stopped
    }
    
    
    
}
