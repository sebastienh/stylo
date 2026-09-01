//
//  NSRange+Additions.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-01-09.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation

public extension NSRange {
 
    var startIndex: Int {
        get {
            return location
        }
    }
    
    var endIndex: Int {
        get {
            return location + length
        }
    }
    
    var asRange: CountableRange<Int> {
        get {
            return location..<location + length
        }
    }
    
    var isEmpty: Bool {
        get {
            return length == 0
        }
    }
    
    func clamp(_ index: Int) -> Int {
        return max(self.startIndex, min(self.endIndex - 1, index))
    }
    
    func intersects(_ range: NSRange) -> Bool {
        return NSIntersectionRange(self, range).isEmpty == false
    }
    
    func intersection(range: NSRange) -> NSRange {
        return NSIntersectionRange(self, range)
    }
    
    /// This method cuts the current range before the starting of the
    /// of the range parameter.
    func cutBefore(_ range: NSRange) -> NSRange {

        if contains(range.location) {
        
            let cutLength = range.location - location
            return NSMakeRange(range.location, length - cutLength)
        }
        return self
    }
    
    /// Function that returns a new NSRange of length 0 and
    /// starting at the parameter range location from an existing NSRange
    var zeroLengthRange: NSRange {
        
        return NSMakeRange(location, 0)
    }

    /// Function that returns a new NSRange of length 0 and
    /// starting at the parameter range location from an existing NSRange
    var endZeroLengthRange: NSRange {
        
        return NSMakeRange(upperBound, 0)
    }
    
    func stringIndexRange(inString string: String) -> Range<String.Index>? {
        
        guard let rangeStart = string.index(string.startIndex, offsetBy: self.location, limitedBy: string.endIndex) else {
            assertionFailure("Error: rangeStart is nil")
            return nil
        }
        guard let rangeEnd = string.index(rangeStart, offsetBy: self.length, limitedBy: string.endIndex) else {
            assertionFailure("Error: rangeEnd is nil")
            return nil
        }
        return rangeStart..<rangeEnd
    }
    
    func utf16StringIndexRange(inString string: String) -> Range<String.UTF16View.Index>? {
        
        guard let rangeStart = string.utf16.index(string.utf16.startIndex, offsetBy: self.location, limitedBy: string.utf16.endIndex) else {
            assertionFailure("Error: rangeStart is nil")
            return nil
        }
        guard let rangeEnd = string.utf16.index(rangeStart, offsetBy: self.length, limitedBy: string.endIndex) else {
            assertionFailure("Error: rangeEnd is nil")
            return nil
        }
        return rangeStart..<rangeEnd
        
    }
    
    func substractsRanges(_ ranges: [NSRange]) -> [NSRange] {
        
        var remainingRanges = [NSRange]()
        
        var currentRangeStart: Int = startIndex
        
        // find the next range end which is the start of the next 
        // ranges to exclude.
        for range in ranges {
            
            if intersects(range) || (range.length == 0 && NSLocationInRange(range.location, self)) {
            
                if currentRangeStart < range.startIndex {
            
                    let currentRangeEnd = range.startIndex
                    let length = currentRangeEnd - currentRangeStart
                    let _range = NSMakeRange(currentRangeStart, length)

                    remainingRanges.append(_range)
                
                    currentRangeStart = range.endIndex
                }
                else if currentRangeStart == range.startIndex {
                    
                    currentRangeStart = range.endIndex
                }
                else if endIndex <= range.endIndex  {
                 
                    currentRangeStart = range.endIndex
                }
                else if endIndex > range.endIndex  {
                    
                    currentRangeStart = range.endIndex
                }
            }
        }
        
        // populate the end range 
        if currentRangeStart < endIndex {
        
            let length = endIndex - currentRangeStart
            let range = NSMakeRange(currentRangeStart, length)
            remainingRanges.append(range)
        }
        
        return remainingRanges
    }
    
    mutating func move(_ count: Int) {
        self.location += count
    }
    
