//
//  CSSRuleList+SequenceType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-17.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

extension CSSRuleList : Sequence {
    
    // SequenceType protocol implementation
    public func makeIterator() -> RulesGenerator {
        
        return RulesGenerator(rules: self.rules)
    }
}

// see http://lillylabs.no/2014/09/30/make-iterable-swift-collection-type-sequencetype/
public final class RulesGenerator : IteratorProtocol {
    
    // Hold the collection to be iterated through
    fileprivate var rules: [CSSRule]
    
    // Hold the index of the next item in the iteration
    fileprivate var nextIndex: Int
    
    // Initialize the generator, passing a reference
    // to the car array
    init(rules: [CSSRule]) {
        
        self.rules = rules
        
        // Set the nextIndex to the index of the
        // first in the array
        // (since our collection is LIFO)
        nextIndex = 0
    }
    
    // Implement the next method, to return nil if
    // there are no more node, or the next Node.
    // Note that we have specified the return type
    // as an optional "node": Node?.
    public func next() -> CSSRule? {
        
        if (nextIndex >= rules.count) {
            return nil
        }
        nextIndex += 1
        return self.rules[nextIndex-1]
    }
}
