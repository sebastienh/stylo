//
//  TreeNode.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-06.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

open class TreeNode: CommonTreeOperable, ReplacableChild, Hashable {
    
    open var nextSibling: TreeNode?
    
    open weak var previousSibling: TreeNode?
    
    open weak var parent: TreeNode?
    
    open var firstChild: TreeNode?
    
    open weak var lastChild: TreeNode?
    
    public init() {
        
    }
    
    
    /// Append a new child at the end of the childs. 
    /// The new child becomes the last child of the current 
    /// TreeNode and also the first child if there no existing 
    /// child under the current TreeNode.
    open func append(_ newChild: TreeNode) {
        
        insertLastCommon(newChild)
    }
    
    /// Add newChild before beforeChild under the current TreeNode.
    open func addChild(_ newChild: TreeNode, beforeChild: TreeNode?) {
        
        insertBeforeCommon(newChild, before: beforeChild)
    }
    
    /// Insert Last Common fucntion.
    fileprivate func insertLastCommon(_ newChild: TreeNode) {
        
        #if DEBUG
        assert(newChild.parent == nil)
        assert(newChild.nextSibling == nil)
        assert(newChild.previousSibling == nil)
        #endif
            
        // The newChild is not the only one.
        if let lastChild = lastChild {
            
            // Assertions
            #if DEBUG
            assert(lastChild.nextSibling == nil)
            #endif
                
            lastChild.nextSibling = newChild
            newChild.previousSibling = lastChild
        }
        // The new child is the only one.
        else  {
            
            // Assertions
            #if DEBUG
            assert(firstChild == nil)
            assert(lastChild == nil)
            #endif
                
            firstChild = newChild
        }
        
        lastChild = newChild
        newChild.parent = self
    }    
    
    
    
    
    /// Insert Before Common.
    /// child is assumed to be non nil
    fileprivate func insertBeforeCommon(_ newChild: TreeNode, before nextChild:TreeNode!) {
        
        #if SAFE_DOM
            assert(newChild.parentNode == nil)
            assert(newChild.nextSibling == nil)
            assert(newChild.previousSibling == nil)
        #endif
        
        let previousSibling = nextChild.previousSibling
        
        #if SAFE_DOM
            assert(lastChild != previousSibling)
        #endif
        
        nextChild.previousSibling = newChild
        
        if let previousSibling = previousSibling {
            
            let previousSiblingNextSibling = previousSibling.nextSibling
            
            #if SAFE_DOM
                assert(firstChild != nextChild)
                assert(previousSiblingNextSibling == nextChild)
            #endif
            previousSibling.nextSibling = newChild
            newChild.previousSibling = previousSibling
        }
        else {
            #if SAFE_DOM
                assert(firstChild == nextChild)
            #endif
            
            firstChild = newChild
        }
        
        newChild.parent = self
        newChild.nextSibling = nextChild
    }
    
    ///
    open func removeChild(_ oldChild: TreeNode) {
        
        removeFromParent(oldChild)
    }
    
    open func unlink() {
        
        if let parent = self.parent {
            
            parent.removeFromParent(self)
        }
    }
    
    fileprivate func removeFromParent(_ node: TreeNode) {
        #if DEBUG
        assert(node.parent == self)
        #endif
        node.parent = nil
        
        // last node
        if lastChild == node {
            #if DEBUG
            assert(node.nextSibling == nil)
            #endif
            // In this case we have only one children
            if self.firstChild == node {
                #if DEBUG
                assert(node.previousSibling == nil)
                #endif
                self.firstChild = nil
                self.lastChild = nil
            }
            // we need to update the previous sibling
            // this previous subling also becomes the lastChild
            // and maybe the firstChild...
            else {
                #if DEBUG
                assert(node.previousSibling != nil)
                #endif
                if let previousSibling = node.previousSibling {
                    
                    previousSibling.nextSibling = nil
                    self.lastChild = previousSibling
                }
            }
        }
        // the first node, we know it's not the last
        else if self.firstChild == node {
            #if DEBUG
            assert(node.previousSibling == nil)
            #endif
            if let nextSibling = node.nextSibling {
                
                nextSibling.previousSibling = nil
                self.firstChild = nextSibling
            }
        }
        // in the middle node, none of firstChild
        // neither lastChild do change.
        else {
            #if DEBUG
            assert(node.previousSibling != nil)
            assert(node.nextSibling != nil)
            #endif
            if let nextSibling = node.nextSibling, let previousSibling = node.previousSibling {
                #if DEBUG
                assert(nextSibling.previousSibling == node)
                assert(previousSibling.nextSibling == node)
                #endif
                nextSibling.previousSibling = previousSibling
                previousSibling.nextSibling = nextSibling
            }
        }
    }
    
    
    var count: Int {
        
        var count = 0
        
        var child: TreeNode? = firstChild
        
        while let _child = child {
            
            count += 1
            
            child = _child.nextSibling
        }
        
        return count
    }
    
    func removeAllChildren() {
        
        var child: TreeNode? = firstChild
        
        while let _child = child {
            
            removeChild(_child)
            
            child = _child.nextSibling
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ReplacableChild protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // also valid for CommonTreeOperable protocol
    typealias ChildNodeType = TreeNode
    
    /// Replace the oldChild with the newChild at the same position
    /// that was taken by the oldChild.
    open func replaceOldChildWithNewChild(_ oldChild: TreeNode, newChild: TreeNode) {
        
        addChild(newChild, beforeChild: oldChild)
        removeChild(oldChild)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Hashable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open var hashValue: Int {
        
        return UInt(bitPattern: ObjectIdentifier(self)).hashValue
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CommonTreeOperable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open func deleteAllChildren() {
        
        removeAllChildren()
    }
    
    open func childIndexForChild(_ childToIndex: TreeNode) -> Int? {
        
        var index: Int = 0
        
        let child: TreeNode? = firstChild
        
        while let _child = child {
         
            if _child == childToIndex {
                
                return index
            }
            
            index += 1
        }
        
        return nil
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

public func ==(lhs: TreeNode, rhs: TreeNode) -> Bool {
    
    return lhs.hashValue == rhs.hashValue
}
