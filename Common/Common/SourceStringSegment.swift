//
//  SourceStringSegment.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-05-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import os

/// A SourceStringSegment can be either a SourceStringPosition
/// or a SourceStringRegion. It contains a startIndex and an endIndex.
public struct SourceStringSegment: Equatable, Comparable, SourceStringFragment {
    
    enum PositionState {
        
        case invalid
        case valid
    }
    
    public var debugDescription: String {
        
        return "start: \(startIndex.integerValue), end: \(endIndex.integerValue)"
    }
    
    public var stringRepresentation: String {
    
        return "\(startIndex.integerValue), \(endIndex.integerValue)"
    }
    
    var state: PositionState = .valid
    
    public var startIndex: Int
    
    /// The endIndex is the last index after the element, it is
    /// not part of the element
    public var endIndex: Int
    
    public var isEmpty: Bool {
        
        return length == 0
    }
    
    public static func Get(_ start: Int, length: Int) -> SourceStringSegment {
        
        return SourceStringSegment(startIndex: start, endIndex: start + length)
    }
    
    public init(range: NSRange) {
        
        self.init(startIndex: range.lowerBound, endIndex: range.upperBound)
        #if DEBUG
        validate()
        #endif
    }
    
    public init(range: Range<Int>) {
        
        self.init(startIndex: range.lowerBound, endIndex: range.upperBound)
        #if DEBUG
        validate()
        #endif
    }
    
    public init(startIntegerIndex: Int, endIntegerIndex: Int) {
        
        self.init(startIndex: startIntegerIndex, endIndex: endIntegerIndex)

        #if DEBUG
        validate()
        #endif
    }
    
    public init(startIndex: Int, endIndex: Int) {
        
        self.startIndex = startIndex
        self.endIndex = endIndex
        /// TO PUT BACK: REMOVED TO AVOID CRASH DURING CUSTOM PROPERTY DEVELOPMENT
//        #if DEBUG
//        validate()
//        #endif
    }
    
    public func isInside(range: Range<Int>) -> Bool {
        
        if startIndex >= range.lowerBound {
            if endIndex <= range.upperBound {
                return true
            }
        }
        return false
    }
    
    public func containsIndex(_ index: Int) -> Bool {
        
        if index >= startIndex.integerValue && index <= endIndex.integerValue {
            return true
        }
        return false
    }
    
    public func strictlyContainsSegment(_ segment: SourceStringSegment) -> Bool {
        
        return strictlyContainsIndexes(startIndex, endIndex)
    }
    
    public func strictlyContainsIndexes(_ possiblyContainedStartIndex: Int, _ possiblyContainedEndIndex: Int) -> Bool {

        // can we consider this node for the smalest region
        if startIndex < possiblyContainedStartIndex && endIndex > possiblyContainedEndIndex {
            return true
        }
        return false
    }
    
    public func isInvalid() -> Bool {
        
        return state == .invalid
    }
    
    public func validate() {
        assert(startIndex >= 0)
        assert(endIndex >= startIndex)
    } 
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: SourceStringFragment protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// Return the first index of the region
    public var startFragmentIndex: Int? {
        
        return startIndex
    }
    
    /// Return the last index of the region
    public var endFragmentIndex: Int? {
        
        return endIndex
    }
    
    public var length: Int {
        
        return endIndex - startIndex
    }
    
    /// subscript access
    public subscript(index: Int) -> Int {
        get {
            guard index < length else {
                fatalError("Index out of range.")
            }
            
            let absoluteIndex = startIndex + index
            return absoluteIndex
        }
    }
    
    public func index(after i: Int) -> Int {
        
        return index(i, offsetBy: 1)
    }
    
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
    public func index(_ i: Int, offsetBy n: Int) -> Int {
        
        return i + n
    }
    
    /// This method truncate the tail by one position, retreating
    /// the last index by one in the region.
    public mutating func truncateTailByOne() {
        
        if startIndex < endIndex {
            endIndex -= 1
        }
    }
    
    /// This method truncate the head by one, moving the first
    /// index by one in the region.
    public mutating func truncateHeadByOne() {
        
        if startIndex < endIndex {
            
            startIndex += 1
        }
    }
    
