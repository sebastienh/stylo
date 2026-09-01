 //
//  StateBlock.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-25.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common
 



/// Parser state class
final class StateBlock: State {

    // can be 'blockquote', 'list', 'root', 'paragraph' or 'reference'
    enum ParentType {
        
        case blockquote
        case list
        case root
        case paragraph
        case reference
    }
    
    /// parsed source String
    let src: MarkdownString
    
    var env: Env
    
    /// link to parser instance
    let md: MarkdownParser
    
    ///
    /// Internal state vartiables
    ///
    
    var tokens: Tokens
    
    /// line begin offsets for fast jumps
    /// bMarks, this variable contains the string absolute 
    /// index of the start of all the lines.
    var bMarks: Array<Int>
    
    /// line end offsets for fast jumps
    /// eMarks
    var eMarks: Array<Int>
    
    ///
    /// offsets of the first non-space characters (tabs not expanded)
    /// tShift
    var tShift: Array<Int>
    
    ///
    /// newLineLengths is used to know the new line length since we support 
    /// \r\n etc... in source and we keep them and we don't replace everything 
    /// by \n new lines manipulations (like getLines) can not assume the new line
    /// length is 1.
    var newLineLengths: Array<Int>
    
    // An amount of virtual spaces (tabs expanded) between beginning
    // of each line (bMarks) and real beginning of that line.
    //
    // It exists only as a hack because blockquotes override bMarks
    // losing information in the process.
    //
    // It's used only when expanding tabs, you can think about it as
    // an initial tab length, e.g. bsCount=21 applied to string `\t123`
    // means first tab should be expanded to 4-21%4 === 3 spaces.
    //
    var bsCount: Array<Int>
    
    /// indents for each line (tabs expanded)
    /// sCount
    var sCount: Array<Int>
    
    ///
    /// block parser variables
    ///
    
    /// required block content indent
    var blkIndent: Int
    
    // (for example, if we are in list)
    
    /// line index in src
    var line: Int 
    
    /// lines count
    var lineMax: Int
    
    /// loose/tight mode for lists
    var tight: Bool
    
    /// indent of the current dd block (-1 if there isn't any)
    /// In our case the ddIndent could be nil, we do not use -1
    var ddIndent: Int?
    
    var level: Int
    
    // renderer
    var result: String
    
    var string: String {
        
        return src.string
    }
    
    // can be 'blockquote', 'list', 'root', 'paragraph' or 'reference'
    // used in lists to determine if they interrupt a paragraph
    var parentType: ParentType = .root
    
    /// This variable is used by the container bloc to tell the state block
    /// that he should parse class names attributes of the form
    /// " class1 class2 ". If a container has not triggered the block
    /// parsing then this kind of attributes bloc is frobidden.
    var allowClassNamesAttributesBlock = false
    
