//
//  list.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-01.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// Lists

// Search `[-+*][\n ]`, returns next pos after marker on success
// or nil on fail.
func skipBulletListMarker(_ state: StateBlock, startLine: Int) -> Int? {
    
    var pos = state.bMarks[startLine] + state.tShift[startLine]
    let max = state.eMarks[startLine]
    
    let marker = state.src.charAt(pos)!
    pos += 1
    
    // Check bullet
    if marker != 0x2A/* * */ &&
        marker != 0x2D/* - */ &&
        marker != 0x2B/* + */ {
        return nil
    }
    
    if pos < max {
        
        let ch = state.src.charAt(pos)!
        
        if !isSpace(ch) {
            
            // " -test " - is not a list item
            return nil
        }
    }
    
    return pos
}

// Search `\d+[.)][\n ]`, returns next pos after marker on success
// or -1 on fail.
func skipOrderedListMarker(_ state: StateBlock, startLine: Int) -> (Int, Int)? {
    
    //    var ch,
    let start = state.bMarks[startLine] + state.tShift[startLine]
    var pos = start
    let max = state.eMarks[startLine]
    
    // List marker should have at least 2 chars (digit + dot)
    if pos + 1 >= max {
        
        return nil
    }
    
    var ch = state.src.charAt(pos)!
    
    pos += 1
    
    if ch < 0x30/* 0 */ || ch > 0x39/* 9 */ {
        
        return nil
    }
    
    let startPosition = pos - 1
    
    while true {
        
        // EOL -> fail
        if pos >= max {
            
            return nil
        }
        
        ch = state.src.charAt(pos)!
        
        pos += 1
        
        if ch >= 0x30/* 0 */ && ch <= 0x39/* 9 */ {
            
            // List marker should have no more than 9 digits
            // (prevents integer overflow in browsers)
            if pos - start >= 10 {
                
                return nil
            }
            
            continue
        }
        
        // found valid marker
        if ch == 0x29/* ) */ || ch == 0x2e/* . */ {
            
            break
        }
        
        return nil
    }
    
    
    if pos < max {
        
        ch = state.src.charAt(pos)!
        
        if !isSpace(ch) {
            
            // " 1.test " - is not a list item
            return nil
        }
    }
    
    return (startPosition, pos)
}

func markTightParagraphs(_ state: StateBlock, idx: Int) {
    
    let l = state.tokens.length - 2
    let level = state.level + 2
    var i = idx + 2
    
    while i < l {
        
        if state.tokens[i]!.level == level && state.tokens[i]!.type == .paragraphOpen {
            
            state.tokens[i + 2]!.hidden = true
            state.tokens[i]!.hidden = true
            i += 2
        }
        
        i += 1
    }
}


