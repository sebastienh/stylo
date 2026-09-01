//
//  TstDictionary+SequenceType.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-02-09.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation


// see http://lillylabs.no/2014/09/30/make-iterable-swift-collection-type-sequencetype/
public final class TstDictionaryEntriesGenerator<T: CompletionValueType> : IteratorProtocol {
    
    // Hold the collection to be iterated through
    fileprivate var tstDictionary: TstDictionary<T>
    
    fileprivate var stack: Stack<TstDictionaryEntry<T>>?
    
    fileprivate var currentNode: TstDictionaryEntry<T>?
    
    // Initialize the generator, passing a reference
    // to the car array
    init(tstDictionary: TstDictionary<T>) {
        
        self.tstDictionary = tstDictionary
    }
    
    // Implement the next method, to return nil if
    // there are no more node, or the next Node.
    // Note that we have specified the return type
    // as an optional "node": Node?.
    public func next() -> TstDictionaryEntry<T>? {
        
        // we are at the beginning
        if stack == nil {
            
            self.stack = Stack<TstDictionaryEntry<T>>()
            
            // not necessary but put here in order to follow closely 
            // the c# algo.
            self.currentNode = nil
            
            if let root = tstDictionary.root {
            
                stack!.push(root)
            }
        }
        else if currentNode == nil {
            
            return nil
        }
        
        if stack!.isEmpty {

            currentNode = nil
        }
        
        while stack!.count > 0 {
            
            self.currentNode = stack!.pop()
            
            if let highChild = currentNode!.highChild {
            
                stack!.push(highChild)
            }
            if let eqChild = currentNode!.eqChild {
            
                stack!.push(eqChild)
            }
            if let lowChild = currentNode!.lowChild {
            
                stack!.push(lowChild)
            }
            
            if let _ = currentNode!.key {
            
                break
            }
        }
        
        return currentNode
    }
    
    
    
}

