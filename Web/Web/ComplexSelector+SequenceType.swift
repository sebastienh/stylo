//
//  ComplexSelector+SequenceType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-10.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

extension ComplexSelector : Sequence {
    
    // SequenceType protocol implementation
    public func makeIterator() -> ComplexSelectorGenerator {
        
        return ComplexSelectorGenerator(selectorList: self.compoundSelectorList)
    }
}

// see http://lillylabs.no/2014/09/30/make-iterable-swift-collection-type-sequencetype/
public final class ComplexSelectorGenerator : IteratorProtocol {
    
    // Hold the current compoundSelector
    fileprivate var currentCompoundSelector: CompoundSelector?
    
    // Hold the current combinator selector
    fileprivate var currentCombinatorSelector: SelectorCombinator?
    
    // Initialize the generator, passing a reference
    // to the car array
    init(selectorList: [CompoundSelector]) {
        
        if selectorList.count > 0 {
        
            self.currentCompoundSelector = selectorList[0]
        }
    }
    
    // Implement the next method, to return nil if
    // there are no more node, or the next Node.
    // Note that we have specified the return type
    // as an optional "node": Node?.
    public func next() -> Selector? {
        
        if let compoundSelector = currentCompoundSelector {
            
            currentCompoundSelector = nil
            
            if let combinator = compoundSelector.combinator {
                
                currentCombinatorSelector = combinator
            }

            return compoundSelector
        }
        else if let combinatorSelector = currentCombinatorSelector {
            
            currentCombinatorSelector = nil
            
            if let compoundSelector = combinatorSelector.rightCompoundSelector {
                
                currentCompoundSelector = compoundSelector
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Invalid state : missing compound selector on the right of selector combinator.", log: Log.Web.all, type: .error)
                #endif
            }
            
            return combinatorSelector
        }
        return nil
    }
}
