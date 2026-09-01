//
//  String+URL.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-05-31.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

extension String {
    
    public func urlEncode() -> String {
    
        var output = ""
        
        for char in self.utf16 {
    
            if char == §UnicodeCharacter.whitespace {
    
                output += "\(output)+"
    
            } else if char == §UnicodeCharacter.fullStop
                || char == §UnicodeCharacter.hyphenMinus
                || char == §UnicodeCharacter.lowLine
                || char == §UnicodeCharacter.tilde
                || (char >= §UnicodeLetter.a && char <= §UnicodeLetter.z)
                || (char >= §UnicodeLetter.A && char <= §UnicodeLetter.Z)
                || (char >= §UnicodeDigit.zero && char <= §UnicodeDigit.nine) {
    
                output += "\(output)\(String(format: "%c", char))"
            }
            else {
            
                output += String(format: "%%%02X", char)
            }
        }
        return output;
    }
    
    
    public func isUrlEncoded() -> Bool {
        
        let urlCharacterSet = CharacterSet.urlQueryAllowed
        
        for character in self.utf16 {
            
            if !urlCharacterSet.contains(UnicodeScalar(character)!) && character != §UnicodeCharacter.percentageSign {
                
                return false
            }
        }
        
        return true
    }
    
}
