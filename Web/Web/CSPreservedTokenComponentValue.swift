//
//  PreservedTokenComponentValue.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-30.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

final class CSPreservedTokenComponentValue: CSComponentValue, CSTokenIdContainer, CSValueHolder {
    
    static let emptyStringComponentValue = CSPreservedTokenComponentValue(value: CSSToken(tokenId: §CSTokenId.stringToken, rawStringValue: ""))
    
    typealias ValueType = Token
    
    var value: Token
    
    override var isWhitespace: Bool {
        
        if self.isTokenId(§CSTokenId.whitespaceToken) {
            return true
        }
        return false
    }
    
    var rawStringValue: String {
        return value.rawStringValue
    }
    
    var formattedStringValue: String? {
        return value.formattedStringValue
    }
    
    var stringRepresentation: String {
        return value.stringRepresentation
    }
    
    init(value: Token) {
        self.value = value
        super.init(sourceStringSegment: value.sourceStringSegment)
        self.messageHandler = value.messageHandler
    }
    
    override func clone() -> CSPreservedTokenComponentValue {
        
        let clone = CSPreservedTokenComponentValue(value: value)
        clone.messageHandler = self.messageHandler
        assert(self.equals(to: clone, comparePositions: true))
        return clone
    }
    
    override func isTokenId(_ tokenId: Int) -> Bool {
     
        if self.value.tokenId == tokenId {
            return true
        }
        return false 
    }
    
    override func cssText() -> DOMString {
        
        return DOMString(value.rawStringValue)
    }
    
    func associatedTokenClass() -> TokenClassType {
        
        switch self.value.tokenId {

        case §CSTokenId.atKeywordToken:
        
            return TokenClassType.AtKeywordToken
        
        case §CSTokenId.badStringToken:
        
            return TokenClassType.BadStringToken
        
        case §CSTokenId.badUrlToken:
        
            return TokenClassType.BadUrlToken
        
        case §CSTokenId.cdcToken:
        
            return TokenClassType.CDCToken
        
        case §CSTokenId.cdoToken:
        
            return TokenClassType.AtKeywordToken
        
        case §CSTokenId.colonToken:
        
            return TokenClassType.AtKeywordToken
        
        case §CSTokenId.columnToken:
        
            return TokenClassType.ColumnToken
        
        case §CSTokenId.commaToken:
        
            return TokenClassType.CommaToken
        
        case §CSTokenId.commentToken:
        
            return TokenClassType.CommentToken
        
        case §CSTokenId.cssEof:
        
            return TokenClassType.CssEof
        
        case §CSTokenId.dashMatchToken:
        
            return TokenClassType.DashMatchToken
        
        case §CSTokenId.delimToken:
        
            return TokenClassType.DelimToken
        
        case §CSTokenId.dimensionToken:
        
            return TokenClassType.DimensionToken
        
        case §CSTokenId.exactMatchToken:
        
            return TokenClassType.EqualMatchToken
        
        case §CSTokenId.functionToken:
        
            return TokenClassType.FunctionToken
        
        case §CSTokenId.hashToken:
        
            return TokenClassType.HashToken
        
        case §CSTokenId.identToken:
        
            return TokenClassType.IdentToken
        
        case §CSTokenId.includeMatchToken:
        
            return TokenClassType.IncludeMatchToken
        
        case §CSTokenId.leftCurlyBraceToken:
        
            return TokenClassType.LeftCurlyBraceToken
        
        case §CSTokenId.leftParenthesisToken:
        
            return TokenClassType.LeftParenthesisToken
        
        case §CSTokenId.leftSquareBracketToken:
        
            return TokenClassType.LeftSquareBraquetToken
        
        case §CSTokenId.numberToken:
        
            return TokenClassType.NumberToken
        
        case §CSTokenId.percentageToken:
        
            return TokenClassType.PercentageToken
        
        case §CSTokenId.prefixMatchToken:
        
            return TokenClassType.AtKeywordToken
        
        case §CSTokenId.rightCurlyBraceToken:
        
            return TokenClassType.RightCurlyBraceToken
        
        case §CSTokenId.rightParenthesisToken:
        
            return TokenClassType.RightParenthesisToken
        
        case §CSTokenId.rightSquareBracketToken:
        
            return TokenClassType.RightSquareBraquetToken
        
        case §CSTokenId.semicolonToken:
        
            return TokenClassType.SemicolonToken
        
        case §CSTokenId.stringToken:
        
            return TokenClassType.StringToken
        
        case §CSTokenId.substringMatchToken:
        
            return TokenClassType.SubstringMatchToken
        
        case §CSTokenId.suffixMatchToken:
        
            return TokenClassType.SuffixMatchToken
        
        case §CSTokenId.unicodeRangeToken:
        
            return TokenClassType.UnicodeRangeToken
        
        case §CSTokenId.urlToken:
        
            return TokenClassType.UrlToken
        
        case §CSTokenId.whitespaceToken:
        
            return TokenClassType.WhitespaceToken
        
        default:
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("ERROR: THIS METHOD SHOULD NOT BE CALLED!!!", log: Log.Web.all, type: .fault)
            #endif
            return TokenClassType.None
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public override func move(_ count: Int) {
     
        self.sourceStringSegment?.move(count)
        self.value.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? CSPreservedTokenComponentValue {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if !self.value.equals(to: other.value, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: value are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CSPreservedTokenComponentValue.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other is nil.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        return true
    }

}

extension CSPreservedTokenComponentValue : DotStringNode {
    
    func dotString(_ nodeName: String) -> String {
        
        return "\(nodeName) [shape=record, label=\"CSPreservedTokenComponentValue: \(value)\"];\n"
    }
}






