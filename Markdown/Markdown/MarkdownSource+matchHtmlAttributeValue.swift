//
//  HtmlAttributeValue.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-18.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {
    
    // ATTRIBUTEVALUE = "(?:" + UNQUOTEDVALUE + "|" + SINGLEQUOTEDVALUE + "|" + DOUBLEQUOTEDVALUE + ")";
    func matchHtmlAttributeValue(fromPosition position: Int = 0) -> [Match]? {
        
        if let unquotedValueMatch = matchHtmlUnquoted(fromPosition: position) {
            
            return unquotedValueMatch
        }
        else if let singleQuotedValueMatch = matchHtmlSingleQuoted(fromPosition: position) {
         
            return singleQuotedValueMatch
        }
        else if let doubleQuotedValueMatch = matchHtmlDoubleQuoted(fromPosition: position) {
            
            return doubleQuotedValueMatch
        }
        
        return nil
    }
    
}
