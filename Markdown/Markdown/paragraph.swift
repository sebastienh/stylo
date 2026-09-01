//
//  paragraph.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-25.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

func paragraph(_ state: StateBlock, startLine: Int, endLine: Int, silent: Bool) -> Bool {
    
    var nextLine = startLine + 1
    
    let terminatorRules = state.md.block.ruler.getRules(§BlockTokenizeRule.Paragraph)
    
    // Removed, but this line follow the original code... but it is a problem
    // in may case. This line will is not applied when the argument is not defined 
    // (in javascript oroginal code)
    let localEndLine = state.lineMax
    
    let oldParentType = state.parentType
    state.parentType = .paragraph
    
    // jump line-by-line until empty one or EOF
    while nextLine < localEndLine && !state.isEmpty(nextLine) {
        
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

            if terminatorRule.fn(state, nextLine, localEndLine, true) {
                
                terminate = true
                break
            }
        }
    
        if terminate {
            break
        }
        
         nextLine += 1
    }
    
    var (content, _, region) = state.getLines(startLine, end: nextLine, indent: state.blkIndent, keepLastLF: false, generateRegion: true, ordered: true)
    
    state.line = nextLine
    
    region = region?.trimmed(withString: state.src) as? SourceStringRegion
    let startIndex = region?.range?.lowerBound
    
    assert(startIndex != nil)
    if let startIndex = startIndex, state.shouldStopToCompile(from: startIndex, tokenType: .paragraphOpen) {
        return false
    }
    
    let paragraphOpenToken = state.push(.paragraphOpen, tag: "p", nesting: .opening)
    
    let inlineToken = state.push(.inline, tag: "", nesting: .selfClosing)
    inlineToken.content = content.trimWhitespaces()
    
    if let paragraphOpenTokenRegion = region {
        paragraphOpenToken.setSourceFragment(paragraphOpenTokenRegion, for: .All)
        inlineToken.setSourceFragment(paragraphOpenTokenRegion, for: .All)
    }
    
    let close = state.push(.paragraphClose, tag: "p", nesting: .closing)
    paragraphOpenToken.startLine = startLine
    close.endLine = state.line
    
    state.parentType = oldParentType
    
    return true
}









