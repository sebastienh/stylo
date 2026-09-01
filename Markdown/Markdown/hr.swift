//
//  hr.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-30.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// Horizontal rule


func hr(_ state: StateBlock, startLine: Int, endLine: Int, silent: Bool) -> Bool {

    var pos = state.bMarks[startLine] + state.tShift[startLine]
    let startPosition = pos
    let max = state.eMarks[startLine]
    
    // if it's indented more than 3 spaces, it should be a code block
    if state.sCount[startLine] - state.blkIndent >= 4 {
        return false
    }
    
    let startPos = pos
    let marker = state.src.charAt(pos)
    pos += 1
    
    if marker == nil {
        
        return  false
    }
    
    // Check hr marker
    if let marker = marker {
        
        if marker != 0x2A/* * */ &&
            marker != 0x2D/* - */ &&
            marker != 0x5F/* _ */ {
                
            return false
        }
    }
    else {
        return false
    }
    
    // markers can be mixed with spaces, but there should be at least 3 of them
    
    var cnt = 1
    
    while pos < max {

        let ch = state.src.charAt(pos)!
        
        pos += 1
        
        if ch != marker && !isSpace(ch) {
        
            return false
        }
        
        if (ch == marker!) {

            cnt += 1
        }
    }
    
    if cnt < 3 {
        
        return false
    }
    
    if silent {
        return true
    }
    
    if state.shouldStopToCompile(from: startPos, tokenType: .hr) {
        return false
    }
    
    state.line = startLine + 1
    
    let hrToken = state.push(.hr, tag: "hr", nesting: .selfClosing)    
    hrToken.startLine = startLine
    hrToken.endLine = state.line
    hrToken.markup = state.src.slice(startPosition, end: pos)!.string
    hrToken.setSourceFragment(SourceStringSegment.Get(startPosition, length: pos - startPosition), for: .All)
    return true
}




