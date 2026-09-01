//
//  String+matchHtmlCommentOpen.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-30.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {
    
    /// js re: /^<!--/
    func matchHtmlCommentOpen(fromPosition position: Int = 0) -> [Match]? {
    
        if hasPrefixFromPositionCaseInsensitive("<!--", fromPosition: position) {
    
            return [Match(start: position, end: position + 4)]
        }
    
        return nil
    }
}
