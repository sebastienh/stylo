//
//  HtmlOpenCloseTag.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-23.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {

    //var HTMLTAG = "(?:" + OPENTAG + "|" + CLOSETAG + "|" + HTMLCOMMENT + "|" +
    //    PROCESSINGINSTRUCTION + "|" + DECLARATION + "|" + CDATA + ")";
    func matchHtmlOpenOrCloseTag(fromPosition position: Int = 0) -> [Match]? {
    
        if let openTagMatch = matchHtmlOpenTag(fromPosition: position) {
        
            return [Match(start: position, end: openTagMatch.first!.length)]
        }
        else if let closeTagMatch = matchHtmlCloseTag(fromPosition: position) {
        
            return [Match(start: position, end: closeTagMatch.first!.length)]
        }
    
        return nil
    }
}
