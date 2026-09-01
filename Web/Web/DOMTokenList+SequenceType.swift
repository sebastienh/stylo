//
//  DOMTokenList+SequenceType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-02-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

extension DOMTokenList : Sequence {
    
    // SequenceType protocol implementation
    public func makeIterator() -> TokenGenerator {
        
        return TokenGenerator(tokens: tokens)
    }
}

// see http://lillylabs.no/2014/09/30/make-iterable-swift-collection-type-sequencetype/
public final class TokenGenerator : IteratorProtocol {
    
    // Hold the collection to be iterated through
    fileprivate let tokens: [DOMString]
    
    // Hold the index of the next item in the iteration
    fileprivate var tokenIndex: Int
    
    // Initialize the generator, passing a reference
    // to the car array
    init(tokens: [DOMString]) {
        
        self.tokens = tokens
        
        // Set the nextIndex to the index of the
        // first in the array
        // (since our collection is LIFO)
        tokenIndex = 0
    }
    
    // Implement the next method, to return nil if
    // there are no more node, or the next Node.
    // Note that we have specified the return type
    // as an optional "node": Node?.
    public func next() -> DOMString? {
        
        if (tokenIndex >= tokens.count) {
            return nil
        }
        
        // Decrement the index after it has been
        //evaluated
        tokenIndex += 1
        return self.tokens[tokenIndex-1]
    }
}
