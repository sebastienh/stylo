//
//  DynamicArray+SequenceType.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-07-18.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
extension DynamicArray : Sequence {
    
    // SequenceType protocol implementation
    public func makeIterator() -> DynamicArrayGenerator<T> {
        
        return DynamicArrayGenerator<T>(values: self.values)
    }
}

// see http://lillylabs.no/2014/09/30/make-iterable-swift-collection-type-sequencetype/
public final class  DynamicArrayGenerator<T> : IteratorProtocol {
    
    // Hold the collection to be iterated through
    fileprivate var values: [T]
    
    // Hold the index of the next item in the iteration
    fileprivate var nextIndex: Int
    
    // Initialize the generator, passing a reference
    // to the car array
    init(values: [T]) {
        
        self.values = values
        
        // Set the nextIndex to the index of the
        // first in the array
        // (since our collection is LIFO)
        nextIndex = 0
    }
    
    // Implement the next method, to return nil if
    // there are no more node, or the next Node.
    // Note that we have specified the return type
    // as an optional "node": Node?.
    public func next() -> T? {
        
        if (nextIndex >= values.count) {
            return nil
        }
        
        // Decrement the index after it has been
        //evaluated
        
        nextIndex += 1
        return self.values[nextIndex - 1]
    }
}
