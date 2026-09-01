//
//  escape.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-02.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

//var ESCAPED = [];

//for (var i = 0; i < 256; i++) { ESCAPED.push(0); }
//

//.split('').forEach(function(ch) { ESCAPED[ch.charCodeAt(0)] = 1; });


let escaped = "'\\!\"#$%&\'()*+,./:;<=>?@[]^_`{|}~-"

/// Process escaped chars and hardbreaks
func escape(_ state: StateInline, silent: Bool) -> Bool {
    
    var pos = state.pos
    let max = state.posMax
    
    if let char = state.src.charAt(pos) , char != 0x5C/* \ */ {
        
        return false
    }
    
    pos += 1
    
    if pos < max {
        
        var ch = state.src.charAt(pos)!
        
        if escaped.utf16.contains(ch) {
            
            if !silent {
                
                state.addTextToPendingText(String.fromCharCode(state.src.charAt(pos)!))
                let segment = state.sourceStringSegmentFromPosition(state.pos, length: 1)!
                state.pendingRegion.addSourceStringSegment(segment)
            }
            
            state.pos += 2
            return true
        }
        
        if let newLineLength = state.src.startWithNewLine(atPosition: pos) {
            
            if !silent {
                
                state.push(.hardbreak, tag: "br", nesting: .selfClosing)
            }
            
            pos += newLineLength
            
            // skip leading whitespaces from next line
            while pos < max {
                
                ch = state.src.charAt(pos)!
                
                if !isSpace(ch) {
                    
                    break
                }
                pos += 1 
            }
            
            state.pos = pos
            return true
        }
    }
    
    if !silent {
        
        state.addTextToPendingText("\\")
        let segment = state.sourceStringSegmentFromPosition(state.pos, length: 1)
        
        assert(segment != nil)
        if let segment = segment {
            state.pendingRegion.addSourceStringSegment(segment)
        }
    }
    
    state.pos += 1
    return true
}




