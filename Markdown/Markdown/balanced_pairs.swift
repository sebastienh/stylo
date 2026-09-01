//
//  balanced_pairs.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-25.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation

///
/// For each opening emphasis-like marker find a matching closing one
///
/// Note: This method always returns false since it does not change the state.pos
/// value (returning true trigg the update of pos in Parserinline.
///
/// silent parameter is not used, it is put here to allow a unified 
/// interface for all inline rule function.
///
func balance_pairs(_ state: StateInline, silent: Bool) -> Bool {
    
    let max = state.delimiters.length
    
    for i in 0..<max {
        
        if !state.delimiters[i]!.close {
            continue
        }
        
        var j = i - state.delimiters[i]!.jump - 1
        
        while j >= 0 {
            
            if (state.delimiters[j]!.open &&
                state.delimiters[j]!.marker == state.delimiters[i]!.marker &&
                state.delimiters[j]!.end == nil &&
                state.delimiters[j]!.level == state.delimiters[i]!.level) {
                
                let oddMatch = (state.delimiters[j]!.close || state.delimiters[i]!.open) &&
                    state.delimiters[j]!.length != nil &&
                    state.delimiters[j]!.length != nil &&
                    (state.delimiters[j]!.length! + state.delimiters[i]!.length!) % 3 == 0
                
                if !oddMatch {
                   
                    state.delimiters[i]!.jump = i - j
                    state.delimiters[i]!.open = false
                    state.delimiters[j]!.end  = i
                    state.delimiters[j]!.jump = 0
                    break
                }
            }
            
            j -= state.delimiters[j]!.jump + 1
        }
    }
    
    return false
}
