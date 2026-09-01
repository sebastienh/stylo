//
//  String+matchOpenCloseHtmlBlock.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-01.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {
    
    /// js re: ^<\/?(block1|block2...)(?=(\s|\/?>|$))
    func matchOpenCloseHtmlBlock(fromPosition position: Int = 0) -> [Match]? {

        var i = position
        
        if i < length {
            
            let c = charAt(i)!
        
            i += 1 
            
            // ^<\/?
            if c == 0x3c /* §UnicodeCharacter.lessThanSign */ {
        
                if i < length {
                    if let next = charAt(i) , next == 0x2f /* §UnicodeCharacter.solidus */ {
                        i += 1
                    }
                }
                else {
                    return nil
                }
                
                // (block1|block2...)
                if let blockMatch = matchHtmlBlock(fromPosition: i) {
                 
                    i += blockMatch.first!.length
                    
                    // (?=(\s|\/?>|$))
                    let possibleWhitespaces = skipAllWhitespaces(fromPosition: i)
                    
                    if i >= length {
                        
                        return [Match(start: position, end: i)]
                    }
                    
                    if possibleWhitespaces > 0 {
                        
                        if possibleWhitespaces == 1 {
                            // (\s
                            return [Match(start: position, end: i + 1)]
                        }
                        else {
                            
                            return nil
                        }
                    }
                        
                    let nextChar = charAt(i)!
                    
                    if nextChar == 0x2f /* §UnicodeCharacter.solidus */ {
                        
                        // \/?>
                        if let possibleGreaterThanSign = charAt(i + 1) , possibleGreaterThanSign == 0x3e /* §UnicodeCharacter.greaterThanSign */ {
                         
                            return [Match(start: position, end: i + 2)]
                        }
                    }
                    // \/?>
                    else if nextChar == 0x3e /* §UnicodeCharacter.greaterThanSign */ {
                        
                        return [Match(start: position, end: i + 1)]
                    }
                    
                }
            }
        }
        
        return nil
    }
}
