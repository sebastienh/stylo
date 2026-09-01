//
//  Options.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-24.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation

public struct Options {
    
    ///
    /// Allow Markdown specific node or not. In the DOM 
    /// HTML generated for the markdown source file we want the 
    /// Markdown elements to be present since we want to be able 
    /// to style them. When outputing pure HTML we obviously don't 
    /// want that in order to have clean HTML. But the same renderer 
    /// is used for both since the same core logic is shared between 
    /// both outputs.
    ///
    public var markdownOut: Bool
    
    /// Enable HTML tags in source
    public let html: Bool
    
    /// Use '/' to close single tags (<br />)
    public let xhtmlOut: Bool
    
    /// Convert '\n' in paragraphs into <br>
    public let breaks: Bool
    
    /// CSS language prefix for fenced blocks
    public let langPrefix: String
    
    /// autoconvert URL-like texts to links
    public let linkify: Bool
    
    // Enable some language-neutral replacements + quotes beautification
    public let typographer: Bool
    
    /// Double + single quotes replacement pairs, when typographer enabled,
    /// and smartquotes on. Could be either a String or an Array.
    ///
    /// For example, you can use '«»„“' for Russian, '„“‚‘' for German,
    /// and ['«\xA0', '\xA0»', '‹\xA0', '\xA0›'] for French (including nbsp).
    let quotes: String
    
    /// Highlighter function. Should return escaped HTML,
    /// or '' if input not changed
    ///
    /// function (/*str, lang*/) { return ''; }
    ///
    var highlight: ((_ str: String, _ lang: String) -> String?)?
    
    /// Internal protection, recursion limit
    let maxNesting: Int
    
    init(markdownOut: Bool, html: Bool, xhtmlOut: Bool, breaks: Bool, langPrefix: String, linkify: Bool, typographer: Bool, quotes: String, highlight: ((_ str: String, _ lang: String) -> String?)?, maxNesting: Int) {
        
        self.markdownOut = markdownOut
        self.html = html
        self.xhtmlOut = xhtmlOut
        self.breaks = breaks
        self.langPrefix = langPrefix
        self.linkify = linkify
        self.typographer = typographer
        self.quotes = quotes
        self.highlight = highlight
        self.maxNesting = maxNesting
    }
    
}
