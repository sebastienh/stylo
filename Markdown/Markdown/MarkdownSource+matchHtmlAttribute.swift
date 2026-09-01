//
//  HtmlAttribute.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-18.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {

    // = '(?:\\s+' + attr_name + '(?:\\s*=\\s*' + attr_value + ')?)';
    // ATTRIBUTE = "(?:" + "\\s+" + ATTRIBUTENAME + ATTRIBUTEVALUESPEC + "?)";
    func matchHtmlAttribute(fromPosition position: Int = 0) -> [Match]? {
        
        var i = position
        
        i += skipAllWhitespaces(fromPosition: i)
        
        // we should have met at least one whitespace according to \s+
        if i == position {
            
            return nil
        }
        
        if let attributeName = matchHtmlAttributeName(fromPosition: i) {
            
            i += attributeName.first!.length
            
            if let attributeValueSpec = matchHtmlAttributeValueSpec(fromPosition: i) {
                
                i += attributeValueSpec.first!.length
            }
            
            return [Match(start: position, end: i)]
        }
        
        return nil
    }
    
    
}
