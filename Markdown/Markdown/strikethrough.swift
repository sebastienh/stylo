//
//  strikethrough.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-03.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// ~~strike through~~
/// Insert each marker as a separate text token, and add it to delimiter list
///
func strikethroughTokenize(_ state: StateInline, silent: Bool) -> Bool {
    
    let start = state.pos
    let marker = state.src.charAt(start)
    
    if silent {
        
        return false
    }
    
    if let marker = marker, marker != 0x7E/* ~ */ {
        
        return false
    }
    
    let scanned = state.scanDelims(state.pos, canSplitWord: true)
    var len = scanned.length
    let ch = String.fromCharCode(marker!)
    
    if len < 2 {
        return false
    }
    
    var scannedRegion = SourceStringRegion()
    scannedRegion.addSourceStringSegment(scanned.segment)
    
    
    if len % 2 != 0 {
        
        let textToken = state.push(.text, tag: "", nesting: .selfClosing)
        textToken.content = ch
        textToken.setSourceFragment(scannedRegion, for: .All)
        len -= 1
    }
    
    
    var i = 0
    while i < len {
        
        let textToken = state.push(.text, tag: "", nesting: .selfClosing)
        textToken.content = ch + ch
        textToken.setSourceFragment(scannedRegion, for: .All)
        state.delimiters.push(
            Delimiter(token: state.tokens.length - 1, close: scanned.can_close, open: scanned.can_open, marker: marker!, length: scanned.length, jump: i, level: state.level, sourceStringSegment: scanned.segment))
        i += 2
    }
    
    state.pos += scanned.length;
    
    return true;
};


/// Walk through delimiter list and replace text tokens with tags
///
/// silent and return value are just there to match the Rule fn pattern
///
func strikethroughPostProcess(_ state: StateInline, silent: Bool) -> Bool {

    var loneMarkers = [Int]()
    let delimiters = state.delimiters
    let max = state.delimiters.length
    
    for i in 0..<max {
        
        let startDelim = delimiters[i]!
        
        if startDelim.marker != 0x7E/* ~ */ {

            continue
        }
        
        if startDelim.end == nil {

            continue
        }
        
        let endDelim = delimiters[startDelim.end!]!
        
        let startDelimToken = state.tokens[startDelim.token]!
        startDelimToken.type    = .strikethroughOpen
        startDelimToken.tag     = "s"
        startDelimToken.nesting = .opening
        startDelimToken.markup  = "~~"
        startDelimToken.content = ""
        
        // ::opening-tag
//        startDelimToken.setSourceFragment(startDelim.sourceStringSegment, for: .OpeningTag)
        
        // ::closing-tag
//        startDelimToken.setSourceFragment(endDelim.sourceStringSegment, for: .ClosingTag)
        
        // ::tag
        var tagRegion = SourceStringRegion()
        tagRegion.addSourceStringSegment(startDelim.sourceStringSegment)
        tagRegion.addSourceStringSegment(endDelim.sourceStringSegment)
        startDelimToken.setSourceFragment(tagRegion, for: .Tag)
        
        // Whole
        startDelimToken.setSourceFragment(SourceStringSegment(startIndex: startDelim.sourceStringSegment.startIndex, endIndex: endDelim.sourceStringSegment.endIndex), for: .All)
        
        let endDelimToken = state.tokens[endDelim.token]!
        endDelimToken.type    = .strikethroughClose
        endDelimToken.tag     = "s"
        endDelimToken.nesting = .closing
        endDelimToken.markup  = "~~"
        endDelimToken.content = ""
        
        if state.tokens[endDelim.token - 1]!.type == .text &&
            state.tokens[endDelim.token - 1]!.content == "~" {
                
            loneMarkers.append(endDelim.token - 1)
        }
    }
    
    // If a marker sequence has an odd number of characters, it's splitted
    // like this: `~~~~~` -> `~` + `~~` + `~~`, leaving one marker at the
    // start of the sequence.
    //
    // So, we have to move all those markers after subsequent s_close tags.
    //
    while loneMarkers.count > 0  {

        let i = loneMarkers.removeLast()
        var j = i + 1
        
        while j < state.tokens.length && state.tokens[j]!.type == .strikethroughClose {

            j += 1
        }
        
        j -= 1
        
        if i != j {
            
            let token = state.tokens[j]
            state.tokens[j] = state.tokens[i]
            state.tokens[i] = token
        }
    }
    
    return false 
}
