////
////  SourceStringRegion+SequenceType.swift
////  Common
////
////  Created by Sébastien Hamel on 2015-11-10.
////  Copyright © 2015 NM. All rights reserved.
////
//
//import Foundation
//
//extension SourceStringRegion : Sequence {
//    
//    // SequenceType protocol implementation
//    public func makeIterator() -> SourceStringRegionIndexGenerator {
//        
//        return SourceStringRegionIndexGenerator(region: self)
//    }
//}
//
///// see http://lillylabs.no/2014/09/30/make-iterable-swift-collection-type-sequencetype/
//public final class SourceStringRegionIndexGenerator : IteratorProtocol {
//    
//    // SourceStringRegion to iterate through
//    fileprivate var region: SourceStringRegion
//    
//    // Hold the index of the next item in the iteration
//    fileprivate var nextIndex: SourceStringRegion.Index?
//    
//    // Initialize the generator, passing a reference
//    // to the car array
//    init(region: SourceStringRegion) {
//        
//        self.region = region
//        
//        // Set the nextIndex to the index of the
//        // first in the array
//        // (since our collection is LIFO)
//        nextIndex = region.startIndex
//    }
//    
//    // Implement the next method, to return nil if
//    // there are no more node, or the next Node.
//    // Note that we have specified the return type
//    // as an optional "node": Node?.
//    public func next() -> SourceStringRegion.Index? {
//        
//        guard let _nextIndex = nextIndex else {
//            
//            return nil
//        }
//        
//        if _nextIndex == region.endIndex {
//            
//            return nil
//        }
//        
//        // keep the current index value
//        let currentIndex = _nextIndex
//        
//        // increment the nextIndex for the next request
//        nextIndex = (self.region.index(after: _nextIndex) as! SourceStringRegion.Index)
//        
//        // return the kept index
//        return currentIndex
//    }
//}
//
