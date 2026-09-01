//
//  TestCSSReader.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-08.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Cocoa
import Common
import XCTest
@testable import Web

class TestCSSReader: XCTestCase {

    func testSimpleCSS() {
        
        let cssReader = CSSReader(sourceString: "body { font-family: arial; } h1 { background-color:#CCC; border: 1px solid; color:#39F; text-align: center; }table { background-color: #F60; border: 1px solid #39F; width: 100%; } td { border: 0px; text-align: center; } p { color:#09F; text-indent: 20px; } "
            )
        
        var lastIndex: Int = 0
        var token: Token
        
        while(true) {
            
            token = cssReader.scan(lastIndex)
            
            lastIndex = token.sourceStringSegment!.endIndex
            
            if token.tokenId == §CSTokenId.cssEof {
                break
            }
            
            print("TokenId : \(token)")
        }
    }
    
    
    func testSimpleQualifiedCSSRule() {
        
        let cssString =
        "body {\n" +
        "   font-family:arial;\n" +
        "}"
        
        let cssReader = CSSReader(sourceString: cssString as NSString)
        
        var lastIndex: Int = 0
        var token: Token
        
        while(true) {
            
            token = cssReader.scan(lastIndex)
            
            lastIndex = token.sourceStringSegment!.endIndex
            
            if token.tokenId == §CSTokenId.cssEof {
                break
            }
            
            print("TokenId : \(token)")
        }
    }

    func testSimpleNonComments() {
        
        let cssString = """
            /
            body {
                font-family:arial;
            }
        """
        
        let tokenIds = buildTokenIds(from: cssString)
        
        let expected = [
            CSTokenId.whitespaceToken,
            CSTokenId.delimToken,
            CSTokenId.whitespaceToken,
            CSTokenId.identToken,
            CSTokenId.whitespaceToken,
            CSTokenId.leftCurlyBraceToken,
            CSTokenId.whitespaceToken,
            CSTokenId.identToken,
            CSTokenId.colonToken,
            CSTokenId.identToken,
            CSTokenId.semicolonToken,
            CSTokenId.whitespaceToken,
            CSTokenId.rightCurlyBraceToken,
        ]
        
        XCTAssert(expected == tokenIds)
    }
    
    func testSimpleCustomProperty() {

        let cssString = """
            :root {
                --my-color: rgb(123,48,23);
            }
        """

        let tokenIds = buildTokenIds(from: cssString)

        let expected: [CSTokenId] = [
            .whitespaceToken,
            .colonToken,
            .identToken,
            .whitespaceToken,
            .leftCurlyBraceToken,
            .whitespaceToken,
            .identToken,
            .colonToken,
            .whitespaceToken,
            .functionToken,
            .numberToken,
            .commaToken,
            .numberToken,
            .commaToken,
            .numberToken,
            .rightParenthesisToken,
            .semicolonToken,
            .whitespaceToken,
            .rightCurlyBraceToken
        ]

        print("tokenIds: \(tokenIds)")
        
        XCTAssert(expected == tokenIds)
    }

    /// color: var(--main-color-1, var(--main-color));
    func testFunctionInsideFunction() {

        let cssString = """
            :root {
                color: var(--main-color-1, var(--main-color));
            }
        """

        let tokenIds = buildTokenIds(from: cssString)

        let expected: [CSTokenId] = [
            .whitespaceToken,
            .colonToken,
            .identToken,
            .whitespaceToken,
            .leftCurlyBraceToken,
            .whitespaceToken,
            .identToken,
            .colonToken,
            .whitespaceToken,
            .functionToken,
            .identToken,
            .commaToken,
            .whitespaceToken,
            .functionToken,
            .identToken,
            .rightParenthesisToken,
            .rightParenthesisToken,
            .semicolonToken,
            .whitespaceToken,
            .rightCurlyBraceToken
        ]

        print("tokenIds: \(tokenIds)")
        
        XCTAssert(expected == tokenIds)
    }
    
    
    func testSimpleCustomPropertyWithVar() {

        let cssString = """
            :root {
                --my-color: var(--variable);
            }
        """

        let tokenIds = buildTokenIds(from: cssString)

        let expected: [CSTokenId] = [
            .whitespaceToken,
            .colonToken,
            .identToken,
            .whitespaceToken,
            .leftCurlyBraceToken,
            .whitespaceToken,
            .identToken,
            .colonToken,
            .whitespaceToken,
            .functionToken,
            .identToken,
            .rightParenthesisToken,
            .semicolonToken,
            .whitespaceToken,
            .rightCurlyBraceToken
        ]

        print("tokenIds: \(tokenIds)")
        
        XCTAssert(expected == tokenIds)
    }
    
    
    
    
    func testSimpleCustomPropertyWithVarAndDefault() {

        let cssString = """
            :root {
                --my-color: var(--variable, red, blue);
            }
        """

        let tokenIds = buildTokenIds(from: cssString)

        let expected: [CSTokenId] = [
            .whitespaceToken,
            .colonToken,
            .identToken,
            .whitespaceToken,
            .leftCurlyBraceToken,
            .whitespaceToken,
            .identToken,
            .colonToken,
            .whitespaceToken,
            .functionToken,
            .identToken,
            .commaToken,
            .whitespaceToken,
            .identToken,
            .commaToken,
            .whitespaceToken,
            .identToken,
            .rightParenthesisToken,
            .semicolonToken,
            .whitespaceToken,
            .rightCurlyBraceToken
        ]

        print("tokenIds: \(tokenIds)")
        
        XCTAssert(expected == tokenIds)
    }
    
