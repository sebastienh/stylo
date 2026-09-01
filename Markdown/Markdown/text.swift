//
//  text.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-26.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// Rule to skip pure text
/// '{}$%@~+=:' reserved for extentions
///
/// !, ", #, $, %, &, ', (, ), *, +, ,, -, ., /, :, ;, <, =, >, ?, @, [, \, ], ^, _, `, {, |, }, or ~
///
/// !!!! Don't confuse with "Markdown ASCII Punctuation" chars
/// http://spec.commonmark.org/0.15/#ascii-punctuation-character
func isTerminatorChar(_ ch: UTF16Char) -> Bool {
    
    if isPossibleNewLineStartCodePoint(ch) {
        
        return true
    }
    
    return isSpecialCharacter(ch)
}

///
///
///
func isSpecialCharacter(_ ch: UTF16Char) -> Bool {
    
    switch (ch) {
    case 0x21: return true /* ! */
    case 0x23: return true /* # */
    case 0x24: return true /* $ */
    case 0x25: return true /* % */
    case 0x26: return true /* & */
    case 0x2A: return true /* * */
    case 0x2B: return true /* + */
    case 0x2D: return true /* - */
    case 0x3A: return true /* : */
    case 0x3C: return true /* < */
    case 0x3D: return true /* = */
    case 0x3E: return true /* > */
    case 0x40: return true /* @ */
    case 0x5B: return true /* [ */
    case 0x5C: return true /* \ */
    case 0x5D: return true /* ] */
    case 0x5E: return true /* ^ */
    case 0x5F: return true /* _ */
    case 0x60: return true /* ` */
    case 0x7B: return true /* { */
    case 0x7D: return true /* } */
    case 0x7E: return true /* ~ */
    default: return false
    }
}

/// Skip text characters for text token, place those to pending buffer
/// and increment current pos
func text(_ state: StateInline, silent: Bool) -> Bool {
    
    var pos = state.pos
    
    // we want to include the newline when it is present.
    while let char = state.src.charAt(pos), pos < state.posMax && !isTerminatorChar(char) {
        
        pos += 1
    }
    
    if pos == state.pos {
        
        return false
    }
    
    if !silent {
        
        // FIXME: Add support for line
        state.addTextToPendingText(state.src.slice(state.pos, end: pos)!.string)
        let segment = state.sourceStringSegmentFromPosition(state.pos, length: pos - state.pos)!
        state.pendingRegion.addSourceStringSegment(segment)
    }
    
    state.pos = pos
    
    return true
}
