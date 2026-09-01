//
//  TestCSSScanner.m
//  CSSKit
//
//  Created by Sébastien Hamel on 2014-05-19.
//  Copyright (c) 2014 Constellation. All rights reserved.
//

import Cocoa
import Common
import XCTest
@testable import Web

class TestCSSReaderConvertToNumber: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConvertAStringToANumberSimple() {
        
        
        
        let cssReader = CSSReader(sourceString: "anything we just want to test the method below")
        
        let number = cssReader.convertAStringToANumber("255", type: NumberType.integer)
        
        switch(number.numberType) {
            
        case .integer:
            XCTAssert(number.value == Double(255), "Pass")
            
        case .real:
            XCTAssert(false, "Error")
            
        case .nil:
            XCTAssert(false, "Error")
        }
    }
    
    func testConvertAStringToANumber1() {
    
         
        
        let cssReader = CSSReader(sourceString: "anything we just want to test the method below")
        
        let number = cssReader.convertAStringToANumber("+12.34e+2", type: NumberType.integer)
        
        switch(number.numberType) {
            
        case .integer:
            XCTAssert(number.value == Double(1234), "Pass")
            
        case .real:
            XCTAssert(false, "Error")
            
        case .nil:
            XCTAssert(false, "Error")
        }
    }

    func testConvertAStringToANumber2() {
        
        let cssReader = CSSReader(sourceString: "anything we just want to test the method below")
        
        let number = cssReader.convertAStringToANumber("12.34", type: NumberType.real)
        
        switch(number.numberType) {
            
        case .integer:
            XCTAssert(false, "Error")
            
        case .real:
            XCTAssert(number.value == Double(12.34), "Pass")
            
        case .nil:
            XCTAssert(false, "Error")
        }
    }
    
    func testConvertAStringToANumber3() {
        
         
        
        let cssReader = CSSReader(sourceString: "anything we just want to test the method below")
        
        let number = cssReader.convertAStringToANumber("12.34e2", type: NumberType.real)
        
        switch(number.numberType) {
            
        case .integer:
            XCTAssert(false, "Error")
            
        case .real:
            XCTAssert(number.value == Double(1234), "Pass")
            
        case .nil:
            XCTAssert(false, "Error")
        }
    }

    func testConvertAStringToANumber4() {
        
         
        
        let cssReader = CSSReader(sourceString: "anything we just want to test the method below")
        
        let number = cssReader.convertAStringToANumber("12.34e-3", type: NumberType.real)
        
        switch(number.numberType) {
            
        case .integer:
            XCTAssert(false, "Error")
            
        case .real:
            XCTAssert(number.value == Double(0.01234), "Pass")
            
        case .nil:
            XCTAssert(false, "Error")
        }
    }
    
    
    func testConvertAStringToANumber5() {
        
         
        
        let cssReader = CSSReader(sourceString: "anything we just want to test the method below")
        
        let number = cssReader.convertAStringToANumber("12.34e+3", type: NumberType.real)
        
        switch(number.numberType) {
            
        case .integer:
            XCTAssert(false, "Error")
            
        case .real:
            XCTAssert(number.value == Double(12340), "Pass")
        
        case .nil:
            XCTAssert(false, "Error")
        }
    }
    
}







//// START :  U+002A ASTERISK (*)
//- (void) testSubstringMatchToken {
//    Constellation::CSSScanner scanner(u"*=");
//    
//    // this time we should receive a whitespace token
//    Constellation::Token* token = scanner.consumeAToken();
//    
//    assert(token->getTokenId() == Constellation::CSSTokenId::SubstringMatchToken);
//    
//}
//
//
//// START :  U+002C COMMA (,)
//- (void) testComma {
//    Constellation::CSSScanner scanner(u",");
//    
//    // this time we should receive a whitespace token
//    Constellation::Token* token = scanner.consumeAToken();
//    
//    assert(token->getTokenId() == Constellation::CSSTokenId::CommaToken);
//
//}
//
//

//
//// START : U+002B PLUS SIGN (+)
//- (void) testPlusSign {
//    Constellation::CSSScanner scanner(u"+12.34e1");
//    
//    // this time we should receive a whitespace token
//    Constellation::Token* token = scanner.consumeAToken();
//    
//    assert(token->getTokenId() == Constellation::CSSTokenId::NumberToken);
//    
//    Constellation::NumberToken* numberToken = (Constellation::NumberToken*) token;
//    
//    Number* number = numberToken->getNumber();
//    assert(number->type == NumericTypeNumber);
//    union NumberData numberData;
//    numberData.d = 123.4;
//    assert(number->data.d == numberData.d);
//    assert(token->getLength() == 8);
//}
//

