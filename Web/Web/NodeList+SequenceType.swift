//
//  NodeList+SequenceType.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-20.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation

extension NodeList : Sequence {
    
    // SequenceType protocol implementation
    public func makeIterator() -> NodeGenerator {
    
        return NodeGenerator(nodeList: self)
    }
}

// see http://lillylabs.no/2014/09/30/make-iterable-swift-collection-type-sequencetype/
public struct NodeGenerator : IteratorProtocol {
    
    // Hold the collection to be iterated through
    fileprivate var nodeList: NodeList
    
    // Hold the index of the next item in the iteration
    fileprivate var nextIndex: Int
    
    // Initialize the generator, passing a reference
    // to the car array
    init(nodeList: NodeList) {
        
        self.nodeList = nodeList
        
        // Set the nextIndex to the index of the
        // first in the array
        // (since our collection is LIFO)
        nextIndex = 0
    }
    
    // Implement the next method, to return nil if
    // there are no more node, or the next Node.
    // Note that we have specified the return type
    // as an optional "node": Node?.
    public mutating func next() -> Node? {
        
        if (nextIndex >= nodeList.length) {
            
            return nil
        }
        
        // Decrement the index after it has been
        //evaluated
        
        nextIndex += 1
        
        return self.nodeList[nextIndex - 1]
    }
}
