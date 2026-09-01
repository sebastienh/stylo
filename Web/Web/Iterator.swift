//
//  Iterator.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-25.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

/**
 *  This class regroup common properties and methods
 *  shared by iterators in general, and NodeIterator
 *  and TreeWalker in particular regarding the DOM
 *  specification in the Traversal section :
 *  @see https://dom.spec.whatwg.org/#traversal
 */
class Iterator {
    
    //    [SameObject] readonly attribute Node root;
    internal(set) var root: Node
    
    //    readonly attribute NodeFilter? filter;
    internal(set) var filter: NodeFilter?
    
    //    readonly attribute unsigned long whatToShow;
    internal(set) var whatToShow: UInt64
    
    
    init(root: Node, whatToShow: WhatToShow, filter: NodeFilter?) {
        self.root = root
        self.filter = filter
        self.whatToShow = whatToShow.rawValue
    }
    
    // https://dom.spec.whatwg.org/#concept-node-filter
    func filter(_ node: Node) -> AcceptNode {
        
        // Let n be node's nodeType attribute value minus 1.
        let n: UInt64 = node.nodeType.rawValue - 1
        
        // If the nth bit (where 0 is the least significant bit)
        // of whatToShow is not set, return FILTER_SKIP.
        let mask: UInt64 = 1 << n
        
        // apply the mask
        let maskResult = n & mask
        
        // if the bit is not set, it will return 0
        if maskResult == 0 {
            return AcceptNode.filter_SKIP
        }
        
        // If filter is null, return FILTER_ACCEPT.
        if let __filter = self.filter {
            
            let result = __filter.acceptNode(node)
            
            if let __result = AcceptNode(rawValue: result) {
                
                return __result
            }
            // The value return by the method acceptNode
            // does not belong to a valid value of AcceptNode
            assert(false, "Invalid value returned from acceptNode method \(result)")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Invalid value returned from acceptNode method %@.", log: Log.Web.all, type: .error, %%result)
            #endif
        }
        
        return AcceptNode.filter_ACCEPT
    }
    
}