//
//// START : U+002B PLUS SIGN (+)
//- (void) testPlusSign2 {
//    Constellation::CSSScanner scanner(u"+12.34e-2");
//    
//    // this time we should receive a whitespace token
//    Constellation::Token* token = scanner.consumeAToken();
//    
//    assert(token->getTokenId() == Constellation::CSSTokenId::NumberToken);
//    
//    Constellation::NumberToken* numberToken = (Constellation::NumberToken*) token;
//    
//    Number* number = numberToken->getNumber();
//    assert(number->type == NumericTypeNumber);
//    union NumberData numberData;
//    numberData.d = 0.1234;
//    assert(number->data.d == numberData.d);
//    assert(token->getLength() == 9);
//}
//
//
//// START : U+0024 DOLLAR SIGN ($)
//- (void) testDollarSign {
//    Constellation::CSSScanner scanner(u"$=");
//    
//    // this time we should receive a whitespace token
//    Constellation::Token* token = scanner.consumeAToken();
//    
//    assert(token->getTokenId() == Constellation::CSSTokenId::SuffixMatchToken);
//    assert(token->getLength() == 2);
//    Constellation::Range range = token->getRange();
//    
//    assert(range.length == 2);
//    assert(range.location == 0);
//}
//
//- (void)testConsumeNumberSign
//{
//    Constellation::CSSScanner scanner(u"#numbersign");
//    
//    // this time we should receive a whitespace token
//    Constellation::Token* token = scanner.consumeAToken();
//    
//    assert(token->getTokenId() == Constellation::CSSTokenId::HashToken);
//    assert(token->getLength() == 11);
//    assert(token->getFormattedStringValue() == u"numbersign");
//
//}
//
//- (void)testConsumeNumberSignWithEscapedCodePoint
//{
//    Constellation::CSSScanner scanner(u"#n\\003434umbersign");
//    
//    // this time we should receive a whitespace token
//    Constellation::HashToken* token = (Constellation::HashToken*)scanner.consumeAToken();
//    
//    assert(token->getTokenId() == Constellation::CSSTokenId::HashToken);
//    assert(token->getLength() == 18);
//    assert(token->getFormattedStringValue() == u"n㐴umbersign");
//    assert(token->getType() == u"id");
//}
//
//- (void)testConsumeACommentToken
//{
//    Constellation::CSSScanner scanner(u"/*  spmehting that will be removed by comments consuming code     */ ");
//    
//    Constellation::Scanner accessScanner = (Constellation::Scanner)scanner;
//    
//    Constellation::Token* token = scanner.consumeAToken();
//    assert(token->getTokenId() == Constellation::CSSTokenId::CommentToken);
//    
//    
//}
//
//
//- (void)testConsumeWhitespacesToken
//{
//    Constellation::CSSScanner scanner(u"/*  */  A string");
//    
//    Constellation::Token* token = scanner.consumeAToken();
//    assert(token->getTokenId() == Constellation::CSSTokenId::CommentToken);
//    assert(token->getLength() == 6);
//    
//    // this time we should receive a whitespace token
//    token = scanner.consumeAToken();
//    assert(token->getTokenId() == Constellation::CSSTokenId::WhitespaceToken);
//    assert(token->getLength() == 2);
//    
//    Constellation::Scanner accessScanner = (Constellation::Scanner)scanner;
//    
//    char16_t codePoint =  accessScanner.consumeNextInputCodePoint();
//    
//    assert(codePoint == 0x0041);
//}
//
//- (void)testConsumeWhitespacesTokenAndString
//{
//    Constellation::CSSScanner scanner(u"/**/                    \u0022A string\u0022 ");
//    
//    Constellation::Token* token = scanner.consumeAToken();
//    assert(token->getTokenId() == Constellation::CSSTokenId::CommentToken);
//    assert(token->getLength() == 4);
//    
//    // this time we should receive a whitespace token
//    token = scanner.consumeAToken();
//    
//    assert(token->getTokenId() == Constellation::CSSTokenId::WhitespaceToken);
//    assert(token->getLength() == 20);
//    
//    Constellation::Scanner accessScanner = (Constellation::Scanner)scanner;
//    
//    char16_t codePoint =  accessScanner.consumeNextInputCodePoint();
//    
//    assert(codePoint == 0x0022);
//    
//    token = scanner.consumeAToken();
//    
//    assert(token->getTokenId() == Constellation::CSSTokenId::StringToken);
//    assert(token->getLength() == 10);
//    assert(token->getFormattedStringValue() == u"A string");
//    
//    token = scanner.consumeAToken();
//    assert(token->getTokenId() == Constellation::CSSTokenId::WhitespaceToken);
//}
//
//- (void)testConsumeWhitespacesTokenAndStringWithEscapedUnicoePoint
//{
//    Constellation::CSSScanner scanner(u"/**/                    \u0022A string\\003434\u0022  ");
//    
//    Constellation::Token* token = scanner.consumeAToken();
//    assert(token->getTokenId() == Constellation::CSSTokenId::CommentToken);
//    assert(token->getLength() == 4);
//    
//    // this time we should receive a whitespace token
//    token = scanner.consumeAToken();
//    
//    assert(token->getTokenId() == Constellation::CSSTokenId::WhitespaceToken);
//    assert(token->getLength() == 20);
//    
//    Constellation::Scanner accessScanner = (Constellation::Scanner)scanner;
//    
//    char16_t codePoint =  accessScanner.consumeNextInputCodePoint();
//    
//    assert(codePoint == 0x0022);
//    
//    token = scanner.consumeAToken();
//    
//    assert(token->getTokenId() == Constellation::CSSTokenId::StringToken);
//    assert(token->getLength() == 17);
//    assert(token->getFormattedStringValue() == u"A string㐴");
//
//    // FALSE : we should not have whitespace at the end according to the
//    // algorythm :
//    // "If the next input code point is whitespace, consume it as well."
//    // see http://dev.w3.org/csswg/css-syntax/#consume-an-escaped-code-point
//    
//    // but with two spaces we should have a whitespace token returned.
//    token = scanner.consumeAToken();
//    assert(token->getTokenId() == Constellation::CSSTokenId::WhitespaceToken);
//    
//    // we basically understand that two conditions can terminate an escaped code point
//    // 1. a whitespace
//    // 2. reaching the maximum length allowed for a code point (which is 6)
//    
//}
//
//@end
