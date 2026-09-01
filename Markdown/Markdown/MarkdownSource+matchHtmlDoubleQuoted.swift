//
//  HtmlDoubleQuoted.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-18.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {
    
    // DOUBLEQUOTEDVALUE = '"[^"]*"';
    func matchHtmlDoubleQuoted(fromPosition position: Int = 0) -> [Match]? {
        
        var i = position
        
        while i < length {
            
            let c = charAt(i)!
            
            if i == position && c != 0x22 /* §UnicodeCharacter.quotationMark */ {
                
                return nil
            }
            else if i != position && c == 0x22 /* §UnicodeCharacter.quotationMark */ {
                
                break
            }
            
            i += 1
        }
        
        if length > 0 {
            
            return [Match(start: position, end: i + 1)]
        }
        
        return nil
    }
    
}
