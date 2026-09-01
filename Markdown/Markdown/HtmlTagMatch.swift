//
//  HtmlTagMatch.swift
//  Markdown
//
//  Created by Sebastien hamel on 2015-11-18.
//  Copyright © 2015 Nebula Media. All rights reserved.
//

import Foundation


//var HTMLTAG = "(?:" + OPENTAG + "|" + CLOSETAG + "|" + HTMLCOMMENT + "|" + PROCESSINGINSTRUCTION + "|" + DECLARATION + "|" + CDATA + ")";
struct HtmlTagMatch: RegularExpression, MesurableMatch {

    var length: Int
    
    var tagMatchString: NSMutableString?
    
    init(length: Int? = nil, tagMatchString: NSMutableString? = nil) {
        
        if let length = length {
            
            self.length = length
        }
        else {
            
            self.length = 0
        }
        
        if let tagMatchString = tagMatchString {
            
            self.tagMatchString = tagMatchString
        }
    }
    
    //var HTMLTAG = "(?:" + OPENTAG + "|" + CLOSETAG + "|" + HTMLCOMMENT + "|" +
    //    PROCESSINGINSTRUCTION + "|" + DECLARATION + "|" + CDATA + ")";
    static func match(string: NSString, fromPosition position: Int = 0, _self: HtmlTagMatch? = nil, options: AnyObject...) -> HtmlTagMatch? {
        
        if let openTagMatch = HtmlOpenTagMatch.match(string, fromPosition: position) {
            
            if var _self = _self {
                
                _self.length = openTagMatch.length
                _self.tagMatchString = openTagMatch.openTagString
                
                return _self
            }
            
            return HtmlTagMatch(length: openTagMatch.length, tagMatchString: openTagMatch.openTagString)
        }
        else if let closeTagMatch = HtmlCloseTagMatch.match(string, fromPosition: position) {
            
            if var _self = _self {
                
                _self.length = closeTagMatch.length
                _self.tagMatchString = closeTagMatch.closeTagString
                
                return _self
            }
            
            return HtmlTagMatch(length: closeTagMatch.length, tagMatchString: closeTagMatch.closeTagString)
        }
        else if let htmlCommentMatch = HtmlCommentMatch.match(string, fromPosition: position) {
            
            if var _self = _self {
                
                _self.length = htmlCommentMatch.length
                _self.tagMatchString = htmlCommentMatch.commentString
                
                return _self
            }
            
            return HtmlTagMatch(length: htmlCommentMatch.length, tagMatchString: htmlCommentMatch.commentString)
        }
        else if let processingInstructionMatch = HtmlProcessingInstructionMatch.match(string, fromPosition: position) {
            
            if var _self = _self {
                
                _self.length = processingInstructionMatch.length
                _self.tagMatchString = processingInstructionMatch.processingInstructionString
                
                return _self
            }
            
            return HtmlTagMatch(length: processingInstructionMatch.length, tagMatchString: processingInstructionMatch.processingInstructionString)
        }
        else if let declarationMatch = HtmlDeclarationMatch.match(string, fromPosition: position) {
            
            if var _self = _self {
                
                _self.length = declarationMatch.length
                _self.tagMatchString = declarationMatch.declarationString
                
                return _self
            }
            
            return HtmlTagMatch(length: declarationMatch.length, tagMatchString: declarationMatch.declarationString)
        }
        else if let cdataMatch = HtmlCDATAMatch.match(string, fromPosition: position) {
            
            if var _self = _self {
                
                _self.length = cdataMatch.length
                _self.tagMatchString = cdataMatch.cdataString
                
                return _self
            }
            
            return HtmlTagMatch(length: cdataMatch.length, tagMatchString: cdataMatch.cdataString)
        }
        
        return nil
    }
}