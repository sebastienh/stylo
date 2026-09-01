//
//  HtmlComment.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-18.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// HTMLCOMMENT = "<!---->|<!--(?:-?[^>-])(?:-?[^-])*-->";
extension MarkdownSource {

    /// [Comments](http://www.w3.org/TR/html5/syntax.html#comments)
    /// 
    /// Must start with the four character sequence U+003C LESS-THAN SIGN,U+0021 EXCLAMATION MARK, U+002D HYPHEN-MINUS, U+002D HYPHEN-MINUS (<!--).
    /// Following this sequence, the comment may have text, with the additional restriction 
    /// that the text must not start with a single ">" (U+003E) character, nor start with 
    /// a U+002D HYPHEN-MINUS character (-) followed by a ">" (U+003E) character, nor contain 
    /// two consecutive U+002D HYPHEN-MINUS characters (--), nor end with a U+002D HYPHEN-MINUS 
    /// character (-). Finally, the comment must be ended by the three character sequence 
    /// U+002D HYPHEN-MINUS, U+002D HYPHEN-MINUS, U+003E GREATER-THAN SIGN (-->).
    
    
    // HTMLCOMMENT = "<!---->|<!--(?:-?[^>-])(?:-?[^-])*-->";
    func matchHtmlComment(fromPosition position: Int = 0) -> [Match]? {
        
        var i = position
        
        // comment start <!-- 
        if  hasPrefixFromPositionCaseSensitive("<!--", fromPosition: i) {
            
            i += "<!--".length
            
            let textStartPosition = i

            while i < length {
                
                let c = charAt(i)!
                
                if i == textStartPosition {
                    
                    // the text must not start with a single ">" (U+003E)
                    if c == 0x3e /* §UnicodeCharacter.greaterThanSign */ {
                        
                        return nil
                    }
                    
                    // nor [the text should] start with a U+002D HYPHEN-MINUS character (-) followed by a ">" (U+003E) character
                    if c == 0x2d /* §UnicodeCharacter.hyphenMinus */ {
                        
                        if let next = charAt(i) , next == 0x3e /* §UnicodeCharacter.greaterThanSign */ {
                            
                            return nil
                        }
                    }
                }
                
                if c == 0x2d /* §UnicodeCharacter.hyphenMinus */ {
                    
                    i += 1
                    
                    // the text should not contain two consecutive U+002D HYPHEN-MINUS characters (--)
                    if i < length {
                        
                        if let next = charAt(i) , next == 0x2d /* §UnicodeCharacter.hyphenMinus */ {
                        
                            // we are in front of -- it should not be inside the text (so must mean the end)
                            
                            i += 1 
                            
                            if let secondNext = charAt(i) , secondNext == 0x3e /* §UnicodeCharacter.greaterThanSign */ {
                                
                                return [Match(start: position, end: i + 1)]
                            }
                            
                            // the text should not contain two consecutive U+002D HYPHEN-MINUS characters (--)
                            // nor end with a U+002D HYPHEN-MINUS character (---) case: it's covered also here.
                            return nil
                        }
                    }
                    else {
                        
                        return nil
                    }
                }
                
                i += 1
            }
        }
        
        return nil
    }
    
}
