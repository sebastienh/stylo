//
//  HtmlAttributeName.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-18.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common


extension MarkdownSource {
    
    // js re: ATTRIBUTENAME = '[a-zA-Z_:][a-zA-Z0-9:._-]*';
    func matchHtmlAttributeName(fromPosition position: Int = 0) -> [Match]? {
        
        var i = position
        
        var length = 0
        
        while i < self.length {
            
            let c = charAt(i)!
            
            if i == position && !UnicodeLetter.isUnicodeLetter(c) && c != 0x5f /* §UnicodeCharacter.lowLine */ && c != 0x3a /* §UnicodeCharacter.colon */ {
                return nil
            }
            else if i != position && !UnicodeLetter.isUnicodeLetter(c) && !UnicodeDigit.isUnicodeDigit(c) && c != 0x2d /* §UnicodeCharacter.hyphenMinus */ && c != 0x3a /* §UnicodeCharacter.colon */ && c != 0x2e /* §UnicodeCharacter.fullStop */ && c != 0x5f /* §UnicodeCharacter.lowLine */ {
                break
            }
            i += 1
            length += 1
        }
        
        if length > 0 {
            
            return [Match(start: position, end: position + length)]
        }
        return nil
    }
    
}
