//
//  State.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-08-29.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common

protocol State: class {
    
    associatedtype FragmentType: SourceStringFragment
    
    /// Method that should return a SourceStringFragment in absolute
    /// indexes using the relative position and the length passed
    /// as parameters.
    func sourceStringSegmentFromPosition(_ startPosition: Int, length: Int) -> SourceStringSegment?
    
    func sourceStringSegment(from range: Range<Int>) -> SourceStringSegment?
    
    /// SourceStringFragment used by this RelativeState
    var sourceFragment: FragmentType { get }
    
    /// Method that should return a CodePointIndex in absolute value from
    /// an relative index inside the RelativeState.
    func codePointIndexFromPosition(_ position: Int) -> Int?
    
    @discardableResult
    func push(_ type: TokenType, tag: String, nesting: Nesting) -> Token
    
}

extension State {
    
    func sourceStringSegment(from range: Range<Int>) -> SourceStringSegment? {
        
        return sourceStringSegmentFromPosition(range.lowerBound, length: range.count)
    }
}
