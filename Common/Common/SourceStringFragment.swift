//
//  SourceStringFragment.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-11-10.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import os

public enum RelativePosition {
    
    case before
    case contained
    case after
}

public protocol SourceStringFragment: NSRangeConvertible {
    
    /// Return the number of indexes in this fragment.
    var length: Int { get }
    
    /// Return the first index of the fragment
    var startFragmentIndex: Int? { get }
    
    /// Return the last index of the fragment
    var endFragmentIndex: Int? { get }
    
    /// description for debugging
    var debugDescription: String { get }
    
    var stringRepresentation: String { get }
    
    /// Returns the position immediately after `i`.
    ///
    /// - Precondition: `(startIndex..<endIndex).contains(i)`
    func index(after i: Int) -> Int
    
    /// Subscripted access
    subscript(index: Int) -> Int { get }
    
    /// As per Swift 3 documentation:
    ///
    /// > Returns the result of advancing `i` by `n` positions.
    /// >
    /// > - Returns:
    /// >   - If `n > 0`, the `n`th index after `i`.
    /// >   - If `n < 0`, the `n`th index before `i`.
    /// >   - Otherwise, `i` unmodified.
    /// >
    /// > - Precondition: `n >= 0` unless `Self` conforms to
    /// >   `BidirectionalCollection`.
    /// > - Precondition:
    /// >   - If `n > 0`, `n <= self.distance(from: i, to: self.endIndex)`
    /// >   - If `n < 0`, `n >= self.distance(from: i, to: self.startIndex)`
    /// >
    /// > - Complexity:
    /// >   - O(1) if `Self` conforms to `RandomAccessCollection`.
    /// >   - O(`abs(n)`) otherwise.
    func index(_ i: Int, offsetBy n: Int) -> Int

    /// Method that return if the index is contained in this SourceStringragment
    func indexRelativePosition(_ index: Int) -> RelativePosition?
    
    /// Method that returns the relative position of both start and end index. 
    func indexesRelativePositions(from range: NSRange) -> (RelativePosition, RelativePosition)
    
    /// Method that returns the relative position of the index
    /// from the range parameter.
    func indexRelativePosition(from range: NSRange, index: Int) -> RelativePosition
    
    /// This method truncate the tail by one position, retreating
    /// the last index by one in the region.
    mutating func truncateTailByOne()
    
    /// This method truncate the head by one, moving the first
    /// index by one in the region.
    mutating func truncateHeadByOne()
    
    /// Return the segment truncated to point to the equivalent
    /// of a trimmed string.
    func trimmed(withString string: String) -> SourceStringFragment
    
    mutating func trim(withString string: String)
    
    /// This method translate the position of the fragment using
    /// the count from which moving the fragment by adding this count
    /// to the start and end index.
    mutating func move(_ count: Int)
    
    mutating func moveEnd(_ count: Int)
    
    func moved(_ count: Int) -> SourceStringFragment
    
    /// Return an array of segments inside the current fragment
    /// between the start and end, if not nil, otherwise it goes
    /// until the end.
    func segments(from start: Int, until end: Int?) -> [SourceStringSegment]?
    
    func equals(to other: Any?) -> Bool
}

extension SourceStringFragment {
    
    /// NSRangeConvertible
    public var ranges: [NSRange] {
        
        var _ranges = [NSRange]()
        
        if let sourceStringSegment = self as? SourceStringSegment {
            
            let position = sourceStringSegment
            
            let range = position.range
            
            assert(range != nil)
            if let range = range {
                
                _ranges.append(range)
            }
        }
        else if let sourceStringRegion = self as? SourceStringRegion {
            
            var _ranges = [NSRange]()
            
            for sourceStringSegment in sourceStringRegion.sourceStringSegments {
                
                let range = sourceStringSegment.range
                
                assert(range != nil)
                if let range = range {
                    
                    _ranges.append(range)
                }
            }
            return _ranges
        }
        return _ranges
    }
    
    /// Method that return if the index is contained in this SourceStringragment
    public func indexRelativePosition(_ index: Int) -> RelativePosition? {
        
        if length > 0 {
        
            if index < startFragmentIndex! {
                
                return .before
            }
            else if index >= endFragmentIndex! {
                
                return .after
            }
            else if index >= startFragmentIndex! && index < endFragmentIndex! {
            
                return .contained
            }
        }
        
        return nil
    }
    
