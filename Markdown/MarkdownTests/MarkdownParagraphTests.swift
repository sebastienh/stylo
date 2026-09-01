//
//  MarkdownParagraphTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-03-17.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Markdown

class MarkdownParagraphTests: MarkdownBasicTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// 
    /// foo <!-- not a comment -- two hyphens -->
    ///
    /// RESULT: PASS
    ///
    func testParagraphWhichIsNotAComment() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "not-comment-paragraph.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("foo <!-- not a comment -- two hyphens -->")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        if tokenString != expectedString {
            
            displayStringDifferences(tokenString, string2: expectedString)
        }
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    
    ///
    /// # Titre 1
    ///
    /// Paragraphe. The meaning of mathematics is very hard to get across without these named block environments, which carefully offset important formal statements from the rest of the text. Lemmas, Theorems, and Proofs are not aesthetics, *they* are specific structural features of a text, just as important to mathematics as code blocks are to discussing programming. This is why I think these blocks should be supported by multimarkdown.
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
    /// > blockquote value blockquote value **blockquote** value blockquote *value* blockquote
    ///
    /// RESULT: PASS
    ///
    func testComplexeParagraph() {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: "complexe-paragraph.json")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse("# Titre 1\n\nParagraphe. The meaning of mathematics is very hard to get across without these named block environments, which carefully offset important formal statements from the rest of the text. Lemmas, Theorems, and Proofs are not aesthetics, *they* are specific structural features of a text, just as important to mathematics as code blocks are to discussing programming. This is why I think these blocks should be supported by multimarkdown.\n\n## titre 2\n\n### titre 3\n\n\nTitre de niveau 1\n=============\n\nTitre de niveau 2\n-----------------------------------\n\n> blockquote value blockquote value **blockquote** value blockquote *value* blockquote")
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
        if tokenString != expectedString {
            
            displayStringDifferences(tokenString, string2: expectedString)
        }
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }

    

}
