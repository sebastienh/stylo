//
//  TreeWalker.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-19.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation

//https://dom.spec.whatwg.org/#treewalker
//interface TreeWalker {
//    [SameObject] readonly attribute Node root;
//    readonly attribute unsigned long whatToShow;
//    readonly attribute NodeFilter? filter;
//    attribute Node currentNode;
//    
//    Node? parentNode();
//    Node? firstChild();
//    Node? lastChild();
//    Node? previousSibling();
//    Node? nextSibling();
//    Node? previousNode();
//    Node? nextNode();
//};

final class TreeWalker : Iterator {
    
    //    attribute Node currentNode;
    var currentNode: Node
    
    override init(root: Node, whatToShow: WhatToShow, filter: NodeFilter?) {
        
        self.currentNode = root
        
        super.init(root: root, whatToShow: whatToShow, filter: filter)
    }
    
    
    /// Return the parentNode of currentNode
    /// Node? parentNode();
    /// see https://dom.spec.whatwg.org/#dom-treewalker-parentnode
    func parentNode() -> Node? {
        
        // 1. Let node be the value of the currentNode attribute.
        var node: Node? = currentNode
        
        // 2. While node is not null and is not root, run these substeps:
        while let _node = node , node != root {
            
            // 1. Let node be node's parent.
            node = _node.parentNode
            
            // 2. If node is not null and filtering node returns FILTER_ACCEPT,
            // then set the currentNode attribute to node, return node.
            if let node = node {
                    
                let result = filter(node)
                    
                if result == AcceptNode.filter_ACCEPT {
                     
                    currentNode = node
                    return node
                }
            }
        }
        
        return nil
    }
    
    /// Node? firstChild();
    /// see https://dom.spec.whatwg.org/#dom-treewalker-firstchild
    func firstChild() -> Node? {
        
        return traverseChildren(ChildType.first)
    }
    
    /// Node? lastChild();
    /// see https://dom.spec.whatwg.org/#dom-treewalker-lastchild
    func lastChild() -> Node? {
        
        return traverseChildren(ChildType.last)
    }
    
    /// Node? previousSibling();
    /// see https://dom.spec.whatwg.org/#dom-treewalker-previoussibling
    func previousSibling() -> Node? {
        
        return traverseSibling(SiblingType.previous)
    }
    
    /// Node? nextSibling();
    /// see https://dom.spec.whatwg.org/#dom-treewalker-nextsibling
    func nextSibling() -> Node? {
        
        return traverseSibling(SiblingType.next)
    }
    
    /// Node? previousNode();
    /// see https://dom.spec.whatwg.org/#dom-treewalker-previousnode
    func previousNode() -> Node? {
        
        // 1. Let node be the value of the currentNode attribute.
        var node: Node = currentNode
        
        // 2. While node is not root, run these substeps:
        while node != root {
            
            // 1. Let sibling be the previous sibling of node.
            var sibling = node.previousSibling
            
            // 2. While sibling is not null, run these subsubsteps:
            while let _sibling = sibling {
             
                // 1. Set node to sibling.
                node = _sibling
                
                // 2. Filter node and let result be the return value.
                var result = filter(node)
                
                // 3. While result is not FILTER_REJECT and node has a child, 
                // set node to its last child and then filter node and set result to the return value.
                while result != AcceptNode.filter_REJECT {
                    
                    // ... and node has a child
                    if let lastChild = node.lastChild {
                        
                        node = lastChild
                        
                        result = filter(node)
                    }
                    else {
                        break
                    }
                }
                
                // 4. If result is FILTER_ACCEPT, 
                // then set the currentNode attribute to node and return node.
                if result == AcceptNode.filter_ACCEPT {
                    
                    currentNode = node
                    return node
                }
                
                // 5. Set sibling to the previous sibling of node.
                sibling = node.previousSibling
            }
        }
        
        // 3. Return null.
        return nil
    }
    
