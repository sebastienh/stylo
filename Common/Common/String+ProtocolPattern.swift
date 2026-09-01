//
//  String+ProtocolPattern.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-06-10.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

extension String {
    
    // /^([a-z0-9.+-]+:)/i,
    func matchProtocolPattern(fromPosition position: Int = 0, toPosition endPosition: Int? = nil) -> [Match]? {
        
        var i = position
        
        var localEndPosition = endPosition
        
        if localEndPosition == nil {
            
            localEndPosition = self.length
        }
        
        // ([a-z0-9.+-]+:)
        while i < localEndPosition! {
            
            let char = charAt(i)!
            
            if Unicode.isAsciiLetterOrDigit(char)
                || char == §UnicodeCharacter.fullStop
                || char == §UnicodeCharacter.plusSign
                || char == §UnicodeCharacter.hyphenMinus {
        
                i += 1
            }
            else if char == §UnicodeCharacter.colon {
                
                if i > position {
                
                    return [Match(start: position, end: i + 1)]
                }
                
                return nil
            }
            else {
                
                break
            }
        }
        
        return nil 
    }
}
