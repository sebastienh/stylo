//
//  HtmlOpenTag.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-18.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common


extension MarkdownSource {
    
    // (OPENTAG | CLOSETAG) + '\\s*$'
    func matchOpenOrCloseTag(fromPosition position: Int = 0) -> [Match]? {
        
        var i = position
        
        if let match = matchHtmlOpenTag(fromPosition: position) {
            
            i += match.first!.length
        }
        else if let match = matchHtmlCloseTag(fromPosition: position) {
            
            i += match.first!.length
        }
        else {
            
            return nil
        }
        
        // skip all whitespaces
        while i < length {
            if let c = charAt(i) , c == 0x20 /* §UnicodeCharacter.whitespace */ {
                i += 1
            }
            else {
                break 
            }
        }
        
        // at the end of all whitespaces we should be at the end of the string
        if i == self.length {
            
            return [Match(start: position, end: i)]
        }
        
        return nil
    }
    
    // CLOSETAG = '<\\/[A-Za-z][A-Za-z0-9\\-]*\\s*>';
    func matchHtmlCloseTag(fromPosition position: Int = 0) -> [Match]? {
    
        var i = position
        
        if let c = charAt(i) , c != 0x3c /* §UnicodeCharacter.lessThanSign */ {
                
            return nil
        }
        
        i += 1
        
        if let c = charAt(i) , c != 0x2f /* §UnicodeCharacter.solidus */ {
            
            return nil
        }
        
        i += 1
        
        if let tagName = matchHtmlTagName(fromPosition: i) {
            
            i += tagName.first!.length
            
            // skip all whitespaces
            while let c = charAt(i) , c == 0x20 /* §UnicodeCharacter.whitespace */ {
                
                i += 1
            }
            
            // the final Greater than sign
            if let c = charAt(i) , c == 0x3e /* §UnicodeCharacter.greaterThanSign */ {
                
                i += 1
                
                return [Match(start: position, end: i)]
            }
        }
        
        return nil
    }
    
    // '<[A-Za-z][A-Za-z0-9\\-]*' + attribute + '*\\s*\\/?>';
    // OPENTAG = "<" + TAGNAME + ATTRIBUTE + "*" + "\\s*/?>";
    func matchHtmlOpenTag(fromPosition position: Int = 0) -> [Match]? {
     
        var i = position
    
        let c = charAt(i)
        
        i += 1
        
        if let c = c {
            
            if c != 0x3c /* §UnicodeCharacter.lessThanSign */ {
            
                return nil
            }
        }
        
        if let tagName = matchHtmlTagName(fromPosition: i) {
            
            i += tagName.first!.length
            
            while let attribute = matchHtmlAttribute(fromPosition: i) {
             
                i += attribute.first!.length
            }
            
            // skip all whitespaces
            i += skipAllWhitespaces(fromPosition: i)
            
            if let c = charAt(i) , c == 0x2f /* §UnicodeCharacter.solidus */ {
             
                i += 1
            }
            
            // the final Greater than sign
            if let c = charAt(i) , c == 0x3e /* §UnicodeCharacter.greaterThanSign */ {
                
                i += 1
                
                return [Match(start: position, end: i)]
            }
        }
        
        return nil
    }
    
}
