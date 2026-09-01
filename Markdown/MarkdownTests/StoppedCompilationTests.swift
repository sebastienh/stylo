//
//  StoppedCompilationTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-02-21.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Common
import Markdown

fileprivate let traceEnabled = true

class StoppedCompilationTests: MarkdownBasicTests {

    
//        func testStoppedCompilationRandom() {
//
//            let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-4.md")!, encoding: String.Encoding.utf8)
//            var failedChanges = [StringChange]()
//            var count = 0
//
//            while failedChanges.count < 10 {
//
//                if let randomChangeType = self.randomChangeType {
//
//                    if let stringChange = randomStringChange(from: string, changeType: randomChangeType) {
//
//                        count += 1
//
//                        let stopped = evaluateStopped(with: stringChange, in: string)
//
//                        if stopped {
//
//                            print("success: \(count)")
//                        }
//                        else {
//
//                            failedChanges.append(stringChange)
//                            print("no stop failure: \(count)")
//                        }
//                    }
//                }
//            }
//            XCTAssert(false, "failedChanges: \(failedChanges)")
//        }
    
    func testNonStoppedCompilationRandom1() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(85996, 78718), replacementString: "")
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(stopped, "Expected stopped.")
    }
    
    func testNonStoppedCompilationRandom2() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(12794, 52078), replacementString: "")
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(stopped, "Expected stopped.")
    }
    
    func testNonStoppedCompilationRandom3() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(54807, 100700), replacementString: "")
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(stopped, "Expected stopped.")
    }
    
    func testNonStoppedCompilationRandom4() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(99242, 45829), replacementRange: NSMakeRange(46000, 45829), string: string)
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(!stopped, "Expected not stopped.")
    }
    
    func testNonStoppedCompilationRandom5() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(39657, 0), replacementRange: NSMakeRange(47183, 19362), string: string)
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(stopped, "Expected stopped.")
    }
    
    func testNonStoppedCompilationRandom6() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(162211, 0), replacementRange: NSMakeRange(53157, 30278), string: string)
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(stopped, "Expected stopped.")
    }
    
    func testNonStoppedCompilationRandom7() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(147149, 0), replacementRange: NSMakeRange(117941, 26086), string: string)
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(!stopped, "Expected not stopped: list continuation.")
    }
    
    func testNonStoppedCompilationRandom8() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(56522, 99363), replacementRange: NSMakeRange(95622, 18878), string: string)
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(!stopped, "Expected not stopped: list continuation.")
    }
    
    func testNonStoppedCompilationRandom9() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(56488, 42398), replacementString: "")
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(!stopped, "Expected not stopped: html block not ending")
    }
    
    func testNonStoppedCompilationRandom10() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(139535, 0), replacementRange: NSMakeRange(165820, 0), string: string)
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(!stopped, "Expected not stopped: list continuation.")
    }
    
    func testNonStoppedCompilationRandom11() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(137017, 15283), replacementRange: NSMakeRange(53380, 2968), string: string)
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(!stopped, "Expected not stopped: html block not ending")
    }
    
