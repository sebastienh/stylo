//
//  entity.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-02.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

//var DIGITAL_RE = /^&#((?:x[a-f0-9]{1,8}|[0-9]{1,8}));/i;
//var NAMED_RE   = /^&([a-z][a-z0-9]{1,31});/i;

// Process html entity - &#123;, &#xAF;, &quot;, ...
func entity(_ state: StateInline, silent: Bool) -> Bool {
    
    let pos = state.pos
    let max = state.posMax
    
    if let char = state.src.charAt(pos) , char != 0x26/* & */ {
        
        return false
    }
    
    if pos + 1 < max {
    
        if let entityMatch = state.src.matchHtmlEntity(fromPosition: pos) {
        
            let entityMatchLength = entityMatch.first!.length

            let codeString = state.src.slice(pos, end: pos + entityMatchLength)!
        
            if let code = codeString.decodeHTML() {
        
                if !silent {
                
                    state.addTextToPendingText(code.string)
                    let segment = state.sourceStringSegmentFromPosition(pos, length: entityMatchLength)!
                    state.pendingRegion.addSourceStringSegment(segment)
                }
                
                state.pos += entityMatchLength
                return true
            }
        }
    }
    
    if !silent {
        
        state.addTextToPendingText("&")
        let segment = state.sourceStringSegmentFromPosition(pos, length: 1)!
        state.pendingRegion.addSourceStringSegment(segment)
    }
    state.pos += 1
    return true
}
