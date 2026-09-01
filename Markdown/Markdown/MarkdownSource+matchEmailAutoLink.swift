//
//  String+matchEmailAutoLink.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-17.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

private let userNameAllowedCodePoint = "abcdefghijklmnopqrstuvwxyzzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.!#$%&'*+/=?^_`{|}~-"

private let hostNameAllowedCodePoint = "abcdefghijklmnopqrstuvwxyzzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

private let domainNameAllowedCodePoint = "abcdefghijklmnopqrstuvwxyzzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

private enum EmailPart {
    
    case prelude
    case userName
    case hostName
    case domain
}

extension MarkdownSource {
    
    /// Try to match email autolink including first <, returning num of chars matched.
    ///
    /// js re: 
    /// 1. /^<([a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+
    /// 2. @
    /// 3. [a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*)>
    //
    /// Note: The emailString include the start and end less and greater than signs.
    func matchEmailAutolink(fromPosition position: Int = 0) -> [Match]? {
        
        var i = position
        var part: EmailPart = .prelude
        var lastCharacterWasHyphenMinus: Bool = false
        var userNamePartLength: Int = 0
        var hostNamePartLength: Int = 0
        var domainPartLength: Int = 0
        
        while i < length {
            
            let c = charAt(i)!
            
            switch part {
                
            case .prelude:
                
                if i == position && c != 0x3c /* §UnicodeCharacter.lessThanSign */ {
                    
                    return nil
                }
                else {
                    
                    part = .userName
                }
                
            case .userName:
                
                if c == §UnicodeCharacter.commercialAt {
                    
                    // we must make sure we have at least two characters
                    // including the first less than sign:
                    // <([a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+
                    if userNamePartLength < 1 {
                        
                        return nil
                    }
                    else {
                        
                        part = .hostName
                    }
                }
                else {
                    
                    if !userNameAllowedCodePoint.utf16.contains(c) {
                        
                        return nil
                    }
                    
                    userNamePartLength += 1
                }
                
            case .hostName:
                
                // [a-zA-Z0-9]
                if hostNamePartLength == 0 {
                    
                    if !UnicodeLetter.isUnicodeLetter(c) && !UnicodeDigit.isUnicodeDigit(c) {
                        
                        return nil
                    }
                }
                // [a-zA-Z0-9-]{0,61}[a-zA-Z0-9]
                else if hostNamePartLength > 0 && hostNamePartLength < 64 {
                
                    if !UnicodeLetter.isUnicodeLetter(c)
                        && !UnicodeDigit.isUnicodeDigit(c)
                        && 0x2d /* §UnicodeCharacter.hyphenMinus */ != c
                        && 0x2e /* §UnicodeCharacter.fullStop */ != c
                        && 0x3e /* §UnicodeCharacter.greaterThanSign */ != c {
                        
                        return nil
                    }
                    
                    if 0x2d /* §UnicodeCharacter.hyphenMinus */ == c {
                        
                        lastCharacterWasHyphenMinus = true
                    }
                    else if UnicodeLetter.isUnicodeLetter(c) || UnicodeDigit.isUnicodeDigit(c) {
                        
                        lastCharacterWasHyphenMinus = false
                    }
                    else if 0x2e /* §UnicodeCharacter.fullStop */ == c {
                        
                        if lastCharacterWasHyphenMinus {
                            
                            return nil
                        }
                        else {
                            
                            lastCharacterWasHyphenMinus = false
                            part = .domain
                        }
                    }
                    else if 0x3e /* §UnicodeCharacter.greaterThanSign */ == c {
                        
                        return [Match(start: position, end: i + 1)]
                    }
                }
                else {
                    
                    return nil
                }
                
                hostNamePartLength += 1
                
            case .domain:
                
                // [a-zA-Z0-9]
                if domainPartLength == 0 {
                    
                    if !UnicodeLetter.isUnicodeLetter(c) && !UnicodeDigit.isUnicodeDigit(c) {
                        
                        return nil
                    }
                }
                    // [a-zA-Z0-9-]{0,61}[a-zA-Z0-9]
                else if hostNamePartLength > 0 && hostNamePartLength < 64 {
                
                    if !UnicodeLetter.isUnicodeLetter(c)
                        && !UnicodeDigit.isUnicodeDigit(c)
                        && 0x2d /* §UnicodeCharacter.hyphenMinus */ != c
                        && 0x2e /* §UnicodeCharacter.fullStop */ != c
                        && 0x3e /* §UnicodeCharacter.greaterThanSign */ != c {
                    
                        return nil
                    }
                
                    if 0x2d /* §UnicodeCharacter.hyphenMinus */ == c {
                    
                        lastCharacterWasHyphenMinus = true
                    }
                    else if UnicodeLetter.isUnicodeLetter(c) || UnicodeDigit.isUnicodeDigit(c) {
                    
                        lastCharacterWasHyphenMinus = false
                    }
                    else if 0x2e /* §UnicodeCharacter.fullStop */ == c {
                    
                        if lastCharacterWasHyphenMinus {
                        
                            return nil
                        }
                        else {
                        
                            domainPartLength = 0
                            part = .domain
                        }
                    }
                    else if 0x3e /* §UnicodeCharacter.greaterThanSign */ == c {
                        
                        return [Match(start: position, end: i + 1)]
                    }
                }
                else {
                    
                    return nil
                }
                
                domainPartLength += 1
            }
            
            i += 1
        }
        
        return nil
    }
}
