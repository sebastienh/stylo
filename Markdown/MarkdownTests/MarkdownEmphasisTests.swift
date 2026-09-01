//
//  MarkdownEmphasisTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-03-15.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Markdown

class MarkdownEmphasisTests: MarkdownBasicTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    ///
    /// # Titre 1
    ///
    /// Paragraphe.
    ///
    /// ## titre 2
    ///
    /// ### titre 3
    ///
    ///
    /// Titre de niveau 1
    /// =============
    ///
    /// Titre de niveau 2
    /// -----------------------------------
    ///
    ///
    /// > blockquote value blockquote value **blockquote** value blockquote *value* blockquote
    ///
    /// RESULT: PASS
    ///
    func testComplexeEmphasisInBlockquoteWithHeader() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "complexe-emphased-text.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("# Titre 1\n\nParagraphe.\n\n## titre 2\n\n### titre 3\n\n\nTitre de niveau 1\n=============\nTitre de niveau 2\n-----------------------------------\n\n\n> blockquote value blockquote value **blockquote** value blockquote *value* blockquote")
        
        XCTAssert(tokens.length != 0)
        
        // var inlineCount = 0
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    
    
    
    
    
    
    ///
    /// # A header
    ///
    /// > Start of blockquote
    /// > Text not in bold **Text in bold**
    /// > End of blockquote
    ///
    /// RESULT: PASS
    ///
    func testEmphasisInBlockquoteWithHeader() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "emphased-text.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        // opening tag segment: 53, 2
        // closing tag segment: 67, 2
        
        let tokens = md.parse("# A header\n\n> Start of blockquote\n> Text not in bold *Emphased*\n> End of blockquote")
        
        XCTAssert(tokens.length != 0)
        
        var inlineCount = 0
        
        for token in tokens {
            
            if token.type == .inline {
                
                inlineCount += 1
                
                if inlineCount == 2 {
                    
                    for childToken in token.children {
                        
                        if childToken.type == .strongOpen {
                            
                            let tagSourceStringRegion = childToken.sourceFragment(for: .Tag) as! SourceStringRegion
                            
                            var tagRegion = SourceStringRegion()
                            tagRegion.addSourceStringSegment(SourceStringSegment.Get(53, length: 2))
                            tagRegion.addSourceStringSegment(SourceStringSegment.Get(63, length: 2))
                            
                            XCTAssert(tagSourceStringRegion == tagRegion, "Received tag region different from expected tag region.")
                            
                            let wholeSourceStringSegment = childToken.sourceFragment(for: .All) as! SourceStringSegment
                            
                            let expectedWholeSourceStringSegment = SourceStringSegment.Get(53, length: 12)
                            
                            XCTAssert(wholeSourceStringSegment == expectedWholeSourceStringSegment, "Received whole segment different from expected whole segment.")
                        }
                    }
                }
            }
        }
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    ///
    /// # A header
    ///
    /// > Start of blockquote
    /// > Text not in bold **Text in bold**
    /// > End of blockquote
    ///
    /// RESULT: PASS
    ///
    func testStrongEmphasisInBlockquoteWithHeader() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "strong-emphasis-in-blockquote-with-header.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        // opening tag segment: 53, 2
        // closing tag segment: 67, 2
        
        let tokens = md.parse("# A header\n\n> Start of blockquote\n> Text not in bold **Text in bold**\n> End of blockquote")
        
        XCTAssert(tokens.length != 0)
        
        var inlineCount = 0
        
        for token in tokens {
            
            if token.type == .inline {
                
                inlineCount += 1
                
                if inlineCount == 2 {
                
                    for childToken in token.children {
                        
                        if childToken.type == .strongOpen {
                            
                            let tagSourceStringRegion = childToken.sourceFragment(for: .Tag) as! SourceStringRegion
                            
                            var tagRegion = SourceStringRegion()
                            tagRegion.addSourceStringSegment(SourceStringSegment.Get(53, length: 2))
                            tagRegion.addSourceStringSegment(SourceStringSegment.Get(67, length: 2))
                            
                            XCTAssert(tagSourceStringRegion == tagRegion, "Received tag region different from expected tag region.")
                            
                            let wholeSourceStringSegment = childToken.sourceFragment(for: .All) as! SourceStringSegment
                            
                            let expectedWholeSourceStringSegment = SourceStringSegment.Get(53, length: 16)
                            
                            XCTAssert(wholeSourceStringSegment == expectedWholeSourceStringSegment, "Received whole segment different from expected whole segment.")
                        }
                    }
                }
            }
        }
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    
    
    ///
    /// **This is bold text**
    ///
    /// RESULT: PASS
    ///
    func testStrongEmphasis() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "strong-emphasis.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("**This is bold text**")
        
        XCTAssert(tokens.length != 0)
        
        for token in tokens {
        
            if token.type == .inline {
                
                for childToken in token.children {
                    
                    if childToken.type == .strongOpen {
                        
                        let tagSourceStringRegion = childToken.sourceFragment(for: .Tag) as! SourceStringRegion
                        
                        var tagRegion = SourceStringRegion()
                        tagRegion.addSourceStringSegment(SourceStringSegment.Get(0, length: 2))
                        tagRegion.addSourceStringSegment(SourceStringSegment.Get(19, length: 2))
                        
                        XCTAssert(tagSourceStringRegion == tagRegion, "Received tag region different from expected tag region.")
                        
                        let wholeSourceStringSegment = childToken.sourceFragment(for: .All) as! SourceStringSegment
                        
                        let expectedWholeSourceStringSegment = SourceStringSegment.Get(0, length: 21)
                        
                        XCTAssert(wholeSourceStringSegment == expectedWholeSourceStringSegment, "Received whole segment different from expected whole segment.")
                    }
                }
            }
        }
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }

}
