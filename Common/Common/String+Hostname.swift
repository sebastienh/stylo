//
//  String+Hostname.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-06-10.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

/// hostnamePartStart = /^([+a-z0-9A-Z_-]{0,63})(.*)$/,

let hostnameMaxLen = 255

extension String {
    
    // /^[+a-z0-9A-Z_-]{0,63}$/,
    func matchHostnamePartPattern(fromPosition position: Int = 0, toPosition endPosition: Int? = nil) -> [Match]? {
        
        var i = position
        
        var localEndPosition = endPosition
        
        if localEndPosition == nil {
            
            localEndPosition = self.length
        }
        
        // ([+a-z0-9A-Z_-]{0,63})
        for index in 0..<64 {
            
            if i >= localEndPosition! - 1 {
                
                return [Match(start: position, end: i)]
            }
            
            if let char = charAt(i),
                !Unicode.isAsciiLetterOrDigit(char)
                && char != §UnicodeCharacter.plusSign
                && char != §UnicodeCharacter.hyphenMinus
                && char != §UnicodeCharacter.lowLine {
                
                break
            }
            
            i += index
        }
        
        if i == localEndPosition! - 1 {
            
            return [Match(start: position, end: i)]
        }
        
        return nil
    }
    
    /// /^([+a-z0-9A-Z_-]{0,63})(.*)$/,
    func matchHostnamePartStart(fromPosition position: Int = 0, toPosition endPosition: Int? = nil) -> [Match]? {
    
        var i = position
    
        var localEndPosition = endPosition
        
        if localEndPosition == nil {
            
            localEndPosition = self.length
        }
        
        var match1: Match?
        var match2: Match?
        
        // ([+a-z0-9A-Z_-]{0,63})
        for index in 0..<64 {
            
            if i >= localEndPosition! - 1 {
                
                return [Match(start: position, end: i + 1)]
            }
            
            if let char = charAt(i), !Unicode.isAsciiLetterOrDigit(char)
                && char != §UnicodeCharacter.plusSign
                && char != §UnicodeCharacter.hyphenMinus
                && char != §UnicodeCharacter.lowLine {
            
                match1 = Match(start: position, end: i)
                
                break
            }
            
            i += index
        }
    
        let match2Start = i
        
        // (.*)$
        while let _ = charAt(i) {
            
            if i >= localEndPosition! - 1 {
                
                return [match1!, Match(start: match2Start, end: i + 1)]
            }
            
            match2 = Match(start: match2Start, end: i + 1)
            
            i += 1
        }
        
        if i == localEndPosition! - 1 {
            
            return [match1!, match2!]
        }
        
        return nil
    }
}
