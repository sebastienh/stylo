//
//  TokenClassType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-09-10.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public enum TokenClassType: String, CSSDOMAllowedClass {
    
    case CommentToken = "comment-token"
    case IdentToken = "ident-token"
    case FunctionToken = "function-token"
    case AtKeywordToken = "at-keyword-token"
    case HashToken = "hash-token"
    case StringToken = "string-token"
    case BadStringToken = "bad-string-token"
    case UrlToken = "url-token"
    case BadUrlToken = "bad_url-token"
    case DelimToken = "delim-token"
    case NumberToken = "number-token"
    case PercentageToken = "percentage-token"
    case DimensionToken = "dimension-token"
    case EqualMatchToken = "equal-match-token"
    case IncludeMatchToken = "include-match-token"
    case DashMatchToken = "dash-match-token"
    case PrefixMatchToken = "prefix-match-token"
    case SuffixMatchToken = "suffix-match-token"
    case SubstringMatchToken = "substring-match-token"
    case ColumnToken = "column-token"
    case WhitespaceToken = "whitespace-token"
    case CDOToken = "CDO-token"
    case CDCToken = "CDC-token"
    case ColonToken = "colon-token"
    case SemicolonToken = "semicolon-token"
    case CommaToken = "comma-token"
    case LeftSquareBraquetToken = "left-square-bracket-token"
    case RightSquareBraquetToken = "right-square-bracket-token"
    case LeftParenthesisToken = "left-parenthesis-token"
    case RightParenthesisToken = "right-parenthesis-token"
    case LeftCurlyBraceToken = "left-curly-brace-token"
    case RightCurlyBraceToken = "right-curly-brace-token"
    case UnicodeRangeToken = "unicode-range-token"
    case UnexpectedToken = "unexpected-token"
    case SimpleBlockToken = "simple-block"
    case customVariable = "custom-variable"
    case CssEof = "eof"
    case None = ""
    
    static func tokenClassFromTokenId(_ tokenId: CSTokenId) -> TokenClassType {
        
        switch tokenId {
            
        case .commentToken: return TokenClassType.CommentToken
        case .identToken: return TokenClassType.IdentToken
        case .functionToken: return TokenClassType.FunctionToken
        case .atKeywordToken: return TokenClassType.AtKeywordToken
        case .hashToken: return TokenClassType.HashToken
        case .stringToken: return TokenClassType.StringToken
        case .badStringToken: return TokenClassType.BadStringToken
        case .urlToken: return TokenClassType.UrlToken
        case .badUrlToken: return TokenClassType.BadUrlToken
        case .delimToken: return TokenClassType.DelimToken
        case .numberToken: return TokenClassType.NumberToken
        case .percentageToken: return TokenClassType.PercentageToken
        case .dimensionToken: return TokenClassType.DimensionToken
        case .unicodeRangeToken: return TokenClassType.UnicodeRangeToken
        case .includeMatchToken: return TokenClassType.IncludeMatchToken
        case .dashMatchToken: return TokenClassType.DashMatchToken
        case .prefixMatchToken: return TokenClassType.PrefixMatchToken
        case .suffixMatchToken: return TokenClassType.SuffixMatchToken
        case .substringMatchToken: return TokenClassType.SubstringMatchToken
        case .exactMatchToken: return TokenClassType.EqualMatchToken
        case .columnToken: return TokenClassType.ColumnToken
        case .whitespaceToken: return TokenClassType.WhitespaceToken
        case .cdoToken: return TokenClassType.CDOToken
        case .cdcToken: return TokenClassType.CDCToken
        case .colonToken: return TokenClassType.ColonToken
        case .semicolonToken: return TokenClassType.SemicolonToken
        case .commaToken: return TokenClassType.CommaToken
        case .leftSquareBracketToken: return TokenClassType.LeftSquareBraquetToken
        case .rightSquareBracketToken: return TokenClassType.RightSquareBraquetToken
        case .leftParenthesisToken: return TokenClassType.LeftParenthesisToken
        case .rightParenthesisToken: return TokenClassType.RightParenthesisToken
        case .leftCurlyBraceToken: return TokenClassType.LeftCurlyBraceToken
        case .rightCurlyBraceToken: return TokenClassType.RightCurlyBraceToken
        case .cssEof: return TokenClassType.CssEof
            
        }
    }
    
    
    
}
