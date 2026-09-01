//
//  NSRange+ElementIndexesInRange.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-06-06.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import os

extension Collection where Element: Positionnable, Index == Int {
    
    public func adjacencies(from range: NSRange) -> RangeElementsAdjacency? {

        if self.isEmpty {
            
            return RangeElementsAdjacency.start
        }
        
        let beforeIndex = nonIncludingIndex(before: range)

        if beforeIndex == -1 {
            
            // look at the next index
            let nextElement = self[0]
            let fragment = nextElement.sourceStringFragment
            
            assert(fragment != nil)
            if let fragment = fragment {
                
                let fragmentRelativePosition = fragment.relativePosition(from: range)
                
                assert(fragmentRelativePosition != nil)
                if let fragmentRelativePosition = fragmentRelativePosition {
                    
                    switch fragmentRelativePosition {
                        
                    case .before:
                        assert(false, "impossible case: the beforeIndex is supposed to be the last .before index before the range.")
                        break
                        
                    case .after:
                        return RangeElementsAdjacency.start
                        
                    case .partiallyBefore:
                        
                        var indexes = [beforeIndex+1]
                        let otherCoveringIndexes = coveringElementsIndexes(range, afterExcludingIndex: beforeIndex+1)
                        indexes.append(contentsOf: otherCoveringIndexes)
                        return .covering(indexes: indexes)
                        
                    case .same:
                        return .covering(indexes: [beforeIndex+1])
                        
                    case .inside:
                        var indexes = [beforeIndex+1]
                        let otherCoveringIndexes = coveringElementsIndexes(range, afterExcludingIndex: beforeIndex+1)
                        indexes.append(contentsOf: otherCoveringIndexes)
                        return .covering(indexes: indexes)
                        
                    case .partiallyAfter:
                        return .covering(indexes: [beforeIndex+1])
                        
                    case .contains:
                        return RangeElementsAdjacency.exclusivelyInside(index: beforeIndex+1)
                    }
                }
            }
        }
        if beforeIndex == self.count-1 {
            return RangeElementsAdjacency.end
        }
        else {

            // look at the next index
            let nextElement = self[beforeIndex+1]
            let fragment = nextElement.sourceStringFragment
            
            assert(fragment != nil)
            if let fragment = fragment {
                
                let fragmentRelativePosition = fragment.relativePosition(from: range)
                
                assert(fragmentRelativePosition != nil)
                if let fragmentRelativePosition = fragmentRelativePosition {
            
                    switch fragmentRelativePosition {
                        
                    case .before:
                        assert(false, "impossible case: the beforeIndex is supposed to be the last .before index before the range.")
                        break
                        
                    case .after:
                        return RangeElementsAdjacency.between(low: beforeIndex, up: beforeIndex+1)
                        
                    case .partiallyBefore:
                        
                        var indexes = [beforeIndex+1]
                        let otherCoveringIndexes = coveringElementsIndexes(range, afterExcludingIndex: beforeIndex+1)
                        indexes.append(contentsOf: otherCoveringIndexes)
                        return .covering(indexes: indexes)
                        
                    case .same:
                        return .covering(indexes: [beforeIndex+1])
                        
                    case .inside:
                        var indexes = [beforeIndex+1]
                        let otherCoveringIndexes = coveringElementsIndexes(range, afterExcludingIndex: beforeIndex+1)
                        indexes.append(contentsOf: otherCoveringIndexes)
                        return .covering(indexes: indexes)
                        
                    case .partiallyAfter:
                        return .covering(indexes: [beforeIndex+1])
                        
                    case .contains:
                        return RangeElementsAdjacency.exclusivelyInside(index: beforeIndex+1)
                    }
                }
            }
        }
        return nil
    }
    
    public func elementIndex(containing range: NSRange) -> Int? {
        
        var lowerIndex = 0
        var upperIndex = count
        
        while lowerIndex < upperIndex {
            
            let mid = lowerIndex + ((upperIndex-lowerIndex)/2)
            let element = self[mid]
            if let fragment = element.sourceStringFragment {
            
                let fragmentRelativePosition = fragment.relativePosition(from: range)
                
                assert(fragmentRelativePosition != nil)
                if let fragmentRelativePosition = fragmentRelativePosition {
                    
                    switch fragmentRelativePosition {
                        
                    case .before:
                        lowerIndex = mid + 1
                    case .after:
                        upperIndex = mid
                    default:
                        return mid
                    }
                }
                else {
                    return nil
                }
            }
            else {
                return nil
            }
        }
        return nil
    }
    
