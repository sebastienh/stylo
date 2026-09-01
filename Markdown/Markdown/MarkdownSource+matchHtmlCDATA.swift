//
//  HtmlCDATA.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-19.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

enum CDATAMatchState {
    
    //  <!\\[CDATA\\[
    case prelude
    
    // [\\s\\S]*? \\]\\]>
    case data
}


/// CDATA = "<!\\[CDATA\\[[\\s\\S]*?\\]\\]>";

extension MarkdownSource {
    
    /// CDATA = "<!\\[CDATA\\[[\\s\\S]*?\\]\\]>";
    func matchHtmlCDATA(fromPosition position: Int = 0) -> [Match]? {
    
        var i = position
        var cdataMatchState: CDATAMatchState = .prelude
        var preludeLength: Int = 0
        var conclusionLength: Int = 0
        
        while i < length {
            
            let c = charAt(i)!
            
            switch cdataMatchState {
        
            // <!\\[CDATA\\[
            case .prelude:
                
                switch preludeLength {
                    
                    
                case 0:
                    
                    // <
                    if c != 0x3c /* §UnicodeCharacter.lessThanSign */ {
                        
                        return nil
                    }
                    preludeLength += 1
                    
                case 1:
                    
                    // !
                    if c != 0x21 /* §UnicodeCharacter.exclamationMark */ {
                        
                        return nil
                    }
                    preludeLength += 1
                    
                case 2:
                    
                    // [
                    if c != 0x5b /* §UnicodeCharacter.leftSquareBracket */ {
                        
                        return nil
                    }
                    preludeLength += 1
                    
                case 3:
                    
                    // C
                    if c != §UnicodeLetter.C {
                        
                        return nil
                    }
                    preludeLength += 1
                    
                case 4:
                    
                    // D
                    if c != §UnicodeLetter.D {
                        
                        return nil
                    }
                    preludeLength += 1
                    
                case 5:
                    
                    // A
                    if c != §UnicodeLetter.A {
                        
                        return nil
                    }
                    preludeLength += 1
                    
                case 6:
                    
                    // T
                    if c != §UnicodeLetter.T {
                        
                        return nil
                    }
                    preludeLength += 1
                    
                case 7:
                    
                    // A
                    if c != §UnicodeLetter.A {
                        
                        return nil
                    }
                    preludeLength += 1
                    
                case 8:
                    
                    // [
                    if c != 0x5b /* §UnicodeCharacter.leftSquareBracket */ {
                        
                        return nil
                    }
                    preludeLength += 1
                    
                    cdataMatchState = .data
                    
                default:
                    
                    return nil
                }
                
            case .data:
                
                // [\\s\\S]*?
                
                if c == 0x5d /* §UnicodeCharacter.rightSquareBracket */ {
                
                    if conclusionLength == 1 || conclusionLength == 0 {
                    
                        conclusionLength += 1
                    }
                    else if conclusionLength == 2 {
                        
                        conclusionLength = 0
                    }
                }
                else if c == 0x3e /* §UnicodeCharacter.greaterThanSign */ {
                
                    if conclusionLength == 2 {
                        return [Match(start: position, end: i + 1)]
                    }
                    else {
                        conclusionLength = 0
                    }
                }
            }
            i += 1
        }
        return nil
    }
    
}