    public func relativePosition(from range: NSRange) -> RangeRelativePosition? {
        
        return self.range?.relativePosition(from: range)
    }
    
    
    public func indexesRelativePositions(from range: NSRange) -> (RelativePosition, RelativePosition) {
    
        let startIndex = startFragmentIndex!.integerValue
        let startIndexRelativePosition = indexRelativePosition(from: range, index: startIndex)
        
        let endIndex = endFragmentIndex!.integerValue
        let endIndexRelativePosition = indexRelativePosition(from: range, index: endIndex)
        
        return (startIndexRelativePosition, endIndexRelativePosition)
    }
    
    /// Method that returns the relative position of the start index
    /// from the range parameter.
    public func indexRelativePosition(from range: NSRange, index: Int) -> RelativePosition {
        
        if NSLocationInRange(index, range) {
            
            return .contained
        }
        else if index < range.location {
            
            return .before
        }
        return .after
    }
    
    public mutating func trim(withString string: String) {
        
        trimHead(usingString: string)
        trimTail(usingString: string)
    }
    
    /// Return the segment truncated to point to the equivalent
    /// of a trimmed string.
    public func trimmed(withString string: String) -> SourceStringFragment {
        
        var trimmed = self
        trimmed.trimHead(usingString: string)
        trimmed.trimTail(usingString: string)
        return trimmed
    }
    
    /// trim the head of all it's whitespaces references
    fileprivate mutating func trimHead(usingString string: String) {
        
        #if false && (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("string.count: %d", log: Log.Common.all, type: .info, string.count)
        os_log("self: %@", log: Log.Common.all, type: .info, %%self)
        #endif
        
        guard let startFragmentIndex = self.startFragmentIndex else { return }
        guard let endFragmentIndex = self.endFragmentIndex else { return }
        
        var fragmentIndex = startFragmentIndex
        
        // FIXME: this wont work with SourceStringRegion since the endFragmentIndex is not 
        // well defined yet.
        while fragmentIndex.integerValue < endFragmentIndex.integerValue {
            
            let firstChar = string.charAt(fragmentIndex.integerValue)!
            let secondChar = string.charAt(fragmentIndex.integerValue + 1)
            
            if let newLineLength = charactersAreNewLine(firstChar, secondCharacter: secondChar) {
                
                for _ in 0..<newLineLength {
                    truncateHeadByOne()
                }
            }
            else if isSpace(firstChar) {
                truncateHeadByOne()
            }
            else {
                break
            }
            
            // since the startFragmentIndex hash been updated we can just
            // re-ask it.
            if let startFragmentIndex = self.startFragmentIndex {

                fragmentIndex = startFragmentIndex
            }
            else {
                
                break
            }
        }
    }
    
    fileprivate mutating func trimTail(usingString string: String) {
        
        guard let startFragmentIndex = self.startFragmentIndex else { return }
        
        var index = length-1
        
        while index >= 0 {
            
            var fragmentIndex = self[index]
            let secondChar = string.charAt(fragmentIndex.integerValue)!
            var firstChar: UTF16.CodeUnit? = nil
            
            if fragmentIndex.integerValue - 1 >= startFragmentIndex.integerValue {
            
                firstChar = string.charAt(fragmentIndex.integerValue - 1)
            }
            
            // both characters need to constitute a new line. The case where only the second character 
            // is a new line is considered next in the "else if".
            if let newLineLength = charactersAreNewLine(firstChar, secondCharacter: secondChar), newLineLength == 2 {
                
                for _ in 0..<newLineLength {
                    
                    if startFragmentIndex.integerValue != fragmentIndex.integerValue {
                    
                        index -= 1
                        fragmentIndex = self[index]
                    }
                    truncateTailByOne()
                }
            }
            else if let _ = charactersAreNewLine(secondChar, secondCharacter: nil) {
            
                index -= 1
                fragmentIndex = self[index]
                truncateTailByOne()
            }
            else if isSpace(secondChar) {
                
                index -= 1
                fragmentIndex = self[index]
                truncateTailByOne()
            }
            else {
                break
            }
            
            // we dont want to continue if we reached the first index, 
            // in the fragment.
            if startFragmentIndex.integerValue == fragmentIndex.integerValue {
                break
            }
        }
    }
}
