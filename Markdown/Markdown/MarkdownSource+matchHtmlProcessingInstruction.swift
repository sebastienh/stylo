//
//  HtmlProcessingInstruction.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-18.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// js re: PROCESSINGINSTRUCTION = "[<][?].*?[?][>]";
extension MarkdownSource {
    
    // PROCESSINGINSTRUCTION = "[<][?].*?[?][>]";
    func matchHtmlProcessingInstruction(fromPosition position: Int = 0) -> [Match]? {
        
        var i = position
        var prelude: Bool = true
        var instruction: Bool = false
        var conclusion: Bool = false
        
        while i < length {
            
            let c = charAt(i)!
            
            i += 1
            
            let currentStringIndex = i - 1
            
            if prelude {
                
                if currentStringIndex == position && c != 0x3c /* §UnicodeCharacter.lessThanSign */ {
                    
                    return nil
                }
                else if currentStringIndex == (position + 1) && c != §UnicodeCharacter.questionMark {
                
                    return nil
                }
                else if currentStringIndex == (position + 1) && c == §UnicodeCharacter.questionMark {
                    
                    prelude = false
                    instruction = true
                }
            }
            else if instruction {
                
                if c == §UnicodeCharacter.questionMark {
                    
                    instruction = false
                    conclusion = true
                }
            }
            else if conclusion {
                
                if c != 0x3e /* §UnicodeCharacter.greaterThanSign */ {
                    
                    return nil
                }
                else {
                    
                    return [Match(start: position, end: i)]
                }
            }
        }
        
        return nil
    }
    
}
