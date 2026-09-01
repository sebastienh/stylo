//
//  MarkdownParser+Helpers.swift
//  Markdown
//
//  Created by Sebastien hamel on 2018-11-26.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}

extension MarkdownParser {
    
    func parseLinkDestination<S: State>(_ relativeState: S, str: String, pos: Int, max: Int? = nil) -> (ok: Bool, start: Int, pos: Int, lines: Int, str: String, region: SourceStringRegion) {
        
        let max = max == nil ? str.utf16.count : max
        
        var pos = pos
        
        // FIXME: Not changed in the code, maybe an error
        // TODO: revise this when testing.
        let lines = 0
        let start = pos
        
        var result = (ok: false, start: start, pos: 0, lines: 0, str: "", region: SourceStringRegion())
        
        var currentSegment = relativeState.sourceStringSegmentFromPosition(start, length: 0)!
        
        if let char = str.charAt(pos), char == 0x3C /* < */ {
            
            pos += 1
            
            while pos < max {
                
                let code = str.charAt(pos)!
                
                /* \n */
                if str.startWithNewLine(atPosition: pos) != nil {
                    return result
                }
                /* > */
                if code == 0x3E {
                    
                    result.pos = pos + 1
                    
                    let endIndex = relativeState.codePointIndexFromPosition(result.pos)
                    
                    assert(endIndex != nil)
                    if let endIndex = endIndex {
                        currentSegment.endIndex = endIndex
                        result.region.addSourceStringSegment(currentSegment)
                    }
                    var substring = str.slice(start + 1, end: pos)
                    
                    result.str = substring!.unescapeAll()
                    result.ok = true
                    
                    return result
                }
                
                if code == 0x5C /* \ */ && pos + 1 < max {
                    
                    pos += 2
                    continue
                }
                pos += 1
            }
            
            // no closing '>'
            return result
        }

        // this should be ... } else { ... branch
        
        var level = 0
        
        while pos < max {
            
            let code = str.charAt(pos)
            
            if code == 0x20 /* §UnicodeCharacter.whitespace */ {
                break
            }
            
            // new line or delete 
            if code == 0x0a /* §UnicodeCharacter.lineFeed */ || code == 0x7F {
                break
            }
            
            if code == 0x5C /* \ */ && pos + 1 < max {
                
                pos += 2
                continue
            }
            
            if code == 0x28 /* ( */ {
                
                level += 1
            }
            
            if code == 0x29 /* ) */ {
                if level == 0 {
                    break
                }
                level -= 1
            }
            pos += 1
        }
        
        if start == pos {
            return result
        }
        
        if level != 0 {
            return result
        }
        
        var link = str.slice(start, end: pos)!
        result.str = link.unescapeAll()
        result.lines = lines
        result.pos = pos
        result.region.addSourceStringSegment(relativeState.sourceStringSegmentFromPosition(start, length: pos - start)!)
        result.ok = true
        
        
        return result
    }
    
    ///
    /// Parse link label
    ///
    /// this function assumes that first character ("[") already matches;
    /// returns the end of the label
    ///
    func parseLinkLabel(_ state: StateInline, start: Int, disableNested: Bool = false) -> Int? {
        
        
        var found = false
        var labelEnd = -1
        
        let max = state.posMax
        let oldPos = state.pos
        
        state.pos = start + 1;
        var level = 1
        
        while state.pos < max {
            
            let marker = state.src.charAt(state.pos)
            
            // ]
            if marker == 0x5D  {
                
                level -= 1
                
                if level == 0 {
                    
                    found = true
                    break
                }
            }
            
            let prevPos = state.pos
            
            state.md.inline.skipToken(state)
            
            // [
            if marker == 0x5B {
                
                if prevPos == state.pos - 1 {
                    
                    // increase level if we find text `[`, which is not a part of any token
                    level += 1
                }
                else if disableNested {
                    
                    state.pos = oldPos
                    
                    return nil
                }
            }
        }
        
        if found {
            
            labelEnd = state.pos
        }
        
        // restore old state
        state.pos = oldPos
        
        return labelEnd
    }
    

