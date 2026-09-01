//
//  reference.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-01.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

///
/// Last update from javascript MarkdownIt: 
///
func reference(_ state: StateBlock, startLine: Int, endLine: Int, silent: Bool) -> Bool {

    var lines = 0
    
    var pos = state.bMarks[startLine] + state.tShift[startLine]
    var max = state.eMarks[startLine]
    var nextLine = startLine + 1
    
    // if it's indented more than 3 spaces, it should be a code block
    if state.sCount[startLine] - state.blkIndent >= 4 {
        return false
    }
    
    if let char = state.src.charAt(pos), char != 0x5B/* [ */ {
        return false
    }
    
    let startPos = pos
    var wholeRegion = SourceStringRegion()
    var tagRegion = SourceStringRegion()
    
    let leftSquareBraquetSegment = SourceStringSegment.Get(pos, length: 1)
    tagRegion.addSourceStringSegment(leftSquareBraquetSegment)
    wholeRegion.addSourceStringSegment(leftSquareBraquetSegment)
    
    var labelSegment = SourceStringSegment.Get(pos + 1, length: 0)
    var labelEnd = pos + 1
    
    // variable used to iterate to the string just to quickly 
    // interupt treatement if it's not a reference but a real link
    var checkPos = pos + 1
    
    // Simple check to quickly interrupt scan on [link](url) at the start of line.
    // Can be useful on practice: https://github.com/markdown-it/markdown-it/issues/54
    while checkPos < max {
        
        if state.src.charAt(checkPos)! == 0x5D /* ] */ && state.src.charAt(checkPos - 1) != 0x5C/* \ */ {
                
            if checkPos + 1 == max {
                return false
            }
                
            if state.src.charAt(checkPos + 1)! != 0x3A/* : */ {
                return false
            }
            break
        }
        checkPos += 1
    }
    
    let endLine = state.lineMax
    
    // jump line-by-line until empty one or EOF
    let terminatorRules = state.md.block.ruler.getRules("reference")
    
    let oldParentType = state.parentType
    state.parentType = .reference
    
    while nextLine < endLine && !state.isEmpty(nextLine) {
        
        // this would be a code block normally, but after paragraph
        // it's considered a lazy continuation regardless of what's there
        if state.sCount[nextLine] - state.blkIndent > 3 {
            nextLine += 1
            continue
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
    
    var (str, globalStartOfLinesIndex, _) = state.getLines(startLine, end: nextLine, indent: state.blkIndent, keepLastLF: false)
//    str = str.trimWhitespaces()
    max = str.length
    
    globalStartOfLinesIndex = globalStartOfLinesIndex! + 1
    
    // set the position pass the first "["
    pos = str.skipWhitespaces(fromPosition: 0)
    pos += 1
    let posAfterLeftBracket = pos
    
    while pos < max {
        
        let ch = str.charAt(pos)!
        
        if ch == 0x5B /* [ */ {
            return false
        }
        else if ch == 0x5D /* ] */ {
            labelEnd = pos
            break
        }
        else if let newLineLength = str.startWithNewLine(atPosition: pos) {
            lines += 1
            pos += (newLineLength - 1)
            globalStartOfLinesIndex! += (newLineLength - 1)
        }
        else if ch == 0x5C /* \ */ {
            
            if let newLineLength = str.startWithNewLine(atPosition: pos), pos < max {

                lines += 1
                pos += (newLineLength - 1)
                globalStartOfLinesIndex! += (newLineLength - 1)
            }
            else {
                pos += 1
                globalStartOfLinesIndex! += 1
            }
        }
        
        pos += 1
        globalStartOfLinesIndex! += 1
    }
    
    if pos < 0 || str.charAt(pos + 1) == nil || str.charAt(pos + 1)! != 0x3A/* : */ {
        return false
    }
    
    // only add the segment if it contains something
    if globalStartOfLinesIndex! > labelSegment.startIndex {
    
        labelSegment.endIndex = globalStartOfLinesIndex!
        wholeRegion.addSourceStringSegment(labelSegment)
    }
    
    let rightSquareBraquetPlusColonSegment = SourceStringSegment.Get(globalStartOfLinesIndex!, length: 2)
    tagRegion.addSourceStringSegment(rightSquareBraquetPlusColonSegment)
    wholeRegion.addSourceStringSegment(rightSquareBraquetPlusColonSegment)
    
    // [label]:   destination   'title'
    //         ^^^ skip optional whitespace here
    globalStartOfLinesIndex! += 2
    pos = labelEnd + 2
    while pos < max {
        
        let ch = str.charAt(pos)!
        
        if let newLineLength = str.startWithNewLine(atPosition: pos) {
            
            lines += 1
            pos += (newLineLength - 1)
            globalStartOfLinesIndex! += (newLineLength - 1)
        }
        else if isSpace(ch) {
            
            /*eslint no-empty:0*/
        }
        else {
            
            break
        }
        pos += 1
        globalStartOfLinesIndex! += 1
    }
    
    // [label]:   destination   'title'
    //            ^^^^^^^^^^^ parse this
    let res = state.md.parseLinkDestination(state, str: str.string, pos: pos, max: max)
    if !res.ok {
        
        return false
    }
    
    var destinationRegion = SourceStringRegion()
    let destinationSegment = SourceStringSegment.Get(globalStartOfLinesIndex!, length: res.str.length)
    destinationRegion.addSourceStringSegment(destinationSegment)
    wholeRegion.addSourceStringSegment(destinationSegment)
    
    globalStartOfLinesIndex! += res.str.length
    
    let href = state.md.normalizeLink(res.str)
    
    if !state.md.validateLink(href) {
        
        return false
    }
    
    pos = res.pos
    lines += res.lines
    
    // save cursor state, we could require to rollback later
    let destEndPos = pos
    let destEndLineNo = lines
    
    let destEndGlobal = globalStartOfLinesIndex!
    
    // [label]:   destination   'title'
    //                       ^^^ skipping those spaces
    let start = pos
    
    while pos < max {
        
        let ch = str.charAt(pos)!
        
        if let newLineLength = str.startWithNewLine(atPosition: pos) {
            
            lines += 1
            pos += (newLineLength - 1)
            globalStartOfLinesIndex! += (newLineLength - 1)
        }
        else if isSpace(ch) {
            /*eslint no-empty:0*/
        }
        else {
            break
        }
        
        pos += 1
        globalStartOfLinesIndex! += 1
    }
    
    var titleSegment = SourceStringSegment.Get(globalStartOfLinesIndex!, length: 0)
    
    // [label]:   destination   'title'
    //                          ^^^^^^^ parse this
    let parseLinkTitleRes = state.md.parseLinkTitle(state, str: str.string, pos: pos, max: max)
    var title: String
    
    if pos < max && start != pos && parseLinkTitleRes.ok {
        
        title = parseLinkTitleRes.str
        pos = parseLinkTitleRes.pos;
        globalStartOfLinesIndex! += title.length + 2 // for separators
        lines += parseLinkTitleRes.lines
        
        titleSegment.endIndex = globalStartOfLinesIndex!
        wholeRegion.addSourceStringSegment(titleSegment)
    }
    else {
        
        title = ""
        pos = destEndPos
        globalStartOfLinesIndex = destEndGlobal
        lines = destEndLineNo
    }
    
    // skip trailing spaces until the rest of the line
    while pos < max {
        
        let ch = str.charAt(pos)!
        
        if !isSpace(ch) {
            
            break
        }
        pos += 1
        globalStartOfLinesIndex! += 1
    }
    
    var attributesBlocTokens: Tokens?
    
    if str.startWithNewLine(atPosition: pos) == nil && pos < max {

        let oldPos = pos
        let (src, _, inlineRegion) = state.getLines(startLine, end: startLine+lines+1, indent: 0, keepLastLF: false, generateRegion: true, ordered: true)

        if let inlineRegion = inlineRegion {

            attributesBlocTokens = Tokens()
            let stateInline = StateInline(src: src, sourceFragment: inlineRegion, md: state.md, env: state.env, outTokens: attributesBlocTokens!)
            stateInline.pos = pos
            if attributes_inline(stateInline, silent: false) {
                pos = pos + stateInline.pos
            }
            else {
                // reset the position to where it was
                pos = oldPos
            }
        }
    }
    
    if str.startWithNewLine(atPosition: pos) == nil && pos < max {
        
        if title.length > 0 {
            
            // garbage at the end of the line after title,
            // but it could still be a valid reference if we roll back
            title = ""
            pos = destEndPos
            lines = destEndLineNo
            
            while pos < max {
                
                let ch = str.charAt(pos)!
                
                if !isSpace(ch) {
                    
                    break;
                }
                pos += 1
                globalStartOfLinesIndex! += 1
            }
        }
    }
    
    if str.startWithNewLine(atPosition: pos) == nil && pos < max {
        
        // garbage at the end of the line
        return false
    }
    
    let label = normalizeReference(str.slice(posAfterLeftBracket, end: labelEnd)!.string)
    
    if label.length <= 0 {
        
        // CommonMark 0.20 disallows empty labels
        return false
    }
    
    // Reference can not terminate anything. This check is for safety only.
    /*istanbul ignore if*/
    if silent {
        return true
    }
    
    if state.shouldStopToCompile(from: startPos, tokenType: .reference) {
        return false
    }
    
    state.line = startLine + lines + 1
    
    if state.md.options.markdownOut {
    
        let referenceToken = state.push(.reference, tag: "reference", nesting: .selfClosing)
    
        referenceToken.referenceLabel = label.lowercased()
        state.md.compiledReferencesLabels.insert(label)
        referenceToken.setSourceFragment(wholeRegion, for: .All)
        referenceToken.setSourceFragment(tagRegion, for: .Tag)
        referenceToken.setSourceFragment(labelSegment, for: .Label)
        referenceToken.setSourceFragment(destinationRegion, for: .Destination)
        referenceToken.setSourceFragment(titleSegment, for: .Title)
        if let attributesBlocTokens = attributesBlocTokens {
            referenceToken.children = attributesBlocTokens
        }
        
        assert(wholeRegion.range != nil)
        if var range = wholeRegion.range {
            
            if let globalPositionOffset = state.md.globalPositionOffset {
                range.move(globalPositionOffset)
            }
            var reference = ReferenceEntry(label: label, href: href, title: title, utf16Range: range)
            
            // we replace any reference that
            state.env.addReference(&reference)
        }
        referenceToken.startLine = startLine
        referenceToken.endLine = state.line
    }
    else if state.env.reference(for: label) == nil {
        
        var reference = ReferenceEntry(label: label, href: href, title: title)
        state.env.addReference(&reference)
    }
    
    state.parentType = oldParentType
    return true
}