func list(_ state: StateBlock, startLine: Int, endLine: Int, silent: Bool) -> Bool {
    
    var tight = true
    var isTerminatingParagraph = false
    var localStartLine = startLine
    var posAfterMarker: Int!
    var startOfMarkerPosition: Int!
    var isOrdered: Bool = false
    var markerValue: Int?
    
    // if it's indented more than 3 spaces, it should be a code block
    if state.sCount[startLine] - state.blkIndent >= 4 {
        return false
    }
    
    // limit conditions when list can interrupt
    // a paragraph (validation mode only)
    if silent && state.parentType == .paragraph {
        
        // Next list item should still terminate previous list item;
        //
        // This code can fail if plugins use blkIndent as well as lists,
        // but I hope the spec gets fixed long before that happens.
        //
        if state.tShift[startLine] >= state.blkIndent {
            isTerminatingParagraph = true
        }
    }
    
    var wholeListRegion = SourceStringRegion()
    
    // Detect list type and position after marker
    if let pos = skipOrderedListMarker(state, startLine: localStartLine) {
        
        startOfMarkerPosition = pos.0
        posAfterMarker = pos.1
        isOrdered = true
        
        let start = state.bMarks[startLine] + state.tShift[startLine]
        let numberString = state.src.substr(start, end: posAfterMarker - 1)
        
        assert(numberString != nil)
        if let numberString = numberString {
            
            markerValue = Int(numberString.string)
            
            // a paragraph, it should start with 1.
            if isTerminatingParagraph && markerValue != 1 {
                return false
            }
        }
    }
    else if let pos = skipBulletListMarker(state, startLine: localStartLine) {
        
        startOfMarkerPosition = pos - 1
        posAfterMarker = pos
        isOrdered = false
    }
    else {
        return false
    }
    
    // If we're starting a new unordered list right after
    // a paragraph, first line should not be empty.
    if isTerminatingParagraph {
        
        if state.skipSpaces(posAfterMarker) >= state.eMarks[startLine] {
            return false
        }
    }
    
    // We should terminate list on style change. Remember first one to compare.
    let markerCharCode = state.src.charAt(posAfterMarker - 1)!
    
    // For validation mode we can terminate immediately
    if silent {
        
        return true
    }
    
    // Start list
    let listTokIdx = state.tokens.length
    
    var listToken: Token
    var token: Token
    let start = state.bMarks[startLine]
    
    if isOrdered {
        
        if state.shouldStopToCompile(from: start, tokenType: .orderedListOpen) {
            return false
        }
        
        listToken = state.push(.orderedListOpen, tag: "ol", nesting: .opening)
        
        assert(markerValue != nil)
        if let markerValue = markerValue, markerValue != 1 {
            
            listToken.attrs = [ ("start", "\(markerValue)")]
        }
    }
    else {
        
        if state.shouldStopToCompile(from: start, tokenType: .bulletListOpen) {
            return false
        }
        
        listToken = state.push(.bulletListOpen, tag: "ul", nesting: .opening)
    }
    
    listToken.markup = String.fromCharCode(markerCharCode)
    
    var listLines = (localStartLine, 0)
    
    //
    // Iterate list items
    //
    var nextLine = localStartLine
    var prevEmptyEnd = false
    let terminatorRules = state.md.block.ruler.getRules(§BlockTokenizeRule.List)
    
    let oldParentType = state.parentType
    state.parentType = .list
    
    while nextLine < endLine {
        
        var pos = posAfterMarker!
        let max = state.eMarks[nextLine]
        
        var offset = state.sCount[nextLine] + posAfterMarker - (state.bMarks[localStartLine] + state.tShift[localStartLine])
        let initial = offset
        
        //
        // Regions that we should record position information about...
        //
        // var wholeListItemRegion = SourceStringRegion()
        // var tagListItemRegion = SourceStringRegion()
        
        while pos < max {
            let ch = state.src.charAt(pos)!
            
            if ch == 0x09 {
                offset += 4 - (offset + state.bsCount[nextLine]) % 4
            }
            else if ch == 0x20 {
                offset += 1
            }
            else {
                break
            }
            
            pos += 1
        }
        
        var contentStart = pos
        
        var indentAfterMarker: Int
        
        if contentStart >= max {
            
            // trimming space in "-    \n  3" case, indent is 1 here
            indentAfterMarker = 1
        }
        else {
            
            indentAfterMarker = offset - initial
        }
        
        // If we have more than 4 spaces, the indent is 1
        // (the rest is just indented code block)
        if indentAfterMarker > 4 {
            
            indentAfterMarker = 1
        }
        
        // "  -  test"
        //  ^^^^^ - calculating total length of this thing
        let indent = initial + indentAfterMarker
        
        // Run subparser & write tokens
        let listItemOpenToken = state.push(.listItemOpen, tag: "li", nesting: .opening)
        listItemOpenToken.markup = String.fromCharCode(markerCharCode)
        var itemLines = (localStartLine, 0)
        
        let oldIndent = state.blkIndent
        let oldTight = state.tight
        let oldTShift = state.tShift[localStartLine]
        let oldLIndent = state.sCount[localStartLine]
        
        state.blkIndent = indent
        state.tight = true
        state.tShift[localStartLine] = contentStart - state.bMarks[localStartLine]
        state.sCount[localStartLine] = offset
        
        // the original adds a true at the end, but the function does not takes
        // Bool argument, I assume it is an error.
        if contentStart >= max && state.isEmpty(localStartLine + 1) {
            
            // workaround for this case
            // (list item is empty, list terminates before "foo"):
            // ~~~~~~~~
            //   -
            //
            //     foo
            // ~~~~~~~~
            state.line = min(state.line + 2, endLine)
        }
        else {
            
            state.md.block.tokenize(state, startLine: localStartLine, endLine: endLine)
        }
        
        // If any of list item is tight, mark list as tight
        if !state.tight || prevEmptyEnd {
            
            tight = false
        }
        
        // Item become loose if finish with empty line,
        // but we should filter last element, because it means list finish
        prevEmptyEnd = (state.line - localStartLine) > 1 && state.isEmpty(state.line - 1);
        
        state.blkIndent = oldIndent;
        state.tShift[localStartLine] = oldTShift
        state.sCount[localStartLine] = oldLIndent;
        state.tight = oldTight;
        
        token = state.push(.listItemClose, tag: "li", nesting: .closing)
        token.markup = String.fromCharCode(markerCharCode);
        
        localStartLine = state.line
        nextLine = state.line
        itemLines.1 = nextLine
        contentStart = state.bMarks[localStartLine]
        
        listItemOpenToken.setSourceFragment(state.regionFromSource(itemLines.0, end: itemLines.1, indent: state.blkIndent, keepLastLF: false), for: .All)
        listItemOpenToken.setSourceFragment(state.sourceStringSegmentFromPosition(startOfMarkerPosition, length: posAfterMarker - startOfMarkerPosition), for: .Tag)
        
        wholeListRegion = wholeListRegion + (listItemOpenToken.sourceFragment(for: .All)! as! SourceStringRegion)
        listToken.setSourceFragment(wholeListRegion, for: .All)
        
        if nextLine >= endLine {
            break
        }
        
        //
        // Try to check if list is terminated or continued.
        //
        if state.sCount[nextLine] < state.blkIndent {
            break
        }
        
        // fail if terminating block found
        var terminate = false
        
        for blockRuleFunction in terminatorRules {
            
            if blockRuleFunction.fn(state, nextLine, endLine, true) {
                
                terminate = true
                break
            }
        }
        
        if terminate {
            
            break
        }
        
        // fail if list has another type
        if isOrdered {
            
            // Detect position before and after marker
            if let _posAfterMarker = skipOrderedListMarker(state, startLine: localStartLine) {
                
                startOfMarkerPosition = _posAfterMarker.0
                posAfterMarker = _posAfterMarker.1
            }
            else {
                
                break
            }
        }
        else {
            
            posAfterMarker = skipBulletListMarker(state, startLine: nextLine)
            
            if posAfterMarker == nil {
                
                break
            }
            
            startOfMarkerPosition = posAfterMarker - 1
        }
        
        if markerCharCode != state.src.charAt(posAfterMarker - 1) {
            
            break
        }
    }
    
    // Finalize list
    if isOrdered {
        
        token = state.push(.orderedListClose, tag: "ol", nesting: .closing)
    }
    else {
        
        token = state.push(.bulletListClose, tag: "ul", nesting: .closing);
    }
    token.markup = String.fromCharCode(markerCharCode);
    
    listLines.1 = nextLine
    
    listToken.setSourceFragment(state.regionFromSource(listLines.0, end: listLines.1, indent: state.blkIndent, keepLastLF: false), for: .Content)
    
    listToken.markup = String.fromCharCode(markerCharCode)
    state.line = nextLine
    
    state.parentType = oldParentType
    
    // mark paragraphs tight if needed
    if tight {
        
        markTightParagraphs(state, idx: listTokIdx)
    }
    
    listToken.startLine = startLine
    token.endLine = state.line
    return true
}



