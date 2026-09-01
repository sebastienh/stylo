//
//  block.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-23.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

func block(_ state: StateCore) {
    
    if state.inlineMode {
        
        let token = Token(type: .inline, tag: "", nesting: .selfClosing)
        var region = SourceStringRegion()
        let sourceStringSegment = SourceStringSegment(startIndex: 0, endIndex: state.src.string.utf16.count)
        region.addSourceStringSegment(sourceStringSegment)
        token.setSourceFragment(region, for: .All)
        token.content = state.src.string
        state.tokens.push(token)
    }
    else {
        
        state.md.block.parse(state.src, md: state.md, env: state.env, outTokens: state.tokens);
    }
}
