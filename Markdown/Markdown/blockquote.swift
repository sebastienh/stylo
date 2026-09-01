//
//  blockquote.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-26.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// Block quotes
func blockquote(_ state: StateBlock, startLine: Int, endLine: Int, silent: Bool) -> Bool {
    
    let oldLineMax = state.lineMax
    var pos = state.bMarks[startLine] + state.tShift[startLine]
    var max = state.eMarks[startLine]
    
    // if it's indented more than 3 spaces, it should be a code block
    if state.sCount[startLine] - state.blkIndent >= 4 {
        return false
    }
    
    var adjustTab: Bool = false
    var spaceAfterMarker: Bool = false
    
    /// Tag Region management
    var tagRegion = SourceStringRegion()
    
    // check the block quote marker
    if let char = state.src.charAt(pos) , char != 0x3E /* > */ {
        return false
    }
    
    tagRegion.addSourceStringSegment(SourceStringSegment.Get(pos, length: 1))
    let startPos = pos
    pos += 1
    
    // we know that it's going to be a valid blockquote,
    // so no point trying to find the end of it in silent mode
    if silent {
        return true
    }
    
    if state.shouldStopToCompile(from: startPos, tokenType: .blockquoteOpen) {
        return false
    }
    
    // skip spaces after ">" and re-calculate offset
    let newOffset = state.tShift[startLine] + pos - (state.bMarks[startLine] + state.tShift[startLine])
    
    var initial = newOffset
    var offset = newOffset
    
    // skip one optional space after '>'
    if state.src.charAt(pos) == 0x20 /* space */ {
        // ' >   test '
        //     ^ -- position start of line here:
        pos += 1
        initial += 1
        offset += 1
        adjustTab = false
        spaceAfterMarker = true
    }
    else if state.src.charAt(pos) == 0x09 /* tab */ {
        
        spaceAfterMarker = true
        if ((state.bsCount[startLine] + offset) % 4 == 3) {
            // '  >\t  test '
            //       ^ -- position start of line here (tab has width===1)
            pos += 1
            initial += 1
            offset += 1
            adjustTab = false
        }
        else {
            // ' >\t  test '
            //    ^ -- position start of line here + shift bsCount slightly
            //         to make extra space appear
            adjustTab = true
        }
    }
    else {
        
        spaceAfterMarker = false
    }
    
    var oldBMarks = [state.bMarks[startLine]]
    state.bMarks[startLine] = pos
    
    while pos < max {
        
        let ch = state.src.charAt(pos)!
        
        if isSpace(ch) {
            
            if ch == 0x09 {
                
                offset += 4 - (offset + state.bsCount[startLine] + (adjustTab ? 1 : 0)) % 4
            }
            else {
            
                offset += 1
            }
        }
        else {

            break
        }
        
        pos += 1
    }
    
    var oldBSCount = [state.bsCount[startLine]]
    state.bsCount[startLine] = state.sCount[startLine] + 1 + (spaceAfterMarker ? 1 : 0)
    
    var lastLineEmpty = pos >= max
    
    var oldSCount = [state.sCount[startLine]]
    state.sCount[startLine] = offset - initial
    
    var oldTShift = [state.tShift[startLine]]
    state.tShift[startLine] = pos - state.bMarks[startLine]
    
    let terminatorRules = state.md.block.ruler.getRules(BlockTokenizeRule.BlockQuote.rawValue)
    
    let oldParentType = state.parentType
    state.parentType = .blockquote
    var wasOutdented = false
    
    // Search the end of the block
    //
    // Block ends with either:
    //  1. an empty line outside:
    //     ```
    //     > test
    //
    //     ```
    //  2. an empty line inside:
    //     ```
    //     >
    //     test
    //     ```
    //  3. another tag:
    //     ```
    //     > test
    //      - - -
    //     ```
    
    var nextLine = startLine + 1
    
    while nextLine < endLine {
        
        // check if it's outdented, i.e. it's inside list item and indented
        // less than said list item:
        //
        // ```
        // 1. anything
        //    > current blockquote
        // 2. checking this line
        // ```
        if state.sCount[nextLine] < state.blkIndent {
            wasOutdented = true
        }
        
        pos = state.bMarks[nextLine] + state.tShift[nextLine]
        max = state.eMarks[nextLine]
        
        if pos >= max {
            
            // Case 1: line is not inside the blockquote, and this line is empty.
            break
        }
        
        if let chat = state.src.charAt(pos), chat == 0x3E/* > */ && !wasOutdented {
            
            let segment = SourceStringSegment.Get(pos, length: 1)
            tagRegion.addSourceStringSegment(segment)
            
            pos += 1
            
            // This line is inside the blockquote.
            
            
            // skip spaces after ">" and re-calculate offset
            let _newOffset = state.sCount[nextLine] + pos - (state.bMarks[nextLine] + state.tShift[nextLine])
            initial = _newOffset
            offset = _newOffset
            
            // skip one optional space after '>'
            if (state.src.charAt(pos) == 0x20 /* space */) {
                // ' >   test '
                //     ^ -- position start of line here:
                pos += 1
                initial += 1
                offset += 1
                adjustTab = false
                spaceAfterMarker = true
            }
            else if state.src.charAt(pos) == 0x09 /* tab */ {
                
                spaceAfterMarker = true
                if (state.bsCount[nextLine] + offset) % 4 == 3 {
                   
                    // '  >\t  test '
                    //       ^ -- position start of line here (tab has width===1)
                    pos += 1
                    initial += 1
                    offset += 1
                    adjustTab = false
                }
                else {
                
                    // ' >\t  test '
                    //    ^ -- position start of line here + shift bsCount slightly
                    //         to make extra space appear
                    adjustTab = true
                }
            } else {
                
                spaceAfterMarker = false
            }
            
            oldBMarks.append(state.bMarks[nextLine])
            state.bMarks[nextLine] = pos
            
            while pos < max {
                
                let ch = state.src.charAt(pos)!
                
                if isSpace(ch) {
                    
                    if ch == 0x09 {
                        offset += 4 - (offset + state.bsCount[nextLine] + (adjustTab ? 1 : 0)) % 4;
                    }
                    else {
                        offset += 1
                    }
                }
                else {
                    break
                }
                pos += 1
            }
            
            lastLineEmpty = pos >= max
            
            oldBSCount.append(state.bsCount[nextLine])
            state.bsCount[nextLine] = state.sCount[nextLine] + 1 + (spaceAfterMarker ? 1 : 0)
            
            oldSCount.append(state.sCount[nextLine])
            state.sCount[nextLine] = offset - initial
            
            oldTShift.append(state.tShift[nextLine])
            state.tShift[nextLine] = pos - state.bMarks[nextLine]
            nextLine += 1
            continue
        }
        
        // Case 2: line is not inside the blockquote, and the last line was empty.
        if lastLineEmpty {
            
            break
        }
        
        // Case 3: another tag found.
        var terminate = false
        
        for terminatorRule in terminatorRules {
            
            if terminatorRule.fn(state, nextLine, endLine, true) {
                
                terminate = true
                break
            }
        }
        if terminate {
            
            // Quirk to enforce "hard termination mode" for paragraphs;
            // normally if you call `tokenize(state, startLine, nextLine)`,
            // paragraphs will look below nextLine for paragraph continuation,
            // but if blockquote is terminated by another tag, they shouldn't
            state.lineMax = nextLine
            if state.blkIndent != 0 {
                
                // state.blkIndent was non-zero, we now set it to zero,
                // so we need to re-calculate all offsets to appear as
                // if indent wasn't changed
                oldBMarks.append(state.bMarks[nextLine])
                oldBSCount.append(state.bsCount[nextLine])
                oldTShift.append(state.tShift[nextLine])
                oldSCount.append(state.sCount[nextLine])
                state.sCount[nextLine] -= state.blkIndent
            }
            break
        }
        
        oldBMarks.append(state.bMarks[nextLine])
        oldBSCount.append(state.bsCount[nextLine])
        oldTShift.append(state.tShift[nextLine])
        oldSCount.append(state.sCount[nextLine])
        
        // A negative indentation means that this is a paragraph continuation
        //
        state.sCount[nextLine] = -1
        
        nextLine += 1
    }
    
    let oldIndent = state.blkIndent
    state.blkIndent = 0
    
    let blockQuoteOpenToken = state.push(.blockquoteOpen, tag: "blockquote", nesting: .opening)
    blockQuoteOpenToken.markup = ">"
    
    state.md.block.tokenize(state, startLine: startLine, endLine: nextLine)
    
    // Restore original tShift; this might not be necessary since the parser
    // has already been here, but just to make sure we can do that.
    for i in 0..<oldTShift.count {
        
        state.bMarks[i + startLine] = oldBMarks[i]
        state.tShift[i + startLine] = oldTShift[i]
        state.sCount[i + startLine] = oldSCount[i]
        state.bsCount[i + startLine] = oldBSCount[i]
    }
    
    state.blkIndent = oldIndent
    
    ///
    /// Update Regions
    ///
    let allRegion = state.regionFromSource(startLine, end: nextLine, indent: state.blkIndent, keepLastLF: true)
    blockQuoteOpenToken.setSourceFragment(allRegion, for: .All)
    blockQuoteOpenToken.setSourceFragment(tagRegion, for: .Tag)
    
    let blockQuoteCloseToken = state.push(.blockquoteClose, tag: "blockquote", nesting: Nesting.closing)
    blockQuoteCloseToken.markup = ">"
    
    state.lineMax = oldLineMax
    state.parentType = oldParentType
    blockQuoteOpenToken.startLine = startLine
    blockQuoteCloseToken.endLine = state.line    
    return true
}
