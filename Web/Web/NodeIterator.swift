//
//  NodeIterator.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-09.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

// see https://dom.spec.whatwg.org/#interface-nodeiterator
//interface NodeIterator {
//    [SameObject] readonly attribute Node root;
//    readonly attribute Node referenceNode;
//    readonly attribute boolean pointerBeforeReferenceNode;
//    readonly attribute unsigned long whatToShow;
//    readonly attribute NodeFilter? filter;
//    
//    Node? nextNode();
//    Node? previousNode();
//    
//    void detach();
//};

/// FIXME: This class implementation must be completed.
/// see https://dom.spec.whatwg.org/#nodeiterator
final class NodeIterator : Iterator {
    
    //    readonly attribute Node referenceNode;
    internal(set) var referenceNode: Node
    
    //    readonly attribute boolean pointerBeforeReferenceNode;
    internal(set) var pointerBeforeReferenceNode: Bool

    internal(set) var nodeList: LiveNodeList
    
    internal(set) var collectionIndex: Int
    
    // @see https://dom.spec.whatwg.org/#dom-document-createnodeiterator
    override init(root: Node, whatToShow: WhatToShow, filter: NodeFilter?) {
        
        assert(false, "Incomplete implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Incomplete implementation.", log: Log.Web.all, type: .error)
        #endif
        
        self.referenceNode = root
        self.pointerBeforeReferenceNode = true
        self.collectionIndex = 0
        
        /// When the filter is nil the default behavior is to accept everything.
        /// see https://dom.spec.whatwg.org/#iterator-collection
        self.nodeList = LiveNodeList(root: root, filter: AcceptAllNodeFilter(), inclusive: false)
        
        super.init(root: root, whatToShow: whatToShow, filter: filter)
    }
    
    /// The nextNode() method must traverse in direction next
    /// Node? nextNode();
    /// see https://dom.spec.whatwg.org/#dom-nodeiterator-nextnode
    func nextNode() -> Node? {

        return traverse(Direction.next)
    }
    
    /// The previousNode() method must traverse in direction previous.
    /// Node? previousNode();
    /// see https://dom.spec.whatwg.org/#dom-nodeiterator-previousnode
    func previousNode() -> Node? {

        return traverse(Direction.previous)
    }
    
    /// see https://dom.spec.whatwg.org/#concept-nodeiterator-traverse
    func traverse(_ direction: Direction) -> Node? {
        
        var node = referenceNode
        
        var beforeNode = pointerBeforeReferenceNode
        
        var result: AcceptNode? = traverseSubsteps(&node, beforeNode: &beforeNode, direction: direction)

        
        while let _result = result {
            
            // If result is FILTER_ACCEPT 
            // Set the referenceNode attribute to node, set the pointerBeforeReferenceNode 
            // attribute to before node, and return node.
            if _result == AcceptNode.filter_ACCEPT {
               
                referenceNode = node
                
                pointerBeforeReferenceNode = beforeNode
                
                return node
            }
            else {
             
                result = traverseSubsteps(&node, beforeNode: &beforeNode, direction: direction)
            }
        }
        
        return nil
    }
    
    /// 3. Run these substeps:
    func traverseSubsteps(_ node: inout Node, beforeNode: inout Bool, direction: Direction) -> AcceptNode? {
        
        switch(direction) {
            
        case .next:
            
            // If before node is false, let node be the first node following node in the iterator collection.
            // If there is no such node return null.
            if !beforeNode {
                
                collectionIndex += 1
                
                if let _node = nodeList.item(collectionIndex) {
                    
                    node = _node
                }
                else {
                    return nil
                }
            }
            else {
                
                beforeNode = true
            }
            
        case .previous:
            
            // If before node is true, let node be the first node preceding node in the iterator collection.
            // If there is no such node return null.
            if beforeNode {
                
                collectionIndex -= 1
                
                if let _node = nodeList.item(collectionIndex) {
                    
                    node = _node
                }
                else {
                    return nil
                }
            }
            else {
                
                beforeNode = false
            }
        }

        // 2. Filter node and let result be the return value.
        return filter(node)
    }
    
    
    /// The detach() method must do nothing.
    /// void detach();
    func detach() {

        // do nothing
    }
    
}


