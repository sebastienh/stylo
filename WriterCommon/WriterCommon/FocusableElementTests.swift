//
//  FocusableElementTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-09-11.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Common
import Igloo

class FocusableElementTests: MarkdownRendererTests {
    
    func testSentenceFocusRange1NoLinks() {
        
        let markdownString: String = {
            
            var value: String = "\n\n" +
                "This is a sentence. This is a ![im](link) second [l](dest) sentence with ![img1](img-dest) an end." +
                "\n\n\n" +
            "\n"
            
            for _ in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        let styleString = """
            body {
                color: black;
            }
            :focus {
                color: red;
            }
            :fade {
                color: black;
            }
        """
        
        
        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        markdownContext.setFocusMode(focusMode: FocusMode.enabled(focusType: .sentence))
        XCTAssert(markdownContext.markdownStyleStore.focusMode.value == FocusMode.enabled(focusType: .sentence))
        
        let totalRange = NSMakeRange(0, markdownString.utf16.count)
        
        let firstSentenceRange = NSMakeRange(2, 19)
        let restRange = NSMakeRange(21, totalRange.length-firstSentenceRange.length)
        
        for i in firstSentenceRange.location..<firstSentenceRange.upperBound {
            markdownContext.applySelectionChange(selectionRange: NSMakeRange(i, 0), visibleRange: totalRange)
            validateFocusColor(in: markdownContext, range: firstSentenceRange, color: red) { (e, r, i) in
                XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
            }
            validateFocusColor(in: markdownContext, range: restRange, color: black) { (e, r, i) in
                XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
            }
        }        
    }
    
    func testSentenceFocusRange2WithLinks() {
        
        let markdownString: String = {
            
            var value: String = "\n\n" +
                "This is a sentence. This is a ![im](link) second [l](dest) sentence with ![img1](img-dest) an end." +
                "\n\n\n" +
            "\n"
            
            for _ in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        let styleString = """
            body {
                color: yellow;
            }
            :focus {
                color: red;
            }
            :fade {
                color: black;
            }
        """
        
        
        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        markdownContext.setFocusMode(focusMode: FocusMode.enabled(focusType: .sentence))
        XCTAssert(markdownContext.markdownStyleStore.focusMode.value == FocusMode.enabled(focusType: .sentence))
        
        markdownContext.string.printCharactersIndexes()
        
        let totalRange = NSMakeRange(0, markdownString.utf16.count)
        
        let firstSentenceRange = NSMakeRange(2, 19)
        let secondSentenceRange = NSMakeRange(22, 78)
        let restRange = NSMakeRange(100, totalRange.length-firstSentenceRange.length)
        
        for i in secondSentenceRange.location..<secondSentenceRange.upperBound {
            markdownContext.applySelectionChange(selectionRange: NSMakeRange(i, 0), visibleRange: totalRange)
            validateFocusColor(in: markdownContext, range: firstSentenceRange, color: black) { (e, r, charIndex) in
                XCTAssert(false, "Expected: \(e), received: \(r) at index: \(charIndex) focusing on \(i)")
            }
            validateFocusColor(in: markdownContext, range: secondSentenceRange, color: red) { (e, r, charIndex) in
                XCTAssert(false, "Expected: \(e), received: \(r) at index: \(charIndex) focusing on \(i)")
            }
            validateFocusColor(in: markdownContext, range: restRange, color: black) { (e, r, charIndex) in
                XCTAssert(false, "Expected: \(e), received: \(r) at index: \(charIndex) focusing on \(i)")
            }
        }
    }
    
    func testSentenceFocusRangeInParagraphWithEmphasis() {
        
        let markdownString: String = {
            
            var value: String = "\n\n" +
                "__[p](https://no)__ - hi\n" +
                "resize." +
                "\n\n\n" +
            "\n"
            
            for _ in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        let styleString = """
            body {
                color: yellow;
            }
            :focus {
                color: red;
            }
            :fade {
                color: black;
            }
        """
        
        
        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        markdownContext.setFocusMode(focusMode: FocusMode.enabled(focusType: .sentence))
        XCTAssert(markdownContext.markdownStyleStore.focusMode.value == FocusMode.enabled(focusType: .sentence))
        
        markdownContext.string.printCharactersIndexes()
        
        let totalRange = NSMakeRange(0, markdownString.utf16.count)
        
        let firstSentenceRange = NSMakeRange(2, 24)
        let secondSentenceRange = NSMakeRange(27, 7)
        let restRange = NSMakeRange(100, totalRange.length-firstSentenceRange.length)
        
        for i in firstSentenceRange.location..<firstSentenceRange.upperBound {
            markdownContext.applySelectionChange(selectionRange: NSMakeRange(i, 0), visibleRange: totalRange)
            validateFocusColor(in: markdownContext, range: firstSentenceRange, color: red) { (e, r, charIndex) in
                XCTAssert(false, "Expected: \(e), received: \(r) at index: \(charIndex) focusing on \(i)")
            }
            validateFocusColor(in: markdownContext, range: secondSentenceRange, color: black) { (e, r, charIndex) in
                XCTAssert(false, "Expected: \(e), received: \(r) at index: \(charIndex) focusing on \(i)")
            }
            validateFocusColor(in: markdownContext, range: restRange, color: black) { (e, r, charIndex) in
                XCTAssert(false, "Expected: \(e), received: \(r) at index: \(charIndex) focusing on \(i)")
            }
        }
    }
    
    func testSentenceFocusRangeInParagraphWithEmphasisInsideAListElement() {
        
        let markdownString: String = {
            
            var value: String = "\n\n" +
                "- __[p](https://no)__ - hi\n" +
                "resize." +
                "\n\n\n" +
            "\n"
            
            for _ in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        let styleString = """
            body {
                color: yellow;
            }
            :focus {
                color: red;
            }
            :fade {
                color: black;
            }
        """
        
        
        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        markdownContext.setFocusMode(focusMode: FocusMode.enabled(focusType: .sentence))
        XCTAssert(markdownContext.markdownStyleStore.focusMode.value == FocusMode.enabled(focusType: .sentence))
        
        markdownContext.string.printCharactersIndexes()
        
        let totalRange = NSMakeRange(0, markdownString.utf16.count)
        
        let firstSentenceRange = NSMakeRange(2, 26)
        let secondSentenceRange = NSMakeRange(29, 7)
        let restRange = NSMakeRange(100, totalRange.length-firstSentenceRange.length)
        
        for i in firstSentenceRange.location..<firstSentenceRange.upperBound {
            markdownContext.applySelectionChange(selectionRange: NSMakeRange(i, 0), visibleRange: totalRange)
            validateFocusColor(in: markdownContext, range: firstSentenceRange, color: red) { (e, r, charIndex) in
                XCTAssert(false, "Expected: \(e), received: \(r) at index: \(charIndex) focusing on \(i)")
            }
            validateFocusColor(in: markdownContext, range: secondSentenceRange, color: black) { (e, r, charIndex) in
                XCTAssert(false, "Expected: \(e), received: \(r) at index: \(charIndex) focusing on \(i)")
            }
            validateFocusColor(in: markdownContext, range: restRange, color: black) { (e, r, charIndex) in
                XCTAssert(false, "Expected: \(e), received: \(r) at index: \(charIndex) focusing on \(i)")
            }
        }
    }
    
    
    func testSentenceFocusRangeInParagraphWithEmphasisInsideAListElementFirstIndexInParagraph() {
        
        let markdownString: String = {
            
            var value: String = "\n\n" +
                "- __[p](https://no)__ - hi\n" +
                "resize." +
                "\n\n\n" +
            "\n"
            
            for _ in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        let styleString = """
            body {
                color: yellow;
            }
            :focus {
                color: red;
            }
            :fade {
                color: black;
            }
        """
        
        
        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        markdownContext.setFocusMode(focusMode: FocusMode.enabled(focusType: .sentence))
        XCTAssert(markdownContext.markdownStyleStore.focusMode.value == FocusMode.enabled(focusType: .sentence))
        
        markdownContext.string.printCharactersIndexes()
        
        let totalRange = NSMakeRange(0, markdownString.utf16.count)
        
        let firstSentenceRange = NSMakeRange(2, 26)
        let secondSentenceRange = NSMakeRange(29, 7)
        let restRange = NSMakeRange(100, totalRange.length-firstSentenceRange.length)
        let index = 4
        
        markdownContext.applySelectionChange(selectionRange: NSMakeRange(4, 0), visibleRange: totalRange)
        validateFocusColor(in: markdownContext, range: firstSentenceRange, color: red) { (e, r, charIndex) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(charIndex) focusing on \(index)")
        }
        validateFocusColor(in: markdownContext, range: secondSentenceRange, color: black) { (e, r, charIndex) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(charIndex) focusing on \(index)")
        }
        validateFocusColor(in: markdownContext, range: restRange, color: black) { (e, r, charIndex) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(charIndex) focusing on \(index)")
        }
    }
    
    
}
