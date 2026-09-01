//
//  String+matchTableRowSeparator.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-03.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {
    
    // /^:?-+:?$/
    func matchTableRowSeparator(fromPosition position: Int = 0) -> [Match]? {
        
        var i = position
        
        var atLeastOneMinus: Bool = false
        
        while i < length {
            
            let c = charAt(i)!
            
            i += 1
            
            if i == position + 1 {
                
                // :
                if c == §":" {
                    
                    continue
                }
                    // -
                else if c == §"-" {
                    
                    atLeastOneMinus = true
                }
                else {
                    
                    return nil
                }
            }
            else {
                
                // :-
                if c == §"-" {
                    
                    atLeastOneMinus = true
                    continue
                }
                else if c == §":" {
                    
                    if atLeastOneMinus {
                        
                        break
                    }
                    else {
                        
                        return nil
                    }
                }
                else {
                    
                    return nil
                }
            }
            
            
        }
        
        return [Match(start: position, end: i)]
    }
}
