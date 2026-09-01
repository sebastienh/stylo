//
//  html_inline.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-29.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

//var HTML_TAG_RE = require('../common/html_re').HTML_TAG_RE;

/// Process html tags
func html_inline(_ state: StateInline, silent: Bool) -> Bool {

    let pos = state.pos
    
    if !state.md.options.html {
        
        return false
    }
    
    // Check start
    let max = state.posMax
    
    if let char = state.src.charAt(pos) , char != 0x3C/* < */ || pos + 2 >= max {
            
        return false
    }
    
    // Quick fail on second char
    if let ch = state.src.charAt(pos + 1) {

        if ch != 0x21/* ! */ && ch != 0x3F/* ? */ && ch != 0x2F/* / */ && !UnicodeLetter.isUnicodeLetter(ch) {
            
            return false
        }
    }
    
    let match = state.src.matchHtmlTag(fromPosition: pos)

    if match == nil {
        
        return false;
    }
    
    let length = match!.first!.length
    
    if !silent {
        
        let htmlInlineToken = state.push(.htmlInline, tag: "", nesting: .selfClosing)
        htmlInlineToken.content = state.src.slice(pos, end: pos + length)!.string
        let sourceStringSegment = state.sourceStringSegmentFromPosition(state.pos, length: length)
        
        assert(sourceStringSegment != nil)
        if let sourceStringSegment = sourceStringSegment {
            htmlInlineToken.setSourceFragment(sourceStringSegment, for: MarkdownSourceFragmentType.All)
        }
    }
    
    state.pos += length
    return true       
}


