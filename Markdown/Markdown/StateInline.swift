//
//  StateInline.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-25.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common


/// Parser state class
final class StateInline: State {
    
//    typealias StringIndex = SourceStringRegion.Index
    
    /// parsed source String
//    var src: [UTF16.CodeUnit]
    let src: MarkdownString
    var env: Env
    
    /// link to parser instance
    let md: MarkdownParser
    
    ///
    /// Internal state vartiables
    ///
    
    var tokens: Tokens

    /// Position in src String 
    var pos: Int
    
    /// Length of src String in UTF16
    var posMax: Int
    
    var level: Int
    
    fileprivate(set) var pending: String
    
    var pendingTextLength: Int {
        
        return pending.length
    }
    
    var pendingRegion: SourceStringRegion
    
    var pendingLevel: Int
    
    /// Stores { start: end } pairs. Useful for backtrack
    var cache: [Int: Int]
    
    /// optimization of pairs parse (emphasis, strikes).
    /// Emphasis-like delimiters
    var delimiters: Delimiters
    
    var string: String {
        
        return src.string
    }
    
    ///
    /// This method is used to keep a set of all potentially
    /// linking positions in the state. We need this because
    /// when we recompile part of the code that contains references
    /// or delete some references. Some text may become links or images
    /// if they were using references.
    ///
    var potentiallyLinking: Bool = false
    
    init(src: MarkdownString, sourceFragment: SourceStringRegion, md: MarkdownParser, env: Env, outTokens: Tokens) {

//        #if DEBUG
//        assert(sourceFragment.ordered)
//        #endif
        self.src = src
        self.sourceFragment = sourceFragment
        self.env = env
        self.md = md
        self.tokens = outTokens
        self.pos = 0
        self.posMax = src.utf16.count
        self.level = 0
        self.pending = ""
        self.pendingLevel = 0
        self.cache = [Int: Int]()
        self.delimiters = Delimiters()
        self.pendingRegion = SourceStringRegion()
    }
    
    ///
    func setPendingText(_ text: String) {
        
        self.pending = text
        if text.isEmpty {
            pendingRegion.clear()
        }
    }
    
    var validated = false
    
    /// Add text to pending text
    func addTextToPendingText(_ text: String) {

        if self.potentiallyLinking && !validated {
            if !self.pending.isEmpty {
                self.potentiallyLinking = false
            }
            else {
                validated = true
            }
        }
        
        self.pending += text
    }
    
    /// Flush pending text
    @discardableResult
    func pushPending() -> Token {

        let token = Token(type: .text, tag: "", nesting: .selfClosing)
        if self.potentiallyLinking && pending.endsWith("]") {
            self.env.referencingTokens.insert(token)
        }
        self.potentiallyLinking = false
        self.validated = false
        token.content = pending
        token.level = pendingLevel
        token.setSourceFragment(pendingRegion, for: .All)
        tokens.push(token)
        pending = ""
        
        pendingRegion.clear()
        return token
    }
    
    /// Push new token to "stream".
    /// If pending text exists - flush it as text token
    @discardableResult
    func push(_ type: TokenType, tag: String, nesting: Nesting) -> Token {

        if pending.length != 0 {
            pushPending()
        }
    
        let token = Token(type: type, tag: tag, nesting: nesting)
        
        if nesting == .closing {
            level -= 1
        }
        
        token.level = level
        
        if nesting == .opening {
            level += 1
        }
        
        pendingLevel = level
        tokens.push(token)
        
        return token
    }
    
    /// Scan a sequence of emphasis-like markers, and determine whether
    /// it can start an emphasis sequence or end an emphasis sequence.
    ///
    ///  - start - position to scan from (it should point at a valid marker);
    ///  - canSplitWord - determine if these markers can be found inside a word
    func scanDelims(_ start: Int, canSplitWord: Bool) -> (can_open: Bool, can_close: Bool, length: Int, segment: SourceStringSegment) {
        
        var pos = start
        var left_flanking = true
        var right_flanking = true
        let max = posMax
        let marker = src.charAt(start)
        
        // treat beginning of the line as a whitespace
        let lastChar = start > 0 ? src.charAt(start - 1)! : 0x20
        
        while let char = src.charAt(pos), char == marker && pos < max {
            
            pos += 1
        }
        
        let segment = sourceStringSegmentFromPosition(start, length: pos - start)!
        
        let count = pos - start
        
        // treat end of the line as a whitespace
        let nextChar = pos < max ? src.charAt(pos)! : 0x20
        
        let isLastPunctChar = isMdAsciiPunct(lastChar) || isPunctChar(lastChar)
        let isNextPunctChar = isMdAsciiPunct(nextChar) || isPunctChar(nextChar)
        
        let isLastWhiteSpace = isWhiteSpace(lastChar)
        let isNextWhiteSpace = isWhiteSpace(nextChar)
        
        if isNextWhiteSpace {
            
            left_flanking = false
        }
        else if isNextPunctChar {
            
            if !(isLastWhiteSpace || isLastPunctChar) {
                
                left_flanking = false
            }
        }
        
        if isLastWhiteSpace {
            
            right_flanking = false
        }
        else if isLastPunctChar {
            
            if !(isNextWhiteSpace || isNextPunctChar) {
                
                right_flanking = false
            }
        }
        
        let can_open: Bool
        let can_close: Bool
        
        if !canSplitWord {
            can_open = left_flanking && (!right_flanking || isLastPunctChar)
            can_close = right_flanking && (!left_flanking || isNextPunctChar)
        }
        else {
            can_open = left_flanking
            can_close = right_flanking
        }
        
        return (can_open:  can_open, can_close: can_close, length: count, segment: segment)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: State protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias FragmentType = SourceStringRegion
    
    var sourceFragment: SourceStringRegion
    
    /// Method that should return a SourceStringFragment in absolute
    /// indexes using the relative position and the length passed
    /// as parameters.
    func sourceStringSegmentFromPosition(_ startPosition: Int, length: Int) -> SourceStringSegment? {

        if let startCodePoint = sourceFragment.codePointFromContentPosition(startPosition) {
            
            let endCodePoint = startCodePoint + length
            return SourceStringSegment(startIndex: startCodePoint, endIndex: endCodePoint)
        }
        return nil
    }
    
    ///
    /// Method that should return a CodePointIndex in absolute value from 
    /// an relative index inside the RelativeState.
    /// FIXME: REMOVE THIS METHOD
    func codePointIndexFromPosition(_ position: Int) -> Int? {
        
        return sourceFragment.codePointFromContentPosition(position)
    }
}
