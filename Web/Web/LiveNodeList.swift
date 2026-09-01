//
//  LiveNodeList.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-08.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

open class LiveNodeList: NodeList {

    var jsError: JSError
    
    var nodes = ContiguousArray<Node>()
    
    // readonly attribute unsigned long length;
    override open var length: Int {
        
        return nodes.count
    }
    
    override init(root: Node, filter: NodeFilter, inclusive: Bool = false) {
        
        self.jsError = JSError.noError
  
        super.init(root: root, filter: filter, inclusive: inclusive)

        // replace the empty nodes array with the real array
        self.nodes = filteredDescendants()
        
        // see : https://dom.spec.whatwg.org/#concept-tree-inclusive-descendant
        if inclusive {

            self.nodes.insert(root, at: 0)
        }
        
//        // create the mutation observer callback
//        let callback: MutationCallback = makeCallback()
//            
//        // register ourself as mutation observer on this node
//        let observerObject = MutationObserver(mutationCallback: callback)
//        
//        let options = MutationObserverInit()
//        options.setPresentValue(MutationOptionType.ChildList)
//        
//        // register ourselves as the observer
//        observerObject.observe(root, options: options, error: &jsError)
    }
    
    override func item(_ index: Int) -> Node? {
        
        if index < nodes.count {
            
            return nodes[index]
        }
        
        return nil
    }
    
    // Method to create a callback when childs of a node change
    func makeCallback() -> MutationCallback {
        
        let callback: ([MutationRecord], MutationObserver) -> Void = {
            
            [weak self] (mutationRecordArray: [MutationRecord], mutationObserver: MutationObserver) -> Void in
            
            for mutationRecord in mutationRecordArray {
             
                if mutationRecord.type == MutationOptionType.ChildList.rawValue {
                 
                    if let _self = self {
                    
                        _self.handleChildListChanged(mutationRecord)
                    }
                }
                else {
                    assert(false, "Received mutation record for unregistered type: \(mutationRecord.type)")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Received mutation record for unregistered type: %@", log: Log.Web.all, type: .error, %%mutationRecord.type)
                    #endif
                }
            }
        }
        
        return callback
    }
    
    func handleChildListChanged(_ mutationRecord: MutationRecord) {
        
        if mutationRecord.target == self.root {
            
            // we know to a child list modification
            self.nodes = filteredDescendants()
        }
        else {
            assert(false, "Received mutation record for wrong target.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Received mutation record for wrong target.", log: Log.Web.all, type: .error)
            #endif
        }
    }
    
    // SequenceType protocol implementation
    func generate() -> DynamicNodeGenerator {
        
        return DynamicNodeGenerator(liveNodeList: self)
    }
}

// see http://lillylabs.no/2014/09/30/make-iterable-swift-collection-type-sequencetype/
final class DynamicNodeGenerator : IteratorProtocol {
    
    // Hold the index of the next item in the iteration
    fileprivate var nextIndex: Int
    
    let liveNodeList: LiveNodeList
    
    // Initialize the generator, passing a reference
    // to the car array
    init(liveNodeList: LiveNodeList) {
        
        self.liveNodeList = liveNodeList
        
        // Set the nextIndex to the index of the
        // first in the array
        // (since our collection is LIFO)
        nextIndex = 0
    }
    
    // Implement the next method, to return nil if
    // there are no more node, or the next Node.
    // Note that we have specified the return type
    // as an optional "node": Node?.
    func next() -> Node? {
        
        if (nextIndex >= liveNodeList.length) {
            
            return nil
        }

        nextIndex += 1
        
        return liveNodeList[nextIndex - 1]
    }
}
