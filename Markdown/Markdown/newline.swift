//
//  newline.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-27.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

func newline(_ state: StateInline, silent: Bool) -> Bool {
    
    var pos = state.pos
    
    var positionIncrement: Int? = nil
    
    if let char = state.src.charAt(pos) , !isPossibleNewLineStartCodePoint(char) {
        
        return false
    }
    else {
        
        let newLineLength = state.src.startWithNewLine(atPosition: pos)!
            
        positionIncrement = newLineLength
    }
    
    
    let pmax = state.pendingTextLength - 1
    let max = state.posMax

    // '  \n' -> hardbreak
    // Lookup in pending chars is bad practice! Don't copy to other rules!
    // Pending string is stored in concat mode, indexed lookups will cause
    // convertion to flat mode.
    if !silent {
        
        if let char = state.pending.charAt(pmax), pmax >= 0 && char == 0x20 {
            
            let _char: UTF16.CodeUnit? = pmax >= 1 ? state.pending.charAt(pmax - 1)! : nil
            
            if let _char = _char , _char == 0x20 {
                
                state.setPendingText(state.pending.trimmingCharacters(in: CharacterSet(charactersIn: " ")))
                state.push(.hardbreak, tag: "br", nesting: .selfClosing)
            }
            else {
                
                state.setPendingText(state.pending.slice(0, end: -1)!)
                state.push(.softbreak, tag: "br", nesting: .selfClosing);
            }
            
        }
        else {
            
            state.push(.softbreak, tag: "br", nesting: .selfClosing);
        }
    }
    
    pos += positionIncrement!
    
    // skip heading spaces for next line
    while let char = state.src.charAt(pos), pos < max && isSpace(char) {
        
        pos += 1 
    }
    
    state.pos = pos
    return true
}
