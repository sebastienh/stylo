//
//  text_collapse.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-25.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// Merge adjacent text nodes into one, and re-calculate all token levels
///
/// This method always returns false since it does not change the state.pos 
/// value (returning true trigg the update of pos in ParserInline.)
///
/// silent parameter is not used, it is put here to allow a unified
/// interface for all inline rule function.
///
func text_collapse(_ state: StateInline, silent: Bool) -> Bool {
    
    var level = 0
    let tokens = state.tokens
    let max = state.tokens.length
    var last = 0
    var curr = 0
    
    while curr < max {
        
        // the validation that allows us to force non-nil 
        // comes from the max value handling.
        let currentToken = tokens[curr]!
        
        // re-calculate levels
        level += §currentToken.nesting
        currentToken.level = level
        
        if currentToken.type == .text && curr + 1 < max && tokens[curr + 1]!.type == .text {
                
            // collapse two adjacent text nodes
            tokens[curr + 1]!.content = currentToken.content + tokens[curr + 1]!.content
            
            let currentTokenRegion = currentToken.sourceFragment(for: .All)! as! SourceStringRegion
            let nextTokenRegion = tokens[curr + 1]!.sourceFragment(for: .All)! as! SourceStringRegion
            tokens[curr + 1]!.setSourceFragment(currentTokenRegion + nextTokenRegion, for: .All)
        }
        else {
            
            if curr != last {
                
                tokens[last] = tokens[curr]
            }
            
            last += 1
        }
        
        curr += 1
    }
    
    if curr != last {
        
        // Should do something similar to original code which does this:
        // ```javascript
        // tokens.length = last
        // ```
        while tokens.length > last {
            
            tokens.popLast()
        }
    }
    
    return false 
}
