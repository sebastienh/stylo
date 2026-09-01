//
//  TestCSSParser.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-10.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Cocoa
import Common
import XCTest
@testable import Web

class TestCSSParser: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSimpleCSSParser() {
        
        
        let cssString =
            "   body {                          " +
            "       font-family: arial;         " +
            "   }                               "
        
        let reader = CSSReader(sourceString: cssString as NSString )
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
//        let dotStringVisitor = CSDotStringPreOrderVisitor()
//        
//        dotStringVisitor.process(styleSheet)
//        
//        createDotFile("simpleCssFileWithBodyRule.dot", content: dotStringVisitor.dotString)
        
    }
    
    func testSimpleCSSParserCSSOM() {
        
        let cssString = " body { font-family: arial; } "
        
        let reader = CSSReader(sourceString: cssString as NSString )
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(origin: .author)
        
        let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
         
        print("\(cssStyleSheet)", terminator: "")

    }
    
    func testCSSParserPseudoElement() {
        
        let cssString =
        "   body::tag {                          " +
        "       font-family: arial;         " +
        "   }                               ";
        
        let reader = CSSReader(sourceString: cssString as NSString )
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
//        let dotStringVisitor = CSDotStringPreOrderVisitor()
//        
//        dotStringVisitor.process(styleSheet)
//        
//        createDotFile("testCSSParserPseudoElement.dot", content: dotStringVisitor.dotString)
        
    }
    
    func testCSSParserPseudoClass() {
        
        let cssString =
        "   body:matches(:hover, :focus) {                          " +
            "       font-family: arial;         " +
        "   }                               ";
        
        let reader = CSSReader(sourceString: cssString as NSString )
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
//        let dotStringVisitor = CSDotStringPreOrderVisitor()
//        
//        dotStringVisitor.process(styleSheet)
//        
//        createDotFile("testCSSParserPseudoClass.dot", content: dotStringVisitor.dotString)
        
    }
    
    
    func testCSSParserHashToken() {
        
        let cssString =
        "   body {                          " +
            "       font-family: arial;         " +
            "   }                               " +
            "   h1 {                            " +
            "       background-color:#CCC;      " +
            "       border: 1px solid;          " +
            "       color:#CCC;                 " +
            "       text-align: center;         " +
            "   }                               " +
            "   table {                         " +
            "       background-color: #CCC;     " +
            "       border: 1px solid #CCC;     " +
            "       width: 100%;                " +
            "   }                               " +
            "   td {                            " +
            "       border: 0px;                " +
            "       text-align: center;         " +
            "   }                               " +
            "   p {                             " +
            "       color:#CCC;                 " +
            "       text-indent: 20px;          " +
        "   }                               "
        
        let reader = CSSReader(sourceString: cssString as NSString )
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
//        let dotStringVisitor = CSDotStringPreOrderVisitor()
//        
//        dotStringVisitor.process(styleSheet)
//        
//        createDotFile("testCSSParserHashTokenFile.dot", content: dotStringVisitor.dotString)
        
    }
    
    func testCSSParser() {

        let cssString =
                "   body {                          " +
                "       font-family: arial;         " +
                "   }                               " +
                "   h1 {                            " +
                "       background-color:#CCC;      " +
                "       border: 1px solid;          " +
                "       color:#39F;                 " +
                "       text-align: center;         " +
                "   }                               " +
                "   table {                         " +
                "       background-color: #F60;     " +
                "       border: 1px solid #39F;     " +
                "       width: 100%;                " +
                "   }                               " +
                "   td {                            " +
                "       border: 0px;                " +
                "       text-align: center;         " +
                "   }                               " +
                "   p {                             " +
                "       color:#09F;                 " +
                "       text-indent: 20px;          " +
                "   }                               "
        
         
        
        
        let reader = CSSReader(sourceString: cssString as NSString )
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
    }

    func testInfiniteLoopWhileParsingProblem() {
        
        let cssString = "markdown-text { font-family: Futura; color: white; }sd"
        
        let reader = CSSReader(sourceString: cssString as NSString )
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
    }
    
}