    /// Method to move the segment by count value  
    public mutating func move(_ count: Int) {
        
        startIndex += count
        endIndex += count
        
        #if DEBUG
        validate()
        #endif
    }
    
    public mutating func moveEnd(_ count: Int) {
        
        endIndex += count
        #if DEBUG
        validate()
        #endif
    }
    
    public func moved(_ count: Int) -> SourceStringFragment {
        
        return SourceStringSegment(startIndex: startIndex + count, endIndex: endIndex + count)
    }
    
    public mutating func substractRange(range: NSRange) {
        
        let ranges = self.range?.substractsRanges([range])
        
        assert(ranges != nil)
        if let ranges = ranges {
            
            assert(!ranges.isEmpty)
            assert(ranges.count == 1)
            let range = ranges.first!
            self = SourceStringSegment(range: range)
        }
    }
    
    public func segments(from start: Int, until end: Int?) -> [SourceStringSegment]? {
        
        if let start = self.start(from: start), let end = self.end(from: end) {
            
            return [SourceStringSegment(startIndex: start, endIndex: end)]
        }
        return nil
    }
    
    private func end(from end: Int?) -> Int? {
    
        if let end = end, end > self.startIndex {
            if end > self.endIndex {
                return self.endIndex
            }
            else {
                return end
            }
        }
        return nil
    }
        
    private func start(from start: Int) -> Int? {
        
        if start < self.endIndex {
        
            if start >= self.startIndex {
                return start
            }
            else {
                return self.startIndex
            }
        }
        return nil
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSRangeConvertible protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var range: NSRange? {
        
        let len = endIndex.integerValue - startIndex.integerValue
        return NSMakeRange(startIndex.integerValue, len)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func equals(to other: Any?) -> Bool {
        
        if let other = other {
        
            if let other = other as? SourceStringSegment {
            
                if self.startIndex != other.startIndex {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("sourceStringSegment: %@", log: Log.Common.all, type: .debug, %%self)
                    os_log("other sourceStringSegment: %@", log: Log.Common.all, type: .debug, %%other)
                    os_log("Not equals: startIndex are different.", log: Log.Common.all, type: .debug)
                    #endif
                    return false
                }

                if self.endIndex != other.endIndex {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: endIndex are different.", log: Log.Common.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not SourceStringSegment.", log: Log.Common.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other is nil.", log: Log.Common.all, type: .debug)
            #endif
            return false
        }
        return true
    }
}

extension SourceStringSegment: Hashable {
    
    public var hashValue: Int {
        
        return startIndex.hashValue ^ endIndex.hashValue
    }
    
}

/// FIXME: The equality method does not take into consideration 
/// lineNumber, we should add it eventually or just get rid of this 
/// concept all together.
public func ==(lhs: SourceStringSegment, rhs: SourceStringSegment) -> Bool {
    
    return lhs.equals(to: rhs)
}

public func <(lhs: SourceStringSegment, rhs: SourceStringSegment) -> Bool {
    
    // Ensure that both indexes are from the same region
    //    assert(lhs.sourceStringRegionIdentity == rhs.sourceStringRegionIdentity)
    
    return lhs.endIndex <= rhs.startIndex
}

public func <=(lhs: SourceStringSegment, rhs: SourceStringSegment) -> Bool {
    
    // Ensure that both indexes are from the same region
    //    assert(lhs.sourceStringRegionIdentity == rhs.sourceStringRegionIdentity)
    
    return lhs < rhs || lhs == rhs
}

public func >(lhs: SourceStringSegment, rhs: SourceStringSegment) -> Bool {
    
    // Ensure that both indexes are from the same region
    //    assert(lhs.sourceStringRegionIdentity == rhs.sourceStringRegionIdentity)
    
    return !(lhs <= rhs)
}

public func >=(lhs: SourceStringSegment, rhs: SourceStringSegment) -> Bool {
    
    // Ensure that both indexes are from the same region
    //    assert(lhs.sourceStringRegionIdentity == rhs.sourceStringRegionIdentity)
    
    return !(lhs < rhs)
}
