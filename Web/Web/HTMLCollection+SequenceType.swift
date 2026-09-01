//
//  HTMLCollection+SequenceType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-07.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

//extension HTMLCollection : SequenceType {
//    
//    // SequenceType protocol implementation
//    public func generate() -> HTMLCollectionGenerator {
//        
//        return HTMLCollectionGenerator(collection: self)
//    }
//}
//
//// see http://lillylabs.no/2014/09/30/make-iterable-swift-collection-type-sequencetype/
//public class HTMLCollectionGenerator : GeneratorType {
//    
////    typealias GeneratorType.Element = Element
//    
//    // Hold the collection to be iterated through
//    private var collection: HTMLCollection
//    
//    // Hold the index of the next item in the iteration
//    private var nextIndex: Int
//    
//    // Initialize the generator, passing a reference
//    // to the car array
//    init(collection: HTMLCollection) {
//        
//        self.collection = collection
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
//    public func next() -> Element? {
//        
//        if let element = collection[nextIndex] as? Element {
//        
//            nextIndex++
//        
//            return element
//        }
//        
//        return nil
//    }
//}
