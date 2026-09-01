//
//  html_block.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-30.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

typealias RegularExpressionMatch = (String) -> (Int) -> [Match]?
typealias RegularExpressionCloseMatch = (String) -> () -> [Match]?

// HTML block


//var block_names = require('../common/html_blocks');
//var HTML_OPEN_CLOSE_TAG_RE = require('../common/html_re').HTML_OPEN_CLOSE_TAG_RE;

// An array of opening and corresponding closing sequences for html tags,
// last argument defines whether it can terminate a paragraph or not
//
let HtmlSequences: [(open: RegularExpressionMatch, close: RegularExpressionCloseMatch, terminator: Bool)] = [
    (String.matchScriptPreStyleOpen, String.matchScriptPreStyleClose, true),
    (String.matchHtmlCommentOpen, String.matchHtmlCommentClose, true),
    (String.matchProcessingInstructionOpen, String.matchProcessingInstructionClose, true),
    (String.matchHtmlDocTypeOpen, String.matchHtmlDocTypeClose, true),
    (String.matchHtmlCDATAOpen, String.matchHtmlCDATAClose, true),
    (String.matchOpenCloseHtmlBlock, String.matchEmpty, true),
    (String.matchOpenOrCloseTag, String.matchEmpty, false)
]

func html_block(_ state: StateBlock, startLine: Int, endLine: Int, silent: Bool) -> Bool {
    
    var pos = state.bMarks[startLine] + state.tShift[startLine]
    var max = state.eMarks[startLine]
    
    // if it's indented more than 3 spaces, it should be a code block
    if state.sCount[startLine] - state.blkIndent >= 4 {
        return false
    }
    
    if !state.md.options.html {
        return false
    }
    
    if let char = state.src.charAt(pos), char != 0x3C/* < */ {
        return false
    }
    
    if !silent && state.shouldStopToCompile(from: pos, tokenType: .htmlBlock) {
        return false
    }
    
    var lineText = state.src.slice(pos, end: max)
    
    var openingSequence: (open: RegularExpressionMatch, close: RegularExpressionCloseMatch, terminator: Bool)? = nil
    
    for sequence in HtmlSequences {
        
        if let _ = sequence.open(lineText!.string)(0) {
            
            openingSequence = sequence
            break
        }
    }
    
    if openingSequence == nil {
        return false
    }
        
    if silent {
        
        // true if this sequence can be a terminator, false otherwise
        return openingSequence!.terminator
    }
    
    var nextLine = startLine + 1
    
    // If we are here - we detected HTML block.
    // Let's roll down till block end.
    if openingSequence!.close(lineText!.string)() == nil{
        
        while nextLine < endLine {
            
            if state.sCount[nextLine] < state.blkIndent {
                break
            }
            
            pos = state.bMarks[nextLine] + state.tShift[nextLine]
            max = state.eMarks[nextLine]
            lineText = state.src.slice(pos, end: max)
            
            if openingSequence!.close(lineText!.string)() != nil{
                
                if lineText!.length != 0 {
                    
                    nextLine += 1 
                }
                
                break
            }
            
            nextLine += 1
        }
    }
    
    state.line = nextLine
    
    let htmlBlockToken = state.push(.htmlBlock, tag: "", nesting: .selfClosing)
    let (content, _, region) = state.getLines(startLine, end: nextLine, indent: state.blkIndent, keepLastLF: true, generateRegion: true)
    htmlBlockToken.content = content.string
    htmlBlockToken.setSourceFragment(region, for: .All)
    htmlBlockToken.startLine = startLine
    htmlBlockToken.endLine = state.line
    return true
}
