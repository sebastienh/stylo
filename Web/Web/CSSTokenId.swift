//
//  CSTokenId.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-02.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

enum CSTokenId: Int, CustomStringConvertible {

    case commentToken                                        // internal comment token
    case identToken                                          // <ident-token>                               x
    case functionToken                                       // <function-token>                            x
    case atKeywordToken                                      // <at-keyword-token>                          -
    case hashToken                                           // <hash-token>                                x
    case stringToken                                         // <string-token>                              x
    case badStringToken                                      // <bad-string-token>                          x
    case urlToken                                            // <url-token>                                 x
    case badUrlToken                                         // <bad-url-token>                             x
    case delimToken                                          // <delim-token>
    case numberToken                                         // <number-token>                              x
    case percentageToken                                     // <percentage-token>                          x
    case dimensionToken                                      // <dimension-token>                           x
    case unicodeRangeToken                                   // <unicode-range-token>                       x
    case includeMatchToken                                   // <include-match-token>                       x
    case dashMatchToken                                      // <dash-match-token>                          x
    case prefixMatchToken                                    // <prefix-match-token>                        x
    case suffixMatchToken                                    // <suffix-match-token>                        x
    case substringMatchToken                                 // <substring-match-token>                     x
    case exactMatchToken                                     // <exact-match-token> : added by me           x
    case columnToken                                         // <column-token>                              
    case whitespaceToken                                     // <whitespace-token>                          x
    case cdoToken                                            // <CDO-token>                                 x
    case cdcToken                                            // <CDC-token>                                 x
    case colonToken                                          // <colon-token>                               x
    case semicolonToken                                      // <semicolon-token>                           x
    case commaToken                                          // <comma-token>                               x
    case leftSquareBracketToken                              // <[-token>                                   x
    case rightSquareBracketToken                             // <]-token>                                   x
    case leftParenthesisToken                                // <(-token>
    case rightParenthesisToken                               // <)-token>                                   x
    case leftCurlyBraceToken                                 // <{-token>                                   x
    case rightCurlyBraceToken                                // <}-token>                                   x
    case cssEof = 255                                        // END OF CSS                                  x
    
    var description : String {
        switch(self) {
        case .commentToken: return "commentToken"
        case .identToken: return "identToken"
        case .functionToken: return "functionToken"
        case .atKeywordToken: return "atKeywordToken"
        case .hashToken: return "hashToken"
        case .stringToken: return "stringToken"
        case .badStringToken: return "badStringToken"
        case .urlToken: return "urlToken"
        case .badUrlToken: return "badUrlToken"
        case .delimToken: return "delimToken"
        case .numberToken: return "numberToken"
        case .percentageToken: return "percentageToken"
        case .dimensionToken: return "dimensionToken"
        case .unicodeRangeToken: return "unicodeRangeToken"
        case .includeMatchToken: return "includeMatchToken"
        case .dashMatchToken: return "dashMatchToken"
        case .prefixMatchToken: return "prefixMatchToken"
        case .suffixMatchToken: return "suffixMatchToken"
        case .substringMatchToken: return "substringMatchToken"
        case .exactMatchToken: return "exactMatchToken"
        case .columnToken: return "columnToken"
        case .whitespaceToken: return "whitespaceToken"
        case .cdoToken: return "cdoToken"
        case .cdcToken: return "cdcToken"
        case .colonToken: return "colonToken"
        case .semicolonToken: return "semicolonToken"
        case .commaToken: return "commaToken"
        case .leftSquareBracketToken: return "leftSquareBracketToken"
        case .rightSquareBracketToken: return "rightSquareBracketToken"
        case .leftParenthesisToken: return "leftParenthesisToken"
        case .rightParenthesisToken: return "rightParenthesisToken"
        case .leftCurlyBraceToken: return "leftCurlyBraceToken"
        case .rightCurlyBraceToken: return "rightCurlyBraceToken"
        case .cssEof: return "cssEof"
        }
    }
    
}
