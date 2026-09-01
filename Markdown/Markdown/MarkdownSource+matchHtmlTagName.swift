//
//  HtmlTagName.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-18.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {
    
    // js re: TAGNAME = '[A-Za-z][A-Za-z0-9-]*'
    func matchHtmlTagName(fromPosition position: Int = 0) -> [Match]? {
        
        var i = position
        
        while i < length {
            
            let c = charAt(i)!
            
            if i == position && !UnicodeLetter.isUnicodeLetter(c) && !UnicodeDigit.isUnicodeDigit(c) {
                
                return nil
            }
            else if !UnicodeLetter.isUnicodeLetter(c) && !UnicodeDigit.isUnicodeDigit(c) && c != 0x2d /* §UnicodeCharacter.hyphenMinus */ {
                
                break
            }
            
            i += 1
        }
        
        if length > 0 {
            
            return [Match(start: position, end: i)]
            
        }
        
        return nil
    }
}
