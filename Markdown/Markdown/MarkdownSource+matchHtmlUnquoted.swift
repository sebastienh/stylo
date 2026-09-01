//
//  HtmlUnquoted.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-18.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// var UNQUOTEDVALUE = "[^\"'=<>`\\x00-\\x20]+";
extension MarkdownSource {
    
    
    /// js re UNQUOTEDVALUE = "[^\"'=<>`\\x00-\\x20]+";
    func matchHtmlUnquoted(fromPosition position: Int = 0) -> [Match]? {
        
        var i = position
        
        var length = 0
        
        while i < self.length {
            
            let c = charAt(i)!
        
            // \\x00-\\x20
            if c >= 0x00 && c <= 0x20 {
            
                if i != position {
                    
                    break
                }
                
                return nil
            }
            
            // \"'=<>`
            if c == 0x22 /* §UnicodeCharacter.quotationMark */ || c == §UnicodeCharacter.apostrophe || c == 0x3d /* §UnicodeCharacter.equalsSign */ || c == 0x3c /* §UnicodeCharacter.lessThanSign */ || c == 0x3e /* §UnicodeCharacter.greaterThanSign */ || c == §UnicodeCharacter.graveAccent {
                
                if i != position {
                    
                    break
                }
                
                return nil
            }
            
            length += 1
            i += 1
        }
        
        if length > 0 {
            
            return [Match(start: position, end: i)]
        }
        
        return nil
    }
}
