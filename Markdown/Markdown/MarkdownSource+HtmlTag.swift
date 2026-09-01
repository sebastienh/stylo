//
//  HtmlTag.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-18.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

//var HTMLTAG = "(?:" + OPENTAG + "|" + CLOSETAG + "|" + HTMLCOMMENT + "|" + PROCESSINGINSTRUCTION + "|" + DECLARATION + "|" + CDATA + ")";
extension MarkdownSource {

    
    //var HTMLTAG = "(?:" + OPENTAG + "|" + CLOSETAG + "|" + HTMLCOMMENT + "|" +
    //    PROCESSINGINSTRUCTION + "|" + DECLARATION + "|" + CDATA + ")";
    func matchHtmlTag(fromPosition position: Int = 0) -> [Match]? {
        
        if let openTagMatch = matchHtmlOpenTag(fromPosition: position) {
            
            return openTagMatch
        }
        else if let closeTagMatch = matchHtmlCloseTag(fromPosition: position) {
            
            return closeTagMatch
        }
        else if let htmlCommentMatch = matchHtmlComment(fromPosition: position) {
            
            return htmlCommentMatch
        }
        else if let processingInstructionMatch = matchHtmlProcessingInstruction(fromPosition: position) {
        
            return [Match(start: position, end: position + processingInstructionMatch.first!.length)]
        }
        else if let declarationMatch = matchHtmlDeclaration(fromPosition: position) {
            
            return [Match(start: position, end: position + declarationMatch.first!.length)]
        }
        else if let cdataMatch = matchHtmlCDATA(fromPosition: position) {

            return [Match(start: position, end: position + cdataMatch.first!.length)]
        }
        
        return nil
    }
}
