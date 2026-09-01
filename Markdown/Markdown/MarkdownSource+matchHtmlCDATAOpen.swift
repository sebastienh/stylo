//
//  String+matchHtmlCDATAOpen.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-30.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common


extension MarkdownSource {
    
    /// js re: /^<!\[CDATA\[/
    func matchHtmlCDATAOpen(fromPosition position: Int = 0) -> [Match]? {

        if hasPrefixFromPositionCaseInsensitive("<![CDATA[", fromPosition: position) {
            
            return [Match(start: position, end: position + 9)]
        }
        
        return nil
    }
}
