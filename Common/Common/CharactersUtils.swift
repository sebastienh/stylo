//
//  CharactersUtils.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-08-30.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation
import os

/// Return if the passed character is a space
public func isSpace(_ code: UTF16.CodeUnit) -> Bool {
    
    switch code {
    case 0x09:
        return true
    case 0x20:
        return true
    default:
        return false
    }
}


/// Returns the length of the new line at position
/// parameter, if it founds one, otherwise returns nil.
public func charactersAreNewLine(_ firstCharacter: UTF16.CodeUnit?, secondCharacter: UTF16.CodeUnit?) -> Int? {
    
    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
    os_log("charactersAreNewLine(%@, secondCharacter: %@)", log: Log.Common.all, type: .info, %%firstCharacter, %%secondCharacter)
    #endif
    
    if let char = firstCharacter {
        
        // LF:    Line Feed ('\n'), U+000A
        // Note: we can't return the length since it could be:
        // LF+CR: Acorn BBC and RISC OS spooled text output.
        if char == §UnicodeCharacter.lineFeed {
            if let secondCharacter = secondCharacter, secondCharacter == 0x000D {
                return 2
            }
            return 1
        }
        
        // CR:    Carriage Return ('\r'), U+000D
        // Note: could be '\r\n' express in two so we don't
        // know its length right away.
        // CommonMark also consider those cases :
        // \r[\n\u0085]
        // CR+LF: CR (U+000D) followed by LF (U+000A)
        if char == 0x000D {
            
            if let secondCharacter = secondCharacter {
                
                // case \r\n
                if secondCharacter == 0x0A {
                    return 2
                }
                
                // case \r0x0085
                if secondCharacter == 0x0085 {
                    return 2
                }
            }
            return 1
        }
        
        // '\r\n', 0x0D0A
        if char == 0x0D0A{
            return 1
        }
        
        // RS, 0x1E
        if char == 0x1E {
            return 1
        }
        
        // NEL:   Next Line, U+0085
        if char == 0x0085 {
            return 1
        }
        
        // LS:    Line Separator, U+2028
        if char == 0x2028 {
            return 1
        }
        // VT:    Vertical Tab, U+000B
        if char == 0x000B {
            return 1
        }
        
        // FF:    Form Feed, U+000C
        if char == 0x000C {
            return 1
        }
        
        // PS:    Paragraph Separator, U+2029
        if char == 0x2029 {
            return 1
        }
    }
    
    return nil
}

/// In this method we return the length when we know the lenght, meaning
/// that the new line character by itself is a new line and we don't further
/// processing.
/// In my case I don't consider the character 0x2424 as a new line in itself
/// as stated in this [wiki article](https://en.wikipedia.org/wiki/Newline)
/// The Unicode characters U+2424 (SYMBOL FOR NEWLINE, ␤), U+23CE (RETURN SYMBOL, ⏎),
/// U+240D (SYMBOL FOR CARRIAGE RETURN, ␍) and U+240A (SYMBOL FOR LINE FEED, ␊) are
/// intended for presenting a user-visible character to the reader of the document,
/// and are thus most often not recognized themselves as a newline.
public func isPossibleNewLineStartCodePoint(_ code: UTF16.CodeUnit) -> Bool {
    
    // LF:    Line Feed ('\n'), U+000A
    // Note: we can't return the length since it could be:
    // LF+CR: Acorn BBC and RISC OS spooled text output.
    if code == 0x0A {
        
        return true
    }
    // CR:    Carriage Return ('\r'), U+000D
    // Note: could be '\r\n' express in two so we don't
    // know its length right away.
    // CommonMark also consider those cases :
    // \r[\n\u0085]
    // CR+LF: CR (U+000D) followed by LF (U+000A)
    if code == 0x0D {
        
        return true
    }
    
    // '\r\n', 0x0D0A
    if code == 0x0D0A{
        
        return true
    }
    
    // RS, 0x1E
    if code == 0x1E {
        
        return true
    }
    
    // NEL:   Next Line, U+0085
    if code == 0x0085 {
        
        return true
    }
    // LS:    Line Separator, U+2028
    if code == 0x2028 {
        
        return true
    }
    // VT:    Vertical Tab, U+000B
    if code == 0x000B {
        
        return true
    }
    
    // FF:    Form Feed, U+000C
    if code == 0x000C {
        
        return true
    }
    
    // PS:    Paragraph Separator, U+2029
    if code == 0x2029 {
        
        return true
    }
    
    return false
}

// Zs (unicode class) || [\t\f\v\r\n]
public func isWhiteSpace(_ code: UTF16.CodeUnit) -> Bool {
    
    if code >= 0x2000 && code <= 0x200A {
        
        return true
    }
    
    switch (code) {
        
    case 0x09:
        // \t
        return true
    case 0x0A:
        
        // \n
        return true
        
    case 0x0B:
        
        // \v
        return true
        
    case 0x0C:
        
        // \f
        return true
        
    case 0x0D:
        
        // \r
        return true
        
    case 0x0085:
        
        // \u0085  (newline, space, invisible
        return true
        
    case 0x2028:
        
        // \u2028  (newline, space, invisible)
        return true
        
    case 0x20:
        
        return true
        
    case 0xA0:
        
        return true
        
    case 0x1680:
        
        return true
        
    case 0x202F:
        
        return true
        
    case 0x205F:
        
        return true
        
    case 0x3000:
        
        return true
        
    default:
        
        return false
    }
}



