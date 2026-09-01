//
//  NSString+Utilities.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-11-15.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation

public extension NSMutableString {
    
    public var numberOfTrailingSpaces: Int {
        
        var _numberOfTrailingSpaces = 0
        
        for i in (length - 1)...0 {
            
            let c = charAt(i)
            
            if UnicodeWhitespace.isUnicodeWhitespace(c!) {
            
                _numberOfTrailingSpaces += 1 
                break
            }
        }
        
        return _numberOfTrailingSpaces
    }
    
    public func lowercaseCharAt(_ pos: Int) -> UniChar? {
        
        if let character = charAt(pos) {
            
            return UnicodeLetter.convertLowercaseIfNeeded(character)
        }
        
        return nil
    }
    
    
    public func charAt(_ pos: Int) -> UTF16.CodeUnit? {
        
        if pos >= 0 && pos < self.length {
            
            return character(at: pos)
        }
        
        return nil
    }
    
    public func peek(_ pos: Int) -> UniChar? {
        
        return charAt(pos)
    }
    
    public func hasPrefixFromPositionCaseInsensitive(_ prefix: NSString, fromPosition position: Int = 0) -> Bool {
        
        let lowercasePrefix = prefix.lowercased
        
        let count = min(length, prefix.length)
        
        if count < prefix.length {
            
            return false
        }
        
        var i = position
        
        var prefixIndex = 0
        
        while let c = lowercasePrefix.charAt(prefixIndex) {
            
            if let char = lowercaseCharAt(i) , char != c {
                
                return false
            }
            
            prefixIndex += 1
            i += 1
        }
        
        return true
    }
    
    // Returns true if string contains only space characters.
    func isBlank() -> Bool {
        
        var i = 0
        
        while let c = charAt(i) {
            
            if c != §UnicodeCharacter.whitespace {
                
                return false
            }
            
            i += 1
        }
        return true
    }
    
}
