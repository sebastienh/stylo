//
//  ContainerNode.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-21.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

open class ContainerNode: Node, CommonTreeOperable, ParentNode {
    
    // readonly attribute Node? firstChild;
    fileprivate var _firstChild: Node?
    
    // readonly attribute Node? lastChild;
    fileprivate weak var _lastChild: Node?
    
    
    var leftMostChildElementDescendant: Element? {
     
        // early exit to avoid the method filteredDescendants() which
        // is really time consuming.
        if _firstChild == nil {
            return nil 
        } else if let _firstChild = _firstChild, let _lastChild = _lastChild, _firstChild == _lastChild {
            return _firstChild as? Element
        }
        
        var leftChild = firstElementChild
        var lastLeftChild = leftChild
        
        while leftChild != nil {
            
            lastLeftChild = leftChild
            leftChild = leftChild!.firstElementChild
        }
        
        return lastLeftChild
    }

    
    override open internal(set) var firstChild: Node? {
        get {
            return _firstChild
        }
        set(firstChildValue) {
            _firstChild = firstChildValue
        }
    }
    
    override open internal(set) var lastChild: Node? {
        get {
            return _lastChild
        }
        set(lastChildValue) {
            _lastChild = lastChildValue
        }
    }
    
    open override var length: Int {
        
        return childNodes!.length
    }

    // [SameObject] readonly attribute NodeList childNodes;
    // see https://rniwa.com/2013-02-10/live-nodelist-and-htmlcollection-in-webkit/
    override open var childNodes: NodeList? {
        
        let filter = ChildNodeFilter(root: self)
        return LiveNodeList(root: self, filter: filter)
    }
    
    public var textChilds: Set<Text>
    
    /// boolean hasChildNodes();
    /// see https://dom.spec.whatwg.org/#dom-node-haschildnodes
    open override func hasChildNodes() -> Bool {

        if let _ = _firstChild {
            return true
        }
        return false
    }
    
    /// Default init
    convenience init(document: Document?) {
        
        self.init(document: document, sourceStringFragment: nil)
    }
    
    /// Init with SourceStringFragment
    override init(document: Document?, sourceStringFragment: SourceStringFragment?) {
        
        self.textChilds = Set<Text>()
        super.init(document: document, sourceStringFragment: sourceStringFragment)
    }

    // MARK: Insertion support methods
    
    /// The Node interface does not support appending child
    /// so calling this function will result in an error.
    ///
    /// Node appendChild(Node node);
    /// see https://dom.spec.whatwg.org/#dom-node-appendchild
    @discardableResult
    open override func appendChild(_ node: Node, exception: inout Exception) -> Node? {
        
        return preInsert(node, before: nil, exception: &exception)?.first
    }
    
    /// The Node interface does not support appending child
    /// so calling this function will result in an error.
    ///
    /// Node replaceChild(Node node, Node child);
    /// see https://dom.spec.whatwg.org/#dom-node-replacechild
    @discardableResult
    open override func replaceChild(_ node: Node, child: Node, exception: inout Exception) -> Node? {
        
        return replace(node, with: child, exception: &exception)
    }
    
    /// The Node interface does not support appending child
    /// so calling this function will result in an error.
    ///
    /// Node removeChild(Node child);
    /// see https://dom.spec.whatwg.org/#dom-node-removechild
    @discardableResult
    open override func removeChild(_ child: Node, exception: inout Exception) -> Node? {
        
        return preRemove(child, exception: &exception)
    }
    
    /// see [Insert before](https://dom.spec.whatwg.org/#dom-node-insertbefore)
    /// @return If node is a DocumentFragment, the childs elements of the document fragment
    ///         Otherwise, the node itself.
    @discardableResult
    open override func insertBefore(_ node: Node!, before child: Node?, exception: inout Exception) -> ContiguousArray<Node>? {
        
        return preInsert(node, before: child, exception: &exception)
    }
    
    /// see https://dom.spec.whatwg.org/#concept-node-pre-insert
    @discardableResult
    func preInsert(_ node: Node!, before child: Node?, exception: inout Exception) -> ContiguousArray<Node>?  {
        
        #if SAFE_DOM
        // 1. Ensure pre-insertion validity of node into parent before child.
        if ensurePreInsertionValidity(node, child: child, exception: &exception) {
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return nil
            }
            
            // 2. Let reference child be child.
            var referenceChild = child
            
            // 3. If reference child is node, set it to node's next sibling.
            if referenceChild === node {
                
                if let nextSibling = node.nextSibling {
                
                    referenceChild = nextSibling
                }
            }
            
            // 4. Adopt node into parent's node document.
            // only a document can adopt a node
            // see [Adopt](https://dom.spec.whatwg.org/#concept-node-adopt)
            document?.adopt(node, exception: &exception)
                
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return nil
            }
            