    func testSimpleCustomEmptyProperty() {

        let cssString = """
            :root {
                --my-color: "";
            }
        """

        let tokenIds = buildTokenIds(from: cssString)

        let expected: [CSTokenId] = [
            .whitespaceToken,
            .colonToken,
            .identToken,
            .whitespaceToken,
            .leftCurlyBraceToken,
            .whitespaceToken,
            .identToken,
            .colonToken,
            .whitespaceToken,
            .stringToken,
            .semicolonToken,
            .whitespaceToken,
            .rightCurlyBraceToken
        ]

        print("tokenIds: \(tokenIds)")
        
        XCTAssert(expected == tokenIds)
    }
    
    func testSimpleNonComments2() {
        
        let cssString = """
            //
            body {
                font-family:arial;
            }
        """
        
        let tokenIds = buildTokenIds(from: cssString)
        
        let expected = [
            CSTokenId.whitespaceToken,
            CSTokenId.delimToken,
            CSTokenId.delimToken,
            CSTokenId.whitespaceToken,
            CSTokenId.identToken,
            CSTokenId.whitespaceToken,
            CSTokenId.leftCurlyBraceToken,
            CSTokenId.whitespaceToken,
            CSTokenId.identToken,
            CSTokenId.colonToken,
            CSTokenId.identToken,
            CSTokenId.semicolonToken,
            CSTokenId.whitespaceToken,
            CSTokenId.rightCurlyBraceToken,
            ]
        
        XCTAssert(expected == tokenIds)
    }
    
    func testSimpleComments1() {
        
        let cssString = """
            //*
            body {
                font-family:arial;
            }
        """
        
        let tokenIds = buildTokenIds(from: cssString)
        
        // the comment is not sent as a token
        let expected = [
            CSTokenId.whitespaceToken,
            CSTokenId.delimToken,
            ]
        
        XCTAssert(expected == tokenIds)
    }
    
    func testSimpleNonComments4() {
        
        let cssString = """
            ///
            body {
                font-family:arial;
            }
        """
        
        let tokenIds = buildTokenIds(from: cssString)
        
        let expected = [
            CSTokenId.whitespaceToken,
            CSTokenId.delimToken,
            CSTokenId.delimToken,
            CSTokenId.delimToken,
            CSTokenId.whitespaceToken,
            CSTokenId.identToken,
            CSTokenId.whitespaceToken,
            CSTokenId.leftCurlyBraceToken,
            CSTokenId.whitespaceToken,
            CSTokenId.identToken,
            CSTokenId.colonToken,
            CSTokenId.identToken,
            CSTokenId.semicolonToken,
            CSTokenId.whitespaceToken,
            CSTokenId.rightCurlyBraceToken,
            ]
        
        XCTAssert(expected == tokenIds)
    }
    
    func testSimpleComments2() {
        
        let cssString = """
            //*
            body {
                font-family:arial;
            }*/
        """
        
        let tokenIds = buildTokenIds(from: cssString)
        
        // the comment is not sent as a token
        let expected = [
            CSTokenId.whitespaceToken,
            CSTokenId.delimToken,
            ]
        
        XCTAssert(expected == tokenIds)
    }
    
    private func buildTokenIds(from string: String) -> [CSTokenId] {
        
        var tokenIds = [CSTokenId]()
        
        let cssReader = CSSReader(sourceString: string as NSString)
        
        var lastIndex: Int = 0
        var token: Token
        
        while(true) {
            
            token = cssReader.scan(lastIndex)
            
            lastIndex = token.sourceStringSegment!.endIndex
            
            if token.tokenId == §CSTokenId.cssEof {
                break
            }
            
            let tokenId = CSTokenId(rawValue: token.tokenId)!
            tokenIds.append(tokenId)
            
            print("TokenId : \(String(describing: CSTokenId(rawValue: token.tokenId)))")
        }
        return tokenIds
    }
    
}
