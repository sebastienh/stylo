//
//  String+matchScheme.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-06-02.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common

private enum EmailPart {
    
    case prelude
    case host
    case end
}

extension MarkdownSource {
    
    /// Try to match email autolink including first <, returning num of chars matched.
    ///
    /// js re:
    /// var AUTOLINK_RE = /^<([a-zA-Z][a-zA-Z0-9+.\-]{1,31}):([^<>\x00-\x20]*)>/;
    ///
    /// prelude : <
    /// host    : [a-zA-Z][a-zA-Z0-9+.\-]{1,31}:
    /// end     : ([^<>\x00-\x20]*)>
    func matchAutolink(fromPosition position: Int = 0) -> [Match]? {
        
        var i = position
        
        var part: EmailPart = .prelude
        
        var hostNamePartLength: Int = 0
        
        while i < length {
            
            let c = charAt(i)!
            
            switch part {
                
            case .prelude:
                
                if i == position && c != 0x3c /* §UnicodeCharacter.lessThanSign */ {
                    return nil
                }
                else {
                    part = .host
                }
                
            case .host:
                
                // [a-zA-Z]
                if hostNamePartLength == 0 {
                    
                    if !UnicodeLetter.isUnicodeLetter(c) {
                        
                        return nil
                    }
                }
                    // [a-zA-Z0-9+.\-]{1,31}:
                else if hostNamePartLength > 0 && hostNamePartLength < 32 {
                    
                    if !UnicodeLetter.isUnicodeLetter(c)
                        && !UnicodeDigit.isUnicodeDigit(c)
                        && 0x2d /* §UnicodeCharacter.hyphenMinus */ != c
                        && 0x2b /* §UnicodeCharacter.plusSign */ != c
                        && 0x2e /* §UnicodeCharacter.fullStop */ != c
                        && 0x3a /* §UnicodeCharacter.colon */ != c {
                        
                        return nil
                    }
                    
                    if 0x3a /* §UnicodeCharacter.colon */ == c && hostNamePartLength > 1 {
                        
                        part = .end
                    }
                    else if 0x3a /* §UnicodeCharacter.colon */ == c && hostNamePartLength == 1 {
                     
                        return nil 
                    }
                    else if 0x3e /* §UnicodeCharacter.greaterThanSign */ == c {
                        
                        return [Match(start: position, end: i + 1)]
                    }
                }
                else {
                    
                    return nil
                }
                
                hostNamePartLength += 1
                
            case .end:
                
                // scan until '>'
                while let char = charAt(i) {
                    
                    // [^<>\x00-\x20]*
                    if char >= 0x00 && char <= 0x20 {
                        
                        return nil
                    }
                    else if char == 0x3c /* §UnicodeCharacter.lessThanSign */ {
                        
                        return nil
                    }
                    else if char == 0x3e /* §UnicodeCharacter.greaterThanSign */ {
                        
                        return [Match(start: position, end: i + 1)]
                    }
                    
                    i += 1
                }
            }
            
            i += 1
        }
        
        return nil
    }
}
