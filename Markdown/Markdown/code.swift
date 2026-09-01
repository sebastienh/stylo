//
//  code.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-29.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// Code block (4 spaces padded)
func code(_ state: StateBlock, startLine: Int, endLine: Int, silent: Bool) -> Bool {
    
    if state.sCount[startLine] - state.blkIndent < 4 {
        
        return false
    }
    
    var last = startLine + 1
    var nextLine = startLine + 1
    
    while nextLine < endLine {
        
        if state.isEmpty(nextLine) {
            
            nextLine += 1
            continue
        }
        
        if state.sCount[nextLine] - state.blkIndent >= 4 {
            
            nextLine += 1
            last = nextLine
            continue
        }
        break
    }
    
    state.line = last
    
    // for the content we want to indent 4+ ...
    let (content, _, _) = state.getLines(startLine, end: last, indent: 4 + state.blkIndent, keepLastLF: true, generateRegion: false)
    
    // ... but for the region we want everything, even the starting spaces, for retriving
    // them when we want to partially compile.
    let (_, _, region) = state.getLines(startLine, end: last, indent: state.blkIndent, keepLastLF: true, generateRegion: true)
    
    let startIndex = region?.range?.lowerBound
    
    assert(startIndex != nil)
    if let startIndex = startIndex, state.shouldStopToCompile(from: startIndex, tokenType: .codeBlock) {
        return false
    }
    
    let codeBlocktoken = state.push(.codeBlock, tag: "code", nesting: .selfClosing)
    codeBlocktoken.startLine = startLine
    codeBlocktoken.endLine = state.line
    codeBlocktoken.content = content.string
    codeBlocktoken.setSourceFragment(region, for: .All)
    return true
}

