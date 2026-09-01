//
//  NewDelimiter.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-26.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// <http://spec.commonmark.org/0.22/#delimiter-stack>
struct Delimiter: Hashable {
    
    /// A position of the token this delimiter corresponds to.
    ///
    let token: Int
    
    /// Char code of the starting marker (number).
    ///
    var marker: UTF16Char
    
    /// An amount of characters before this one that's equivalent to
    /// current one. In plain English: if this delimiter does not open
    /// an emphasis, neither do previous `jump` characters.
    ///
    /// Used to skip sequences like "*****" in one step, for 1st asterisk
    /// value will be 0, for 2nd it's 1 and so on.
    ///
    var jump: Int
    
    /// whether the delimiter is “active” (all are active to start), and
    var active: Bool
    
    let length: Int?
    
    /// Next delimiter in the double liked list
    fileprivate var _previous: [Delimiter]?
    
    var previous: Delimiter? {
        set {
            _previous = newValue.map{[$0]}
        }
        get {
            return _previous?.first
        }
    }
    
    /// Previous delimiter in the double linked list
    fileprivate var _next: [Delimiter]?
    
    var next: Delimiter? {
        set {
            _next = newValue.map{[$0]}
        }
        get {
            return _next?.first
        }
    }
    
    /// Absolute position in the source file
    let sourceStringSegment: SourceStringSegment
    
    /// Boolean flags that determine if this delimiter could open or close
    /// an emphasis.
    ///
    var close: Bool
    
    var open: Bool
    
    var hashValue: Int {
        
        // really simple hashValue using the object identifier
        // simpler, sufficient and efficient.
        return token.hashValue ^ sourceStringSegment.hashValue ^ marker.hashValue<<3
    }
    
    /// If this delimiter is matched as a valid opener, `end` will be
    /// equal to its position, otherwise it's `-1`.
    ///
    var end: Int?
    
    /// Token level.
    ///
    var level: Int
    
    init(token: Int, close: Bool, open: Bool, marker: UTF16Char, length: Int?, jump: Int, level: Int, sourceStringSegment: SourceStringSegment) {
        
        self.token = token
        self.active = true
        self.jump = jump
        self.level = level
        self.close = close
        self.open = open
        self.marker = marker
        self.sourceStringSegment = sourceStringSegment
        self.length = length
    }
}

func ==(lhs: Delimiter, rhs: Delimiter) -> Bool {
    
    return lhs.hashValue == rhs.hashValue
}