            // 5. Insert node into parent before reference child.
            let nodes = insert(node, before: referenceChild, exception: &exception)
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return nil
            }
            
            // 6. return node
            return nodes
        
        }
        else {
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return nil
            }
        }
            
        #else
            
        // 2. Let reference child be child.
        var referenceChild = child
        
        // 3. If reference child is node, set it to node's next sibling.
        if referenceChild == node {
            if let nextSibling = node.nextSibling {
                referenceChild = nextSibling
            }
        }
        
        // 4. Adopt node into parent's node document.
        // only a document can adopt a node
        // see https://dom.spec.whatwg.org/#concept-node-adopt
        document?.adopt(node, exception: &exception)
    
        // 5. Insert node into parent before reference child.
        let nodes = insert(node, before: referenceChild, exception: &exception)
        
        // 6. return node
        return nodes

        #endif
        
        // This return assumes that the successful code returns something 
        // when everything goes well.
        return nil
    }

    // Insert node into parent before reference child.
    // see https://dom.spec.whatwg.org/#concept-node-insert
    @discardableResult
    fileprivate func insert(_ node: Node, before child: Node?, suppressObserversFlag: Bool = false, exception: inout Exception) -> ContiguousArray<Node>? {
        
        // 1. Let count be the number of children of node if it is a DocumentFragment node,
        // and one otherwise.
        var count: Int = 1
        
        if node.nodeType == NodeType.document_fragment_node {
            count = node.length
        }
        
        #if FULL_DOM
        // 2. If child is non-null, run these substeps:
        if let child = child, let document = document {
            
            // 1. For each range whose start node is parent and start offset
            // is greater than child's index, increase its start offset by count.
            for range in document.ranges {
                
                if range.startContainer == self {
                 
                    if range.startOffset > child.index {
                        
                        range.startOffset += count
                    }
                }
            }
            
            // 2. For each range whose end node is parent and end offset 
            // is greater than child's index, increase its end offset by count.
            for range in document.ranges {
                
                if range.endContainer == self {
                    
                    if range.endOffset > child.index {
                        
                        range.endOffset += count
                    }
                }
            }
        }
        #endif
        
        // 3. Let nodes be node's children if node is a DocumentFragment node, 
        // and a list containing solely node otherwise.
        let nodes: NodeList
        
        if node.nodeType == NodeType.document_fragment_node {
            nodes = LiveNodeList(root: node, filter: ChildNodeFilter(root: node), inclusive: false)
        }
        else {
            nodes = SingleNodeList(node: node)
        }
        
        #if MUTATION_RECORDS
        // 4. If node is a DocumentFragment node, queue a mutation record of "childList" 
        // for node with removedNodes nodes.
        if node.nodeType == NodeType.document_fragment_node {
            
            if let recordManager = document?.mutationRecordManager {
            
                let mutationRecord = recordManager.createRemovedChildsMutationRecord(self, removedNodes: nodes)
                recordManager.queueMutationRecord(mutationRecord)
            }
        }
        #endif
            
        // 5. If node is a DocumentFragment node, remove its children with the suppress observers flag set.
        if node.nodeType == NodeType.document_fragment_node {
            
            let documentFragment = node as! DocumentFragment
            
            if let childNodes = documentFragment.childNodes {
                
                for childNode in childNodes {
                    
                    documentFragment.remove(childNode, suppressObserverFlag: true, exception: &exception)
                    
                    if exception.isError() {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                        #endif
                        return nil
                    }
                }
            }
        }
        
        #if MUTATION_RECORDS
        // 6. If suppress observers flag is unset, 
        // queue a mutation record of "childList" for parent with addedNodes nodes, 
        // nextSibling child, and previousSibling child's previous sibling 
        // or parent's last child if child is null.
        if !suppressObserversFlag {
            
            if let recordManager = document?.mutationRecordManager {
        
                var mutationRecord = recordManager.createAddedChildsMutationRecord(self, addedNodes: nodes)
                mutationRecord.nextSibling = child
            
                if let child = child  {
                
                    mutationRecord.previousSibling = child.previousSibling
                }
                else {
                
                    if let lastChild = self.lastChild {
                        mutationRecord.previousSibling = lastChild
                    }
                }
                recordManager.queueMutationRecord(mutationRecord)
            }
        }
        #endif
            
        // 7. For each newNode in nodes, in tree order, run these substeps:
        for newChild in nodes {
            
            // 1. Insert newNode into parent before child or at the end of parent if child is null.
            // FIXME: It would be more efficient to make this test before calling 
            // insert... method for each node. But we aim at simplicity, we should modify this
            // only if we see a clear preformance hit.
            if child != nil {
                insertBeforeCommon(newChild, before: child)
            }
            else {
                insertLastCommon(newChild)
            }
            
            // 2. Run the insertion steps with newNode.
            // FIXME: nothing to do.
        }
        
        return nodes.asArray()
    }
    
    /// Insert Last Common fucntion.
    fileprivate func insertLastCommon(_ newChild: Node) {
        
        _inspectableChilds = nil
        _pathableChilds = nil
        
        #if SAFE_DOM
        assert(newChild.parentNode == nil)
        assert(newChild.nextSibling == nil)
        assert(newChild.previousSibling == nil)
        #endif
            
        // The newChild is not the only one.
        if let lastChild = lastChild {
            
            #if SAFE_DOM
            // Assertions
            assert(lastChild.nextSibling == nil)
            #endif
                
            lastChild.nextSibling = newChild
            newChild.previousSibling = lastChild
        }
        // The new child is the only one.
        else  {
            
            #if SAFE_DOM
            // Assertions
            assert(firstChild == nil)
            assert(lastChild == nil)
            #endif
                
            firstChild = newChild
        }
        
        if let textNode = newChild as? Text {
            self.textChilds.insert(textNode)
        }
        
        lastChild = newChild
        newChild.parentNode = self
    }
    
    /// Insert Before Common.
    /// child is assumed to be non nil
    fileprivate func insertBeforeCommon(_ newChild: Node, before nextChild: Node!) {
        
        #if SAFE_DOM
        assert(newChild.parentNode == nil)
        assert(newChild.nextSibling == nil)
        assert(newChild.previousSibling == nil)
        #endif
            
        let previousSibling = nextChild.previousSibling
            
        #if SAFE_DOM
        assert(lastChild !== previousSibling)
        #endif
        
        nextChild.previousSibling = newChild
        
        if let previousSibling = previousSibling {

            let previousSiblingNextSibling = previousSibling.nextSibling
            
            #if SAFE_DOM
            assert(firstChild !== nextChild)
            assert(previousSiblingNextSibling === nextChild)
            #endif
            previousSibling.nextSibling = newChild
            newChild.previousSibling = previousSibling
        }
        else {
            #if SAFE_DOM
            assert(firstChild === nextChild)
            #endif
            
            firstChild = newChild
        }
        
        if let textNode = newChild as? Text {
            self.textChilds.insert(textNode)
        }
        
        newChild.parentNode = self
        newChild.nextSibling = nextChild
    }
    
    ///
    /// This method execute any required validation before inserting a
    /// node before another one called child.
    ///
    /// @return  the node if the node can be inserted false otherwise nil
    ///          with the appropriate error code stored in exceptionCode
    ///
    /// @see https://dom.spec.whatwg.org/#concept-node-ensure-pre-insertion-validity
    ///
    ///
    @discardableResult
    internal func ensurePreInsertionValidity(_ node: Node!, child: Node?, exception: inout Exception) -> Bool {
        
        #if SAFE_DOM
        // 1. If parent is not a Document, DocumentFragment, or Element node,
        // throw a "HierarchyRequestError" and terminate these steps.
        if !(self.nodeType == NodeType.document_node
            || self.nodeType == NodeType.document_fragment_node
            || self.nodeType == NodeType.element_node) {
                
            exception.code = ExceptionCode.hierarchyRequestError
            return false
        }
        
        // 2. If node is a host-including inclusive ancestor of parent,
        // throw a "HierarchyRequestError".
        if node.isHostIncludingInclusiveAncestor(self) {
            
            exception.code = ExceptionCode.hierarchyRequestError
            return false
        }
        
        // 3. If child is not null and its parent is not parent,
        // throw a "NotFoundError" exception.
        if let child = child {
            
            if let childParent = child.parentNode {
                
                if childParent !== self {
                    
                    exception.code = ExceptionCode.notFoundError
                    return false
                }
            }
        }
        
        // 4. If node is not a DocumentFragment, DocumentType, Element,
        // Text, ProcessingInstruction, or Comment node,
        // throw a "HierarchyRequestError".
        if node.nodeType != NodeType.document_fragment_node
            && node.nodeType != NodeType.document_type_node
            && node.nodeType != NodeType.element_node
            && node.nodeType != NodeType.text_node
            && node.nodeType != NodeType.processing_instruction_node
            && node.nodeType != NodeType.comment_node {
                
                exception.code = ExceptionCode.hierarchyRequestError
                return false
        }
        
        // 5. If either node is a Text node and parent is a document,
        // or node is a doctype and parent is not a document,
        // throw a "HierarchyRequestError".
        if (node.nodeType == NodeType.text_node && self.nodeType == NodeType.document_node)
            || (node.nodeType == NodeType.document_type_node && self.nodeType != NodeType.document_node) {
                
                exception.code = ExceptionCode.hierarchyRequestError
                return false
        }
        
        // 6. If parent is a document, and any of the statements below, switched on node, are true,
        // throw a "HierarchyRequestError".
        if self.nodeType == NodeType.document_node {
            
            if node.nodeType == NodeType.document_fragment_node {
                
                if let documentFragmentNode = node as? DocumentFragment {
                    
                    // If node has more than one element child or
                    // has a Text node child.
                    if documentFragmentNode.childElementCount > 1 {
                        
                        exception.code = ExceptionCode.hierarchyRequestError
                        return false
                    }
                        // Otherwise, if node has one element child and
                        // either parent has an element child,
                        //        child is a doctype,
                        //        or child is not null and a doctype is following child.
                    else {
                        
                        // if node has one element child
                        if documentFragmentNode.childElementCount == 1 {
                            
                            // parent has an element child
                            if self.hasElementChild() {
                                exception.code = ExceptionCode.hierarchyRequestError
                                return false
                            }
                            
                            // child is a doctype
                            if let child = child {

                                if child.nodeType == NodeType.document_type_node {
                                    exception.code = ExceptionCode.hierarchyRequestError
                                    return false
                                }
                            }
                            
                            // child is not null and a doctype is following child.
                            if let child = child {
                                
                                if child.isDoctypeFollowingNode() {
                                    exception.code = ExceptionCode.hierarchyRequestError
                                    return false
                                }
                            }
                        }
                        
                        if let child = child {
                            
                            if child.nodeType == NodeType.document_type_node {
                            
                                exception.code = ExceptionCode.hierarchyRequestError
                                return false
                            }
                        }
                    }
                } // end : if let documentFragmentNode = node as? DocumentFragment
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Error : If node.nodeType == NodeType.DOCUMENT_FRAGMENT_NODE, node has to be a DocumentFragment.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else if node.nodeType == NodeType.element_node {
                
                // parent has an element child, child is a doctype, or child is not null and a doctype is following child.
                // parent has an element child
                if self.hasElementChild() {
                    
                    if let child = child {
                        
                        // TODO : verify why the standard would for the second condition mention that
                        // the child is not null and not for the first condition (this one)
                        if child.nodeType == NodeType.document_type_node {
                            
                            exception.code = ExceptionCode.hierarchyRequestError
                            return false
                        }
                        if child.isDoctypeFollowingNode() {
                            
                            exception.code = ExceptionCode.hierarchyRequestError
                            return false
                        }
                    }
                }
            }
            else if node.nodeType == NodeType.document_type_node {
                
                // parent has a doctype child, an element is preceding child, or child is null and parent has an element child.
                if self.hasDoctypeChild() {
                    
                    if let child = child {
                        
                        if child.isElementPreceding() {
                            
                            exception.code = ExceptionCode.hierarchyRequestError
                            return false
                        }
                        if self.hasElementChild() {
                            
                            exception.code = ExceptionCode.hierarchyRequestError
                            return false
                        }
                    }
                }
            }
        }
        #endif
            
        return true
    }

    /// To append a node to a parent, pre-insert node into parent before null.
    /// see https://dom.spec.whatwg.org/#concept-node-append
    func append(_ node: Node, exception: inout Exception) {
        
        preInsert(node, before: nil, exception: &exception)
    }

    // MARK: Replace support methods
    
    /// Replace a child with node within a parent
    /// see https://dom.spec.whatwg.org/#concept-node-replace
    func replace(_ child: Node, with node: Node, exception: inout Exception) -> Node? {
     
        #if SAFE_DOM
        // 1. If parent is not a Document, DocumentFragment, or Element node, 
        // throw a HierarchyRequestError.
        if self.nodeType != NodeType.document_node
            && self.nodeType != NodeType.document_fragment_node
            && self.nodeType != NodeType.element_node {
                
            exception.code = ExceptionCode.hierarchyRequestError
            return nil
        }
        
        // 2. If node is a host-including inclusive ancestor of parent, 
        // throw a HierarchyRequestError.
        // FIXME: need to be implemented.
        
        // 3. If child's parent is not parent, 
        // throw a NotFoundError exception.
        if let childParent = child.parentNode {
            
            if childParent != self {
                exception.code = ExceptionCode.notFoundError
                return nil
            }
        }
        else {
            exception.code = ExceptionCode.notFoundError
            return nil
        }
        
        // 4. If node is not a DocumentFragment, DocumentType, Element, Text, ProcessingInstruction, 
        // or Comment node, throw a HierarchyRequestError.
        if node.nodeType != NodeType.document_type_node
            && node.nodeType != NodeType.document_fragment_node
            && node.nodeType != NodeType.element_node
            && node.nodeType != NodeType.text_node
            && node.nodeType != NodeType.processing_instruction_node
            && node.nodeType != NodeType.comment_node {
        
            exception.code = ExceptionCode.hierarchyRequestError
            return nil
        }
        
        // 5. If either node is a Text node and parent is a document, 
        // or node is a doctype and parent is not a document, throw a HierarchyRequestError.
        if node.nodeType == NodeType.text_node
            && self.nodeType == NodeType.document_node {
                
            exception.code = ExceptionCode.hierarchyRequestError
            return nil
        }
        
        if node.nodeType == NodeType.document_type_node
            && self.nodeType != NodeType.document_node {
                
            exception.code = ExceptionCode.hierarchyRequestError
            return nil
        }
     
        // 6. If parent is a document, and any of the statements below, switched on node, are true, 
        // throw a HierarchyRequestError.
        if self.nodeType == NodeType.document_node {
            
            // 1. DocumentFragment node
            if node.nodeType == NodeType.document_fragment_node {
                
                assert(node is DocumentFragment, "node is not DocumentFragment")
                
                if let documentFragment = node as? DocumentFragment {
                    
                    // 1. If node has more than one element child or has a Text node child.
                    if documentFragment.childElementCount > 1
                        || documentFragment.hasTextChild(){
                        
                        exception.code = ExceptionCode.hierarchyRequestError
                        return nil
                    }
                    
                    // 2. Otherwise, if node has one element child and either parent has an element child 
                    // that is not child or a doctype is following child.
                    else {
                        
                        if documentFragment.childElementCount == 1 {
                            
                            // parent has a doctype child that is not child
                            if let childNodes = self.childNodes {
                                
                                for childNode in childNodes {
                                    
                                    if childNode.nodeType == NodeType.document_type_node {
                                        
                                        if childNode != child {
                                            
                                            exception.code = ExceptionCode.hierarchyRequestError
                                            return nil
                                        }
                                    }
                                }
                            }
                            
                            // an element is preceding child.
                            if let childPrecedingNode = child.precedingNode() {
                             
                                if childPrecedingNode.nodeType == NodeType.element_node {
                                    
                                    exception.code = ExceptionCode.hierarchyRequestError
                                    return nil
                                }
                            }
                        }
                    }
                }
            }
            
            // 2. element
            else if node.nodeType == NodeType.element_node {
            
                assert(node is Element, "node is not Element")
                    
                // parent has an element child that is not child or ...
                if let childNodes = self.childNodes {
                    
                    for childNode in childNodes {
                        
                        if childNode.nodeType == NodeType.element_node {
                            
                            if childNode != child {
                                
                                exception.code = ExceptionCode.hierarchyRequestError
                                return nil
                            }
                        }
                    }
                }
                
                // a doctype is following child.
                if let childFollowingNode = child.followingNode() {
                    
                    if childFollowingNode.nodeType == NodeType.document_type_node {
                        exception.code = ExceptionCode.hierarchyRequestError
                        return nil
                    }
                }
            }
            
            // 3. doctype
            else if node.nodeType == NodeType.document_type_node {
                
                assert(node is DocumentType, "node is not DocumentType")
                
                // parent has a doctype child that is not child, or...
                if let childNodes = self.childNodes {
                    
                    for childNode in childNodes {
                        
                        if childNode.nodeType == NodeType.document_type_node {
                            
                            if childNode != child {
                                
                                exception.code = ExceptionCode.hierarchyRequestError
                                return nil
                            }
                        }
                    }
                }
                
                // an element is preceding child.
                if let childPrecedingNode = child.precedingNode() {
                    
                    if childPrecedingNode.nodeType == NodeType.element_node {
                        
                        exception.code = ExceptionCode.hierarchyRequestError
                        return nil
                    }
                }
            }
        }
        #endif // SAFE_DOM
            
        // 7. Let reference child be child's next sibling.
        var referenceChild = child.nextSibling
        
        // 8. If reference child is node, set it to node's next sibling.
        if referenceChild == node {
            referenceChild = node.nextSibling
        }
        
        // 9. Adopt node into parent's node document.
            
        document.adopt(node, exception: &exception)
            
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return nil
        }
        
        // 10. Remove child from its parent with the suppress observers flag set.
        remove(child, suppressObserverFlag: true, exception: &exception)
        
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return nil
        }
        
        // 11. Insert node into parent before reference child with the suppress observers flag set.
        insert(node, before: referenceChild, suppressObserversFlag: true, exception: &exception)
        
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return nil
        }
        
        #if MUTATION_RECORDS
        // 12. Let nodes be node's children if node is a DocumentFragment node,
        // and a list containing solely node otherwise.
        let nodes: NodeList
        
        if node.nodeType == NodeType.document_fragment_node {
            nodes = LiveNodeList(root: node, filter: ChildNodeFilter(root: node), inclusive: false)
        }
        else {
            nodes = SingleNodeList(node: node)
        }
        
        // 13. Queue a mutation record of "childList" for target parent with addedNodes nodes, 
        // removedNodes a list solely containing child, nextSibling reference child, 
        // and previousSibling child's previous sibling.
        
        if let recordManager = document.mutationRecordManager {
            
            var mutationRecord = MutationRecord(type: §MutationRecordType.ChildList , target: self)
            mutationRecord.addedNodes = nodes
            mutationRecord.removedNodes = SingleNodeList(node: child)
            mutationRecord.nextSibling = referenceChild
            mutationRecord.previousSibling = child.previousSibling
            
            recordManager.queueMutationRecord(mutationRecord)
        }
        #endif
            
        // 14. Return child.
        return child
    }
    
    /// replaceAll method.
    /// see https://dom.spec.whatwg.org/#concept-node-replace-all
    /// To replace all with a node within a parent, run these steps
    func replaceAll(_ node: Node?, exception: inout Exception) {
    
        // 1. If node is not null, adopt node into parent's node document.
        if let node = node {
         
            document.adopt(node, exception: &exception)
                
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        }
        
        // 2. Let removedNodes be parent's children.
        let removedNodes = self.childNodes
        
        // 3. Let addedNodes be the empty list if node is null, 
        // node's children if node is a DocumentFragment node, 
        // and a list containing node otherwise.
        var addedNodes: NodeList?
        
        if let node = node {
            
            if node.nodeType == NodeType.document_fragment_node {
                addedNodes = LiveNodeList(root: node, filter: ChildNodeFilter(root: node), inclusive: false)
            }
            else {
                addedNodes = SingleNodeList(node: node)
            }
        }
        
        // 4. Remove all parent's children, in tree order, 
        // with the suppress observers flag set.
        removeAllChildren(&exception)
        
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return
        }
        
        // 5. If node is not null, insert node into parent before null 
        // with the suppress observers flag set.
        if let node = node {
         
            insert(node, before: nil, suppressObserversFlag: true, exception: &exception)
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        }
        
        #if MUTATION_RECORDS
        // 6. Queue a mutation record of "childList" for parent
        // with addedNodes addedNodes and removedNodes removedNodes.
        if let recordManager = document.mutationRecordManager {
            
            var mutationRecord = MutationRecord(type: §MutationRecordType.ChildList , target: self)
            mutationRecord.addedNodes = addedNodes
            mutationRecord.removedNodes = removedNodes
            
            recordManager.queueMutationRecord(mutationRecord)
        }
        #endif
    }
    
    /// removeAllChildren
    ///
    open func removeAllChildren(_ exception: inout Exception) {
    
        if let children = self.childNodes {
            
            for child in children {
                
                assert(child.parentNode == self)
                remove(child, suppressObserverFlag: true, exception: &exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return
                }
            }
        }
    }
    
    open func removeChilds(with localname: String, _ exception: inout Exception) {
        
        if let children = self.childNodes {
            
            for child in children {
                
                assert(child.parentNode == self)
                if let element = child as? Element, element.localName == localname {
                    
                    remove(child, suppressObserverFlag: true, exception: &exception)
                    
                    if exception.isError() {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                        #endif
                        return
                    }
                }
            }
        }
    }
    
    /// preRemove method.
    /// see https://dom.spec.whatwg.org/#concept-node-pre-remove
    /// To pre-remove a child from a parent, run these steps:
    func preRemove(_ child: Node, exception: inout Exception) -> Node? {
    
        // 1. If child's parent is not parent, throw a NotFoundError exception.
        if let childParent = child.parentNode {
            
            if childParent != self {
                
                exception.code = ExceptionCode.notFoundError
                return nil
            }
        }
        else {
            exception.code = ExceptionCode.notFoundError
            return nil
        }
        
        // 2. Remove child from parent.
        remove(child, exception: &exception)
        
        // 3. Return child.
        return child
    }
    
    
    // MARK: Remove support methods
    
    ///
    /// see https://dom.spec.whatwg.org/#concept-node-remove
    /// NW-62
    func remove(_ node: Node, suppressObserverFlag: Bool = false, exception: inout Exception) {
        
        /// DOMInspectable
        _inspectableChilds = nil
        _pathableChilds = nil
        
        #if FULL_DOM
        
        // 1. Let index be node's index.
        // see https://dom.spec.whatwg.org/#concept-tree-index
        // def : The index of an object is its number of preceding siblings.
        // already calculated using the variable index.
        let index = node.index
        
        // 2. For each range whose start node is an inclusive descendant of node,
        // set its start to (parent, index).
        // Note: all ranges are kept by document since they are only valid for this document.
        if let _document = document {

            for range in _document.ranges {
         
                let startNode = range.startContainer
            
                if let containerNode = node as? ContainerNode {
            
                    if startNode.isInclusiveDescendant(of: containerNode) {
                
                        // (repeating) set its start to (parent, index)
                        // where parent is self
                        range.setStart(self, offset: index, exception: &exception)
                
                        if exception.isError() {
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                            #endif
                            return
                        }
                    }
                }
            }
        
            // 3. For each range whose end node is an inclusive descendant of node,
            // set its end to (parent, index).
            for range in _document.ranges {
            
                let endNode = range.endContainer
            
                if let containerNode = node as? ContainerNode {
            
                    if endNode.isInclusiveDescendant(of: containerNode) {
                
                        // (repeating) set its end to (parent, index)
                        // where parent is self.
                        range.setEnd(self, offset: index, exception: &exception)
                
                        if exception.isError() {
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                            #endif
                            return
                        }
                    }
                }
            }
        
            // 4. For each range whose start node is parent and start offset is greater than index,
            // decrease its start offset by one.
            for range in _document.ranges {
            
                let startNode = range.startContainer
                let startOffset = range.startOffset
            
                if startNode == self  {
                
                    if startOffset > index {
                        range.startOffset -= 1
                    }
                }
            }
        
            // 5. For each range whose end node is parent and end offset is greater than index,
            // decrease its end offset by one.
            for range in _document.ranges {
            
                let endNode = range.endContainer
                let endOffset = range.endOffset
            
                if endNode == self {
                
                    if endOffset > index {
                        range.endOffset -= 1
                    }
                }
            }
        }

        #endif 
        
        // 6. Let oldPreviousSibling be node's previous sibling
        let oldPreviousSibling = node.previousSibling
        
        #if MUTATION_RECORDS
        // 7. If suppress observers flag is unset, queue a mutation record of "childList"
        // for parent with removedNodes a list solely containing node,
        // nextSibling node's next sibling, and previousSibling oldPreviousSibling.
        if !suppressObserverFlag {

            if let recordManager = document.mutationRecordManager {

                var mutationRecord = MutationRecord(type: §MutationRecordType.ChildList , target: self)
                mutationRecord.removedNodes = SingleNodeList(node: node)

                if let nextSibling = node.nextSibling {

                    mutationRecord.nextSibling = nextSibling

                }

                if let oldPreviousSibling = oldPreviousSibling {

                    mutationRecord.previousSibling = oldPreviousSibling
                }
                recordManager.queueMutationRecord(mutationRecord)
            }
        }

        // 8. For each ancestor ancestor of node, if ancestor has any registered observers
        // whose options's subtree is true, then for each such registered observer registered,
        // append a transient registered observer whose observer and options are identical to those
        // of registered and source which is registered to node's list of registered observers.
        for ancestor in node.ancestors() {

            if var mutationObserverRegistry = ancestor.mutationObserverRegistry {

                for (registeredObserver, options) in mutationObserverRegistry.registeredObservers {

                    if let subtreeOptionValue = options.getBoolOptionValue(MutationOptionType.Subtree) {

                        if subtreeOptionValue {

                            // FIXME: needs to be added when transient registered observer are supported.
                            let transientMutationObserver = registeredObserver.clone()
                            let transientMutationObserverOptions = options.clone()
                            mutationObserverRegistry.transientRegisteredObservers[transientMutationObserver] = transientMutationObserverOptions

                            // FIXME: to clarify : and source which is registered to node's list of registered observers.
                            Log.fatal("Missing implementation!")
                        }
                    }
                }
            }
        }
        #endif
        
        // 9. Remove node from its parent's children
        removeFromParentChildren(node)
        
        if let textNode = node as? Text {
            self.textChilds.remove(textNode)
        }
        
        // 10. Run the removing steps with node, parent, and oldPreviousSibling.
        node.nextSibling = nil
        node.previousSibling = nil
        
    }
    
    func removeFromParentChildren(_ node: Node) {
        
        #if SAFE_DOM
        assert(node.parentNode === self)
        #endif
        
//        node.document = nil
        
        if node.parentNode != nil {
            
            node.parentNode = nil
            
            // last node
            if lastChild == node {
                
                #if SAFE_DOM
                assert(node.nextSibling == nil)
                #endif
                    
                // In this case we have only one children
                if self.firstChild == node {
                    
                    #if SAFE_DOM
                    assert(node.previousSibling == nil)
                    #endif
                        
                    self.firstChild = nil
                    self.lastChild = nil
                }
                // we need to update the previous sibling
                // this previous subling also becomes the lastChild
                // and maybe the firstChild...
                else {
                    
                    #if SAFE_DOM
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
                
                #if SAFE_DOM
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
                
                #if SAFE_DOM
                assert(node.previousSibling != nil)
                assert(node.nextSibling != nil)
                #endif
                
                // we know there is both a nextSibling and a peviousSibling since
                // this node is not the first nor the last child.
                if let nextSibling = node.nextSibling, let previousSibling = node.previousSibling {
                    
                    #if SAFE_DOM
                        assert(nextSibling.previousSibling == node)
                        assert(previousSibling.nextSibling == node)
                    #endif
                    
                    nextSibling.previousSibling = previousSibling
                    previousSibling.nextSibling = nextSibling
                }
            }
        }
    }
    
    /// boolean contains(Node? other);
    /// see https://dom.spec.whatwg.org/#dom-node-contains
    /// The contains(other) method must return true if other is an
    /// inclusive descendant of the context object,
    /// and false otherwise (including when other is null).
    func contains(_ other: Node?) -> Bool {
        
        if let other = other {
            
            if other.isInclusiveDescendant(of: self) {
                return true
            }
            return false
        }
        else {
            return false
        }
    }
    
    // Utility methods 
    
    
    /// def : An inclusive ancestor is an object or
    /// one of its ancestors.
    /// see https://dom.spec.whatwg.org/#concept-tree-inclusive-ancestor
    override func isInclusiveAncestor(of node: Node) -> Bool {
        
        // consider the node itself (inclusive part)
        if self === node {
            return true
        }
        return isAncestor(of: node)
    }
    
    /// def : An object A is called an ancestor of an object B
    /// if and only if B is a descendant of A.
    /// see https://dom.spec.whatwg.org/#concept-tree-ancestor
    func isAncestor(of node: Node) -> Bool {
        
        // we don't consider the node itself.
        var parent: Node? = node.parentNode;
        
        while let _parent = parent {
            
            if _parent === self {
                
                return true
            }
            parent = _parent.parentNode
        }
        return false
    }
    
    /// Return all the iclusive descendants starting at the
    /// node parameter.
    open func rightSubtree(ofChild node: Node, inclusive: Bool = false) -> NodeList {
        
        // assert that node is a child of the current
        assert(node.parentNode === self)
        
        // construct the descendants list
        return DescendantsFromNodeList(root: self, filter: AcceptAllNodeFilter(), inclusive: inclusive, sourceNode: node)
    }
    
    /// Method that returns true if the node
    
    /// def : An inclusive descendant is an object or one of its descendants.
    /// All descendents of the adopted node, including the node itself
    /// must set their document property's value to this document
    open func inclusiveDescendants() -> LiveNodeList {
        
        return LiveNodeList(root: self, filter: AcceptAllNodeFilter(), inclusive: true)
    }
    
    /// def : An object A is called a descendant of an object B,
    /// if either A is a child of B or A is a child of an object C
    /// that is a descendant of B.
    open func descendants() -> LiveNodeList {
        
        return LiveNodeList(root: self, filter: AcceptAllNodeFilter())
    }
    
    ///
    ///  Calls childElementCount to know how many
    ///  elements childs this ParentNode has, return
    ///  true if this number is greater than 0.
    ///
    override func hasElementChild() -> Bool {
        
        if self.childElementCount > 0 {
            
            return true
        }
        return false
    }
    
    ///
    ///
    func hasTextChild() -> Bool {
        
        if self.hasChildNodes() {
            
            if let childNodes = self.childNodes {
                
                for child in childNodes {
                    
                    if child.nodeType == NodeType.text_node {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    ///
    override func hasDoctypeChild() -> Bool {
        
        if self.hasChildNodes() {
            
            if let childNodes = self.childNodes {
            
                for child in childNodes {
                
                    if child.nodeType == NodeType.document_type_node {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = ContainerNode
    
    /// Implementing ClonableNode protocol
    override open func cloneNode(_ deep: Bool = false) -> ContainerNode {
        
        var copy = createInstance()
        
        cloneFields(&copy)
        
        if deep {
            
            cloneChildren(into: copy, deep: deep)
        }
        return copy
    }
    
    
    /// see https://dom.spec.whatwg.org/#concept-node-clone
    func cloneChildren(into copy: Node, deep: Bool = false) {
        
        // If the clone children flag is set, clone all the children of
        // node and append them to copy, with document as specified
        // and the clone children flag being set.
        let childs = self.childNodes
        
        if let _childs = childs {
            
            for child in _childs {
                
                let childCopy = child.cloneNode(deep)
                
                var exception = Exception()
                
                _ = copy.appendChild(childCopy, exception: &exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return
                }
            }
        }
    }
    
    override open func createInstance() -> ContainerNode {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing subclass implementation!", log: Log.Web.all, type: .fault)
        #endif
        assert(false, "Missing subclass implementation.")
        fatalError("Missing subclass implementation.")
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout ContainerNode) {
        
        var node = copy as Node
        super.cloneFields(&node)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override func equals(to other: Any?, comparePositions: Bool) -> Bool {
        
        if let other = other {
            
            if let other = other as? ContainerNode {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.firstChild != nil && other.firstChild != nil {
                    
                    var child: Node? = self.firstChild
                    var otherChild: Node? = other.firstChild
                    
                    while let _child = child, let _otherChild = otherChild {
                        
                        if !_child.equals(to: _otherChild, comparePositions: comparePositions) {
                            
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("Not equals: child are different.", log: Log.Web.all, type: .debug)
                            #endif
                            return false
                        }
                        
                        child = _child.nextSibling
                        // we know otherChild is not nil since
                        // it is equal to child which is not nil.
                        // the nextSibling maybe nil though.
                        otherChild = _otherChild.nextSibling
                    }
                    if child == nil && otherChild != nil {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: childs are nil and not nil.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                    else if child != nil && otherChild == nil {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: childs are not nil and nil.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if self.firstChild == nil && other.firstChild != nil {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: firstChild are nil and not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                else if self.firstChild != nil && other.firstChild == nil {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: firstChild are not nil and nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not ContainerNode.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other is nil.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        return true
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// boolean isEqualNode(Node? node);
    /// see https://dom.spec.whatwg.org/#dom-node-isequalnode
    override func isEqualNode(_ other: Node?) -> Bool {
        
        if !super.isEqualNode(other) {
        
            return false
        }
        
        if let other = other as? ContainerNode {
        
            if self.firstChild != nil && other.firstChild != nil {
                
                var child: Node? = self.firstChild
                var otherChild: Node? = other.firstChild
                
                while child != nil {
                    
                    if !child!.isEqualNode(otherChild) {
                        return false;
                    }
                    child = child!.nextSibling
                    // we know otherChild is not nil since
                    // it is equal to child which is not nil.
                    // the nextSibling maybe nil though.
                    otherChild = otherChild!.nextSibling
                }
                
                if otherChild != nil {
                    return false;
                }
            }
            else if self.firstChild == nil && other.firstChild != nil {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Not equals: firstChild are nil and not nil.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
            else if self.firstChild != nil && other.firstChild == nil {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Not equals: firstChild are not nil and nil.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Hashable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override open var hashValue: Int {
        
        // FIXME: Test the proformance of this hash and make sure it is not
        // too slow in critical operations.

        
        return UInt(bitPattern: ObjectIdentifier(self)).hashValue
        
//        var h: Int = nodeType.hashValue ^ nodeName.hashValue ^ super.hashValue
//            
//        if let firstChild = firstChild {
//            h = h ^ firstChild.hashValue
//        }
//            
//        if let lastChild = lastChild {
//            h = h ^ lastChild.hashValue
//        }
//            
//        return h
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CommonTreeOperable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ChildNodeType = Node
    
    open func childIndexForChild(_ child: Node) -> Int? {
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("childIndexForChild(...) missing implementation.", log: Log.Web.all, type: .error)
        #endif
        return nil
    }
    
    open func deleteAllChildren() {
        
        var exception = Exception()
        self.removeAllChildren(&exception)
        
        #if SAFE_DOM
        assert(!exception.isError(), "error while removing all children")
        #endif
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ParentNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    /// Returns the child elements.
    /// [SameObject] readonly attribute HTMLCollection children;
    /// see https://dom.spec.whatwg.org/#dom-parentnode-children
    open var children: HTMLCollection {
        
        let filter = ChildrenElementNodeFilter(root: self)
        return HTMLCollection(root: self, filter: filter)
    }
    
    open var childrenWithSourceStringFragment: HTMLCollection {
        
        let filter = ChildrenElementNodeWithSourceStringFragmentFilter(root: self)
        return HTMLCollection(root: self, filter: filter)
    }
    
    /// Return the first child that is an element, and null otherwise.
    /// readonly attribute Element? firstElementChild;
    /// see https://dom.spec.whatwg.org/#dom-parentnode-firstelementchild
    var firstElementChild: Element? {
        
        let filter = ChildrenElementNodeFilter(root: self)
        let children = HTMLCollection(root: self, filter: filter)
        
        if let child = children.item(0) {
            
            if let childElement = child as? Element {
                
                return childElement
            }
            else {
                assert(false, "child is not Element.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("child is not Element.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        return nil
    }
    
    /// Return the last child that is an element, and null otherwise.
    /// readonly attribute Element? lastElementChild;
    /// see https://dom.spec.whatwg.org/#dom-parentnode-lastelementchild
    var lastElementChild: Element? {
        
        let filter = ChildrenElementNodeFilter(root: self)
        let children = HTMLCollection(root: self, filter: filter)
        
        if children.length > 0 {
            
            if let child = children.item(children.length - 1) {
                
                if let childElement = child as? Element {
                    
                    return childElement
                }
                else {
                    assert(false, "child is not Element.")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("child is not Element.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("child is nil.", log: Log.Web.all, type: .error)
                #endif
                assert(false, "child is nil.")
            }
        }
        return nil
    }
    
    /// Return the number of children of the context object that are elements.
    /// readonly attribute unsigned long childElementCount;
    /// see https://dom.spec.whatwg.org/#dom-parentnode-childelementcount
    var childElementCount: Int {
        
        let filter = ChildrenElementNodeFilter(root: self)
        let children = HTMLCollection(root: self, filter: filter)
        return children.length
    }
    
    /// Inserts nodes before the first child of node, while replacing strings in nodes with equivalent Text nodes.
    /// Throws a HierarchyRequestError if the constraints of the node tree are violated.
    ///
    /// [Unscopeable] void prepend((Node or DOMString)... nodes);
    /// see https://dom.spec.whatwg.org/#dom-parentnode-prepend
    func prepend(_ nodes: [Node], stringNodes: [DOMString], exception: inout Exception) {
        
        var prependNodes = [Node]()
        
        // 1. Let node be null.
        var node: Node? = nil
        
        // 2. Replace each string in nodes with a Text node whose data is the string value.
        for node in stringNodes {
            
            let textNode = document.createTextNode(node)
            
            prependNodes.append(textNode)
        }
        
        for node in nodes {
            
            prependNodes.append(node)
        }
        
        // 3. If nodes contains more than one node, set node to a new DocumentFragment and
        // [append](https://dom.spec.whatwg.org/#concept-node-append) each node in nodes to it.
        // Rethrow any exceptions.
        if prependNodes.count > 1 {
            
            let documentFragment = document.createDocumentFragment()
            
            for node in prependNodes {
                
                documentFragment.append(node, exception: &exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return
                }
            }
            
            node = documentFragment
        }
        else if prependNodes.count == 1 {
            
            node = prependNodes[0]
        }
        
        // [Pre-insert](https://dom.spec.whatwg.org/#concept-node-pre-insert) node into the context object
        // before the context object's first child.
        if let node = node {
            
            self.preInsert(node, before: self.firstChild, exception: &exception)
        }
    }
    
    /// Inserts nodes after the last child of node, while replacing strings in nodes with equivalent Text nodes.
    /// Throws a HierarchyRequestError if the constraints of the node tree are violated.
    ///
    /// [Unscopeable] void append((Node or DOMString)... nodes);
    /// see https://dom.spec.whatwg.org/#dom-parentnode-append
    func append(_ nodes: [Node], stringNodes: [DOMString], exception: inout Exception) {
        
        var prependNodes = [Node]()
        
        // 1. Let node be null.
        var node: Node? = nil
        
        // 2. Replace each string in nodes with a Text node whose data is the string value.
        for node in stringNodes {
            
            let textNode = document.createTextNode(node)
            
            prependNodes.append(textNode)
        }
        
        for node in nodes {
            
            prependNodes.append(node)
        }
        
        // 3. If nodes contains more than one node, set node to a new DocumentFragment and
        // [append](https://dom.spec.whatwg.org/#concept-node-append) each node in nodes to it.
        // Rethrow any exceptions.
        if prependNodes.count > 1 {
            
            let documentFragment = document.createDocumentFragment()
            
            for node in prependNodes {
                
                documentFragment.append(node, exception: &exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return
                }
            }
            
            node = documentFragment
        }
        else if prependNodes.count == 1 {
            
            node = prependNodes[0]
        }
        
        // [Append](https://dom.spec.whatwg.org/#concept-node-append) node to the context object.
        if let node = node {
            
            self.append(node, exception: &exception)
        }
    }
    
    /// Returns the first element that is a descendant of node that matches relativeSelectors.
    ///
    /// [Unscopeable] Element? query(DOMString relativeSelectors);
    /// see https://dom.spec.whatwg.org/#dom-parentnode-query
    func query(_ relativeSelectors: DOMString, exception: inout Exception) -> Element? {
        
        let matchList = matchRelativeSelectors(relativeSelectors, set: [self], exception: &exception)
        
        if let matchList = matchList {
            
            if matchList.isEmpty {
                
                return nil
            }
            else {
                
                return matchList[0]
            }
        }
        return nil
    }
    
    
    /// Return an Elements array initialized with the result of running
    /// match a relative selectors string relativeSelectors against a set consisting of context object.
    ///
    /// [NewObject, Unscopeable] Elements queryAll(DOMString relativeSelectors);
    /// see https://dom.spec.whatwg.org/#dom-parentnode-queryall
//    open func queryAll(_ relativeSelectors: DOMString, exception: inout Exception) -> Elements {
//        
//        let matchList = matchRelativeSelectors(relativeSelectors, set: [self], exception: &exception)
//        
//        let elements = Elements()
//        
//        if let matchList = matchList {
//            
//            if !matchList.isEmpty {
//                
//                for element in matchList {
//                    
//                    elements.append(element)
//                }
//            }
//        }
//        return elements
//    }
    
    /// Returns the first element that is a descendant of node that matches selectors.
    ///
    /// Element? querySelector(DOMString selectors);
    /// see https://dom.spec.whatwg.org/#dom-parentnode-queryselector
    open func querySelector(_ selectors: DOMString, exception: inout Exception) -> Element? {
        
        let matchList = scopeMatchSelectors(selectors, against: self, exception: &exception)
        
        if let matchList = matchList {
            
            if matchList.isEmpty {
                
                return nil
            }
            else {
                
                return matchList.first
            }
        }
        return nil
    }
    
    /// Returns all element descendants of node that match selectors.
    ///
    /// FIXME: My implementation returns an Elements array instead od a NodeLits
    /// maybe it will need to be fixed in later versions.
    ///
    /// [NewObject] NodeList querySelectorAll(DOMString selectors);
    /// see https://dom.spec.whatwg.org/#dom-parentnode-queryselectorall
//    open func querySelectorAll(_ selectors: DOMString, exception: inout Exception) -> Elements {
//
//        let matchList = scopeMatchSelectors(selectors, against: self, exception: &exception)
//
//        let elements = Elements()
//
//        if let matchList = matchList {
//
//            if !matchList.isEmpty {
//
//                for element in matchList {
//
//                    elements.append(element)
//                }
//            }
//        }
//
//        return elements
//    }
    
    /// void normalize();
    /// see https://dom.spec.whatwg.org/#dom-node-normalize
    /// The normalize() method must run these steps
    func normalize(_ exception: inout Exception) {
        
        // 1. For each Text node descendant of the context object:
        let descendants = self.descendants()
        
        for child in descendants {
            
            if let node = child as? Text {
                
                assert(node.nodeType == NodeType.text_node)
                
                // 2. Let length be node's length attribute value.
                var length = node.length
                
                // 3. If length is zero, remove node and continue with the next Text node, if any.
                if length == 0 {
                    
                    remove(node, exception: &exception)
                    
                    if exception.isError() {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                        #endif
                        return
                    }
                }
                
                // 4. Let data be the concatenation of the data of node's contiguous Text nodes
                // (excluding itself), in tree order.
                let contiguousTextNodes = node.contiguousTextNodes()
                
                var data: String = ""
                
                for textNode in contiguousTextNodes {
                    
                    data = data + textNode.data
                }
                
                // 5. Replace data with node node, offset length, count 0, and data data.
                node.replaceData(length, count: 0, data: data, exception: &exception)
                
                if exception.isError() {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                    #endif
                    return
                }
                
                // 6. Let current node be node's next sibling.
                var currentNode: Node? = node.nextSibling
                
                // 7. While current node is a Text node:
                while let currentTextNode = currentNode as? Text {
                    
                    // 1. For each range whose start node is current node,
                    // add length to its start offset and set its start node to node.
                    for range in document.ranges {
                        
                        if range.startContainer == currentTextNode {
                            
                            range.startOffset += length
                            range.startContainer = node
                        }
                    }
                    
                    // 2. For each range whose end node is current node,
                    // add length to its end offset and set its end node to node.
                    for range in document.ranges {
                        
                        if range.endContainer == currentTextNode {
                            
                            range.endOffset += length
                            range.endContainer = node
                        }
                    }
                    
                    // 3. For each range whose start node is current node's parent
                    // and start offset is current node's index,
                    // set its start node to node and its start offset to length.
                    for range in document.ranges {
                        
                        if let currentNodeParent = currentTextNode.parentNode {
                            
                            if range.startContainer == currentNodeParent {
                                
                                if range.startOffset == currentTextNode.index {
                                    
                                    range.startContainer = node
                                    range.startOffset = length
                                }
                            }
                        }
                    }
                    
                    // 4. For each range whose end node is current node's parent
                    // and end offset is current node's index,
                    // set its end node to node and its end offset to length.
                    for range in document.ranges {
                        
                        if let currentNodeParent = currentTextNode.parentNode {
                            
                            if range.endContainer == currentNodeParent {
                                
                                if range.endOffset == currentTextNode.index {
                                    
                                    range.endContainer = node
                                    range.endOffset = length
                                }
                            }
                        }
                    }
                    
                    // 5. Add current node's length attribute value to length.
                    length += currentTextNode.length
                    
                    // 6. Set current node to its next sibling.
                    currentNode = currentTextNode.nextSibling
                }
                
                // 8. Remove node's contiguous Text nodes (excluding itself), in tree order.
                for contiguousTextNode in contiguousTextNodes {
                    
                    if contiguousTextNode != self {
                        
                        remove(contiguousTextNode, exception: &exception)
                        
                        if exception.isError() {
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                            #endif
                            return
                        }
                    }
                }
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// Scope-match a selectors string selectors against a node
    /// see https://dom.spec.whatwg.org/#scope-match-a-selectors-string
    private func scopeMatchSelectors(_ selectors: DOMString, against node: Node, exception: inout Exception) -> [Element]? {
        
        let selectorsModule = CSSSelectorsModule.shared

        if let element = node as? Element {

            // 3. Return the result of [evaluate a selector]
            // (http://dev.w3.org/csswg/selectors/#evaluate-a-selector) s
            // using :scope elements set. [SELECTORS]
            // 3. Return the result of evaluate a selector s against node's root using scoping root node and scoping method scope-filtered. [SELECTORS].
            if let keys = selectorsModule.evaluate(selectors, against: [element], stylesheet: nil, filterContext: FilterContext())?.keys {
                
                return Array(keys)
            }
        }
        return nil
    }
    
    /// Match a relative selectors string relativeSelectors against a set
    /// see https://dom.spec.whatwg.org/#match-a-relative-selectors-string
    private func matchRelativeSelectors(_ selectors: DOMString, set: [Node], exception: inout Exception) -> [Element]? {
        
        assert(false, "Missing implementation.")
        
        //        let selectorsModule = CSSSelectorsModule.shared
        //
        //        // 1. Let s be the result of [parse a relative selector]
        //        // (http://dev.w3.org/csswg/selectors/#parse-a-relative-selector)
        //        // from relativeSelectors against set. [SELECTORS]
        //        let result = selectorsModule.parseRelativeSelector(selectors, refs: set)
        //
        //        let selectorList = result.0
        //        let parserReport = result.1
        //
        //        // 2. If s is failure, throw a SyntaxError.
        //        if parserReport.hasErrors() {
        //
        //            exception.code = ExceptionCode.SyntaxError
        //            return nil
        //        }
        //
        //        if let selectorList = selectorList {
        //
        //            // 3. Return the result of [evaluate a selector]
        //            // (http://dev.w3.org/csswg/selectors/#evaluate-a-selector) s
        //            // using :scope elements set. [SELECTORS]
        //            return selectorsModule.evaluate(selectorList, scopingRoot: nil, against: set)
        //            
        //            return selectorsModule.evaluate(<#selector: DOMString#>, against: <#[Element]#>, scopingMethod: <#ScopingMethod?#>, scopingRoot: <#Node?#>, scopeElements: <#[Element]#>, allowedPseudoElements: <#[DOMString]?#>)
        //        }
        //        
        return nil
    }



}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func == (lhs: ContainerNode, rhs: ContainerNode) -> Bool {
    
    return lhs.isEqualNode(rhs)
}