    /// Node? nextNode();
    /// see https://dom.spec.whatwg.org/#dom-treewalker-nextnode
    func nextNode() -> Node? {
        
        // 1. Let node be the value of the currentNode attribute.
        var node: Node = currentNode
        
        // 2. Let result be FILTER_ACCEPT.
        var result = AcceptNode.filter_ACCEPT
        
        // 3. Run these substeps 
        // see nextNodeSubsteps(...)
        return nextNodeSubsteps(&node, result: &result)
    }
    
    /// nextNode() substeps
    /// see https://dom.spec.whatwg.org/#dom-treewalker-nextnode
    fileprivate func nextNodeSubsteps(_ node: inout Node, result: inout AcceptNode) -> Node? {
        
        // 1. While result is not FILTER_REJECT and node has a child, 
        // run these subsubsteps:
        while result != AcceptNode.filter_REJECT {
            
            // ...and node has a child
            if let firstChild = node.firstChild {
             
                // 1. Set node to its first child.
                node = firstChild
                
                // 2. Filter node and set result to the return value.
                result = filter(node)
                
                
                // 3. If result is FILTER_ACCEPT, 
                // then set the currentNode attribute to node and return node.
                if result == AcceptNode.filter_ACCEPT {
                 
                    currentNode = node
                    return node
                }
            }
            else {
                break
            }
        }
        
        // 2. If a node is following node and is not following root, 
        // set node to the first such node.
        if let followingNode = findFirstFollowingNode(of: node) {
         
            node = followingNode
        }
        // Otherwise, return null.
        else {
            return nil
        }
        
        // 3. Filter node and set result to the return value.
        result = filter(node)
        
        // 4. If result is FILTER_ACCEPT, then set the currentNode attribute to node 
        // and return node.
        if result == AcceptNode.filter_ACCEPT {
            
            currentNode = node
            return node
        }
        else {
            
            // 5. Run these substeps again.
            return nextNodeSubsteps(&node, result: &result)
        }
    }
    
    /// First first following node of node which is not 
    /// following root
    /// see https://dom.spec.whatwg.org/#dom-treewalker-nextnode
    fileprivate func findFirstFollowingNode(of node: Node) -> Node? {
        
        var followingNode: Node? = node.followingNode()
        
        while let _followingNode = followingNode {
            
            if !_followingNode.isFollowing(root) {
             
                return _followingNode
            }
            
            followingNode = _followingNode.followingNode()
        }
        
        return nil
    }
    
    
    /// Traverse sibling
    /// see https://dom.spec.whatwg.org/#concept-traverse-siblings
    func traverseSibling(_ type: SiblingType) -> Node? {
        
        // 1. Let node be the value of the currentNode attribute.
        var node: Node = currentNode
        
        // 2. If node is root, return null.
        if node == root {
        
            return nil
        }
        // Run these substeps:
        else {
            return traverseSiblingSubsteps(&node, type: type)
        }
    }
    
    
    /// Traverse sibling substeps
    fileprivate func traverseSiblingSubsteps(_ node: inout Node, type: SiblingType) -> Node? {
        
        // 1. Let sibling be node's next sibling if type is next,
        // and node's previous sibling if type is previous.
        var sibling: Node?
        
        if type == SiblingType.next {
            
            sibling = node.nextSibling
        }
        else {
            
            sibling = node.previousSibling
        }
        
        // 2. While sibling is not null, run these subsubsteps:
        while let _sibling = sibling {
            
            // 1. Set node to sibling.
            node = _sibling
            
            // 2. Filter node and let result be the return value.
            let result = filter(node)
            
            // 3. If result is FILTER_ACCEPT,
            // then set the currentNode attribute to node and return node.
            if result == AcceptNode.filter_ACCEPT {
                
                currentNode = node
                return node
            }
            else {
                
                // 4. Set sibling to node's first child if type is next,
                // and node's last child if type is previous.
                if type == SiblingType.next {
                    
                    sibling = node.firstChild
                }
                else {
                    
                    sibling = node.lastChild
                }
                
                // 5. If result is FILTER_REJECT or sibling is null,
                // then set sibling to node's next sibling if type is next,
                // and node's previous sibling if type is previous.
                if result == AcceptNode.filter_REJECT || sibling == nil {
                    
                    if type == SiblingType.next {
                        
                        sibling = node.nextSibling
                    }
                    else {
                        
                        sibling = node.previousSibling
                    }
                }
            }
        }
        
        // 3. Set node to its parent.
        if let parent = node.parentNode {
            
            // 4. If node is null or is root, return null.
            if parent == root {
                
                return nil
            }
            else {
                
                // 3. Set node to its parent.
                // 5. Filter node and if the return value is FILTER_ACCEPT,
                // then return null.
                node = parent
                
                let result = filter(node)
                
                if result == AcceptNode.filter_ACCEPT {
                    
                    return nil
                }
                
                // 6. Run these substeps again.
                return traverseSiblingSubsteps(&node, type: type)
            }
        }
        // 4. If node is null or is root, return null.
        else {
            
            return nil
        }
    }
    
