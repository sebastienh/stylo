//
//  StyleSheetList+SequenceType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-31.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

extension StyleSheetList : Sequence {
    
    // SequenceType protocol implementation
    func makeIterator() -> StyleSheetListGenerator {
        
        return StyleSheetListGenerator(styleSheetList: self.styleSheetList)
    }
}

// see http://lillylabs.no/2014/09/30/make-iterable-swift-collection-type-sequencetype/
final class StyleSheetListGenerator : IteratorProtocol {
    
    // Hold the collection to be iterated through
    fileprivate var styleSheetList: [CSSStyleSheet]
    
    // Hold the index of the next item in the iteration
    fileprivate var nextIndex: Int
    
    // Initialize the generator, passing a reference
    // to the car array
    init(styleSheetList: [CSSStyleSheet]) {
        
        self.styleSheetList = styleSheetList
        
        // Set the nextIndex to the index of the
        // first in the array
        // (since our collection is LIFO)
        nextIndex = 0
    }
    
    // Implement the next method, to return nil if
    // there are no more node, or the next Node.
    // Note that we have specified the return type
    // as an optional "node": Node?.
    func next() -> CSSStyleSheet? {
        
        if (nextIndex >= styleSheetList.count) {
            return nil
        }
        
        nextIndex += 1
        
        return self.styleSheetList[nextIndex - 1]
    }
}
