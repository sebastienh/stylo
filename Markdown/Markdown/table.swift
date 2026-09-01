//
//  table.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-03.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os

/// GFM(GitHub Flavored) table, non-standard

fileprivate func trimLeadingAndEndingVerticalBars(from string: String) -> String {
    
    var trimmedLineText = string
    if trimmedLineText.starts(with: "|") {
        trimmedLineText.removeFirst()
    }
    if trimmedLineText.endsWith("|") {
        trimmedLineText.removeLast()
    }
    return trimmedLineText
}


func getLine(_ state: StateBlock, line: Int) -> (line: String, start: Int, end: Int)? {
    
    let (pos, max) = getLineStartAndEndIndex(state, line: line)
    
    let string = state.src.slice(pos, end: max)?.string
    
    if string == nil {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) &&  DEBUG
        os_log("pos: %@", log: Log.Markdown.all, type: .debug, %%pos)
        os_log("max: %@", log: Log.Markdown.all, type: .debug, %%max)
        os_log("blkIndent: %@", log: Log.Markdown.all, type: .debug, %%state.blkIndent)
        
        os_log("length: %@", log: Log.Markdown.all, type: .debug, %%state.src.utf16.count)
        assert(false, "Error while getting the string")
        #endif
        return nil
    }
    
    return (string!, pos, max)
}

///
/// Return all the text segments in a specific line
///
func getTextSegments(_ state: StateBlock, line: Int, separator: UTF16.CodeUnit) -> (text: [SourceStringSegment], tag: [SourceStringSegment]) {

    let (start, end) = getLineStartAndEndIndex(state, line: line)

    var textSegmentsArray = [SourceStringSegment]()
    var tagsSegmentsArray = [SourceStringSegment]()
    
    var i = start
    
    while i <= end {
        
        // we may not have a separator at the start of the line
        if let char = state.src.charAt(i), char == separator || i == start {
            
            if char == separator {
                tagsSegmentsArray.append(SourceStringSegment(startIndex: i, endIndex: i+1))
                i += 1
            }
            
            if i != end {
            
                if let segment = getTextSegment(state, startIndex: i, endIndex: end, separator: separator /* §UnicodeCharacter.verticalLine */) {
                
                    assert(segment.endIndex <= end)
                    textSegmentsArray.append(segment)
                    i += segment.length
                }
            }
            else {
                break
            }
            if i == start && char != separator {
                i += 1
            }
        }
        else {
            i += 1
        }
    }
    return (textSegmentsArray, tagsSegmentsArray)
}

///
/// This method assumes that we are afer the first separator and look for the end separator
/// to identify the text segment.
///
func getTextSegment(_ state: StateBlock, startIndex: Int, endIndex: Int, separator: UTF16.CodeUnit) -> SourceStringSegment? {
    
    var pendingEscape: Int?
    
    for i in startIndex...endIndex {
        
        if i == endIndex {
            
            return SourceStringSegment(startIndex: startIndex, endIndex: i)
        }
        
        if let char = state.src.charAt(i) {
        
            if char == separator {
            
                // make sure it's not an escaped character, if it's no the case we
                // create the end CodePointIndex and return it.
                if pendingEscape == nil {
                
                    return SourceStringSegment(startIndex: startIndex, endIndex: i)
                }
                else {
                    pendingEscape = nil
                }
            }
            else if char == 0x5c /* §UnicodeCharacter.reverseSolidus */  {
                
                if pendingEscape == nil {
                    pendingEscape = i
                }
                else {
                    pendingEscape = nil
                }
            }
            else {
            
                if pendingEscape != nil {
                    pendingEscape = nil
                }
            }
        }
        else if state.src.startWithNewLine(atPosition: i) != nil {
            
            return SourceStringSegment(startIndex: startIndex, endIndex: i)
        }
    }
    return nil
}

func getLineStartAndEndIndex(_ state: StateBlock, line: Int) -> (start: Int, end: Int) {
    
    let pos = state.bMarks[line] + state.blkIndent
    let max = state.eMarks[line]
    
    assert(pos >= 0, "pos: \(pos)")
    assert(pos <= state.src.length, "pos: \(pos), length: \(state.src.length)")
    assert(max <= state.src.length, "max: \(max), length: \(state.src.length)")
//    assert(max - pos >= 0, "max: \(max), pos: \(pos)")
    if max < pos {
        // this line is empty for the considered block...
        return (pos, pos)
    }
    return (pos, max)
}

