//
//  String+matchScriptPreStyleClose.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-30.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// "<\\/(script|pre|style)>/i"
extension MarkdownSource {
    
    /// "<\\/(script|pre|style)>/i"
    func matchScriptPreStyleClose() -> [Match]? {
    
        var i = 0
        
        while i < length {
            
            let c = charAt(i)!
            
            i += 1
            
            if c == 0x3c /* §UnicodeCharacter.lessThanSign */ {
                
                if i < length {
                    
                    let nextChar = charAt(i)!
                 
                    if nextChar == 0x2f /* §UnicodeCharacter.solidus */ {
                        
                        if hasPrefixFromPositionCaseInsensitive("script>", fromPosition: i + 1) {
                            
                            return [Match(start: i - 1, end: i + 8)]
                        }
                        else if hasPrefixFromPositionCaseInsensitive("pre>", fromPosition: i + 1) {
                            
                            return [Match(start: i - 1, end: i + 5)]
                        }
                        else if hasPrefixFromPositionCaseInsensitive("style>", fromPosition: i + 1) {
                            
                            return [Match(start: i - 1, end: i + 6)]
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
}
