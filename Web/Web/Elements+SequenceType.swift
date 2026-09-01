//
//  Elements+SequenceType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-01.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

//extension Elements : Sequence {
//    
//    // SequenceType protocol implementation
//    public func makeIterator() -> ElementsGenerator {
//        
//        return ElementsGenerator(elementsList: self.valuesArray)
//    }
//}
//
//// see http://lillylabs.no/2014/09/30/make-iterable-swift-collection-type-sequencetype/
//public final class ElementsGenerator : IteratorProtocol {
//    
//    // Hold the collection to be iterated through
//    fileprivate var elementsList: [Element]
//    
//    // Hold the index of the next item in the iteration
//    fileprivate var nextIndex: Int
//    
//    // Initialize the generator, passing a reference
//    // to the car array
//    init(elementsList: [Web.Element]) {
//        
//        self.elementsList = elementsList
//        
//        // Set the nextIndex to the index of the
//        // first in the array
//        // (since our collection is LIFO)
//        nextIndex = 0
//    }
//    
//    // Implement the next method, to return nil if
//    // there are no more node, or the next Node.
//    // Note that we have specified the return type
//    // as an optional "node": Node?.
//    public func next() -> Node? {
//        
//        if (nextIndex >= elementsList.count) {
//            return nil
//        }
//        
//        // Decrement the index after it has been
//        //evaluated
//        nextIndex += 1
//        return self.elementsList[nextIndex - 1]
//    }
//}

