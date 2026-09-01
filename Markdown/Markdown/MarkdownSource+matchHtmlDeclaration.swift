//
//  HtmlDeclaration.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-19.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

enum DeclarationMatchState {
    
    //  <!
    case prelude
    
    // [A-Z]+
    case identifier
    
    // \\s+
    case whitespaces
    
    // [^>]*>
    case conclusion
}


/// DECLARATION = "<![A-Z]+" + "\\s+[^>]*>";
extension MarkdownSource {

    
    /// DECLARATION = "<![A-Z]+" + "\\s+[^>]*>";
    ///
    /// Prelude: <!
    /// Identifier: [A-Z]+
    /// Whitespaces: \\s+
    /// Conclusion: [^>]*>
    func matchHtmlDeclaration(fromPosition position: Int = 0) -> [Match]? {
        
        var i = position
        
        var declarationMatchState: DeclarationMatchState = .prelude
        
        var identifierLength: Int = 0
        
        var conclusionLength: Int = 0
        
        while i < length {
            
            let c = charAt(i)!
            
            switch declarationMatchState {
            
            // Prelude: <!
            case .prelude:
                
                if i == position && c != 0x3c /* §UnicodeCharacter.lessThanSign */ {
                    
                    return nil
                }
                else if i == (position + 1) && c != 0x21 /* §UnicodeCharacter.exclamationMark */ {
                    
                    return nil
                }
                else if i == (position + 1) && c == 0x21 /* §UnicodeCharacter.exclamationMark */ {
                    
                    declarationMatchState = .identifier
                }
            
            // Identifier: [A-Z]+
            case .identifier:
                
                if UnicodeLetter.isUppercaseLetter(c) {
                    
                    identifierLength += 1
                }
                else if isWhitespace(fromPosition: i) {
                    
                    i -= 1 
                    
                    declarationMatchState = .whitespaces
                }
                else {
                    
                    return nil
                }

            // Whitespaces: \\s+
            case .whitespaces:
        
                let whitespacesLength = skipAllWhitespaces(fromPosition: i)
                
                if whitespacesLength == 0 {
                    
                    return nil
                }
                
                i += whitespacesLength - 1
                
                declarationMatchState = .conclusion
                
            // [^>]*>
            case .conclusion:
        
                if c != 0x3e /* §UnicodeCharacter.greaterThanSign */ {
                
                    conclusionLength += 1
                }
                else {

                    return [Match(start: position, end: i + 1)]
                }
            }
            
            i += 1
        }
        
        return nil
    }
    
}