func escapedSplit(_ str: String) -> [String]{
    
    var result = [String]()
    var pos = 0
    let max = str.length

    var escapes = 0
    var lastPos = 0
    var backTicked = false
    var lastBackTick = 0
    
    var ch: UTF16Char?  = str.charAt(pos)
    
    while pos < max {
        
        if ch == 0x60/* ` */ {
            
            if backTicked {
                
                // make \` close code sequence, but not open it;
                // the reason is: `\` is correct code block
                backTicked = false
                lastBackTick = pos
            }
            else if escapes % 2 == 0 {
                backTicked = true
                lastBackTick = pos
            }
        }
        else if ch == 0x7c/* | */ && (escapes % 2 == 0) && !backTicked {
            
            result.append(str.substr(lastPos, end: pos)!)
            lastPos = pos + 1
        }
        
        if ch == 0x5c/* \ */ {
            escapes += 1
        }
        else {
            escapes = 0
        }
        
        pos += 1
        
        // If there was an un-closed backtick, go back to just after
        // the last backtick, but as if it was a normal character
        if pos == max && backTicked {
            
            backTicked = false
            pos = lastBackTick + 1
        }
        
        ch = str.charAt(pos)
    }
    
    result.append(str.slice(lastPos) ?? "")
    
    return result
}


