//
//  StateCore.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-22.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// Core state object
final class StateCore {
    
    var src: MarkdownString
    
    let env: Env
    
    let _tokens: Tokens
    
    var tokens: Tokens {
        return _tokens
    }
    
    let inlineMode: Bool
    
    unowned let md: MarkdownParser
    
    init(src: MarkdownString, md: MarkdownParser, env: Env, tokens: Tokens? = nil, inlineMode: Bool) {
    
        self.src = src
        self.env = env
        self._tokens = tokens ?? Tokens()
        self.inlineMode = inlineMode
        
        // link to parser instance
        self.md = md
    }
}
