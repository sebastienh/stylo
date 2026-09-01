//
//  String+matchProcessingInstructionClose.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-30.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common


extension MarkdownSource {
    
    /// js re: /\?>/
    func matchProcessingInstructionClose() -> [Match]? {
        
        var i = 0
        
        while i < length {
            
            let c = charAt(i)!
            
            i += 1
            
            if c == §UnicodeCharacter.questionMark {
        
                if i < length {
                    
                    let nextChar = charAt(i)!
                    
                    if nextChar == 0x3e /* §UnicodeCharacter.greaterThanSign */ {
                        
                        return [Match(start: i - 1, end: i + 1)]
                    }
                }
                else {
                    
                    return nil
                }
            }
        }
        
        return nil
    }
    
}