func table(_ state: StateBlock, startLine: Int, endLine: Int, silent: Bool) -> Bool {
    
    // should have at least two lines
    if startLine + 2 > endLine {
        return false
    }
    
    var nextLine = startLine + 1
    
    if state.sCount[nextLine] < state.blkIndent {
        return false
    }
    
    // if it's indented more than 3 spaces, it should be a code block
    if state.sCount[nextLine] - state.blkIndent >= 4 {
        return false
    }
    
    // first character of the second line should be '|', '-', ':',
    // and no other characters are allowed but spaces;
    // basically, this is the equivalent of /^[-:|][-:|\s]*$/ regexp
    var pos = state.bMarks[nextLine] + state.tShift[nextLine]
    if pos >= state.eMarks[nextLine] {
        return false
    }
    
    var wholeTableRegion = SourceStringRegion()
    var tagRegion = SourceStringRegion()
    
    let ch = state.src.charAt(pos)!
    pos += 1
    
    if ch != 0x7C/* | */ && ch != 0x2D/* - */ && ch != 0x3A/* : */ {
        return false
    }
    
    while pos < state.eMarks[nextLine] {
        
        let ch = state.src.charAt(pos)
        
        if ch != 0x7C/* | */ && ch != 0x2D/* - */ && ch != 0x3A/* : */ && !isSpace(ch!) {
            return false
        }
        pos += 1
    }
    
    var (lineText, start, end) = getLine(state, line: startLine + 1) ?? ("", 0, 0)
    
    let separatorSegment = SourceStringSegment.Get(start, length: end - start)
    
    // for a reason we need to investigate this method returns
    // empty lines
    var columns = lineText.components(separatedBy: CharacterSet(charactersIn: "|"))
    
    var nonEmptyColumns = [String]()
    
    for i in 0..<columns.count {
        if !columns[i].isEmpty {
            nonEmptyColumns.append(columns[i])
        }
        else if columns[i].isEmpty && i != 0 && i != columns.count-1 {
            return false
        }
    }

    columns = nonEmptyColumns
    
    var aligns = [String]()
    
    for i in 0..<columns.count {
        
        let t = columns[i].trimWhitespaces()
        
        if t.count == 0  {
            
            // allow empty columns before and after table, but not in between columns;
            // e.g. allow ` |---| `, disallow ` ---||--- `
            if i == 0 || i == columns.count - 1 {
                continue
            }
            else {
                return false
            }
        }
        
        // !/^:?-+:?$/.test(t)
        if t.matchTableRowSeparator() == nil {
            return false
        }
        
        if t.charAt(t.length - 1) == 0x3A/* : */ {
            aligns.append(t.charAt(0) == 0x3A/* : */ ? "center" : "right")
        }
        else if t.charAt(0) == 0x3A/* : */ {
            aligns.append("left")
        }
        else {
            aligns.append("")
        }
        
        for (index, char) in t.enumerated() {
            if index != 0 && index != t.count-1 {
                if t.charAt(index) == 0x3A {
                    return false
                }
            }
        }
    }
    
    (lineText, start, end) = getLine(state, line: startLine) ?? ("", 0, 0)
    
    // this is thead
    wholeTableRegion.addSourceStringSegment(SourceStringSegment.Get(start, length: end - start))
    let (tableHeadSegments, tagSegments) = getTextSegments(state, line: startLine, separator: 0x7c /* §UnicodeCharacter.verticalLine */)
    
    wholeTableRegion.addSourceStringSegment(separatorSegment)
    
    for tagSegment in tagSegments {
        tagRegion.addSourceStringSegment(tagSegment)
    }
    
    // to keep the order in the tag region segment...
    tagRegion.addSourceStringSegment(separatorSegment)
    
    if lineText.indexOf("|") == nil {
        return false
    }
    
    // replace "|" at the start and at the end.
    let trimmedLineText = trimLeadingAndEndingVerticalBars(from: lineText)
    
    if state.sCount[startLine] - state.blkIndent >= 4 {
        return false
    }
    
    columns = escapedSplit(trimmedLineText)
    
    if columns.count > aligns.count {
        return false
    }
    
    if silent {
        return true
    }
    
    if state.shouldStopToCompile(from: start, tokenType: .tableOpen) {
        return false
    }
    
    let tableOpenToken = state.push(.tableOpen, tag: "table", nesting: .opening)
    let tableHeadToken = state.push(.theadOpen, tag: "thead", nesting: .opening)
    let tableRowToken = state.push(.trOpen, tag: "tr", nesting: .opening)
    
    let nbColumns = columns.count
    
    var headRegion = SourceStringRegion()
    
    for i in 0..<nbColumns {

        let thOpenToken = state.push(.thOpen, tag: "th", nesting: .opening)
        
        if i < tableHeadSegments.count {
            let tableHeadSegment = tableHeadSegments[i]
            thOpenToken.setSourceFragment(tableHeadSegment, for: .All)
        }
        
        if !aligns[i].isEmpty {
            thOpenToken.attrs  = [ ("style", "text-align:" + aligns[i])]
        }
        
        let inlineToken = state.push(.inline, tag: "", nesting: .selfClosing)
        inlineToken.content  = columns[i].trimWhitespaces()

        if i < tableHeadSegments.count {
            var sourceStringSegment = tableHeadSegments[i]
            sourceStringSegment.trim(withString: state.md.src)
            inlineToken.setSourceFragment(SourceStringRegion(sourceStringSegment), for: .All)
            headRegion.addSourceStringSegment(sourceStringSegment)
        }
        state.push(.thClose, tag: "th", nesting: .closing)
    }
    
    tableHeadToken.setSourceFragment(headRegion, for: .All)
    tableRowToken.setSourceFragment(headRegion, for: .All)
    
    state.push(.trClose, tag: "tr", nesting: .closing)
    state.push(.theadClose, tag: "thead", nesting: .closing)
    let tableBodyToken = state.push(.tBodyOpen, tag: "tbody", nesting: .opening)
    
    var bodyRegion = SourceStringRegion()
    
    // Process tbody
    nextLine = startLine + 2
    while nextLine < endLine {
        
        if state.sCount[nextLine] < state.blkIndent {
            break
        }
        
        guard let (lineText, start, end) = getLine(state, line: nextLine) else {
            break 
        }
        
        if lineText.indexOf("|") == nil {
            break
        }

        if state.sCount[nextLine] - state.blkIndent >= 4 {
            break
        }
        
        let segment = SourceStringSegment.Get(start, length: end - start)
        wholeTableRegion.addSourceStringSegment(segment)
        bodyRegion.addSourceStringSegment(segment)
        let (tableBodyLineSegments, tagSegments) = getTextSegments(state, line: nextLine, separator: 0x7c /* §UnicodeCharacter.verticalLine */)
        
        for tagSegment in tagSegments {
            tagRegion.addSourceStringSegment(tagSegment)
        }
        
        // replace "|" at the start and at the end.
        let trimmedLineText = trimLeadingAndEndingVerticalBars(from: lineText)
        columns = escapedSplit(trimmedLineText)
        
        // set number of columns to number of columns in header row
        //        rows.length = aligns.length;
        
        let tableRowToken = state.push(.trOpen, tag: "tr", nesting: .opening)
        var tableRowRegion = SourceStringRegion()
        
        for i in 0..<nbColumns {
            
            let tdOpenToken = state.push(.tdOpen, tag: "td", nesting: .opening)
            
            if aligns[i].length > 0 {
                tdOpenToken.attrs = [("style", "text-align:\(aligns[i])")]
            }
            
            if i < tableBodyLineSegments.count {
            
                let tableBodyLineSegment = tableBodyLineSegments[i]
                tdOpenToken.setSourceFragment(tableBodyLineSegment, for: .All)
                tableRowRegion.addSourceStringSegment(tableBodyLineSegment)
                
                let inlineToken = state.push(.inline, tag: "", nesting: .selfClosing)
                inlineToken.content  = i < columns.endIndex ? columns[i].trimWhitespaces()  : ""
                var sourceStringSegment = tableBodyLineSegments[i]
                sourceStringSegment.trim(withString: state.md.src)
                inlineToken.setSourceFragment(SourceStringRegion(sourceStringSegment), for: .All)
                
            }
            state.push(.tdClose, tag: "td", nesting: .closing)
        }
        
        tableRowToken.setSourceFragment(tableRowRegion, for: .All)
        state.push(.trClose, tag: "tr", nesting: .closing)
        
        nextLine += 1
    }
    
    tableBodyToken.setSourceFragment(bodyRegion, for: .All)
    tableOpenToken.setSourceFragment(tagRegion, for: .Tag)
    tableOpenToken.setSourceFragment(wholeTableRegion, for: .All)
    state.push(.tBodyClose, tag: "tbody", nesting: .closing)
    let tableCloseToken = state.push(.tableClose, tag: "table", nesting: .closing)
    
    // maybe to remove
    //    tableLines[1] = nextLine
    state.line = nextLine
    tableOpenToken.startLine = startLine
    tableCloseToken.endLine = state.line
    return true
}






