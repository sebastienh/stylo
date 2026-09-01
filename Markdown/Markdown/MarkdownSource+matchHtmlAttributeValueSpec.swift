//
//  HtmlAttributeValueSpec.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-18.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {
    
    // ATTRIBUTEVALUESPEC = "(?:" + "\\s*=" + "\\s*" + ATTRIBUTEVALUE + ")";
    func matchHtmlAttributeValueSpec(fromPosition position: Int = 0) -> [Match]? {
        
        var i = position
        
        i += skipAllWhitespaces(fromPosition: i)
        
        // after the whitespaces we must have found the equal sign
        if i < length {
            if let c = charAt(i) , c != 0x3d /* §UnicodeCharacter.equalsSign */ {
                return nil
            }
        }
        else {
            return nil
        }
        
        i += 1
        
        // skip all whitespaces
        i += skipAllWhitespaces(fromPosition: i)
        
        if let attributeValueMatch = matchHtmlAttributeValue(fromPosition: i) {

            if attributeValueMatch.first!.length > 0 {
                
                return [Match(start: position, end: i + attributeValueMatch.first!.length)]
            }
        }
        
        return nil
    }
}