    init(src: MarkdownString, md: MarkdownParser, env: Env, tokens: Tokens) {
        
        self.src = src
        self.md = md
        self.env = env
        self.tokens = tokens
        self.bMarks = Array<Int>()
        self.eMarks = Array<Int>()
        self.tShift = Array<Int>()
        self.sCount = Array<Int>()
        self.newLineLengths = Array<Int>()
        self.bsCount = Array<Int>()
        self.blkIndent = 0
        self.line = 0
        self.lineMax = 0
        self.tight = false
        self.parentType = .root
        self.level = 0
        self.result = ""
        self.sourceFragment = SourceStringSegment(startIndex: 0, endIndex: md.src.length)
        // Create caches
        // Generate markers.
        createCachesAndGenerateMarkers()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: local implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// Push new token to "stream".
    ///
    /// FIXME: positions are not handled, 
    /// TODO: handle positions
    @discardableResult
    func push(_ type: TokenType, tag: String, nesting: Nesting) -> Token {

        let token = Token(type: type, tag: tag, nesting: nesting)
        
        token.block = true
    
        if nesting == .closing {
            level -= 1 
        }

        token.level = level

        if nesting == .opening {
            level += 1
        }
        
        tokens.push(token)
        return token
    }
    
    func shouldStopToCompile(from startIndex: Int, tokenType: TokenType) -> Bool {
        
        if self.level == 0 {
            return md.shouldStopToCompile(from: startIndex, tokenType: tokenType)
        }
        return false 
    }
    
    func isEmpty(_ lineIndex: Int) -> Bool {
        
        return bMarks[lineIndex] + tShift[lineIndex] >= eMarks[lineIndex]
    }
    
    /// Skip empty lines from a line
    func skipEmptyLines(_ from: Int) -> Int {
        
        var from = from
        let max = lineMax
        
        while from < max {
            
            if bMarks[from] + tShift[from] < eMarks[from] {
                break
            }
            from += 1
        }
        return from
    }
    
    
    /// Skip spaces from given position.
    func skipSpaces(_ pos: Int) -> Int {
        
        var pos = pos
        let max = src.length
        
        while pos < max {
            
            if let ch = src.charAt(pos) {
                if (!isSpace(ch)) {
                    break
                }
            }
            
            pos += 1
        }
        return pos
    }
    
    /// Skip spaces from given position in reverse.
    func skipSpacesBack(_ pos: Int, min: Int) -> Int {
        
        var localPosition = pos
        
        if localPosition <= min {
        
            return localPosition
        }
    
        while localPosition > min {
            
            localPosition -= 1
            
            if let char = src.charAt(localPosition), !isSpace(char) && char != §UnicodeCharacter.lineFeed {
                
                return localPosition + 1
            }
        }

        return localPosition
    }
    
    /// Skip char codes from given position
    func skipChars(_ pos: Int, codes: UTF16Char...) -> Int {
        
        var localPosition = pos
        let max = src.length
        
        while localPosition < max {

            if let char = src.charAt(localPosition) {
                
                var found = false
                for code in codes {
                    if char == code {
                        found = true
                        break
                    }
                }
                if !found {
                    break
                }
            }
            localPosition += 1
        }

        return localPosition
    }

    /// Skip char codes reverse from given position - 1
    func skipCharsBack(_ pos: Int, code: UTF16Char, min: Int) -> Int {

        var localPosition = pos
        
        if localPosition <= min {
            
            return localPosition
        }
    
        while localPosition > min {
    
            localPosition -= 1
            
            if let char = src.charAt(localPosition) , char != code {
                
                return localPosition + 1;
            }
        }

        return localPosition
    }
    
    fileprivate func lineSegments(_ begin: Int, end: Int, indent: Int, keepLastLF: Bool) -> [LineSegment]? {
        
        var segments = [LineSegment]()
        
        if begin >= end {
            
            return nil
        }
        
        for line in begin..<end {
            
            var lineIndent = 0
            
            let lineStart = bMarks[line]
            var first = bMarks[line]
            
            let last: Int
            
            // if the line is not the last one, or
            // if it is, we want to keep the last LF
            if line + 1 < end || keepLastLF {
                
                // No need for bounds check because we have fake entry on tail.
                last = eMarks[line] + newLineLengths[line]
            }
            else {
                
                last = eMarks[line]
            }
            
            while first < last && lineIndent < indent {
                
                if let ch = src.charAt(first) {
                    
                    if isSpace(ch) {
                        
                        if ch == 0x09 {
                            lineIndent += 4 - (lineIndent + bsCount[line]) % 4
                        }
                        else {                            
                            lineIndent += 1
                        }
                    }
                    else if first - lineStart < tShift[line] {
                        
                        // patched tShift masked characters to look like spaces (blockquotes, list markers)
                        lineIndent += 1
                    }
                    else {
                        
                        break
                    }
                    
                    first += 1
                }
                else {
                    
                    break
                }
            }
            
            if lineIndent > indent {
                // partially expanding tabs in code blocks, e.g '\t\tfoobar'
                // with indent=2 becomes '  \tfoobar'
                segments.append(LineSegment(line: line, start: first, end: last, prefixSpaces: lineIndent - indent))
            } else {
                segments.append(LineSegment(line: line, start: first, end: last))
            }
        }
        
        return segments
    }
    
    func regionFromSource(_ begin: Int, end: Int, indent: Int, keepLastLF: Bool, ordered: Bool = false) -> SourceStringRegion? {
        
        if let segments = lineSegments(begin, end: end, indent: indent, keepLastLF: keepLastLF) {
            
            // size should be end - begin
            var region = SourceStringRegion()
            
            for segment in segments {
                
                // Since lines are zero indexed in the lineSegments methods we should increment them here
                // the support the fact that code point indexe indexes them starting by one.
                if segment.end - segment.start > 0 {

                    let segment = SourceStringSegment(startIndex: segment.start, endIndex: segment.end)
                    region.addSourceStringSegment(segment)
                }
            }
            return region
        }
        return nil
    }
    
    ///
    /// cut lines range from source and return the cut lines as a string 
    /// and the start index of those lines in the initial string from which 
    /// we extracted those lines.
    ///
    func getLines(_ begin: Int, end: Int, indent: Int, keepLastLF: Bool, generateRegion: Bool = false, ordered: Bool = false) -> (MarkdownString, Int?, SourceStringRegion?) {

        // size should be end - begin
        var queue = MarkdownString()
        
        // start of the string in the global index space
        // may be nil if we did not find any segments 
        var startIndexInGlobalSpace: Int? = nil
        
        // size should be end - begin
        var region: SourceStringRegion? = nil
        
        if let segments = lineSegments(begin, end: end, indent: indent, keepLastLF: keepLastLF) {
            
            if generateRegion {
            
                region = SourceStringRegion()
            }
            
            for (index, segment) in segments.enumerated() {

                // extract the first start of line index
                if index == 0 {
                    startIndexInGlobalSpace = segment.start
                }
                
                queue.append(substring(from: segment))
                
                if generateRegion {
                
                    // Since lines are zero indexed in the lineSegments methods we should increment them here
                    // the support the fact that code point indexe indexes them starting by one.
                    let prefixSpaces = segment.prefixSpaces ?? 0
                    let segment = SourceStringSegment(startIndex: segment.start - prefixSpaces, endIndex: segment.end)
                    region!.addSourceStringSegment(segment)
                }
            }
        }
            
        return (queue, startIndexInGlobalSpace, region)
    }
    
    fileprivate func substring(from segment: LineSegment) -> String {
    
        var substring = src.slice(segment.start, end: segment.end)!
        
        if let prefixSpaces = segment.prefixSpaces {
            
            var spaces = ""
            for _ in 0..<prefixSpaces {
                spaces += " "
            }
            substring = spaces + substring
        }
        return substring
    }
    
    fileprivate func createCachesAndGenerateMarkers() {
        
        // take a copy of src
        let s = md.src
        var indentFound = false
        
        var start = 0
        var pos = 0
        var indent = 0
        var offset = 0
        
        // This is UTF16 length, and all positions are UTF16 based
        let len = s!.length
        
        // iterate through all code points in the string.
        while pos < len {
            
            let ch = s!.charAt(pos)!
            
            // initially it is false, so we pass here.
            if  !indentFound {
                
                // for each space we increase the indent value of one
                if isSpace(ch) {
                    
                    indent += 1
                    
                    // and we increae the offset value depending if
                    // it's a tab or not
                    if ch == 0x09 {
                        
                        // increase the value offset by four considering offset may
                        // not include only tabs already (- offset % 4), this calcul
                        // diminish the number tabs really represents by including 
                        // spaces into them, so the offset would be increased by 3
                        // if there was one space counted in the offset previously:
                        // with one tab and one space previously counted that would give us
                        // with a new tab
                        // 4 + 1 = 5
                        // offset += 4 - (5%4) => 5 += 3 => 8
                        offset += 4 - offset % 4
                    }
                    else {
                        
                        offset += 1
                    }
                    
                    pos += 1
                    continue
                }
                else {
                    
                    // we change this value to pass here the next time 
                    // so the real meaning of this variable is if we have finished 
                    // to treat initial indents...
                    // the original name is indent_found...
                    indentFound = true
                }
            }
            
            // if we are at a new line or we are at the last code point.
            // in our case new line could be of more than 0x0a since we don't
            // remove the \r etc... in the initial normalize core phase 
            if let newLineLength = s!.startWithNewLine(atPosition: pos) {
                
                bMarks.append(start)
                eMarks.append(pos)
                tShift.append(indent)
                sCount.append(offset)
                bsCount.append(0)
                
                indentFound = false
                indent = 0
                offset = 0
                start = pos + 1
                
                // **Don't touch this anymore**, this is the right value
                // that should be put here.
                // we increment for the next starting knowing that each loop increment pos by one
                // so we just need to increment it by the new line length minus one.
                start += newLineLength - 1
                pos += newLineLength - 1
                newLineLengths.append(newLineLength)

            }
            else if pos == len - 1  {
            
                bMarks.append(start)
                eMarks.append(pos+1)
                tShift.append(indent)
                sCount.append(offset)
                bsCount.append(0)
                newLineLengths.append(0)
            }
            pos += 1
        }
        
        assert(newLineLengths.count == bMarks.count)
        
        // Push fake entry to simplify cache bounds checks
        bMarks.append(s!.length)
        eMarks.append(s!.length)
        tShift.append(0)
        sCount.append(0)
        newLineLengths.append(0)
        bsCount.append(0)
        
        // don't count last fake line
        lineMax = bMarks.count - 1
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: State protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias FragmentType = SourceStringSegment
    
    var sourceFragment: SourceStringSegment
    
    ///
    /// Method that should return a SourceStringFragment in absolute
    /// indexes using the relative position and the length passed
    /// as parameters.
    ///
    func sourceStringSegmentFromPosition(_ startPosition: Int, length: Int) -> SourceStringSegment? {
        
        let startCodePoint = startPosition   
        let endCodePoint = startCodePoint + length
            
        return SourceStringSegment(startIndex: startCodePoint, endIndex: endCodePoint)
    }
    
    ///
    /// Method that should return a CodePointIndex in absolute value from
    /// an relative index inside the RelativeState.
    /// FIXME: REMOVE THIS METHOD
    func codePointIndexFromPosition(_ position: Int) -> Int? {
        
        return  position
    }
}
