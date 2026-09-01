//
//  SourceStringRegion.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-11-10.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import os

/// A SourceStringRegion is a set of SourceStringSegments
public struct SourceStringRegion: SourceStringFragment, Equatable {
    
    
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
        
        let position = i + n
        return self[position]
    }

    /// Subscripted access
    /// return the fragment index
    public subscript(index: Int) -> Int {
        
        let globalIndexFromContentPosition = self.globalIndexFromContentPosition(index)
        
        assert(globalIndexFromContentPosition != nil)
        if let (position, _) = globalIndexFromContentPosition {
            
            return position
        }
        fatalError("globalIndexFromContentPosition is nil")
    }

    /// Returns the position immediately after `i`.
    ///
    /// - Precondition: `(startIndex..<endIndex).contains(i)`
    public func index(after i: Int) -> Int {
        
        let position = i + 1
        return self[position]
    }

    /// Return the first index of the fragment
    public var startFragmentIndex: Int? {
        
        return sourceStringSegments.first?.startIndex
    }
    
    /// Return the last index of the fragment
    public var endFragmentIndex: Int? {
        
        return sourceStringSegments.last?.endIndex
    }
    
    public var debugDescription: String {
        
        var _desc = ""
        
        for segment in sourceStringSegments {
            
            _desc += "-> \(segment.debugDescription)\n"
        }
        
        return _desc
    }
    
    public var stringRepresentation: String {
     
        var _stringRep = ""
        
        for (index, segment) in sourceStringSegments.enumerated() {
            
            if index != 0 {
                
                _stringRep += ";"
            }
            
            _stringRep += "\(segment.stringRepresentation)"
        }
        
        return _stringRep
    }
    
    ///
    public var sourceStringSegments: [SourceStringSegment]
    
    /// This array contains the length of each segment + total length so far,
    /// it is useful when we want to know to which segment a
    /// position belongs since we just need to use this until we found the
    /// "container" segment index.
    ///
    /// With two segments with lengths 4 and 5, the array would contain:
    /// [0] -> 4
    /// [1] -> 9
    /// [2]
    ///
    /// So if we have a position in the region, considered sequently
    /// we just need to iterate until the length is greater than the position
    /// we want in our case, for an index 7 [0] -> 4 is smaller, we move on to the next
    /// and we know since is is greater that our position must be in this segment
    var totalLengths: [Int]
    
    ///
    public var length: Int {
        
        // the last length contains the total length
        // of the region.
        if let lastLength = totalLengths.last {
            
            return lastLength
        }
        return 0
    }
    
    ///
    /// Return true if the SourceStringRegion has total length of 0.
    ///
    var isEmpty: Bool {
        
        return totalLengths.reduce(0, +) == 0
    }
    
    public var startIndex: Int? {
        
        if let firstSegment = sourceStringSegments.first {
            
            return firstSegment.startIndex
        }
        
        return nil
    }
    
    public var lastIndex: Int? {
        
        if let lastSegment = sourceStringSegments.last {
            
            return lastSegment.endIndex
        }
        
        return nil
    }
    
    public subscript(index: Int) -> SourceStringSegment? {
        
        if index < sourceStringSegments.count {
            
            return sourceStringSegments[index]
        }
        
        return nil
    }
    
    public init(_ sourceStringSegment: SourceStringSegment) {
        
        sourceStringSegments = [SourceStringSegment]()
        totalLengths = [Int]()
        self.addSourceStringSegment(sourceStringSegment)
    }

    public init() {
        
        sourceStringSegments = [SourceStringSegment]()
        totalLengths = [Int]()
    }
    
    public mutating func removeSourceStringSegment(_ sourceStringSegmentToDelete: SourceStringSegment) {
        
        var indexesToDelete = [Int]()
        
        for i in 0..<self.sourceStringSegments.count {
            
            let sourceStringSegment = sourceStringSegments[i]
            
            if sourceStringSegment.equals(to: sourceStringSegmentToDelete) {
                
                indexesToDelete.append(i)
            }
        }
        
        for indexeToDelete in indexesToDelete.reversed() {
            
            sourceStringSegments.remove(at: indexeToDelete)
        }
    }
    
    public mutating func addSourceStringSegment(_ sourceStringSegment: SourceStringSegment) {
        
        assert(sourceStringSegment.startIndex <=  sourceStringSegment.endIndex)
        
//        #if DEBUG
//        if let lastSegment = self.sourceStringSegments.last {
//            assert(lastSegment < sourceStringSegment)
//        }
//        #endif
        
        if self.sourceStringSegments.last != sourceStringSegment {
        
            self.sourceStringSegments.append(sourceStringSegment)
            
            if let last = totalLengths.last {
                
                totalLengths.append(last + sourceStringSegment.length)
            }
            else {
                
                totalLengths.append(sourceStringSegment.length)
            }
        }
    }
    
    public func merged(with otherFragment: SourceStringFragment) -> SourceStringRegion? {
    
        if let sourceStringRegion = otherFragment as? SourceStringRegion {
            
            return self.mergedRegion(with: sourceStringRegion)
        }
        else {
            
            let sourceStringSegment = otherFragment as? SourceStringSegment
            
            assert(sourceStringSegment != nil)
            if let sourceStringSegment = sourceStringSegment {
                
                return self.mergedSegment(with: sourceStringSegment)
            }
        }
        return nil 
    }
    
    private func mergedRegion(with otherRegion: SourceStringRegion) -> SourceStringRegion {
        
        var index = 0
        var otherIndex = 0
        let totalSegments = self.sourceStringSegments.count + otherRegion.sourceStringSegments.count
        var result = SourceStringRegion()
        
        for _ in 0..<totalSegments {
         
            if index < self.sourceStringSegments.count {
            
                if otherIndex < otherRegion.sourceStringSegments.count {
                
                    if self.sourceStringSegments[index] <= otherRegion.sourceStringSegments[otherIndex] {
                        
                        result.addSourceStringSegment(self.sourceStringSegments[index])
                        index += 1
                    }
                    else {
                        
                        result.addSourceStringSegment(otherRegion.sourceStringSegments[otherIndex])
                        otherIndex += 1
                    }
                }
                else {
                    
                    result.addSourceStringSegment(self.sourceStringSegments[index])
                    index += 1
                }
            }
            else {
                
                result.addSourceStringSegment(otherRegion.sourceStringSegments[otherIndex])
                otherIndex += 1
            }
        }
        return result
    }
    
    private func mergedSegment(with sourceStringSegment: SourceStringSegment) -> SourceStringRegion {
        
        var index = 0
        let totalSegments = self.sourceStringSegments.count + 1
        var result = SourceStringRegion()
        var insertedSegment = false
        
        
        for _ in 0..<totalSegments {
            
            if (index < self.sourceStringSegments.count && self.sourceStringSegments[index] <= sourceStringSegment) || insertedSegment {
                
                result.addSourceStringSegment(self.sourceStringSegments[index])
                index += 1
            }
            else {
                
                result.addSourceStringSegment(sourceStringSegment)
                insertedSegment = true
            }
        }
        return result
    }
    
    public mutating func clear() {
        
        sourceStringSegments.removeAll()
        totalLengths.removeAll()
    }
    
    public func segments(from start: Int, until end: Int?) -> [SourceStringSegment]? {
        
        var result = [SourceStringSegment]()
        
        for sourceStringSegment in self.sourceStringSegments {
        
            if let segments = sourceStringSegment.segments(from: start, until: end) {
                result.append(contentsOf: segments)
            }
        }
        return result
    }
    
    public func subRegion(fromPosition start: Int = 0, endPosition end: Int) -> SourceStringRegion? {
        
        let globalStart = codePointFromContentPosition(start)!
        let globalEnd = codePointFromContentPosition(end)!
        
        if let firstSegmentIndex = segmentIndexForPosition(start) {
            
            var firstSegment = sourceStringSegments[firstSegmentIndex]
            
            // replace the first integer index with the start
            firstSegment.startIndex = globalStart
            
            if let endSegmentIndex = segmentIndexForPosition(end) {
                
                var subRegion = SourceStringRegion()
                
                if firstSegmentIndex == endSegmentIndex {
                    
                    firstSegment.endIndex = globalEnd
                    subRegion.addSourceStringSegment(firstSegment)
                    return subRegion
                }
                else {
                    
                    var endSegment = sourceStringSegments[endSegmentIndex]
                    
                    // replace the end integer index with the end
                    endSegment.endIndex = globalEnd
                    subRegion.addSourceStringSegment(firstSegment)
                    
                    // for all segments in between
                    for index in (firstSegmentIndex + 1)...(endSegmentIndex - 1) {
                        
                        subRegion.addSourceStringSegment(sourceStringSegments[index])
                    }
                    
                    subRegion.addSourceStringSegment(endSegment)
                    return subRegion
                }
            }
        }
        
        return nil
    }
    
    /// translate the region by count.
    mutating public func move(_ count: Int) {
        
        for i in 0..<sourceStringSegments.count {
            sourceStringSegments[i].move(count)
        }
    }
    
    public mutating func moveEnd(_ count: Int) {
        
        let lastIndex = self.sourceStringSegments.count-1
        sourceStringSegments[lastIndex].moveEnd(count)
    }
    
    public func moved(_ count: Int) -> SourceStringFragment {
        
        var sourceStringRegion = SourceStringRegion()
        
        for i in 0..<sourceStringSegments.count {
            
            let movedSourceStringSegment = sourceStringSegments[i].moved(count) as? SourceStringSegment
            
            assert(movedSourceStringSegment != nil)
            if let movedSourceStringSegment = movedSourceStringSegment {
            
                sourceStringRegion.addSourceStringSegment(movedSourceStringSegment)
            }
        }
        return sourceStringRegion
    }
    
    /// This method truncate the head by one, moving the first
    /// index by one in the region.
    mutating public func truncateHeadByOne() {
        
        let sourceStringSegment = sourceStringSegments.first
        
        assert(sourceStringSegment != nil)
        if var sourceStringSegment = sourceStringSegment {
        
            sourceStringSegment.truncateHeadByOne()
            
            if !sourceStringSegment.isEmpty {
                
                assert(sourceStringSegments.first!.length > 1)
                sourceStringSegments[0] = sourceStringSegment
            }
            else {
                
                assert(sourceStringSegments.first!.length == 1)
                sourceStringSegments.removeFirst()
                totalLengths.removeFirst()
            }
            // update lengths
            for i in 0..<totalLengths.count {
                totalLengths[i] = totalLengths[i]-1
            }
        }
    }
    
    /// This method truncate the tail by one position, retreating
    /// the last index by one in the region.
    mutating public func truncateTailByOne() {
        
        let sourceStringSegment = sourceStringSegments.last
        
        assert(sourceStringSegment != nil)
        if var sourceStringSegment = sourceStringSegment {
            
            sourceStringSegment.truncateTailByOne()
            
            if !sourceStringSegment.isEmpty {
                sourceStringSegments[sourceStringSegments.count-1] = sourceStringSegment
                totalLengths[sourceStringSegments.count-1] = totalLengths[sourceStringSegments.count-1]-1
            }
            else {
                sourceStringSegments.removeLast()
                totalLengths.removeLast()
            }
        }
    }
    
    ///
    public func codePointFromContentPosition(_ position: Int) -> Int? {
        
        if let (globalIndex, _) = globalIndexFromContentPosition(position) {
            
            return globalIndex
        }
        return nil
    }
    
    ///
    func globalIndexFromContentPosition(_ position: Int) -> (Int, SourceStringSegment)? {
        
        if let segmentIndex = segmentIndexForPosition(position) {
            
            let segment = sourceStringSegments[segmentIndex]
            
            // take the previous segment last position
            let positionModifier = segmentIndex > 0 ? totalLengths[segmentIndex - 1] : 0
            
            //
            let _position = position + segment.startIndex - positionModifier
            
            return (_position, segment)
        }
        
        return nil
    }
    
    /// This method return the index of the source string segment this
    /// position belongs when all segments are considered "côte-à-côte".
    fileprivate func segmentIndexForPosition(_ position: Int) -> Int? {
        
        if let last = totalLengths.last {
            
            /// the position is outside the range covered by this
            /// region.
            if position >= last {
                return nil
            }
        }
        
        for (index, length) in totalLengths.enumerated() {
            
            if position < length {
                return index
            }
        }
        return nil
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func equals(to other: Any?) -> Bool {
        
        if let other = other {
        
            if let other = other as? SourceStringRegion {
                
                if sourceStringSegments.count != other.sourceStringSegments.count {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: sourceStringSegments.count are different.", log: Log.Common.all, type: .debug)
                    #endif
                    return false
                }
                
                for (index, segment) in sourceStringSegments.enumerated() {
                    
                    let otherSegment = other.sourceStringSegments[index]
                    
                    if !segment.equals(to: otherSegment) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: sourceStringSegment elements are different.", log: Log.Common.all, type: .debug)
                        #endif
                        return false
                    }
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not SourceStringRegion.", log: Log.Common.all, type: .debug)
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
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSRangeConvertible protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var range: NSRange? {
        
        guard let startIndex = startIndex, let lastIndex = lastIndex else {
            
            os_log("Invalid fragment start index: %@, end index: %d", log: Log.Common.all, type: .error, %%self.startIndex, %%self.lastIndex)
            // it's posible to have an empty region
            return nil
        }
        
        let lenght = lastIndex - startIndex
        
        return NSMakeRange(startIndex, lenght)
    }
}

public func ==(lhs: SourceStringRegion, rhs: SourceStringRegion) -> Bool {
    
    return lhs.equals(to: rhs)
}

public func + (left: SourceStringRegion, right: SourceStringRegion) -> SourceStringRegion {
    
    var result = SourceStringRegion()
    
    for segment in left.sourceStringSegments {
        
        result.addSourceStringSegment(segment)
    }
    
    for segment in right.sourceStringSegments {
        
        result.addSourceStringSegment(segment)
    }
    
    return result
}

public func += (left: SourceStringRegion, right: SourceStringRegion) -> SourceStringRegion {
    
    return left + right
}