    public func elementIndex(containing location: Int) -> Int? {
        
        let range = NSMakeRange(location, 0)
        var lowerIndex = 0
        var upperIndex = count
        
        while lowerIndex < upperIndex {
            
            let mid = lowerIndex + ((upperIndex-lowerIndex)/2)
            let element = self[mid]
            if let fragment = element.sourceStringFragment {
                
                let fragmentRelativePosition = fragment.relativePosition(from: range)
                
                assert(fragmentRelativePosition != nil)
                if let fragmentRelativePosition = fragmentRelativePosition {
                    
                    switch fragmentRelativePosition {
                        
                    case .before:
                        lowerIndex = mid + 1
                    case .after:
                        upperIndex = mid
                    default:
                        return mid
                    }
                }
                else {
                    return nil
                }
            }
            else {
                return nil
            }
        }
        return nil
    }
    
    public func elementIndex(containingOrEnding location: Int) -> Int? {
        
        if count == 0 {
            return nil
        }
        
        var lowerIndex = 0
        var upperIndex = count
        var elementIndexEnding: Int?
        
        while lowerIndex < upperIndex {
            
            let mid = lowerIndex + ((upperIndex-lowerIndex)/2)
            let element = self[mid]
            if let fragment = element.sourceStringFragment {
                
                let range = fragment.range
                
                assert(range != nil)
                if let range = range {
                
                    if location < range.location {
                        upperIndex = mid
                    }
                    else if location > range.upperBound {
                        lowerIndex = mid + 1
                    }
                    else if range.upperBound == location {
                        lowerIndex = mid + 1
                        elementIndexEnding = mid
                    }
                    else {
                        return mid
                    }
                }
                else {
                    return elementIndexEnding
                }
            }
        }
        return elementIndexEnding
    }
    
    /// Method that returns the elements that are completely or partially
    /// in the given range.
    ///
    /// Note: a zero range contains nothing by definition.
    public func elementsIndexes(in range: NSRange) -> [Int] {
        
        var elementsIndexes = [Int]()
        
        if let (index, relativePosition) = elementIndex(in: range) {
            
            switch relativePosition {
                
            case .partiallyBefore:
                
                elementsIndexes.append(index)
                let indexesAfter = elementsIndexesAfter(range, excluding: index)
                elementsIndexes.append(contentsOf: indexesAfter)
                
            case .same:
                elementsIndexes.append(index)
                
            case .inside:
                
                elementsIndexes.append(index)
                let indexesBefore = elementsIndexesBefore(range, excluding: index)
                elementsIndexes.append(contentsOf: indexesBefore)
                let indexesAfter = elementsIndexesAfter(range, excluding: index)
                elementsIndexes.append(contentsOf: indexesAfter)
                
            case .partiallyAfter:
                elementsIndexes.append(index)
                let indexesBefore = elementsIndexesBefore(range, excluding: index)
                elementsIndexes.append(contentsOf: indexesBefore)
                
            case .contains:
                
                elementsIndexes.append(index)
                
            default:
                assert(false, "Realtive fragment position should not be: \(relativePosition)")
                break
            }
        }
        return elementsIndexes.sorted()
    }
    
