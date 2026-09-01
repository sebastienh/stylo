//
//  SetextMatch.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-11.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {

    /// js re: /^(?:=+|-+) *$/
    func matchSetexHeaderLine(fromPosition position: Int, options: AnyObject...) -> [Match]? {
        
        var i = position
        
        var setextCodePoint: UniChar?
        
        var totalLengthWithSpaces: Int = 0
        
        var setextLength: Int = 0
        
        while i < length {
            
            let c = charAt(i)!
            
            if c == 0x2d /* §UnicodeCharacter.hyphenMinus */ || c == 0x3d /* §UnicodeCharacter.equalsSign */ {
            
                if setextLength == 0 {
                    
                    setextCodePoint = c
                }
                // we have encountered spaces so we only accept spaces...
                else if totalLengthWithSpaces > setextLength {
                 
                    return nil 
                }
                else if c != setextCodePoint {
                        
                    return nil
                }
                
                setextLength += 1
                totalLengthWithSpaces += 1
            }
            else  if c == 0x20 /* §UnicodeCharacter.whitespace */ {
                
                if setextLength == 0 {
                    
                    return nil
                }
                else {
                    
                    totalLengthWithSpaces += 1
                }
            }
            else {
                
                return nil
            }
            
            i += 1
        }
        
        if setextLength > 0 {
            
            return [Match(start: position, end: position + setextLength)]
        }
        
        return nil
    }
    
}
