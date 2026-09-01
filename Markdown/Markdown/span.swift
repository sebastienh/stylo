//
//  span.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-05-18.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// Process html tags
func span(_ state: StateInline, silent: Bool) -> Bool {
    
    let startPos = state.pos
    var pos = state.pos
    
    // Check start
    let max = state.posMax
    
    if let char = state.src.charAt(pos), char != §UnicodeCharacter.leftSquareBracket {
        return false
    }
    
    // A stack to help us track the matching closing
    // square braquet for the opening square braquet
    // we are investigating.
    var openSquareStack = Stack<Bool>()
    
    // unroll until we find a right square braquet.
    // A span cannot contain another span so as soon
    // as we find a matching end right square braquet we
    // look for the attributes
    
    // push the fist opening square braquet
    openSquareStack.push(true)
    
    // go beyond the first opening square braquet
    pos += 1
    
    while pos < max {
        
        if let char = state.src.charAt(pos), char == §UnicodeCharacter.leftSquareBracket {
            openSquareStack.push(true)
        }
        else if let char = state.src.charAt(pos), char == §UnicodeCharacter.rightSquareBracket {
            openSquareStack.pop()
        }
        pos += 1
        if openSquareStack.isEmpty {
            break
        }
    }
    
    if !openSquareStack.isEmpty {
        return false
    }
    
    let endSquareBraquetIndex = pos-1
    
    // skip all whitespace
    while pos < max {
        
        let code = state.src.charAt(pos)!
        
        if !isSpace(code) && !isPossibleNewLineStartCodePoint(code) {
            break
        }
        else if let newLineLength = state.src.startWithNewLine(atPosition: pos) {
            pos += (newLineLength - 1)
        }
        pos += 1
    }
    
    // if we are in front of a left curly braquet
    // then we can proceed
    if let char = state.src.charAt(pos), char != §UnicodeCharacter.leftCurlyBracket {
        return false
    }
    
    // create a state inline only for the purpose of validating
    // theif we are in front of an attributs bloc
    let stateInline = StateInline(src: state.src, sourceFragment: state.sourceFragment, md: state.md, env: state.env, outTokens: Tokens())
    
    stateInline.pos = pos
    // check if we are in front of an inline attributes bloc
    if !attributes_inline(stateInline, silent: true) {
        return false
    }
    
    state.pos = pos
    
    if silent {
        return true
    }
    
    let wholeRegion = state.sourceStringSegmentFromPosition(startPos, length: endSquareBraquetIndex+1-startPos)
    var tagRegion = SourceStringRegion()
    let contentRegion = state.sourceStringSegmentFromPosition(startPos+1, length: endSquareBraquetIndex-(startPos+1))
    
    let startSquareBraquetSegment = state.sourceStringSegmentFromPosition(startPos, length: 1)
    
    assert(startSquareBraquetSegment != nil)
    if let startSquareBraquetSegment = startSquareBraquetSegment {
        tagRegion.addSourceStringSegment(startSquareBraquetSegment)
    }
    
    let endSquareBraquetSegment = state.sourceStringSegmentFromPosition(endSquareBraquetIndex, length: 1)
    
    assert(endSquareBraquetSegment != nil)
    if let endSquareBraquetSegment = endSquareBraquetSegment {
        tagRegion.addSourceStringSegment(endSquareBraquetSegment)
    }
    
    let spanToken = state.push(.span, tag: "span", nesting: .selfClosing)
    spanToken.content = state.src.slice(startPos+1, end: endSquareBraquetIndex)!.string
    spanToken.setSourceFragment(wholeRegion, for: .All)
    spanToken.setSourceFragment(tagRegion, for: .Tag)
    spanToken.setSourceFragment(contentRegion, for: .Content)
    return true
}