    private func firstElementIndex(in range: NSRange, from index: Int) -> Int? {
        
        var lastIndexInside: Int?
        
        outerLoop: for i in stride(from: index, through: 0, by: -1) {
            
            let element = self[i]
            let fragment = element.sourceStringFragment
            
            assert(fragment != nil)
            if let fragment = fragment {
                
                let fragmentRelativePosition = fragment.relativePosition(from: range)
                
                assert(fragmentRelativePosition != nil)
                if let fragmentRelativePosition = fragmentRelativePosition {
                    
                    switch fragmentRelativePosition {
                        
                    case .before:
                        break outerLoop
                        
                    case .partiallyBefore:
                        
                        lastIndexInside = i
                        break outerLoop
                        
                    case .same:
                        lastIndexInside = i
                        break outerLoop
                        
                    case .inside:
                        lastIndexInside = i
                        
                    case .partiallyAfter:
                        
                        lastIndexInside = i
                        
                    case .after:
                        
                        #if DEBUG
                        // impossible case
                        assert(false, "we are asking for previous indexes but it is after...")
                        #endif
                        break outerLoop
                        
                    case .contains:
                        
                        #if DEBUG
                        // impossible case
                        assert(false, "we are asking for previous indexes but it contains...")
                        #endif
                        break outerLoop
                    }
                }
                else {
                    break
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("element's fragment is nil.", log: Log.Common.all, type: .debug)
                #endif
            }
        }
        return lastIndexInside
    }
    
    private func elementsIndexesBefore(_ range: NSRange, excluding index: Int) -> [Int] {
        
        var indexes = [Int]()
        
        outerLoop: for i in stride(from: index - 1, through: 0, by: -1) {
            
            let element = self[i]
                
            let fragment = element.sourceStringFragment
            
            assert(fragment != nil)
            if let fragment = fragment {
                
                let fragmentRelativePosition = fragment.relativePosition(from: range)
                
                assert(fragmentRelativePosition != nil)
                if let fragmentRelativePosition = fragmentRelativePosition {
                    
                    switch fragmentRelativePosition {
                        
                    case .before:
                        break outerLoop
                        
                    case .same:
                        indexes.append(i)
                        break outerLoop
                        
                    case .partiallyBefore:
                        
                        indexes.append(i)
                        break outerLoop
                        
                    case .inside:
                        
                        indexes.append(i)
                        
                    case .partiallyAfter:
                        
                        #if DEBUG
                        // impossible case
                        assert(false, "performance problem: we are asking for previous indexes but it is partially after...")
                        #endif
                        break
                        
                    case .after:
                        
                        #if DEBUG
                        // impossible case
                        assert(false, "performance problem: we are asking for previous indexes but it is after...")
                        #endif
                        break outerLoop
                        
                    case .contains:
                        
                        #if DEBUG
                        // impossible case
                        assert(false, "we are asking for previous indexes but it contains...")
                        #endif
                        break
                    }
                }
                else {
                    break
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("element's fragment is nil.", log: Log.Common.all, type: .debug)
                #endif
            }
        }
        return indexes
    }
    
    /// Covering indexes are indexes that fall into one of these cases:
    /// .partiallyBefore
    /// .same
    /// .inside
    /// .partiallyAfter
    /// .contains
    private func coveringElementsIndexes(_ range: NSRange, afterExcludingIndex index: Int) -> [Int] {
        
        var indexes = [Int]()
        
        outerLoop: for i in index+1..<self.count {
            
            let element = self[i]
            
            let fragment = element.sourceStringFragment
            
            assert(fragment != nil)
            if let fragment = fragment {
                
                let fragmentRelativePosition = fragment.relativePosition(from: range)
                
                assert(fragmentRelativePosition != nil)
                if let fragmentRelativePosition = fragmentRelativePosition {
                    
                    switch fragmentRelativePosition {
                        
                    case .before:
                        #if DEBUG
                        // impossible case
                        assert(false, "performance problem: we are asking for after indexes but the current one is before...")
                        #endif
                        break
                        
                    case .partiallyBefore:
                        
                        indexes.append(i)
                        
                    case .same:
                        indexes.append(i)
                        break outerLoop
                        
                    case .inside:
                        indexes.append(i)
                        
                    case .partiallyAfter:
                        
                        indexes.append(i)
                        break outerLoop
                        
                    case .after:
                        break outerLoop
                        
                    case .contains:
                        
                        #if DEBUG
                        // impossible case
                        assert(false, "possible logic problem: verify calling code.")
                        #endif
                        indexes.append(i)
                    }
                }
                else {
                    break
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("element's fragment is nil.", log: Log.Common.all, type: .debug)
                #endif
            }
        }
        return indexes
    }
    
    private func elementsIndexesAfter(_ range: NSRange, excluding index: Int) -> [Int] {
        
        var indexes = [Int]()
        
        outerLoop: for i in index+1..<self.count {
            
            let element = self[i]
                
            let fragment = element.sourceStringFragment
            
            assert(fragment != nil)
            if let fragment = fragment {
                
                let fragmentRelativePosition = fragment.relativePosition(from: range)
                
                assert(fragmentRelativePosition != nil)
                if let fragmentRelativePosition = fragmentRelativePosition {
                    
                    switch fragmentRelativePosition {
                        
                    case .before:
                        #if DEBUG
                        // impossible case
                        assert(false, "performance problem: we are asking for after indexes but it is before...")
                        #endif
                        break
                        
                    case .partiallyBefore:
                        
                        #if DEBUG
                        // impossible case
                        assert(false, "performance problem: we are asking for after indexes but it is partially before...")
                        #endif
                        break
                        
                    case .same:
                        indexes.append(i)
                        break outerLoop
                        
                    case .inside:
                        
                        indexes.append(i)
                        
                    case .partiallyAfter:
                        
                        indexes.append(i)
                        break outerLoop
                        
                    case .after:
                        break outerLoop
                        
                    case .contains:
                        
                        #if DEBUG
                        // impossible case
                        assert(false, "performance problem: we are asking for after indexes but it contains...")
                        #endif
                        break
                    }
                }
                else {
                    break
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("element's fragment is nil.", log: Log.Common.all, type: .debug)
                #endif
            }
        }
        return indexes
    }
    
    /// Returns the index of the element before the specified range
    /// but not touching this range.
    public func nonIncludingIndex(before range: NSRange) -> Int {
    
        var lowerIndex = 0
        var upperIndex = count
        
        while lowerIndex <= upperIndex {
            
            let mid = lowerIndex + ((upperIndex-lowerIndex)/2)
            let element = self[mid]
            let fragment = element.sourceStringFragment!
            
            let fragmentRelativePosition = fragment.relativePosition(from: range)
            
            assert(fragmentRelativePosition != nil)
            if let fragmentRelativePosition = fragmentRelativePosition {
                
                switch fragmentRelativePosition {
                    
                case .before:
                    // ok
                    if lowerIndex == upperIndex {
                        return mid-1
                    }
                    else if mid + 1 == upperIndex {
                        // we are at the end
                        return mid
                    }
                    lowerIndex = mid + 1
                case .after:
                    // ok
                    if lowerIndex == upperIndex {
                        return mid-1
                    }
                    upperIndex = mid
                case .same:
                    // ok
                    #if DEBUG
                    if mid > 0 {
                        let _element = self[mid-1]
                        let _fragment = _element.sourceStringFragment!
                        let _fragmentRelativePosition = _fragment.relativePosition(from: range)
                        assert(_fragmentRelativePosition == .before)
                    }
                    #endif
                    return mid-1
                case .partiallyBefore:
                    // ok
                    #if DEBUG
                    if mid > 0 {
                        let _element = self[mid-1]
                        let _fragment = _element.sourceStringFragment!
                        let _fragmentRelativePosition = _fragment.relativePosition(from: range)
                        assert(_fragmentRelativePosition == .before)
                    }
                    #endif
                    return mid-1
                case .inside:
                    #if DEBUG
                    if mid > 0 {
                        // here we test that the element before the current element
                        // is either before, partiallyBefore or inside
                        let _element = self[mid-1]
                        let _fragment = _element.sourceStringFragment!
                        let _fragmentRelativePosition = _fragment.relativePosition(from: range)
                        assert(_fragmentRelativePosition == .before || _fragmentRelativePosition == .partiallyBefore || _fragmentRelativePosition == .inside)
                    }
                    #endif
                    if lowerIndex == upperIndex {
                        return mid-1
                    }
                    upperIndex = mid
                case .partiallyAfter:
                    if lowerIndex == upperIndex {
                        return mid-1
                    }
                    upperIndex = mid
                case .contains:
                    return mid-1
                }
            }
        }
        assert(false, "returning 0")
        return 0
    }
    
    private func elementIndex(in range: NSRange) -> (Int, RangeRelativePosition)? {
        
        if range.length == 0 || count == 0 {
            return nil
        }
        
        var lowerIndex = 0
        var upperIndex = count
        
        while lowerIndex < upperIndex {
            
            let mid = lowerIndex + ((upperIndex-lowerIndex)/2)
            let element = self[mid]
            let fragment = element.sourceStringFragment!
            
            let fragmentRelativePosition = fragment.relativePosition(from: range)
            
            assert(fragmentRelativePosition != nil)
            if let fragmentRelativePosition = fragmentRelativePosition {
                
                switch fragmentRelativePosition {
                    
                case .before:
                    lowerIndex = mid + 1
                case .after:
                    upperIndex = mid
                default:
                    return (mid, fragmentRelativePosition)
                }
            }
            else {
                return nil
            }
        }
        return nil
    }
    
    
}
