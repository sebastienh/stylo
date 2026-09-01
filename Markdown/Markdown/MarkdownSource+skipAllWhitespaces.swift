//
//  String+skipAllWhitespaces.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-06-01.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {
    
    func isWhitespace(fromPosition position: Int) -> Bool {
        
        let i = position
        
        if let c = charAt(i) {
        
            return isPossibleNewLineStartCodePoint(c) || isSpace(c)
        }
        
        return false
    }
    
    func skipWhitespaces(fromPosition position: Int) -> Int {
    
        var i = position
        
        // skip all whitespaces
        while i < length {
            
            let c = charAt(i)!
            
            if isSpace(c) {
                i += 1
            }
            else {
                break
            }
        }
        return i - position
    }
    
    func skipAllWhitespaces(fromPosition position: Int) -> Int {
        
        var i = position
        
        // skip all whitespaces
        while i < length {
            
            let c = charAt(i)!
            
            if isPossibleNewLineStartCodePoint(c) {
                
                if let newLineLength = startWithNewLine(atPosition: i) {
                    
                    i += newLineLength
                }
                else {
                    
                    i += 1
                }
            }
            else if isSpace(c) {
                
                i += 1
            }
            else {
                
                break
            }
        }
        return i - position
    }
}
