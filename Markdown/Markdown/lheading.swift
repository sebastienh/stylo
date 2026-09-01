//
//  lheading.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-01.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common


/// lheading (---, ===)
func lheading(_ state: StateBlock, startLine: Int, endLine: Int, silent: Bool) -> Bool {
    
    var nextLine = startLine + 1
    var level: Int? = nil
    var marker: UTF16.CodeUnit?
    let oldParentType = state.parentType
    state.parentType = .paragraph
    
    let terminatorRules = state.md.block.ruler.getRules("paragraph")
    
    // if it's indented more than 3 spaces, it should be a code block
    if state.sCount[startLine] - state.blkIndent >= 4 {
        return false
    }
    
    var tagRegion = SourceStringRegion()
    
    // jump line-by-line until empty one or EOF
    while nextLine < endLine && !state.isEmpty(nextLine) {
        
        // this would be a code block normally, but after paragraph
        // it's considered a lazy continuation regardless of what's there
        if (state.sCount[nextLine] - state.blkIndent > 3) {
            
            nextLine += 1
            continue
        }
        
        //
        // Check for underline in setext header
        //
        if (state.sCount[nextLine] >= state.blkIndent) {
            
            var pos = state.bMarks[nextLine] + state.tShift[nextLine]
            let max = state.eMarks[nextLine]
            
            if pos < max {
                
                marker = state.src.charAt(pos)!
                
                if (marker == 0x2D/* - */ || marker == 0x3D/* = */) {
                    
                    let tagStartPos = pos
                    
                    pos = state.skipChars(pos, codes: marker!)
                    
                    let tagSegment = SourceStringSegment(startIndex: tagStartPos, endIndex: pos)
                    tagRegion.addSourceStringSegment(tagSegment)
                    
                    pos = state.skipSpaces(pos)
                    
                    if let char = state.src.charAt(pos), char == §UnicodeCharacter.lineFeed {
                        pos += 1
                    }
                    
                    if pos >= max {
                        
                        level = marker == 0x3D/* = */ ? 1 : 2
                        break
                    }
                }
            }
        }
        
        // quirk for blockquotes, this line should already be checked by that rule
        if state.sCount[nextLine] < 0 {
            
            nextLine += 1
            continue
        }
        
        // Some tags can terminate paragraph without empty line.
        var terminate = false
        
        for terminatorRule in terminatorRules {
            
            if terminatorRule.fn(state, nextLine, endLine, true) {
                
                terminate = true
                break
            }
        }
        
        if terminate {
            
            break
        }
        
        nextLine += 1
    }
    
    if level == nil {
        
        // Didn't find valid underline
        return false
    }
    
    let (content, _, region) = state.getLines(startLine, end: nextLine, indent: state.blkIndent, keepLastLF: false, generateRegion: true)
    
    state.line = nextLine + 1
    
    let wholeRegion = region != nil ? region! + tagRegion : tagRegion
    
    let startIndex = wholeRegion.range?.lowerBound
    
    assert(startIndex != nil)
    if let startIndex = startIndex, state.shouldStopToCompile(from: startIndex, tokenType: .headingOpen) {
        return false
    }
    
    let headingOpenToken = state.push(.headingOpen, tag: "h\(level!)", nesting: .opening)
    headingOpenToken.markup = String(describing: UnicodeScalar(marker!)!)
    
    let inlineToken = state.push(.inline, tag: "", nesting: .selfClosing)
    inlineToken.content  = content.trimWhitespaces().string
    
    headingOpenToken.setSourceFragment(wholeRegion, for: .All)
    inlineToken.setSourceFragment(wholeRegion, for: .All)
    headingOpenToken.setSourceFragment(tagRegion, for: .Tag)
    
    let headingCloseToken = state.push(.headingClose, tag: "h\(level!)", nesting: .closing)
    headingCloseToken.markup   = String(describing: UnicodeScalar(marker!)!)

    headingOpenToken.startLine = startLine
    headingCloseToken.endLine = state.line
    
    state.parentType = oldParentType
    
    return true
}




