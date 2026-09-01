//
//  Tokens+SequenceType.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-24.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation

extension Tokens: Sequence {
    
    // SequenceType protocol implementation
    public func makeIterator() -> TokenGenerator {
        
        return TokenGenerator(tokens: self.tokenValues)
    }
}

// see http://lillylabs.no/2014/09/30/make-iterable-swift-collection-type-sequencetype/
public final class TokenGenerator : IteratorProtocol {
    
    // Hold the collection to be iterated through
    fileprivate var tokens: [Token]
    
    // Hold the index of the next item in the iteration
    fileprivate var nextIndex: Int
    
    // Initialize the generator, passing a reference
    // to the car array
    init(tokens: [Token]) {
        
        self.tokens = tokens
        
        // Set the nextIndex to the index of the
        // first in the array
        // (since our collection is LIFO)
        nextIndex = 0
    }
    
    // Implement the next method, to return nil if
    // there are no more node, or the next Node.
    // Note that we have specified the return type
    // as an optional "node": Node?.
    public func next() -> Token? {
        
        if nextIndex >= tokens.count {
            
            return nil
        }
        
        nextIndex += 1
        
        return self.tokens[nextIndex-1]
    }
}
