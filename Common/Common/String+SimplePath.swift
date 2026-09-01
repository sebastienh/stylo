//
//  String+SimplePath.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-06-10.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

extension String {
    
    // /^(\/\/?(?!\/)[^\?\s]*)(\?[^\s]*)?$/
    func matchSimplePathPattern(fromPosition position: Int = 0, toPosition endPosition: Int? = nil) -> [Match]? {
        
        var i = position
        
        var localEndPosition = endPosition
        
        if localEndPosition == nil {
            
            localEndPosition = self.length
        }
        
        // \/
        if let c = charAt(i), c == §UnicodeCharacter.solidus {
        
            i += 1
            
            // \/?
            if let c = charAt(i), c == §UnicodeCharacter.solidus {
                
                i += 1
                
                // (?!\/)
                if let c = charAt(i), c == §UnicodeCharacter.solidus {
                    
                    return nil
                }
            }
            
            // [^\?\s]*
            while let c = charAt(i), c != §UnicodeCharacter.questionMark
                && !isWhiteSpace(c) {
                
                i += 1
            }
            
            if i == localEndPosition {
                
                return [Match(start: position, end: localEndPosition!)]
            }
            
            // (\?[^\s]*)?
            if let c = charAt(i), c == §UnicodeCharacter.questionMark {
             
                let pathMatch = Match(start: position, end: i)
                
                let startSearch = i
                
                i += 1
                
                while let c = charAt(i) {
                 
                    if !isWhiteSpace(c) {
                    
                        i += 1
                    }
                    else {
                        
                        return nil
                    }
                }
                
                if i == localEndPosition {
                    
                    return [pathMatch, Match(start: startSearch, end: localEndPosition!)]
                }
            }
        }
        
        return nil
    }
    
    // [\t\f\r\n ]
    func isWhiteSpace(_ code: UTF16.CodeUnit) -> Bool {
        
        switch (code) {
            
        case 0x09:
            // \t
            return true
        case 0x0A:
            
            // \n
            return true
            
        case 0x0C:
            
            // \f
            return true
            
        case 0x0D:
            
            // \r
            return true
            
        case 0x20:
            
            return true
            
        default:
            
            return false
        }
    }
    
}
