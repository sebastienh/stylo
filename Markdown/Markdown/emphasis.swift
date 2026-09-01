//
//  emphasis.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-26.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

///
/// Insert each marker as a separate text token, and add it to delimiter list
///
func emphasisTokenize(_ state: StateInline, silent: Bool) -> Bool {
    
    let start = state.pos
    let marker = state.src.charAt(start)
    
    if silent {
        return false
    }
    
    if let marker = marker, marker != 0x5F /* _ */ && marker != 0x2A /* * */ {
        return false
    }
    
    let scanned = state.scanDelims(state.pos, canSplitWord: marker == 0x2A)
    
    for i in 0..<scanned.length {
        
        let token = state.push(.text, tag: "", nesting: .selfClosing)
        token.content = String.fromCharCode(marker!)
        
        var textRegion = SourceStringRegion()
        textRegion.addSourceStringSegment(state.sourceStringSegmentFromPosition(state.pos, length: scanned.length)!)
        token.setSourceFragment(textRegion, for: .All)
        
        state.delimiters.push(
            Delimiter(token: state.tokens.length - 1,
                      close: scanned.can_close,
                      open: scanned.can_open,
                      marker: marker!,
                      length: scanned.length,
                      jump: i,
                      level: state.level,
                      sourceStringSegment: scanned.segment))
    }
    
    state.pos += scanned.length
    
    return true
}

///
/// Skip text characters for text token, place those to pending buffer
/// and increment current pos
///
func emphasisPostProcess(_ state: StateInline, silent: Bool) -> Bool {
    
    let delimiters = state.delimiters
    let max = state.delimiters.length
    
    var i = max - 1
    
    while i >= 0 {
        
        let startDelim = delimiters[i]!
        
        if startDelim.marker != 0x5F/* _ */ && startDelim.marker != 0x2A/* * */ {
            i -= 1
            continue
        }
        
        // Process only opening markers
        if startDelim.end == nil {
            i -= 1
            continue
        }
        
        let endDelim = delimiters[startDelim.end!]
        
        // If the previous delimiter has the same marker and is adjacent to this one,
        // merge those into one strong delimiter.
        //
        // `<em><em>whatever</em></em>` -> `<strong>whatever</strong>`
        //
        
        var isStrong = false
        
        if i > 0 {
        
            let previousDelimiter = delimiters[i - 1]!
            
            isStrong =
                previousDelimiter.end == startDelim.end! + 1 &&
                previousDelimiter.token == startDelim.token - 1 &&
                delimiters[startDelim.end! + 1]!.token == endDelim!.token + 1 &&
                previousDelimiter.marker == startDelim.marker
        }
        
        let ch = String.fromCharCode(startDelim.marker)
        
        let startDelimToken = state.tokens[startDelim.token]!
        startDelimToken.type = isStrong ? .strongOpen : .emOpen
        startDelimToken.tag = isStrong ? "strong" : "em"
        startDelimToken.nesting = .opening
        startDelimToken.markup  = isStrong ? ch + ch : ch
        startDelimToken.content = ""
        
        // ::opening-tag
//        startDelimToken.setSourceFragment(startDelim.sourceStringSegment, for: .OpeningTag)
        
        // ::closing-tag
//        startDelimToken.setSourceFragment(endDelim!.sourceStringSegment, for: .ClosingTag)
        
        // ::tag
        var tagRegion = SourceStringRegion()
        tagRegion.addSourceStringSegment(startDelim.sourceStringSegment)
        tagRegion.addSourceStringSegment(endDelim!.sourceStringSegment)
        startDelimToken.setSourceFragment(tagRegion, for: .Tag)
        
        // Whole
        startDelimToken.setSourceFragment(SourceStringSegment(startIndex: startDelim.sourceStringSegment.startIndex, endIndex: endDelim!.sourceStringSegment.endIndex), for: .All)
        
        let endDelimToken = state.tokens[endDelim!.token]!
        endDelimToken.type = isStrong ? .strongClose : .emClose
        endDelimToken.tag = isStrong ? "strong" : "em"
        endDelimToken.nesting = .closing
        endDelimToken.markup  = isStrong ? ch + ch : ch
        endDelimToken.content = ""
        
        if isStrong {
            
            state.tokens[delimiters[i - 1]!.token]!.content = "";
            state.tokens[delimiters[startDelim.end! + 1]!.token]!.content = ""
            i -= 1
        }
        
        i -= 1 
    }
    
    return false
}







