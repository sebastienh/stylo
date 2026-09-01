//
//  UnicodeCharacter.swift
//  CommonStylo
//
//  Created by Sébastien Hamel on 2015-02-22.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public enum UnicodeCharacter: UniChar {
    case    null                    = 0x00
    case    endOfText               = 0x03
    case    backspace               = 0x08
    case    characterTabulation     = 0x09
    case    lineFeed                = 0x0a
    case    lineTabulation          = 0x0b
    case    formFeed                = 0x0c
    case    carriageReturn          = 0x0d
    case    shift                   = 0x0e
    case    informationSeparatorOne = 0x1f
    case    whitespace              = 0x20
    case    exclamationMark         = 0x21
    case    quotationMark           = 0x22
    case    quotationMarkV2         = 0x201c
    case    numberSign              = 0x23
    case    dollarSign              = 0x24
    case    percentageSign          = 0x25
    case    ampersand               = 0x26
    case    apostrophe              = 0x27
    case    leftParenthesis         = 0x28
    case    rightParenthesis        = 0x29
    case    asterisk                = 0x2a
    case    plusSign                = 0x2b
    case    comma                   = 0x2c
    case    hyphenMinus             = 0x2d
    case    fullStop                = 0x2e
    case    solidus                 = 0x2f
    case    zero                    = 0x30
    case    one                     = 0x31
    case    two                     = 0x32
    case    three                   = 0x33
    case    four                    = 0x34
    case    five                    = 0x35
    case    six                     = 0x36
    case    seven                   = 0x37
    case    height                  = 0x38
    case    nine                    = 0x39
    case    colon                   = 0x3a
    case    semiColon               = 0x3b
    case    lessThanSign            = 0x3c
    case    equalsSign              = 0x3d
    case    greaterThanSign         = 0x3e
    case    questionMark            = 0x3f
    case    commercialAt            = 0x40
    case    latinCapitalLetterE     = 0x45
    case    latinCapitalLetterF     = 0x46
    case    leftSquareBracket       = 0x5b
    case    reverseSolidus          = 0x5c
    case    rightSquareBracket      = 0x5d
    case    circumflexAccent        = 0x5e
    case    lowLine                 = 0x5f
    case    graveAccent             = 0x60
    case    latinSmallLetterE       = 0x65
    case    leftCurlyBracket        = 0x7b
    case    verticalLine            = 0x7c
    case    rightCurlyBracket       = 0x7d
    case    tilde                   = 0x7e
    case    delete                  = 0x7f
    case    replacementCharacter    = 0xfffd
    
    
    public static func mirrorVariantCharacter(_ uniChar: UniChar) -> UniChar? {
        
        switch uniChar {
            
        case §leftSquareBracket:
            return §rightSquareBracket
            
        case §leftCurlyBracket:
            return §rightCurlyBracket
            
        case §leftParenthesis:
            return §rightParenthesis
            
        case §quotationMark:
            return §quotationMark
            
        case §apostrophe:
            return §apostrophe
            
        case §lessThanSign:
            return §greaterThanSign
            
        case §colon:
            return §semiColon
            
        default:
            return nil
        }
    }
    
    public func descriptionString() -> String {
        
        switch self {
            
        case    .null: return ""
        case    .endOfText: return "end-of-text"
        case    .characterTabulation: return "character-tabulation"
        case    .backspace: return "backspace"
        case    .lineFeed: return "line-feed"
        case    .lineTabulation: return "line-tabulation"
        case    .formFeed: return "form-feed"
        case    .carriageReturn: return "carriage-return"
        case    .shift: return "shift"
        case    .informationSeparatorOne: return "information-separator-one"
        case    .whitespace: return "whitespace"
        case    .exclamationMark: return "exclamation-mark"
        case    .quotationMark: return "quotation-mark"
        case    .quotationMarkV2: return "quotationMarkV2"
        case    .numberSign: return "number-sign"
        case    .dollarSign: return "dollar-sign"
        case    .percentageSign: return "percentage-sign"
        case    .apostrophe: return "apostrophe"
        case    .leftParenthesis: return "left-parenthesis"
        case    .rightParenthesis: return "right-parenthesis"
        case    .asterisk: return "asterisk"
        case    .plusSign: return "plus-sign"
        case    .comma: return "comma"
        case    .hyphenMinus: return "hyphen-minus"
        case    .fullStop: return "full-stop"
        case    .solidus: return "solidus"
        case    .zero: return "zero"
        case    .one: return "one"
        case    .two: return "two"
        case    .three: return "three"
        case    .four: return "four"
        case    .five: return "five"
        case    .six: return "six"
        case    .seven: return "seven"
        case    .height: return "height"
        case    .nine: return "nine"
        case    .colon: return "colon"
        case    .semiColon: return "semi-colon"
        case    .lessThanSign: return "less-than-sign"
        case    .equalsSign: return "equals-sign"
        case    .greaterThanSign: return "greather-than-sign"
        case    .questionMark: return "question-mark"
        case    .commercialAt: return "commercial-at"
        case    .latinCapitalLetterE: return "latin-capital-letter-e"
        case    .latinCapitalLetterF: return "latin-capiatal-letter-f"
        case    .leftSquareBracket: return "left-square-bracket"
        case    .reverseSolidus: return "reverse-solidus"
        case    .rightSquareBracket: return "right-square-bracket"
        case    .circumflexAccent: return "circumflex-accent"
        case    .lowLine: return "low-line"
        case    .latinSmallLetterE: return "latin-small-letter-e"
        case    .leftCurlyBracket: return "left-curly-bracket"
        case    .verticalLine: return "vertical-line"
        case    .rightCurlyBracket: return "right-curly-bracket"
        case    .tilde: return "tilde"
        case    .delete: return "delete"
        case    .replacementCharacter: return "replacement-character"
        case    .ampersand: return "&"
        case    .graveAccent: return "`"
        }
    }
    
}