//    func testStoppedCompilationRandomAddition() {
//
//        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
//        var failedChanges = [StringChange]()
//        var count = 0
//
//        while failedChanges.count < 10 {
//
//            autoreleasepool {
//
//                let additionLocation = Int.random(in: 0...string.utf16.count)
//                let characterLocation = Int.random(in: 0..<string.utf16.count)
//                let characterString = string.substring(characterLocation, length: 1)!
//                let stringChange = StringChange(affectedRange: NSMakeRange(additionLocation, 0), replacementString: characterString)
//
//                count += 1
//
//                let stopped = evaluateStopped(with: stringChange, in: string)
//
//                if stopped {
//
//                    print("success: \(count)")
//                }
//                else {
//
//                    failedChanges.append(stringChange)
//                    print("no stop failure: \(count)")
//                }
//            }
//        }
//        XCTAssert(false, "failedChanges: \(failedChanges)")
//    }
    
    func testNonStoppedCompilationAddition12() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(50296, 0), replacementString: "d")
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(stopped, "Expected stopped")
    }
    
    func testNonStoppedCompilationAddition13() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(270040, 0), replacementString: "f")
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(!stopped, "Expected stopped")
    }
    
    func testNonStoppedCompilationAddition14() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(4729, 0), replacementString: "H")
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(stopped, "Expected stopped")
    }
    
    func testNonStoppedCompilationAddition15() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(54400, 0), replacementString: "\'")
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(stopped, "Expected stopped")
    }
    
    func testNonStoppedCompilationAddition16() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(1509, 0), replacementString: "o")
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(stopped, "Expected stopped")
    }
    
    func testNonStoppedCompilationAddition17() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(120945, 0), replacementString: "c")
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(stopped, "Expected stopped")
    }
    
    func testNonStoppedCompilationAddition18() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(56536, 0), replacementString: "<")
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(!stopped, "Expected not stopped: we screw the end of a clode block")
    }
    
    func testNonStoppedCompilationAddition19() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(56008, 0), replacementString: " ")
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(!stopped, "Expected not stopped: we screw the end of a clode block")
    }
    
    func testNonStoppedCompilationAddition20() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-2.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(115502, 0), replacementString: "\n")
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(stopped, "Expected stopped")
    }
    
    func testNonStoppedCompilationAddition21() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-3.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(115502, 0), replacementString: "\n")
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(stopped, "Expected stopped")
    }
    
    func testNonStoppedCompilationRemoval22() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-4.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(174293, 1), replacementString: "")
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(stopped, "Expected stopped")
    }
    
    func testNonStoppedCompilationRemoval23() {
        
        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-4.md")!, encoding: String.Encoding.utf8)
        let stringChange = StringChange(affectedRange: NSMakeRange(174164, 1), replacementString: "")
        let stopped = evaluateStopped(with: stringChange, in: string)
        XCTAssert(stopped, "Expected stopped")
    }
    
//    func testStoppedCompilationRandomSingleRemoval() {
//        
//        let string = try! String(contentsOf: urlOfFile(named: "stopped-compilation-4.md")!, encoding: String.Encoding.utf8)
//        var failedChanges = [StringChange]()
//        var count = 0
//        
//        while failedChanges.count < 10 {
//            
//            autoreleasepool {
//                
//                let removalLocation = Int.random(in: 0...string.utf16.count)
//                let stringChange = StringChange(affectedRange: NSMakeRange(removalLocation, 1), replacementString: "")
//                
//                count += 1
//                
//                let stopped = evaluateStopped(with: stringChange, in: string)
//                
//                if stopped {
//                    
//                    print("success: \(count)")
//                }
//                else {
//                    
//                    failedChanges.append(stringChange)
//                    print("no stop failure: \(count)")
//                }
//            }
//        }
//        XCTAssert(false, "failedChanges: \(failedChanges)")
//    }

    
    
    
    func evaluateStopped(with stringChange: StringChange, in string: String) -> Bool {
        
        if traceEnabled {
            print("=======================================================")
            print("=======================================================")
            print("=======================================================")
            print("Original String: \(string)")
            print("=======================================================")
            print("=======================================================")
            print("=======================================================")
        }
        
        let md = MarkdownParser()
        let tokens = md.parse(string)
        
        let changeLength = stringChange.replacementString.utf16.count - stringChange.affectedRange.length
        
        if let (replacement, destination) = replacementAndDestinationSubtring(fromSourceString: string, range: stringChange.affectedRange, replacementString: stringChange.replacementString) {
            
            if traceEnabled {
                print("=======================================================")
                print("=======================================================")
                print("=======================================================")
                print("Modified String: \(destination)")
                print("=======================================================")
                print("=======================================================")
                print("=======================================================")
            }
            
            let change = SourceStringChangeDescription(range: stringChange.affectedRange, stringReplacement: replacement, changeLength: changeLength, targetString: destination)
            
            if let range = tokens.rangeOfBlockTokensAround(changeDescription: change) {
                
                return partialCompilationStopped(originalTokenRange: range, markdownTokens: tokens, description: change)
            }
        }
        return false
    }
    
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
