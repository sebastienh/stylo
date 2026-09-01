//
//  CSDeclarationList+SequenceType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-09-26.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation

extension CSDeclarationList : Sequence {
    
    // SequenceType protocol implementation
    func makeIterator() -> DeclarationGenerator {
        
        return DeclarationGenerator(declarations: self.declarations)
    }
}

// see http://lillylabs.no/2014/09/30/make-iterable-swift-collection-type-sequencetype/
final class DeclarationGenerator : IteratorProtocol {
    
    // Hold the collection to be iterated through
    fileprivate var declarations: [Declaration]
    
    // Hold the index of the next item in the iteration
    fileprivate var nextIndex: Int
    
    // Initialize the generator, passing a reference
    // to the car array
    init(declarations: [Declaration]) {
        
        self.declarations = declarations
        
        // Set the nextIndex to the index of the
        // first in the array
        // (since our collection is LIFO)
        nextIndex = 0
    }
    
    // Implement the next method, to return nil if
    // there are no more node, or the next Node.
    // Note that we have specified the return type
    // as an optional "node": Node?.
    func next() -> Declaration? {
        
        if (nextIndex >= declarations.count) {
            return nil
        }
        
        // Decrement the index after it has been
        //evaluated
        
        nextIndex += 1
        
        return self.declarations[nextIndex - 1]
    }
}
