//
//  container.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-04-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}


/// container(::: class1 class2 :::)
/// or ":::::: {.class .test name=value #id}  ::::: "
func container(_ state: StateBlock, startLine: Int, endLine: Int, silent: Bool) -> Bool {
    
    // var marker, len, params, nextLine, mem, token, markup,
    var haveEndMarker = false
    var pos = state.bMarks[startLine] + state.tShift[startLine]
    var max = state.eMarks[startLine]
    
    // if it's indented more than 3 spaces, it should be a code block
    if state.sCount[startLine] - state.blkIndent >= 4 {
        return false
    }
    
    if pos + 3 > max {
        return false
    }
    
    let marker = state.src.charAt(pos)
    
    if marker == nil || marker != 0x3A /* : */ {
        
        return false
    }
    
    // scan marker length
    var mem = pos
    pos = state.skipChars(pos, codes: marker!)
    
    let len = pos - mem
    
    if len < 3 {
        return false
    }
    var tagRegion = SourceStringRegion()
    var wholeContainerCodeRegion = SourceStringRegion()
    let markup = state.src.slice(mem, end: pos)
    let openingFenceSegmentStart = SourceStringSegment.Get(mem, length: pos - mem)
    wholeContainerCodeRegion.addSourceStringSegment(openingFenceSegmentStart)
    tagRegion.addSourceStringSegment(openingFenceSegmentStart)
    
    // when returning the parseAttributes function should point either
    // at the next non-space character or the end (max)
    assert(pos == max || state.src.charAt(pos)! != §UnicodeCharacter.lineFeed)
    let attributesBloc = parseAttributes(state.src, pos: &pos, max: max)
    
    // if we don't have attributes it is not a starting indicator
    if let attributesBloc = attributesBloc {
        
        let attributesStartPos = attributesBloc.startPosition
        
        var attributesBlocSegment: SourceStringSegment? = nil
        if max - attributesStartPos > 0 {
            attributesBlocSegment = SourceStringSegment.Get(attributesStartPos, length: pos - attributesStartPos)
            
            assert(attributesBlocSegment != nil)
            if let attributesBlocSegment = attributesBlocSegment {
                wholeContainerCodeRegion.addSourceStringSegment(attributesBlocSegment)
            }
        }
        
        // here there could be spaces...
        pos = state.skipChars(pos, codes: §UnicodeCharacter.whitespace)
        
        // handle the colons
        let colonsStartPosition = pos
        pos = state.skipChars(pos, codes: §UnicodeCharacter.colon)
        let colonsEndPosition = pos
        
        // skip the rest of the whitespaces...
        pos = state.skipChars(pos, codes: §UnicodeCharacter.whitespace)
        
        if pos != max {
            return false
        }
        
        // add the ending
        if colonsEndPosition - colonsStartPosition > 0 {
            let openingFenceSegmentEnd = SourceStringSegment.Get(colonsStartPosition, length: colonsEndPosition - colonsStartPosition)
            wholeContainerCodeRegion.addSourceStringSegment(openingFenceSegmentEnd)
            tagRegion.addSourceStringSegment(openingFenceSegmentEnd)
        }
        
        var endingFenceSegment: SourceStringSegment?
        
        // Since start is found, we can report success here in validation mode
        if silent {
            return true
        }
        
        if state.shouldStopToCompile(from: mem, tokenType: .containerOpen) {
            return false
        }
        
        // search end of block
        var nextLine = startLine
        var openedFences = 0
        
        while true {
    
            nextLine += 1
            if nextLine >= endLine {
    
                // unclosed block should be autoclosed by end of document.
                // also block seems to be autoclosed by end of parent
                break
            }
    
            pos = state.bMarks[nextLine] + state.tShift[nextLine]
            mem = state.bMarks[nextLine] + state.tShift[nextLine]
            max = state.eMarks[nextLine]
    
            if pos < max && state.sCount[nextLine] < state.blkIndent {
    
                // non-empty line with negative indent should stop the list:
                // - ```
                //  test
                break
            }
    
            if let char = state.src.charAt(pos), char != §UnicodeCharacter.colon {
                continue
            }
    
            if state.sCount[nextLine] - state.blkIndent >= 4 {
    
                // closing fence should be indented less than 4 spaces
                continue
            }
    
            // we can have an opening or a closing fence
            // test for opening
            if container(state, startLine: nextLine, endLine: nextLine+1, silent: true) {
                openedFences += 1
                continue
            }
            else {
            
                pos = state.skipChars(pos, codes: §UnicodeCharacter.colon)
        
                // closing code fence must be at least length 3
                if pos - mem < 3 {
                    continue
                }
        
                // make sure tail has spaces only
                pos = state.skipSpaces(pos)
        
                if pos < max {
                    continue
                }
        
                // unstack one opening fence
                if openedFences > 0 {
                    openedFences -= 1
                    continue
                }
                else {
                    
                    assert(openedFences == 0)
                    endingFenceSegment = SourceStringSegment.Get(mem, length: pos - mem)
                    haveEndMarker = true
                    // found!
                    break
                }
            }
        }
        
        // put the attributes token on top of the container
        
        let contentEnd = state.line - 1
        
        let containerOpenToken = state.push(.containerOpen, tag: "div", nesting: .opening)
        
        let (content, _, contentRegion) = state.getLines(startLine + 1, end: contentEnd, indent: 0, keepLastLF: true, generateRegion: true)
        containerOpenToken.content = content.string
        containerOpenToken.markup  = markup!.string
        
        containerOpenToken.setSourceFragment(contentRegion, for: .Content)
        if let sourceStringSegments = contentRegion?.sourceStringSegments {
            
            for sourceStringSegment in sourceStringSegments {
                wholeContainerCodeRegion.addSourceStringSegment(sourceStringSegment)
            }
        }
        
        if let endingFenceSegment = endingFenceSegment {
            wholeContainerCodeRegion.addSourceStringSegment(endingFenceSegment)
            tagRegion.addSourceStringSegment(endingFenceSegment)
        }
    
        containerOpenToken.setSourceFragment(wholeContainerCodeRegion, for: .All)
        containerOpenToken.setSourceFragment(tagRegion, for: .Tag)
        
        // save old state
        let oldBMark = state.bMarks[startLine]
        let oldTShift = state.tShift[startLine]
        let oldEMark = state.eMarks[startLine]
        let oldLineMax = state.lineMax
        
        let oldIndent = state.blkIndent
        state.blkIndent = 0
        
        state.bMarks[startLine] = attributesStartPos
        state.tShift[startLine] = 0
        
        // should end before the next ":" if any
        if let endingFenceSegment = endingFenceSegment {
            state.eMarks[nextLine] = endingFenceSegment.endIndex
        }
        
        state.lineMax = nextLine
        state.allowClassNamesAttributesBlock = true
        state.md.block.tokenize(state, startLine: startLine, endLine: nextLine)
        
        let containerCloseToken = state.push(.containerClose, tag: "div", nesting: .closing)
        
        // restore old state
        state.bMarks[startLine] = oldBMark
        state.tShift[startLine] = oldTShift
        state.eMarks[startLine] = oldEMark
        state.blkIndent = oldIndent
        state.lineMax = oldLineMax
        
        state.line = nextLine + (haveEndMarker ? 1 : 0)
        containerOpenToken.startLine = startLine
        containerCloseToken.endLine = state.line
        return true
    }
    else {
        
        return false
    }
}