    ///
    /// Method to parse a link title.
    ///
    /// @return Returns a tuple with values:
    ///             ok      :   to indicate if we found something
    ///             start   :   index of the first delimiting marker
    ///             pos     :   index of the character following the end delimiter
    ///             lines   :   lines span of the title...
    ///             str     :   the string of the title
    ///             region  :   internal value used to indicate the title region in the link
    ///                         It is a region since it can span multiple lines
    ///
    func parseLinkTitle<S: State>(_ relativeState: S, str: String, pos: Int, max: Int? = nil) -> (ok: Bool, start: Int, pos: Int, lines: Int, str: String, region: SourceStringRegion) {
        
        let localMax = max == nil ? str.utf16.count : max
        
        // we keep our own local reference of the index we are at
        // in the string.
        var index = pos
        var lines = 0
        let start = pos
        
        var result = (ok: false, start: start, pos: 0, lines: 0, str: "", region: SourceStringRegion())
        
        if pos >= max {
            
            return result
        }
        
        var marker = str.charAt(pos)
        
        if marker != 0x22 /* " */ && marker != 0x27 /* ' */ && marker != 0x28 /* ( */ {
            
            return result
        }
        
        // add the segment for the first marker
        var currentSegment = relativeState.sourceStringSegmentFromPosition(index, length: 0)!
        
        index += 1
        
        // if opening marker is "(", switch it to closing marker ")"
        if marker == 0x28 {
            
            marker = 0x29
        }
        
        while let code = str.charAt(index) , index < localMax {
            
            if code == marker {
                
                var str = str.slice(start + 1, end: index)!
                
                result.pos = index + 1
                result.lines = lines
                result.str = str.unescapeAll()
                result.ok = true
                
                let endIndex = relativeState.codePointIndexFromPosition(index + 1)
                
                assert(endIndex != nil)
                if let endIndex = endIndex {
                    currentSegment.endIndex = endIndex
                    result.region.addSourceStringSegment(currentSegment)
                }
                
                return result
            }
            else if let newLineLength = str.startWithNewLine(atPosition: index){
                
                // update the current segment with the characters in the new line
                let endIndex = relativeState.codePointIndexFromPosition(index + newLineLength)
                
                assert(endIndex != nil)
                if let endIndex = endIndex {
                    
                    currentSegment.endIndex = endIndex
                    // add the segment to the region
                    // Note : this code assumes the contiguity of link title
                    // but it is not necessarly so we prepare for that using multiple
                    // segments
                    result.region.addSourceStringSegment(currentSegment)
                }
                
                // start a new segment with the first character of the next line.
                currentSegment = relativeState.sourceStringSegmentFromPosition(index + newLineLength, length: 0)!
                
                // we remove one since the last incrementer will increment
                // of one in any case.
                index += (newLineLength - 1)
                lines += 1
            }
            else if code == 0x5C /* \ */ && index + 1 < localMax {
                
                // update the current en index
                currentSegment.endIndex = index + 1
                
                index += 1
                
                if let newLineLength = str.startWithNewLine(atPosition: index) {
                    
                    let endIndex = relativeState.codePointIndexFromPosition(index + newLineLength)
                    
                    assert(endIndex != nil)
                    if let endIndex = endIndex {
                        
                        // update the current segment with the characters in the new line
                        currentSegment.endIndex = endIndex
                        
                        // add the segment to the region
                        result.region.addSourceStringSegment(currentSegment)
                    }
                    
                    // start a new segment with the first character of the next line.
                    currentSegment = relativeState.sourceStringSegmentFromPosition(index + newLineLength, length: 0)!
                    
                    // we remove one since the last incrementer will increment
                    // of one in any case.
                    index += (newLineLength - 1)
                    lines += 1
                }
            }
            
            index += 1
        }
        
        return result
    }
    
}
