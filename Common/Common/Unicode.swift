//
//  UnicodeUtils.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-06-02.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation

public struct Unicode {

    public static func codePointBetween(_ codePoint: UniChar, firstCodePoint: UniChar, secondCodePoint: UniChar) -> Bool {
        
        if firstCodePoint >= codePoint && codePoint <= secondCodePoint {
            
            return true
        }
        
        return false
    }
    
    // see http://dev.w3.org/csswg/css-syntax/#non-ascii-code-point
    public static func isNonAsciiCodePoint(_ codePoint: UniChar) -> Bool {
        
        if codePoint > 0x80 {
            return true
        }
        return false
    }
    
    // http://dev.w3.org/csswg/css-syntax/#starts-with-a-valid-escape
    public static func checkIfTwoCodePointsAreAValidEscape(_ firstCodePoint: UniChar, secondCodePoint: UniChar ) -> Bool {
    
        if firstCodePoint != UnicodeCharacter.reverseSolidus.rawValue {
            
            return false
        }
        else if secondCodePoint == UnicodeCharacter.lineFeed.rawValue {
        
            return false
        }
        
        return true;
    }
    
    // see http://dev.w3.org/csswg/css-syntax/#non-printable-code-point
    public static func isNonPrintableCodePoint(_ codePoint: UniChar) -> Bool {
        
        // A code point between U+0000 NULL and U+0008 BACKSPACE, or U+000B LINE TABULATION,
        // or a code point between U+000E SHIFT OUT and U+001F INFORMATION SEPARATOR ONE, or U+007F DELETE.
        
        if (codePoint >= §UnicodeCharacter.null
            && codePoint <= §UnicodeCharacter.backspace) {
            return true;
        }
        
        if (codePoint == §UnicodeCharacter.lineTabulation) {
            return true;
        }
        
        if (codePoint >= §UnicodeCharacter.shift
            && codePoint <= §UnicodeCharacter.informationSeparatorOne) {
            return true;
        }
        
        if (codePoint == §UnicodeCharacter.delete) {
            return true;
        }
        return false;
    }
    
    /// [a-zA-Z0-9]
    public static func isAsciiLetterOrDigit(_ codePoint: UniChar) -> Bool {
        
        if !UnicodeLetter.isUnicodeLetter(codePoint) {
            
            if !UnicodeDigit.isUnicodeDigit(codePoint) {
             
                return false
            }
        }
        
        return true
    }
    
    /// [a-f0-9]
    public static func isHexLetterOrDigit(_ codePoint: UniChar) -> Bool {
        
        if !UnicodeLetter.isUnicodeLetter(codePoint) {
            
            if !UnicodeDigit.isUnicodeDigit(codePoint) {
                
                return false
            }
        }
        
        return true
    }
    
}




