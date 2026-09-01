//
//  CSSTextDecorationLine+SequenceType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-29.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

extension CSSTextDecorationLine : Sequence {
        
    // SequenceType protocol implementation
    public func makeIterator() -> TextDecorationLineTypeGenerator {
            
        return TextDecorationLineTypeGenerator(textDecorationLineArray: self.textDecorationLineArray)
    }
}

// see http://lillylabs.no/2014/09/30/make-iterable-swift-collection-type-sequencetype/
public final class  TextDecorationLineTypeGenerator : IteratorProtocol {
        
    // Hold the collection to be iterated through
    fileprivate var textDecorationLineArray: [CSSTextDecorationLineType]
    
    // Hold the index of the next item in the iteration
    fileprivate var nextIndex: Int
    
    // Initialize the generator, passing a reference
    // to the car array
    init(textDecorationLineArray: [CSSTextDecorationLineType]) {
        
        self.textDecorationLineArray = textDecorationLineArray
        
        // Set the nextIndex to the index of the
        // first in the array
        // (since our collection is LIFO)
        nextIndex = 0
    }
    
    // Implement the next method, to return nil if
    // there are no more node, or the next Node.
    // Note that we have specified the return type
    // as an optional "node": Node?.
    public func next() -> CSSTextDecorationLineType? {
        
        if (nextIndex >= textDecorationLineArray.count) {
            return nil
        }
        
        // Decrement the index after it has been
        //evaluated
        
        nextIndex += 1
        return self.textDecorationLineArray[nextIndex - 1]
    }
}
