//
//  String+matchHtmlDocTypeClose.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-30.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common


extension MarkdownSource {
    
    /// js re: />/
    func matchHtmlDocTypeClose() -> [Match]? {

        var i = 0
        
        while i < length {
            
            let c = charAt(i)!
            
            if c == 0x3e /* §UnicodeCharacter.greaterThanSign */ {
                
                return [Match(start: i, end: i + 1)]
            }
            
            i += 1
        }
    
        return nil
    }
}


