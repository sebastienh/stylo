//
//  MarkdownParser+Utilities.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2017-11-29.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os

extension MarkdownParser {
    
    ///
    /// the range passed is a line range
    public static func headingTagRange(in string: String, range: NSRange) -> (NSRange, String)? {
        
        let stringToParse = string.substr(range.location, end: range.location + range.length)!
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("header tag: evaluating if string: %@ is header tag...", log: Log.Markdown.all, type: .debug, %%stringToParse)
        #endif
        let parser = MarkdownParser()
        let tokens = parser.parse(stringToParse)
        
        if let token = tokens.tokenValues.first, token.type == .headingOpen {
            
            let tagRanges = token.sourceFragment(for: .Tag)?.ranges
            
            assert(tagRanges?.first != nil)
            if let tagRange = tagRanges?.first {
                
                let globalTagRange = NSMakeRange(range.location + tagRange.location, tagRange.length)
                return (globalTagRange, token.tag)
            }
        }
        
        return nil 
    }
    
    ///
    /// the range passed is a line range
    /// WARNING: NOT TESTED AT ALL!!!
    public static func fencedCodeBlocTagRange(in string: String, range: NSRange) -> (NSRange, String)? {
        
        let stringToParse = string.substr(range.location, end: range.location + range.length)!
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("header tag: evaluating if string: %@ is header tag...", log: Log.Markdown.all, type: .debug, %%stringToParse)
        #endif
        let parser = MarkdownParser()
        let tokens = parser.parse(stringToParse)
        
        if let token = tokens.tokenValues.first, token.type == .codeBlock {
            
            let tagRanges = token.sourceFragment(for: .Tag)?.ranges
            
            assert(tagRanges?.first != nil)
            if let tagRange = tagRanges?.first {
                
                let globalTagRange = NSMakeRange(range.location + tagRange.location, tagRange.length)
                return (globalTagRange, token.tag)
            }
        }
        return nil
    }
    
}
