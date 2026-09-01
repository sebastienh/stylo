//
//  String+UsernameServerPattern.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-06-10.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

extension String {
    
    // /^\/\/[^@\/]+@[^@\/]+/
    func matchUsernameServerPattern(fromPosition position: Int = 0, toPosition endPosition: Int? = nil) -> [Match]? {
        
        var i = position
        
        var localEndPosition = endPosition
        
        if localEndPosition == nil {
            
            localEndPosition = self.length
        }
        
        var valid: Bool = false
        
        // \/
        if let c = charAt(i), c == §UnicodeCharacter.solidus {
            
            i += 1
            
            // \/
            if let c = charAt(i), c == §UnicodeCharacter.solidus {
                
                i += 1
                
                // [^@\/]+
                while let char = charAt(i), char != §UnicodeCharacter.commercialAt
                    && char != §UnicodeCharacter.solidus {
                    
                    valid = true
                    i += 1
                }
                
                if valid {
                
                    valid = false
                    
                    // @
                    if let char = charAt(i), char == §UnicodeCharacter.commercialAt {
                
                        i += 1
                        
                        // [^@\/]+
                        while let char = charAt(i), char != §UnicodeCharacter.commercialAt
                            && char != §UnicodeCharacter.solidus {
                                
                            valid = true
                            i += 1
                        }
                        if valid {
                            
                            return [Match(start: position, end: i)]
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
}
