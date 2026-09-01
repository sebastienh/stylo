//
//  fence.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-29.
//  Copyright © 2015 Textually Inc. All rights reserved.
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


/// fences (``` lang, ~~~ lang)
func fence(_ state: StateBlock, startLine: Int, endLine: Int, silent: Bool) -> Bool {

//    var marker, len, params, nextLine, mem, token, markup,
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
    
    if marker == nil || (marker != 0x7E/* ~ */ && marker != 0x60 /* ` */) {
        return false
    }
    
    // scan marker length
    var mem = pos
    pos = state.skipChars(pos, codes: marker!)
    
    var len = pos - mem
    
    if len < 3 {
        return false
    }
    
    var wholeFencedCodeRegion = SourceStringRegion()
    
    let markup = state.src.slice(mem, end: pos)
    var params = state.src.slice(pos, end: max)
    
    // [Info strings] for backtick code blocks cannot contain backticks:
    // [Info strings] for tilde code blocks can contain backticks and tildes:
    if let params = params, marker! == 0x60, params.indexOf(String.fromCharCode(marker!)) >= 0 {
        return false
    }
    
    let openingFenceSegment = SourceStringSegment.Get(mem, length: pos - mem)
    wholeFencedCodeRegion.addSourceStringSegment(openingFenceSegment)
    
    var endingFenceSegment: SourceStringSegment?
    
    // Since start is found, we can report success here in validation mode
    if silent {
        return true
    }
    
    if state.shouldStopToCompile(from: mem, tokenType: .fence) {
        return false
    }
    
    // FIXME: we should just try to parse the params as we would normally do for
    // any other markdown segment.
    params = parseParams(state.src.string, pos: pos, max: max)
    
    var attributesBlocTokens: Tokens?
    
    var paramsSegment: SourceStringSegment? = nil
    if max - pos > 0 {
        
        let offset = state.tShift[startLine] + (markup?.length ?? 0)
        
        // try to parse attributes
        let attributesResult = parseAttributes(state: state, line: startLine, offset: offset)
        
        if let (tokens, _) = attributesResult {
            attributesBlocTokens = tokens
        }
        else {
            paramsSegment = SourceStringSegment.Get(pos, length: max - pos)
        }
    }
    
    // search end of block
    var nextLine = startLine
    
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
        
        if let char = state.src.charAt(pos), char != marker {
            
            continue
        }
        
        if state.sCount[nextLine] - state.blkIndent >= 4 {
           
            // closing fence should be indented less than 4 spaces
            continue
        }
        
        pos = state.skipChars(pos, codes: marker!)
        
        // closing code fence must be at least as long as the opening one
        if pos - mem < len {
            continue
        }
        
        // make sure tail has spaces only
        pos = state.skipSpaces(pos)
        
        if pos < max {
            continue
        }
        
        endingFenceSegment = SourceStringSegment.Get(mem, length: pos - mem)
        haveEndMarker = true
        // found!
        break
    }
    
    // If a fence has heading spaces, they should be removed from its inner block
    len = state.sCount[startLine]
    
    state.line = nextLine + (haveEndMarker ? 1 : 0)
    
    let fenceToken = state.push(.fence, tag: "code", nesting: .selfClosing)
    fenceToken.info = params
    let (content, _, contentRegion) = state.getLines(startLine + 1, end: nextLine, indent: len, keepLastLF: true, generateRegion: true)
    fenceToken.content = content.string
    fenceToken.markup  = markup!.string
    
    if let attributesBlocTokens = attributesBlocTokens {
        fenceToken.children = attributesBlocTokens
    }
    
    if let paramsSegment = paramsSegment {
        
        fenceToken.setSourceFragment(paramsSegment, for: MarkdownSourceFragmentType.Params)
        wholeFencedCodeRegion.addSourceStringSegment(paramsSegment)
    }
    
    /// The code fence could contain nothing, its not illegal.
    if let contentRegion = contentRegion {
    
        // this way we keep the proper order
        for segment in contentRegion.sourceStringSegments {
            wholeFencedCodeRegion.addSourceStringSegment(segment)
        }
        fenceToken.setSourceFragment(contentRegion, for: .Content)
    }
    
    //
    if let endingFenceSegment = endingFenceSegment {

        wholeFencedCodeRegion.addSourceStringSegment(endingFenceSegment)
//        fenceToken.setSourceFragment(endingFenceSegment, for: MarkdownSourceFragmentType.ClosingTag)
    }
//    fenceToken.setSourceFragment(openingFenceSegment, for: MarkdownSourceFragmentType.OpeningTag)
    
    // ::tag
    var tagRegion = SourceStringRegion()
    tagRegion.addSourceStringSegment(openingFenceSegment)
    
    fenceToken.setSourceFragment(wholeFencedCodeRegion, for: .All)
    
    // we could be writting so the endingFenceSegment is not defined.
    if let endingFenceSegment = endingFenceSegment {
    
        tagRegion.addSourceStringSegment(endingFenceSegment)
    }
    fenceToken.setSourceFragment(tagRegion, for: .Tag)
    fenceToken.startLine = startLine
    fenceToken.endLine = state.line
    return true
}

func parseAttributes(state: StateBlock, line: Int, offset: Int) -> (tokens: Tokens, offset: Int)? {
    
    var attributesBlocTokens: Tokens?
    
    let (src, _, inlineRegion) = state.getLines(line, end: line+1, indent: 0, keepLastLF: false, generateRegion: true, ordered: true)
    
    var firstLeftCurlyBracketIndex = offset
    while let char = src.charAt(firstLeftCurlyBracketIndex), char != §UnicodeCharacter.leftCurlyBracket {
        firstLeftCurlyBracketIndex += 1
    }
    
    if let char = src.charAt(firstLeftCurlyBracketIndex), char == §UnicodeCharacter.leftCurlyBracket {
        
        if let inlineRegion = inlineRegion {
            
            attributesBlocTokens = Tokens()
            let stateInline = StateInline(src: src, sourceFragment: inlineRegion, md: state.md, env: state.env, outTokens: attributesBlocTokens!)
            stateInline.pos = firstLeftCurlyBracketIndex
            if !attributes_inline(stateInline, silent: false) {
                return nil
            }
            
            return (attributesBlocTokens!, stateInline.pos)
        }
    }
    return nil
}


func parseParams(_ src: String, pos: Int, max: Int) -> String? {
    
    var startedIdentifier: Bool = false
    var startIdentifierIndex: Int = pos
    var endIdentifierIndex: Int = pos
    
    for i in pos..<max {
        
        let char = src.charAt(i)!
        endIdentifierIndex = i
        
        if char == 0x60 /* §UnicodeCharacter.graveAccent */ {
            
            return nil
        }
        
        if startedIdentifier {
            
            if isSpace(char) {
                
                return src.slice(startIdentifierIndex, end: i)
            }
        }
        else {
            
            if !isSpace(char) {
                startIdentifierIndex = i
                startedIdentifier = true
            }
        }
    }
    
    endIdentifierIndex += 1
    
    // because we could reach the max of the line without having encountered 
    // a space but still have a valid identifier
    // e.g. ```ruby\n
    if startedIdentifier && endIdentifierIndex != startIdentifierIndex {
        
        return src.slice(startIdentifierIndex, end: endIdentifierIndex)
    }
    
    return ""
}

