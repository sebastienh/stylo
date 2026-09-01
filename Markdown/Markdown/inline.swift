//
//  inline.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-22.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

func inline(_ state: StateCore) {
    
    let tokens = state.tokens
    
    // seems to not stop for some reason
//    DispatchQueue.concurrentPerform(iterations: tokens.length) { (index) in
//
//        let token = tokens[index]!
//
//        if token.type == TokenType.Inline {
//
//            state.md.inline.parse(token.content, stringRegion: token.sourceFragment(for: .All)! as! SourceStringRegion, md: state.md, env: state.env, outTokens: token.children);
//        }
//    }
    

    // Parse inlines
    for token in tokens {
//
        if token.type == .inline {

//            debugPrint("token.content: \(token.content)")

            // to really make it paralel we need a way to return the tokens, not pass a
            // reference to the children like we do here
            if let allSourceFragment = token.sourceFragment(for: .All) as? SourceStringRegion {
            
                state.md.inline.parse(token.content, stringRegion: allSourceFragment, md: state.md, env: state.env, outTokens: token.children)
            }
        }
    }
}
