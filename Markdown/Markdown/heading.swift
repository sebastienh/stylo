//
//  heading.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-28.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// heading (#, ##, ...)
func heading(_ state: StateBlock, startLine: Int, endLine: Int, silent: Bool) -> Bool {

    var pos = state.bMarks[startLine] + state.tShift[startLine]
    var max = state.eMarks[startLine]
    
    // if it's indented more than 3 spaces, it should be a code block
    if state.sCount[startLine] - state.blkIndent >= 4 {
        return false
    }
    
    if let char = state.src.charAt(pos), char != 0x23/* # */ || pos >= max {
        return false
    }
    
    let headingStartPosition = pos
    
    // count heading level
    var level = 1
    pos += 1
    var ch = state.src.charAt(pos)
    
    while let _ch = ch, _ch == 0x23/* # */ && pos < max && level <= 6 {
        level += 1
        pos += 1
        ch = state.src.charAt(pos)
    }
    
    if level > 6 || (pos < max && !isSpace(ch!)) {
        return false
    }
    
    if let char = state.src.charAt(pos), isPossibleNewLineStartCodePoint(char) {
        return false
    }

    if pos == max {
        return false
    }
    
    if silent {
        return true
    }
    
    if state.shouldStopToCompile(from: headingStartPosition, tokenType: .headingOpen) {
        return false
    }
    
    // Let's cut tails like '    ###  ' from the end of string
    
    // A closing sequence of `#` characters is optional:
    max = state.skipSpacesBack(max, min: pos)
    let tmp = state.skipCharsBack(max, code: 0x23, min: pos) // #

    let tailLength = max - tmp
    
    if let char = state.src.charAt(tmp - 1), tmp > pos && isSpace(char) {
        max = tmp
    }
    
    state.line = startLine + 1
    
    let headingOpenToken = state.push(.headingOpen, tag: "h\(level)", nesting: .opening)
    headingOpenToken.markup = "########".slice(0, end: level)!
    
    var headingTagRegion = SourceStringRegion()
    headingTagRegion.addSourceStringSegment(SourceStringSegment.Get(headingStartPosition, length: level))
    
    // add the tail to the tag
    if max == tmp {
        let tailSegment = SourceStringSegment.Get(max, length: tailLength)
        if tailSegment.length != 0 {
            headingTagRegion.addSourceStringSegment(tailSegment)
        }
    }
    
    headingOpenToken.setSourceFragment(headingTagRegion, for: .Tag)
    
    var headingWholeContentIncludingTagRegion = SourceStringRegion()
    headingWholeContentIncludingTagRegion.addSourceStringSegment(SourceStringSegment.Get(headingStartPosition, length: max - headingStartPosition))
    
    headingOpenToken.setSourceFragment(headingWholeContentIncludingTagRegion, for: .All)
    
    let inlineToken = state.push(.inline, tag: "", nesting: .selfClosing)
    
    let content = state.src.slice(pos, end: max)
    inlineToken.content  = content?.trimWhitespaces().string ?? ""
    
    var inlineRegion = SourceStringRegion()
    if max - pos > 0 {
        
        let contentSegment = SourceStringSegment.Get(pos, length: max - pos)
        let trimmedContentSegment = contentSegment.trimmed(withString: state.src) as? SourceStringSegment
        
        assert(trimmedContentSegment != nil)
        if let trimmedContentSegment = trimmedContentSegment {
            
            inlineRegion.addSourceStringSegment(trimmedContentSegment)
        }
    }
    inlineToken.setSourceFragment(inlineRegion, for: .All)
    
    let headingCloseToken = state.push(.headingClose, tag: "h\(level)", nesting: .closing)
    headingCloseToken.markup = "########".slice(0, end: level)!
    headingOpenToken.startLine = startLine
    headingCloseToken.endLine = state.line
    return true
}
