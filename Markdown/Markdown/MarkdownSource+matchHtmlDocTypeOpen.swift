//
//  String+matchHtmlDocTypeOpen.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-30.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common


extension MarkdownSource {

    /// js re: /^<![A-Z]/
    func matchHtmlDocTypeOpen(fromPosition position: Int = 0) -> [Match]? {
    
        if hasPrefixFromPositionCaseInsensitive("<!", fromPosition: position) {
    
            if 2 < length {
                
                let nextCharacter = charAt(2)!
    
                if UnicodeLetter.isUppercaseLetter(nextCharacter) {
    
                    return [Match(start: position, end: position + 3)]
                }
            }
        }
    
        return nil
    }
}
