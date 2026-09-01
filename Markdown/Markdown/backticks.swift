//
//  backticks.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-01.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

fileprivate let SPACES_REGEX = regex("[ ]+")

func backticks(_ state: StateInline, silent: Bool) -> Bool {

    var pos = state.pos
    let ch = state.src.charAt(pos)
    
    if let ch = ch, ch != 0x60/* ` */ {
        
        return false
    }
    
    var tagRegion = SourceStringRegion()
    
    let startPosition = state.codePointIndexFromPosition(pos)
    
//    assert(startPosition != nil)
    if let startPosition = startPosition {
        
        tagRegion.addSourceStringSegment(SourceStringSegment(startIndex: startPosition, endIndex: startPosition + 1))
    }
    
    let start = pos
    pos += 1
    let max = state.posMax
    
    while let char = state.src.charAt(pos), pos < max && char == 0x60/* ` */ {
        
        let startPosition = state.codePointIndexFromPosition(pos)
        
        assert(startPosition != nil)
        if let startPosition = startPosition {
            
            tagRegion.addSourceStringSegment(SourceStringSegment(startIndex: startPosition, endIndex: startPosition + 1))
        }
        pos += 1
    }
    
    let marker = state.src.slice(start, end: pos)!
    
    var matchEnd = pos
    
    while let matchStart = state.src.indexOf("`", fromIndex: matchEnd) {
        
        let startPosition = state.codePointIndexFromPosition(matchStart)
        
//        assert(startPosition != nil)
        if let startPosition = startPosition {
            
            tagRegion.addSourceStringSegment(SourceStringSegment(startIndex: startPosition, endIndex: startPosition + 1))
        }
        
        matchEnd = matchStart + 1
        
        while let char = state.src.charAt(matchEnd), matchEnd < max && char == 0x60/* ` */ {
            
            let startPosition = state.codePointIndexFromPosition(matchEnd)
            
            assert(startPosition != nil)
            if let startPosition = startPosition {
                
                tagRegion.addSourceStringSegment(SourceStringSegment(startIndex: startPosition, endIndex: startPosition + 1))
            }
            matchEnd += 1
        }
        
        if matchEnd - matchStart == marker.length {
            
            if !silent {
                
                if var contentString = state.src.slice(pos, end: matchStart) {
                    
                    var allRegion = SourceStringRegion()
                    
                    let codeInlineToken = state.push(.codeInline, tag: "code", nesting: .selfClosing)
                    codeInlineToken.markup  = marker.string
                
                    contentString = contentString.replacingOccurrences(of: "\n", with: " ")
                    
                    // If the resulting string both begins *and* ends with a [space]
                    // character, a single [space] character is removed from the
                    // front and back.
                    if let startChar = contentString.charAt(0), let endChar = contentString.charAt(contentString.length - 1), startChar == 0x20 && endChar == 0x20 {
                        codeInlineToken.content = contentString.trimOneLeadingAndTrailingSpace()
                    }
                    else {
                        codeInlineToken.content = contentString
                    }
                    if let contentSegment = state.sourceStringSegmentFromPosition(pos, length: matchStart - pos) {
                        codeInlineToken.setSourceFragment(contentSegment, for: .Content)
                        // here we are making sure that the tag region part before
                        // the content is before the content in the .all SourceStringRegion
                        // and that the tag region after the content is after in the .all
                        // SourceStringRegion
                        var lastInsertedTagSourceStringSegmentIndex: Int?
                        for (index, tagSourceStringSegment) in tagRegion.sourceStringSegments.enumerated() {
                            if tagSourceStringSegment.endIndex <= contentSegment.startIndex {
                                lastInsertedTagSourceStringSegmentIndex = index
                                allRegion.addSourceStringSegment(tagSourceStringSegment)
                            }
                        }
                        allRegion.addSourceStringSegment(contentSegment)
                        if let lastInsertedTagSourceStringSegmentIndex = lastInsertedTagSourceStringSegmentIndex {
                            for i in lastInsertedTagSourceStringSegmentIndex+1..<tagRegion.sourceStringSegments.count {
                                allRegion.addSourceStringSegment(tagRegion.sourceStringSegments[i])
                            }
                        }
                        else {
                            assert(tagRegion.sourceStringSegments.isEmpty)
                        }
                    }
                    
                    codeInlineToken.setSourceFragment(allRegion, for: .All)
                    codeInlineToken.setSourceFragment(tagRegion, for: .Tag)
                }
            }
            
            state.pos = matchEnd
            return true
        }
    }
    
    if !silent {
        
        state.addTextToPendingText(marker.string)
        let segment = state.sourceStringSegmentFromPosition(start, length: marker.length)!
        state.pendingRegion.addSourceStringSegment(segment)
    }
    
    state.pos += marker.length
    return true
}


