//
//  SourceStringSegment+SequenceType.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-08-30.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

extension SourceStringSegment : Sequence {
    
    // SequenceType protocol implementation
    public func makeIterator() -> SourceStringSegmentIndexGenerator {
        
        return SourceStringSegmentIndexGenerator(segment: self)
    }
}

/// see http://lillylabs.no/2014/09/30/make-iterable-swift-collection-type-sequencetype/
public final class SourceStringSegmentIndexGenerator : IteratorProtocol {
    
    // SourceStringRegion to iterate through
    fileprivate var segment: SourceStringSegment
    
    // Hold the index of the next item in the iteration
    fileprivate var nextIndex: Int?
    
    // Initialize the generator, passing a reference
    // to the car array
    init(segment: SourceStringSegment) {
        
        self.segment = segment
        
        // Set the nextIndex to the index of the
        // first in the array
        // (since our collection is LIFO)
        nextIndex = segment.startIndex
    }
    
    // Implement the next method, to return nil if
    // there are no more node, or the next Node.
    // Note that we have specified the return type
    // as an optional "node": Node?.
    public func next() -> Int? {
        
        guard let _nextIndex = nextIndex else {
            
            return nil
        }
        
        if _nextIndex == segment.endIndex {
            
            return nil
        }
        
        // keep the current index value
        let currentIndex = _nextIndex
        
        // increment the nextIndex for the next request
        nextIndex = self.segment.index(after: _nextIndex)
        
        // return the kept index
        return currentIndex
    }
}

