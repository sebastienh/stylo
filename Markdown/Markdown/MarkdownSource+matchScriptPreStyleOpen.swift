//
//  matchScriptPreStyleOpen.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-30.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {
    
    // (?=(\s|>|$))/i
    fileprivate func validateTagEnding(_ position: Int) -> (Bool, Int?) {
        
        if position < length {
            
            let c = charAt(position)!
            
            let possibleWhitespaces = skipAllWhitespaces(fromPosition: position)
            
            if possibleWhitespaces == 1 {
                
                return (true, 1)
            }
            else if c == 0x3e /* §UnicodeCharacter.greaterThanSign */ {
                
                return (true, 1)
            }
            
            return (false, nil)
        }
        
        // reached end which is accepted
        return (true, 0)
    }
    
    /// /^<(script|pre|style)(?=(\s|>|$))/i
    func matchScriptPreStyleOpen(fromPosition position: Int = 0) -> [Match]? {
        
        if hasPrefixFromPositionCaseInsensitive("<script", fromPosition: position) {
            
            let endingPosition = "<script".length
            
            let (match, endingLength) = validateTagEnding(endingPosition)
            
            if match {
                
                return [Match(start: position, end: position + endingPosition + endingLength!)]
            }
        }
        else if hasPrefixFromPositionCaseInsensitive("<pre", fromPosition: position) {
            
            let endingPosition = "<pre".length
            
            let (match, endingLength) = validateTagEnding(endingPosition)
            
            if match {
                
                return [Match(start: position, end: position + endingPosition + endingLength!)]
            }
        }
        else if hasPrefixFromPositionCaseInsensitive("<style", fromPosition: position) {
            
            let endingPosition = "<style".length
            
            let (match, endingLength) = validateTagEnding(endingPosition)
            
            if match {
                
                return [Match(start: position, end: position + endingPosition + endingLength!)]
            }
        }
        
        return nil
        
    }
    

}
