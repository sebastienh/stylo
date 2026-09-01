//
//  XMLValidator.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-05-23.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

final class XMLValidator {
    
    /// The first character of a Name must be a NameStartChar, and any other characters must be NameChars; this mechanism is used to prevent names from beginning with European (ASCII) digits or with basic combining characters. Almost all characters are permitted in names, except those which either are or reasonably could be used as delimiters. The intention is to be inclusive rather than exclusive, so that writing systems not yet encoded in Unicode can be used in XML names. See J Suggestions for XML Names for suggestions on the creation of names.
    /// see http://www.w3.org/TR/xml/#NT-Name
    class func validateNameProduction(_ name: DOMString) -> Bool {
        
        // 1. If name does not match the Name production in XML,
        // throw an InvalidCharacterError exception.
        // FIXME: Should be implemented when XML is implemented
        // see http://www.w3.org/TR/xml/#NT-Name
        // For the time being we will only validate that it does not
        // start with a number
        if name.hasPrefix("0")
            || name.hasPrefix("1")
            || name.hasPrefix("2")
            || name.hasPrefix("3")
            || name.hasPrefix("4")
            || name.hasPrefix("5")
            || name.hasPrefix("6")
            || name.hasPrefix("7")
            || name.hasPrefix("8")
            || name.hasPrefix("9") {
            
            
            return false
        }
        
        return true
    }
    
    
    ///
    /// PubidChar	   ::=   	#x20 | #xD | #xA | [a-zA-Z0-9] | [-'()+,./:=?;!*#@$_%]
    ///
    /// https://www.w3.org/TR/xml/#NT-PubidChar
    ///
    class func validatePubidCharProduction(_ unicodeCharacter: UnicodeScalar) -> Bool {
        
        if unicodeCharacter.value != 0x20
            && unicodeCharacter.value != 0xA
            && unicodeCharacter.value != 0xD
            // 0-9
            && !(unicodeCharacter.value >= 0x30 && unicodeCharacter.value <= 0x39)
            // a-z
            && !(unicodeCharacter.value >= 0x61 && unicodeCharacter.value <= 0x7a)
            // A-Z
            && !(unicodeCharacter.value >= 0x41 && unicodeCharacter.value <= 0x5a)
            && !"-'()+,./:=?;!*#@$_%".contains(String(unicodeCharacter)) {
            
            return false
        }
     
        return true
    }
    
    ///
    /// https://www.w3.org/TR/xml/#sec-well-formed
    ///
    class func validateCharProduction(_ string: DOMString?) -> Bool {
        
        if let string = string {
            
            for char in string.unicodeScalars {
                
                // Char	   ::=   	#x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD] | [#x10000-#x10FFFF]
                if char.value != 0x9
                    && char.value != 0xA
                    && char.value != 0xD
                    && !(char.value >= 0x20 && char.value <= 0xD7FF)
                    && !(char.value >= 0xE000 && char.value <= 0xFFFD)
                    && !(char.value >= 0x10000 && char.value <= 0x10FFFE) {
                    
                    return false
                }
            }
        }
        
        return true
    }
    
}
