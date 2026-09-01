//
//  String+matchHtmlCDATAClose.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-30.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common


extension MarkdownSource {
    
    /// js re: /\]\]>/
    func matchHtmlCDATAClose() -> [Match]? {
        
        var i = 0
        
        while i < length {
            
            let c = charAt(i)!
            
            if c == 0x5d /* §UnicodeCharacter.rightSquareBracket */ {
                
                if hasPrefixFromPositionCaseInsensitive("]>", fromPosition: i) {
            
                    return [Match(start: i, end: i + 2)]
                }
            }
            
            i += 1
        }
        
        return nil
    }
}
