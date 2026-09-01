//
//  attributes_bloc_inline.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-04-29.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// Process html tags
func attributes_inline(_ state: StateInline, silent: Bool) -> Bool {
    
    let startPos = state.pos
    var pos = state.pos
    
    // Check start
    let max = state.posMax
    
    if let char = state.src.charAt(pos), char != 0x7B/* { */ {
        
        return false
    }
    
    let attributesBloc = parseAttributesBloc(state.src, pos: &pos, max: max)
    
    if let attributesBloc = attributesBloc {
        
        state.pos = pos
        
        if silent {
            return true
        }
        
        let attrBlocTokens = attributesBloc.pushAttributesBlocTokens(in: state)
        
        assert(attrBlocTokens != nil)
        if let (startToken, _) = attrBlocTokens {
            setEmptyLineAboveValuee(in: startToken, pos: startPos, src: state.src)
        }
        return true
    }
    else {
        
        return false
    }
}

fileprivate func setEmptyLineAboveValuee(in token: Token, pos: Int, src: String) {
    
    token.emptyLineAbove = false
    
    var charPos = pos
    
    while let char = src.charAt(charPos), char != §UnicodeCharacter.lineFeed {
        charPos -= 1
    }
    
    // previous line end line feed
    if let char = src.charAt(charPos), char == §UnicodeCharacter.lineFeed {
        
        let lineBeforeEndLineFeed = charPos
        
        while let char = src.charAt(charPos), char != §UnicodeCharacter.lineFeed {
            charPos -= 1
        }
        
        // previous line start line feed
        if let char = src.charAt(charPos), char == §UnicodeCharacter.lineFeed {
            
            let lineBeforeFirstCharacter = charPos+1
            
            if (lineBeforeEndLineFeed - lineBeforeFirstCharacter) == 0 {
                token.emptyLineAbove = true
            }
            else {
                
                if let lineAbove = src.slice(lineBeforeFirstCharacter, end: lineBeforeEndLineFeed) {
                    
                    if lineAbove.trimmed().isEmpty {
                        token.emptyLineAbove = true
                    }
                }
            }
        }
    }
}