    func relativePosition(from range: NSRange) -> RangeRelativePosition? {
        
        let (startIndexRelativePosition, endIndexRelativePosition) = indexesRelativePositions(from: range)
        
        switch startIndexRelativePosition {
            
        case .before:
            
            switch endIndexRelativePosition {
            case .before:
                return RangeRelativePosition.before
            case .start:
                return RangeRelativePosition.before
            case .contained:
                return RangeRelativePosition.partiallyBefore
            case .end:
                return RangeRelativePosition.partiallyBefore
            case .after:
                return RangeRelativePosition.contains
            }
            
        case .start:
            
            switch endIndexRelativePosition {
            case .before:
                #if DEBUG
                // impossible case
                assert(false, "end index cannot be before start index")
                #endif
                break
            case .start:
                return RangeRelativePosition.same
            case .contained:
                return RangeRelativePosition.inside
            case .end:
                return RangeRelativePosition.same
            case .after:
                
                if range.length == 0 {
                    return RangeRelativePosition.after
                }
                else {
                    return RangeRelativePosition.contains
                }
            }
            
        case .contained:
            
            switch endIndexRelativePosition {
            case .before:
                #if DEBUG
                // impossible case
                assert(false, "end index cannot be before start index")
                #endif
                break
            case .start:
                #if DEBUG
                // impossible case
                assert(false, "end index cannot be before start index")
                #endif
                break
            case .contained:
                return RangeRelativePosition.inside
                
            case .end:
                return RangeRelativePosition.inside
            case .after:
                return RangeRelativePosition.partiallyAfter
            }
            
        case .end:
            
            switch endIndexRelativePosition {
            case .before:
                #if DEBUG
                // impossible case
                assert(false, "end index cannot be before start index")
                #endif
                break
                
            case .start:
                #if DEBUG
                // impossible case
                assert(false, "end index cannot be before start index")
                #endif
                break
            case .contained:
                #if DEBUG
                // impossible case
                assert(false, "end index cannot be before start index")
                #endif
                break
            case .end:
                return RangeRelativePosition.same
            case .after:
                return RangeRelativePosition.after
            }
            
        case .after:
            
            switch endIndexRelativePosition {
            case .before:
                #if DEBUG
                // impossible case
                assert(false, "end index cannot be before start index")
                #endif
                break
                
            case .start:
                #if DEBUG
                // impossible case
                assert(false, "end index cannot be before start index")
                #endif
                break
                
            case .contained:
                #if DEBUG
                // impossible case
                assert(false, "end index cannot be before start index")
                #endif
                break
                
            case .end:
                #if DEBUG
                // impossible case
                assert(false, "end index cannot be before start index")
                #endif
                break
                
            case .after:
                return RangeRelativePosition.after
            }
        }
        return nil
    }
    
    private func indexesRelativePositions(from range: NSRange) -> (IndexRelativePosition, IndexRelativePosition) {
        
        let startIndexRelativePosition = indexRelativePosition(from: range, index: startIndex)
        let endIndexRelativePosition = indexRelativePosition(from: range, index: endIndex)
    
        return (startIndexRelativePosition, endIndexRelativePosition)
    }
    
    /// Method that returns the relative position of the index
    /// from the range parameter.
    private func indexRelativePosition(from range: NSRange, index: Int) -> IndexRelativePosition {
        
        if index == range.lowerBound {
            return .start
        } else if index == range.upperBound {
            return .end
        } else if NSLocationInRange(index, range) {
            return .contained
        } else if index < range.location {
            return .before
        }
        assert(index > range.upperBound)
        return .after
    }
    
    func update(with request: SourceStringChangeDescription) -> [NSRange]? {
        
        var _range = self
        
        let rangeRelativePosition = _range.relativePosition(from: request.range)
        
        assert(rangeRelativePosition != nil)
        if let rangeRelativePosition = rangeRelativePosition {
            
            // this is the position of the _attributesRange relative
            // to the request affected range
            switch rangeRelativePosition {
                
            case .before:
                // in this case we return the original range
                return [self]
                
            case .after:
                
                switch request.changeType {
                    
                case .pureReplace: fallthrough
                case .unchanged:
                    return [self]
                    
                case .pureRemoval: fallthrough
                case .replaceRemoval: fallthrough
                case .replaceAddition: fallthrough
                case .pureAddition:
                    _range.move(request.changeLength)
                    return [_range]
                }
                
            case .contains:
                
                // if the attributes range contains the modified range
                // we ask for the range before and the range after,
                // both could be nil as the modification could cover
                // the attributes range completely.
                let ranges = _range.substractsRanges([request.range])
                
                // for each range individually we compute the partial result
                var result = [NSRange]()
                for range in ranges {
                    
                    let partialResult = range.update(with: request)
                    if let partialResult = partialResult {
                        result.append(contentsOf: partialResult)
                    }
                }
                return result
                
            case .inside:
                
                // if we are completely inside then this range is not valid anymore
                return nil
                
            case .same:
                return nil
                
            case .partiallyAfter: fallthrough
            case .partiallyBefore:
                
                let intersect = _range.intersection(range: request.range)
                let ranges = _range.substractsRanges([intersect])
                
                assert(ranges.count == 1)
                assert(ranges.first != nil)
                if let substractionResultRange = ranges.first {
                    return substractionResultRange.update(with: request)
                }
                return nil
            }
        }
        return nil
    }
}















