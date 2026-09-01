//
//  NMDOMNodeListImpl.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-19.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

// see https://dom.spec.whatwg.org/#nodelist
//interface NodeList {
//    getter Node? item(unsigned long index);
//    readonly attribute unsigned long length;
//    iterable<Node>;
//};

open class NodeList {
    
    internal var _filteredDescendants: ContiguousArray<Node>?
    
    //    readonly attribute unsigned long length;
    open var length: Int {
        
        var nodes = filteredDescendants()
        
        if inclusive {
            // add the root in the nodes
            nodes.insert(self.root, at: 0)
        }
        return nodes.count
    }
    
    // When a collection is created, a filter and
    // a root are associated with it.
    unowned let root: Node
    
    // node list root node
    var filter: NodeFilter

    // see https://dom.spec.whatwg.org/#concept-tree-inclusive-descendant
    let inclusive: Bool
    
    // access like nodeList[index]
    open subscript(index: Int) -> Node? {
    
        return item(index)
    }
    
    init(root: Node, filter: NodeFilter, inclusive: Bool) {
        
        self.root = root
        self.filter = filter
        self.inclusive = inclusive
    }
    
    open func asArray() -> ContiguousArray<Node> {
        
        return _filteredDescendants!
    }
    
    /**
     *  Basic live method to get the new list 
     *  each time it is invoqued. Some optimisation 
     *  will need to be put here, like for example
     *  while adding every descendants of a node
     *  to register ourselves for any changes on those
     *  nodes in order to be able to recalculate
     *  the tree totaly if not partially (only for the
     *  affected nodes) which may need to record the 
     *  list of ascendants for each node in order to detect which 
     *  range of nodes to remove for the actual tree 
     *  and to replace with the new ones calculated.
     */
     func item(_ index: Int) -> Node? {
        
        if !inclusive {
        
            let nodes = filteredDescendants()
        
            if index < nodes.count {
        
                return nodes[index]
            }
        }
        else {
            
            var nodes = filteredDescendants()
            
            // add the root in the nodes
            nodes.insert(self.root, at: 0)
            
            if index < nodes.count {
                
                return nodes[index]
            }
        }
        return nil
    }
    
    // def : An object A is called a descendant of an object B,
    // if either A is a child of B or A is a child of an object C
    // that is a descendant of B.
    func filteredDescendants() -> ContiguousArray<Node> {
        
        if let _filteredDescendants = _filteredDescendants {
            
            return _filteredDescendants
        }
        
        var nodeArray = ContiguousArray<Node>()
        let node: Node? = self.root.firstChild
                
        if let node = node {
            
            var result: (Node, AcceptNode)? = appendFilterResult(node)
            
            while let (node, accept) = result  {
                
                switch accept {
                    
                case .filter_ACCEPT:
                    
                    nodeArray.append(node)
                    result = treeOrderNextNode(node, root: root)
                    
                case .filter_REJECT:
                    
                    // skip all the subtree, and go to the sibling node
                    result = siblingNextNode(node, root: root)
                    
                case .filter_SKIP:
                    
                    result = treeOrderNextNode(node, root: root)
                }
            }
        }
        
        _filteredDescendants = nodeArray
        
        return _filteredDescendants!
    }
    
    func siblingNextNode(_ node: Node, root: Node) -> (Node, AcceptNode)? {
        
        // we are at the bottom, starting to go right
        if let nextSibling = node.nextSibling {
            
            return appendFilterResult(nextSibling)
        }
        // we are at the bottom, starting to go right
        else if let nextSibling = node.parentNode?.nextSibling {
                
            return appendFilterResult(nextSibling)
        }
        return nil
    }
    
    // This method is a preorder depth-first traversal function
    // that stops the traversal at root.
    func treeOrderNextNode(_ node: Node, root: Node) -> (Node, AcceptNode)? {
        
        // go down in the tree
        if let firstChild = node.firstChild {
            
            return appendFilterResult(firstChild)
        }
        
        // we are at the bottom, starting to go right
        if let nextSibling = node.nextSibling {
            
            return appendFilterResult(nextSibling)
        }
        
        // can not go right, go up
        var iterationNode: Node? = node
        
        while let _iterationNode = iterationNode , _iterationNode.nextSibling == nil {
            
            iterationNode = _iterationNode.parentNode
            
            if (iterationNode === root) {
                
                return nil
            }
        }
        
        if let iterationNode = iterationNode {
            
            if let iterationNodeNextSibling = iterationNode.nextSibling {
                
                return appendFilterResult(iterationNodeNextSibling)
            }
            return nil
        }
        else {
            assert(false, "iterationNode is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("iterationNode is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        return nil
    }
    
    /**
    *  Method that applies the filter to the selected node.
    */
    func appendFilterResult(_ node: Node) -> (Node, AcceptNode) {
            
        let result = self.filter.acceptNode(node)
            
        if let acceptNode  = AcceptNode(rawValue: result) {
                
            return (node, acceptNode)
        }
        else {
            // The value return by the method acceptNode
            // does not belong to a valid value of AcceptNode
            assert(false, "Invalid value returned from acceptNode method \(result)")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Invalid value returned from acceptNode method: %@.", log: Log.Web.all, type: .error, %%result)
            #endif
        }
        // default behavior : accept evrything
        return (node, AcceptNode.filter_ACCEPT)
    }

}
