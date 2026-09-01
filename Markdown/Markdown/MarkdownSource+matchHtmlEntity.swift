//
//  String+HtmlEntity.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-16.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {

    
    
    
    /// "^&(?:
    
    /// [Hexadecimal numeric character references](@) consist of `&#` + either `X` or `x` + a string of 1-6 hexadecimal digits + `;`.
    /// unicode entity: #x[a-f0-9]{1,6}|
    
    
    /// [Decimal numeric character references](@) consist of `&#` + a string of 1--7 arabic digits + `;`.
    /// number entity:  #[0-9]{1,7}|
    
    /// named entity:   [a-z][a-z0-9]{1,31});"
    func matchHtmlEntity(fromPosition position: Int = 0) -> [Match]? {
        
        var i = position
        var numberEntity: Bool = false
        var unicodeEntity: Bool = false
        var validEntityValue = false
        
        // increment at the end 
        while i < length {
            
            let c = charAt(i)!
            let currentStringIndex = i
            
            if currentStringIndex == position  {
                
                if c != 0x26 /* §UnicodeCharacter.ampersand */ {
                    
                    return nil
                }
            }
            else {
                
                // second position
                if currentStringIndex == position + 1 && c == 0x23 /* §UnicodeCharacter.numberSign */  {
                    
                    numberEntity = true
                }
                else if currentStringIndex == position + 2 && (c == 0x78 /* §UnicodeLetter.x */ || c == 0x58 /* §UnicodeLetter.X */) && numberEntity {
                 
                    unicodeEntity = true
                    numberEntity = false
                }
                else {
                    
                    if c == 0x3b /* §UnicodeCharacter.semiColon */ {
                        
                        if !validEntityValue {
                            return nil
                        }
                        i += 1 
                        break
                    }
                    
                    // [0-9]{1,7}|
                    if numberEntity {
                    
                        if currentStringIndex > position + 9 || !UnicodeDigit.isUnicodeDigit(c){
                            
                            return nil
                        }
                        validEntityValue = true
                    }
                    else if unicodeEntity {
                        
                        if currentStringIndex > position + 9 {
                            
                            return nil
                        }
                        else {
                            
                            if !UnicodeDigit.isUnicodeDigit(c) && !UnicodeLetter.isUnicodeLetter(c) {
                                
                                return nil
                            }
                        }
                        
                        validEntityValue = true
                    }
                    else {
                        
                        // first position must be a letter 
                        if currentStringIndex == position + 1 && !UnicodeLetter.isUnicodeLetter(c) {
                            
                            return nil
                        }
                        else {
                            
                            if currentStringIndex > position + 31 {
                                
                                return nil
                            }
                            else if !UnicodeDigit.isUnicodeDigit(c) && !UnicodeLetter.isUnicodeLetter(c) {
                                
                                return nil
                            }
                        }
                        
                        validEntityValue = true
                    }
                }
            }
            i += 1
        }
        
        if i - position < 3 {
            
            return nil
        }
            
        return [Match(start: position, end: i)]
    }
}