    /// Traverse children.
    /// see https://dom.spec.whatwg.org/#concept-traverse-children
    func traverseChildren(_ type: ChildType) -> Node? {
        
        // 1. Let node be the value of the currentNode attribute.
        var node: Node? = currentNode
        
        // 2. Set node to node's first child if type is first,
        //and node's last child if type is last.
        if type == ChildType.first {
            
            node = currentNode.firstChild
        }
        else {
            
            node = currentNode.lastChild
        }
        
        return traverseChildrenMain(&node, type: type)
    }
    
    /// 3. Main: While node is not null, run these substeps:
    /// see https://dom.spec.whatwg.org/#concept-traverse-children-main
    fileprivate func traverseChildrenMain(_ node: inout Node?, type: ChildType) -> Node? {
        
        // While node is not null:
        while let _node = node {
            
            // 1. Filter node and let result be the return value.
            let result = filter(_node)
            
            // 2. If result is FILTER_ACCEPT,
            // then set the currentNode attribute to node and return node.
            if result == AcceptNode.filter_ACCEPT {
                
                currentNode = _node
                return _node
            }
                
                // 3. If result is FILTER_SKIP, run these subsubsteps:
            else if result == AcceptNode.filter_SKIP {
                
                var child: Node?
                
                // 1. Let child be node's first child if type is first,
                // and node's last child if type is last.
                if type == ChildType.first {
                    
                    child = _node.firstChild
                }
                else {
                    
                    child = _node.lastChild
                }
                
                // 2. If child is not null, set node to child and goto Main.
                if let child = child {
                    
                    node = child
                    
                    return traverseChildrenMain(&node, type: type)
                }
            }
            
            // 4. While node is not null, run these subsubsteps:
            while let _node = node {
                
                var sibling: Node?
                
                // 1. Let sibling be node's next sibling if type is first,
                // and node's previous sibling if type is last.
                if type == ChildType.first {
                    
                    sibling = _node.nextSibling
                }
                else {
                    
                    sibling = _node.previousSibling
                }
                
                // 2. If sibling is not null, set node to sibling and goto Main.
                if let sibling = sibling {
                    
                    node = sibling
                    return traverseChildrenMain(&node, type: type)
                }
                else {

                    // 3. Let parent be node's parent.
                    let parent: Node? = _node.parentNode
                    
                    // 4. If parent is null, parent is root, or parent is currentNode attribute's value, 
                    // return null.
                    if parent == nil {
                        
                        return nil
                    }
                    else if let parent = parent {
                        
                        if parent == root {
                            return nil
                        }
                        else if parent == currentNode {
                            return nil
                        }
                    }
                    else {
                        
                        node = parent
                    }
                }
            }
        }
        
        return nil
    }
}















