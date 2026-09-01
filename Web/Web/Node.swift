//
//  NMDOMNodeImpl.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-19.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

/* Non DOM Values */
let nodeStyleChangeShift: Int = 14

// https://dom.spec.whatwg.org/#node
//interface Node : EventTarget {

//    readonly attribute unsigned short nodeType;
//    readonly attribute DOMString nodeName;
//
//    readonly attribute DOMString? baseURI;
//
//    readonly attribute Document? ownerDocument;
//    readonly attribute Node? parentNode;
//    readonly attribute Element? parentElement;
//    boolean hasChildNodes();
//    [SameObject] readonly attribute NodeList childNodes;
//    readonly attribute Node? firstChild;
//    readonly attribute Node? lastChild;
//    readonly attribute Node? previousSibling;
//    readonly attribute Node? nextSibling;
//
//    attribute DOMString? nodeValue;
//    attribute DOMString? textContent;
//    void normalize();
//
//    [NewObject] Node cloneNode(optional boolean deep = false);
//    boolean isEqualNode(Node? node);
//
//    const unsigned short DOCUMENT_POSITION_DISCONNECTED = 0x01;
//    const unsigned short DOCUMENT_POSITION_PRECEDING = 0x02;
//    const unsigned short DOCUMENT_POSITION_FOLLOWING = 0x04;
//    const unsigned short DOCUMENT_POSITION_CONTAINS = 0x08;
//    const unsigned short DOCUMENT_POSITION_CONTAINED_BY = 0x10;
//    const unsigned short DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC = 0x20;
//    unsigned short compareDocumentPosition(Node other);
//    boolean contains(Node? other);
//
//    DOMString? lookupPrefix(DOMString? namespace);
//    DOMString? lookupNamespaceURI(DOMString? prefix);
//    boolean isDefaultNamespace(DOMString? namespace);
//
//    Node insertBefore(Node node, Node? child);
//    Node appendChild(Node node);
//    Node replaceChild(Node node, Node child);
//    Node removeChild(Node child);
//};

enum NilOption {
    case some
    case none
}

open class Node: DOMLanguageObject, Hashable, ClonableNode, EquatableNode, DomInspectable, DomPathable {
    
    fileprivate var optional: NilOption
    
    // readonly attribute unsigned short nodeType;
    open var nodeType: NodeType = NodeType.nil

    /**
     * The name of this node, depending on its type; see the table above.
     *
     * readonly attribute DOMString nodeName;
     *
     */
    /// FIXME: This is a illegal name but we return it for hashing purpose
    open var nodeName: DOMString = "#node"
    
    /// readonly attribute DOMString? baseURI;
    var baseURI: DOMString?
    
    /// see https://dom.spec.whatwg.org/#concept-node-document
    open weak var document: Document!
    
    /// readonly attribute Document? ownerDocument;
    var ownerDocument: Document? {
        
        if let _ = self as? Document {
            
            return nil
        }
        return self.document
    }
    
    /// readonly attribute Node? parentNode;
    weak open var parentNode: ContainerNode?
    
    /// readonly attribute Element? parentElement;
    open var parentElement: Element? {
        if let element = self.parentNode as? Element {
            return element
        }
        return nil
    }
    
    /// this will almost always return something 
    /// since there is always a document element.
    open var closestParentElement: Element? {
        
        var _node = self.parentNode
        while _node != nil {
            if let element = _node as? Element {
                return element
            }
            _node = _node!.parentNode
        }
        return nil
    }
    
    /// [SameObject] readonly attribute NodeList childNodes;
    /// see https://rniwa.com/2013-02-10/live-nodelist-and-htmlcollection-in-webkit/
    var childNodes: NodeList? {
        
        return nil
    }
    
    /// The root of an object is itself, if its parent is null,
    /// or else it is the root of its parent.
    var root: Node {
        
        if let _parentNode = self.parentNode {
            return _parentNode.root
        }
        else {
            return self
        }
    }
    
    /// readonly attribute Node? previousSibling;
    public weak var previousSibling: Node?
    
    /// readonly attribute Node? nextSibling;
    public var nextSibling: Node?
    
    ///
    var lastChild: Node? {
        get {
            return nil
        }
        set {
            // do nothing
        }
    }
    
    /// 
    var firstChild: Node? {
        get {
            return nil
        }
        set {
            // do nothing
        }
    }
    
    /**
     * This value can only be set using the setter 
     * setNodeValue in order to be able to return 
     * an error code. By default this method has no effect.
     *
     * attribute DOMString? nodeValue;
     *
     */
    internal var nodeValue: DOMString? {
        get {
            return nil
        }
        set {
            // by default do nothing
        }
    }
    
    /// attribute DOMString? textContent;
    var textContent: DOMString? {
        get {
            return nil
        }
        set {
            // by default do nothing
        }
    }

    public var length: Int {

        return 0
    }
    
    /// def : The index of an object is its number of preceding siblings.
    /// def : An object A is preceding an object B if A and B are in the same tree and A comes before B in tree order.
    /// def : An object A is called a sibling of an object B, if and only if B and A share the same non-null parent.
    /// see https://dom.spec.whatwg.org/#concept-tree-index
    var index: Int {

        var counter: Int = 0
        var precedingSibling: Node? = precedingNode()
            
        while let _precedingSibling = precedingSibling {
                
            counter += 1
            precedingSibling = _precedingSibling.precedingNode()
        }
        return counter
    }
    
    var mutationObserverRegistry: MutationObserverRegistry?
    
    var _nodeIdentity: NodeIdentity?
    
    var _treePositionIdentity: TreePositionIdentity?
    
    public init(document: Document?, sourceStringFragment: SourceStringFragment?) {
        
        self.document = document
        self.optional = NilOption.some
        //        self.mutationObserverRegistry = MutationObserverRegistry()
        
        super.init(sourceStringFragment: sourceStringFragment)
    }
    
    /// boolean hasChildNodes();
    open func hasChildNodes() -> Bool {
        
        return false
    }
    
    /// unsigned short compareDocumentPosition(Node other);
    /// see https://dom.spec.whatwg.org/#dom-node-comparedocumentposition
    func compareDocumentPosition(_ other: Node!) -> UInt16 {

        if let other = other {
            
            // 1. Let reference be the context object.
            let reference = self
        
            // 2. If other and reference are the same object, return zero.
            if reference == other {
                
                return §DocumentPosition.document_POSITION_EQUIVALENT
            }
        
            // 3. If other and reference are not in the same tree,
            // return the result of adding DOCUMENT_POSITION_DISCONNECTED,
            // DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC, and either DOCUMENT_POSITION_PRECEDING or
            // DOCUMENT_POSITION_FOLLOWING, with the constraint that this is to be consistent, together.
            //  Note: If the two elements don't have a common root, they're not in the same tree.
            if reference.root != other.root {
                
                return DocumentPosition.document_POSITION_DISCONNECTED.rawValue
                    + DocumentPosition.document_POSITION_IMPLEMENTATION_SPECIFIC.rawValue
                    + DocumentPosition.document_POSITION_PRECEDING.rawValue
            }
            
            
            // 4. If other is an ancestor of reference, return the result of adding 
            // DOCUMENT_POSITION_CONTAINS to DOCUMENT_POSITION_PRECEDING.
            if let containerNode = other as? ContainerNode {

                if containerNode.isAncestor(of: reference) {
                
                    return §DocumentPosition.document_POSITION_CONTAINS
                        + §DocumentPosition.document_POSITION_PRECEDING
                }
            }
            // 5. If other is a descendant of reference, return the result of adding 
            // DOCUMENT_POSITION_CONTAINED_BY to DOCUMENT_POSITION_FOLLOWING.
            if let containerNode = reference as? ContainerNode {
           
                if other.isDescendant(of: containerNode) {
                
                    return §DocumentPosition.document_POSITION_CONTAINED_BY
                        + §DocumentPosition.document_POSITION_FOLLOWING
                }
            }
            
            // 6. If other is preceding reference return DOCUMENT_POSITION_PRECEDING.
            if other.isPreceding(reference) {
                
                return §DocumentPosition.document_POSITION_PRECEDING
            }
            
            // 7. Return DOCUMENT_POSITION_FOLLOWING.
            return §DocumentPosition.document_POSITION_FOLLOWING
        }
        else {
            // Following WebKit on this.
            return §DocumentPosition.document_POSITION_DISCONNECTED;
        }
    }
    
    
    ///
    /// DOMString? lookupPrefix(DOMString? namespace);
    /// https://dom.spec.whatwg.org/#dom-node-lookupprefix
    /// The lookupPrefix(namespace) method must run these steps:
    func lookupPrefix(_ namespace: DOMString!) -> DOMString? {
        
        // 1. If namespace is null or the empty string, return null.
        if let namespace = namespace , namespace.length != 0 {
            
                
            // 2. Otherwise it depends on the context object:
            if let element = self as? Element {
                    
                // Return the result of locating a namespace prefix for
                // the node using namespace.
                return locateNamespacePrefix(element, namespace: namespace)
            }
            else if let document = self as? Document {
                    
                // Return the result of locating a namespace prefix for its document element,
                // if that is not null, and null otherwise.
                if let documentElement = document.documentElement {
                    
                    return locateNamespacePrefix(documentElement, namespace: namespace)
                }
            }
            else if let _ = self as? DocumentType {
             
                return nil
            }
            else if let _ = self as? DocumentFragment {
            
                return nil
            }
            else {
                    
                // Return the result of locating a namespace prefix for its parent element,
                // or if that is null, null.
                if let parentElement = self.parentElement {
                        
                    return locateNamespacePrefix(parentElement, namespace: namespace)
                }
                    
                return nil
            }
        }

        return nil
    }
    
    ///
    /// see https://dom.spec.whatwg.org/#locate-a-namespace-prefix
    fileprivate func locateNamespacePrefix(_ element: Element, namespace: DOMString) -> DOMString? {
        
        // 1. If element's namespace is namespace and its namespace prefix is not null,
        // return its namespace prefix.
        if element.namespaceURI == namespace {
            
            if let prefix = element.prefix {
                
                return prefix
            }
        }
        
        // 2. If, element has an attribute whose namespace prefix is "xmlns" and value is namespace,
        // then return element's first such attribute's local name.
        for attribute in element.attributeList {
            
            if attribute.namespaceURI == namespace {
                
                if let _ = attribute.prefix {
                    
                    return attribute.localName
                }
            }
        }
        
        // 3. If element's parent element is not null,
        // return the result of running locate a namespace prefix on that element using namespace.
        // Otherwise, return null.
        if let parentElement = element.parentElement {
            
            return locateNamespacePrefix(parentElement, namespace: namespace)
        }
        
        return nil
    }
    
    /// Locate a namespace : default implementation
    /// see https://dom.spec.whatwg.org/#locate-a-namespace
    /// Overidden by Element, Document, DocumentType and DocumentFragment
    func locateNamespace(_ prefix: DOMString?) -> DOMString? {
    
        
        if let parentElement = self.parentElement {
            
            // 2. Return the result of running locate a namespace on its parent element using prefix.
            return parentElement.locateNamespace(prefix)
        }
        
        // 1. If its parent element is null, return null.
        return nil
    }
    
    /// DOMString? lookupNamespaceURI(DOMString? prefix);
    /// see https://dom.spec.whatwg.org/#dom-node-lookupnamespaceuri
    func lookupNamespaceURI(_ prefix: DOMString!) -> DOMString! {

        var localPrefix: DOMString? = nil
        
        // 1. If prefix is the empty string, set it to null.
        if !prefix.isEmpty {
            
            localPrefix = prefix
        }
        
        // 2. Return the result of running locate a namespace for the context object using prefix.
        return locateNamespace(localPrefix)
    }
    
    /// boolean isDefaultNamespace(DOMString? namespace);
    /// see https://dom.spec.whatwg.org/#dom-node-isdefaultnamespace
    func isDefaultNamespace(_ namespace: DOMString!) -> Bool {
        
        var localNamespace: DOMString? = nil
        
        // 1. If namespace is the empty string, set it to null.
        if !namespace.isEmpty {
            
            localNamespace = namespace
        }
        
        // 2. Let defaultNamespace be the result of running locate a namespace 
        // for the context object using null.
        let defaultNamespace = locateNamespace(nil)
        
        // 3. Return true if defaultNamespace is the same as namespace, 
        // and false otherwise.
        if defaultNamespace == namespace {
         
            return true
        }
        
        return false
    }

    /// The Node interface does not support inserting child
    /// so calling this function will result in an error.
    ///
    /// Node insertBefore(Node node, Node? child);
    /// see https://dom.spec.whatwg.org/#dom-node-insertbefore
    func insertBefore(_ node: Node!, before child: Node?, exception: inout Exception) -> ContiguousArray<Node>? {
        
        // by default Node does not allow to insert 
        // new node, it should be a container node to allow 
        // this operation.
        // see ContainerNode.
        exception.code = ExceptionCode.hierarchyRequestError
        return nil
    }
    
    /// The Node interface does not support appending child
    /// so calling this function will result in an error.
    ///
    /// Node appendChild(Node node);
    /// see https://dom.spec.whatwg.org/#dom-node-appendchild
    @discardableResult
    func appendChild(_ node: Node, exception: inout Exception) -> Node? {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing subclass implementation!", log: Log.Web.all, type: .fault)
        #endif
        assert(false, "Missing subclass implementation.")
        return nil
    }
    
    /// The Node interface does not support appending child
    /// so calling this function will result in an error.
    ///
    /// Node replaceChild(Node node, Node child);
    /// see https://dom.spec.whatwg.org/#dom-node-replacechild
    func replaceChild(_ node: Node, child: Node, exception: inout Exception) -> Node? {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing subclass implementation!", log: Log.Web.all, type: .fault)
        #endif
        assert(false, "Missing subclass implementation.")
        return nil
    }

    /// The Node interface does not support appending child
    /// so calling this function will result in an error.
    ///
    /// Node removeChild(Node child);
    /// see https://dom.spec.whatwg.org/#dom-node-removechild
    func removeChild(_ child: Node, exception: inout Exception) -> Node? {

        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing subclass implementation!", log: Log.Web.all, type: .fault)
        #endif
        assert(false, "Missing subclass implementation.")
        return nil
    }
    
    /// Events are not supported yet.
    /// void addEventListener(DOMString type, EventListener? callback, optional boolean capture = false);
    func addEventListener(_ type: DOMString!, callback: EventListener!, capture: Bool) {
        // TODO:
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing implementation!", log: Log.Web.all, type: .fault)
        #endif
    }
    
    /// Events are not supported yet.
    /// void removeEventListener(DOMString type, EventListener? callback, optional boolean capture = false);
    func removeEventListener(_ type: DOMString, callback: DOMEventListener, capture: Bool) {
        // TODO:
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing implementation!", log: Log.Web.all, type: .fault)
        #endif
    }
    
    /// Events are not supported yet.
    /// boolean dispatchEvent(Event event);
    func dispatchEvent(_ event: DOMEvent) -> Bool {
        // TODO:
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing implementation!", log: Log.Web.all, type: .fault)
        #endif
        fatalError("Missing implementation.")
    }
    
    /// Return true if it is a DocumentType.
    func isDocumentTypeNode() -> Bool {
    
        return self.nodeType == NodeType.document_type_node;
    }

    ///
    func childTypeAllowed(_ nodeType: NodeType) -> Bool {
    
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing subclass implementation!", log: Log.Web.all, type: .fault)
        #endif
        assert(false, "Missing subclass implementation.")
        return false
    }
    
    // MARK: Element list methods
    
    /// Return the list of elements with local name localName for a node root.
    /// This method return a HTMLCollection with the LocalnameElementNodeFilter filter.
    /// In this method the root is the context object.
    /// see https://dom.spec.whatwg.org/#concept-getelementsbytagname
    func listElementsWithLocalname(_ localname: DOMString, htmlDocument: Bool = true) -> HTMLCollection {
        
        let filter = LocalnameElementNodeFilter(htmlDocument: htmlDocument, localname: localname)
        return HTMLCollection(root: self, filter: filter)
    }
    
    /// Return the list of elements with namespace namespace and local name localName for a node root.
    /// This method return a HTMLCollection with the NamespaceAndLocalnameElementNodeFilter filter.
    /// In this method the root is the context object.
    /// see https://dom.spec.whatwg.org/#concept-getelementsbytagnamens
    func listElementsWithLocalnameAndNamespace(_ localname: DOMString, namespace: DOMString) -> HTMLCollection {
        
        let filter = NamespaceAndLocalnameElementNodeFilter(localname: localname, namespace: namespace)
        return HTMLCollection(root: self, filter: filter)
    }
    
    /// Return the list of elements with class names classNames for a node root.
    /// This method return a HTMLCollection with the ClassnamesElementNodeFilter filter.
    /// In this method the root is the context object.
    /// see https://dom.spec.whatwg.org/#concept-getelementsbyclassname
    func listElementsWithClassnames(_ classnames: DOMString) -> HTMLCollection {
        
        // 1. Let classes be the result of running the ordered set parser on classNames.
        let classes = OrderedSetParser.parse(classnames)
        let filter = ClassnamesElementNodeFilter(classnames: classes)
        return HTMLCollection(root: self, filter: filter)
    }
    
    // MARK: Common methods
    
    
    /// Method to get the list of ancestors of context object.
    /// This list is returned in tree order.
    /// FIXME:
    /// see https://dom.spec.whatwg.org/#concept-tree-ancestor
    func inclusiveAncestors() -> [Node] {
        
        var inclusiveAncestors = [Node]()
        var node: Node? = self;
        
        while let _node = node {
            
            inclusiveAncestors.append(_node)
            node = _node.parentNode
        }
        return Array(inclusiveAncestors.reversed())
    }
    
    /// Method to get the list of ancestors of context object
    /// This list is returned in tree order.
    /// see https://dom.spec.whatwg.org/#concept-tree-ancestor
    func ancestors() -> [Node] {
     
        var ancestors = [Node]()
        // we don't consider the node itself.
        var parent: Node? = self.parentNode;
        
        while let _parent = parent {
            
            ancestors.append(_parent)
            parent = _parent.parentNode
        }
        return Array(ancestors.reversed())
    }
    
    /// An object A is a host-including inclusive ancestor of an object B, 
    /// if either A is an inclusive ancestor of B, or if B's root has an associated host 
    /// and A is a host-including inclusive ancestor of B's root's host.
    ///
    /// see https://dom.spec.whatwg.org/#concept-tree-host-including-inclusive-ancestor
    func isHostIncludingInclusiveAncestor(_ node: Node) -> Bool {

        if self.isInclusiveAncestor(of: node) {
            
            return true
        }
        
        if let documentFragment = node.root as? DocumentFragment {
            
            if let host = documentFragment.host {
             
                return isHostIncludingInclusiveAncestor(host)
                
            }
        }
        
        return false
    }

    /// doctype is following child
    /// def "following" :    An object A is following an object B if A and B are
    ///                      in the same tree and A comes after B in tree order.
    /// def "tree order":    In tree order is preorder,depth-first traversal of a tree.
    /// in our case following in tree order traversal means : the first-child of child
    /// see https://dom.spec.whatwg.org/#concept-tree-following
    func isDoctypeFollowingNode() -> Bool {
                                    
        if let _followingNode = followingNode() {
                                
            if _followingNode.nodeType == NodeType.document_type_node {

                return true
            }
        }
        return false
    }
    
    /// In this method we want to know if the
    /// the context node (ouselves) is following
    /// the node parameter
    func isFollowing(_ node: Node) -> Bool {
        
        // get the following node if existing of node
        if let _followingNode = node.followingNode() {
            
            // if it is ourselve, return true
            if _followingNode === self {
                
                return true
            }
        }
        return false
    }
    
    /// Return true if the preceeding node (in tree order)
    /// is an element node NodeType.
    func isElementPreceding() -> Bool {
        
        if let _preceedingNode = precedingNode() {
            
            if _preceedingNode.nodeType == NodeType.element_node {
                return true
            }
        }
        return false
    }
    
    /// An object A is following an object B if A and B are
    /// in the same tree and A comes after B in tree order.
    /// see https://dom.spec.whatwg.org/#concept-tree-following
    func followingNode() -> Node? {
        
        // if there is a first child it is 
        // the following node in tree order
        if let _firstChild = self.firstChild {
            
            return _firstChild
        }
        
        // if there is no first child, the next sibling
        // is the following node in tree order
        if let _nextSibling = self.nextSibling {
            
            return _nextSibling
        }
        
        // if there is no next sibling and no first child
        // the following node is the following node of the parent 
        // excluding it's childs since we know we are the last child.
        if let _parentNode = self.parentNode {
            
            if let _parentNonChildFollowingNode = _parentNode.nonChildFollowingNode() {
             
                return _parentNonChildFollowingNode
            }
        }
        
        return nil
    }
    
    /// This method return the following node when
    /// the child does not know it's following node
    /// in the the tree order, it then must ask it's
    /// parent. Basically in this method we always
    /// look at nextSibling and if it's nil
    /// we look at the parent's next sibling.
    /// see https://dom.spec.whatwg.org/#concept-tree-following
    func nonChildFollowingNode() -> Node? {
        
        if let _nextSibling = self.nextSibling {
            
            return _nextSibling
        }
        
        // if there is no next sibling and no first child
        // the following node is the following node of the parent
        // excluding it's childs since we know we are the last child.
        if let _parentNode = self.parentNode {
            
            if let _parentNonChildFollowingNode = _parentNode.nonChildFollowingNode() {
                
                return _parentNonChildFollowingNode
            }
        }
        
        return nil
    }
    
    /// An object A is preceding an object B if A and B
    /// are in the same tree and A comes before B in tree order.
    /// see https://dom.spec.whatwg.org/#concept-tree-preceding
    func precedingNode() -> Node? {
        
        // if there is a previous sibling it is
        // the preceding node in pre order traversal
        if let _previousSibling = self.previousSibling {
            
            return _previousSibling
        }
        
        // if there is no previous sibling, we must
        // look at the parent node.
        if let _parentNode = self.parentNode {
            
            return _parentNode
        }
        
        // otherwise this node is the first in tree order 
        // and is floating so there is no preceeding node
        return nil
    }
    
    /// This method is a preorder depth-first traversal function
    /// that stops the traversal at root.
    func traverseNextNode(_ node: Node, root: Node) -> Node? {
        
        let treeWalker = TreeWalker(root: node, whatToShow: WhatToShow.show_ALL, filter: nil)
        return treeWalker.nextNode()
    }
    
    /// internal method taking a String in parameter
    func appendToTextContent(_ buf: String) {
        
        if let content = self.nodeValue {
            self.nodeValue = content + buf
        }
    }
    
    /// Method that returns true is if nodeType
    /// is NodeType.TEXT_NODE or NodeType.PROCESSING_INSTRUCTION_NODE
    /// or NodeType.COMMENT_NODE
    func isTextOrProcessingOrComment() -> Bool {
        
        let type = self.nodeType
        
        if type == NodeType.text_node
            ||  type == NodeType.processing_instruction_node
            ||  type == NodeType.comment_node {
                
            return true
        }
        return false
    }

    // MARK: Utility methods
    
    
    /// Method that return if the context object (self)
    /// is preceding the node parameter.
    func isPreceding(_ node: Node) -> Bool {
        
        let preceding = precedingNode()
        
        if let preceding = preceding, preceding === self {
            
            return true
        }
        return false
    }
    
    /// Method to return if the current node is a
    /// desendant of node.
    func isDescendant(of node: ContainerNode) -> Bool {
        
        let descendants = node.descendants()
        
        for descendant in descendants {
            
            if descendant === self {
                return true
            }
        }
        return false
    }
    
    /// Method to return if the current node is an inclusive
    /// desendant of node.
    /// def : An inclusive descendant is an object or one of its descendants.
    /// see https://dom.spec.whatwg.org/#concept-tree-inclusive-descendant
    func isInclusiveDescendant(of node: ContainerNode) -> Bool {
        
        let inclusiveDescendants = node.inclusiveDescendants()
        
        for descendant in inclusiveDescendants {
            
            if descendant === self {
                return true
            }
        }
        return false
    }
    
    /// def : An inclusive ancestor is an object or
    /// one of its ancestors.
    /// see https://dom.spec.whatwg.org/#concept-tree-inclusive-ancestor
    func isInclusiveAncestor(of node: Node) -> Bool {
        
        // consider the node itself (inclusive part)
        if self === node {
            
            return true
        }
        return false
    }
    
    ///
    ///  Calls childElementCount to know how many
    ///  elements childs this ParentNode has, return
    ///  true if this number is greater than 0.
    func hasElementChild() -> Bool {
        
        return false
    }
    
    ///
    func hasDoctypeChild() -> Bool {
        
        return false
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: DomPathable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var path: [Int] {
        
        if let pathableParent = pathableParent {
            
            var _path: [Int] = pathableParent.path
            _path.append(indexInParent!)
            return _path
        }
        return []
        
    }
    
    public var pathableParent: DomPathable? {
        
        return self.parentNode
    }
    
    var _pathableChilds: [DomPathable]?
    
    public var pathableChilds: [DomPathable]? {
        
        if let _length = _length, self.length == _length {
            
            if let _pathableChilds = _pathableChilds {
                
                return _pathableChilds
            }
        }
        
        _length = length
        
        if let childNodes = self.childNodes {
            
            var pathableChildren = [DomPathable]()
            
            for child in childNodes {
                
                pathableChildren.append(child)
            }
            
            _pathableChilds = pathableChildren
            
            return pathableChildren
        }
        return nil
    }
    
    public func pathable(at path: [Int]) -> DomInspectable? {
        
        if path.isEmpty {
            
            return self
        }
        
        if let index = path.first {
            
            if let childs = pathableChilds {
                
                var _childPath = path
                
                _childPath.removeFirst()
                
                if childs.indices.contains(index) {
                    
                    return childs[index].pathable(at: _childPath)
                }
            }
        }
        return  nil
        
    }
    
    fileprivate var indexInParent: Int? {
        
        if let pathableParent = pathableParent {
            
            // since we are a child of this parent we can assume
            // it has at least one child
            let parentChilds = pathableParent.pathableChilds!
            
            for (index, parentChild) in parentChilds.enumerated() {
                
                if let _parentChild = parentChild as? Node {
                    
                    if _parentChild == self {
                        
                        return index
                    }
                }
            }
        }
        return nil
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: DomInspectable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open func inspectable(at path: [Int]) -> DomInspectable? {
        
        if path.isEmpty {
            
            return self
        }
        
        if let index = path.first {
            
            if let childs = inspectableChilds {
                
                var _childPath = path
                
                _childPath.removeFirst()
                
                if childs.indices.contains(index) {
                    
                    return childs[index].inspectable(at: _childPath)
                }
            }
        }
        return  nil
    }
    
    open var range: NSRange? {

        return sourceStringFragment?.range
    }
    
    open var inspectablePath: [Int] {
    
        if let inspectableParent = inspectableParent {
        
            // since we are a child of this parent we can assume
            // it has at least one child
            let parentChilds = inspectableParent.inspectableChilds!
            
            for (index, parentChild) in parentChilds.enumerated() {
                
                if let parentChild = parentChild as? Node, parentChild == self {
                    
                    var _path: [Int] = inspectableParent.inspectablePath
                    _path.append(index)
                    return _path
                }
            }
        }
        return []
    }
    
    open var inspectableParent: DomInspectable? {
        
        return self.parentNode
    }
    
    open var expanded: Bool = false
    
    fileprivate var _length: Int?
    
    var _inspectableChilds: [DomInspectable]?
    
    /// FIXME: Performance, we should maybe cache the result of this operation
    open var inspectableChilds: [DomInspectable]? {
        
        if let _length = _length, self.length == _length {
            
            if let _inspectableChilds = _inspectableChilds {
                
                return _inspectableChilds
            }
        }
        
        _length = length
        
        if let childNodes = self.childNodes {
            
            var diplayableChildren = [Node]()
            
            for child in childNodes {
                
                // an empty text node is not displayable...
                if let text = child as? Text {
                    
                    let trimmed = text.data.trimmed()
                    
                    if !trimmed.isEmpty {
                        
                        diplayableChildren.append(child)
                    }
                }
                else {
                    
                    if let element = child as? Element, let childs = element.inspectableChilds {
                        
                        // an empty element is not displayable...
                        if !childs.isEmpty {
                            
                            diplayableChildren.append(child)
                        }
                    }
                    else {
                        diplayableChildren.append(child)
                    }
                }
            }
            
            _inspectableChilds = diplayableChildren
            
            return diplayableChildren
        }
        return nil
    }
    
    open var numberOfChildren: Int {
        
        if let childs = inspectableChilds {
            
            return childs.count
        }
        
        return 1
    }
    
    open var expandable: Bool {
        
        if let childs = inspectableChilds {
            
            return childs.count > 0
        }
        
        return false
    }
    
    open var expandedOpenElementString: String {
        
        return ""
    }
    
    open var unexpandedElementString: String {
        
        return ""
    }
    
    open func childAtIndex(_ index: Int) -> DomInspectable? {
        
        return inspectableChilds![index]
    }
    
    /// This method returns true is the current ContainerNode
    /// has only text nodes.
    open func hasOnlyChildTextNodes() -> Bool {
        
        for child in inspectableChilds! {
            
            if child.nodeType != NodeType.text_node {
                return false
            }
        }
        return true
    }

    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    public typealias ClonableNodeType = Node
    
    /// If document is not given, let document be node's node document.
    /// see https://dom.spec.whatwg.org/#concept-node-clone
    func computeOwnerDocument(fromDocument document: Document? = nil) -> Document {
        
        var documentValue: Document? = nil
        
        if document != nil {
            documentValue = document
            
        } else {
            documentValue = self.document
        }
        
        return documentValue!
    }
    
    /// see
    open func cloneNode(_ deep: Bool = false) -> Node {
    
        var copy = createInstance()
        cloneFields(&copy)
        return copy
    }
    
    open func cloneFields(_ copy: inout Node) {
        
        copy.sourceStringFragment = self.sourceStringFragment
        copy.baseURI = self.baseURI
        copy.nodeValue = self.nodeValue
        copy.textContent = self.textContent
        
        for message in self.messageHandler.allMessages {
            copy.messageHandler.allMessages.append(message)
        }
    }
    
    open func createInstance() -> Node {
        
        return Node(document: nil, sourceStringFragment: nil)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override func equals(to other: Any?, comparePositions: Bool) -> Bool {
     
        if let other = other {
        
            if let other = other as? Node {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.nodeType != other.nodeType {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: nodeType are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.nodeName != other.nodeName {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: nodeName are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }

                if let baseURI = self.baseURI {
                    
                    if let otherBaseURI = other.baseURI {
                        
                        if baseURI != otherBaseURI {
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("Not equals: baseURI are different.", log: Log.Web.all, type: .debug)
                            #endif
                            return false
                        }
                    }
                    else {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: other baseURI is nil.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.baseURI != nil {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other baseURI is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not Node.", log: Log.Web.all, type: .debug)
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
    
    /// A node A equals a node B if all of the following conditions are true:
    /// boolean isEqualNode(Node? node);
    /// see https://dom.spec.whatwg.org/#dom-node-isequalnode
    func isEqualNode(_ other: Node?) -> Bool {
        
        if let other = other {
        
            // A and B's nodeType attribute value is identical.
            if self.nodeType.rawValue != other.nodeType.rawValue {
            
                return false;
            }
        }
        else {
            
            return false
        }
        return true;
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Hashable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open var hashValue: Int {
        
        // FIXME: Test the proformance of this hash and make sure it is not
        // too slow in critical operations.

        return UInt(bitPattern: ObjectIdentifier(self)).hashValue
        
//        var h: Int = nodeName.hashValue
//        
//        h = h ^ nodeType.hashValue
//        
//        if let baseURI = baseURI {
//            h = h ^ baseURI.hashValue
//        }
//        
//        h = h ^ document.hashValue
//        
//        if let parentNode = parentNode {
//            h = h ^ parentNode.hashValue
//        }
//        
//        if let parentElement = parentElement {
//            h = h ^ parentElement.hashValue
//        }
//        
//        if let firstChild = firstChild {
//            h = h ^ firstChild.hashValue
//        }
//        
//        if let lastChild = lastChild {
//            h = h ^ lastChild.hashValue
//        }
//        
//        if let previousSibling = previousSibling {
//            h = h ^ previousSibling.hashValue
//        }
//        
//        if let nextSibling = nextSibling {
//            h = h ^ nextSibling.hashValue
//        }
//        
//        if let nodeValue = nodeValue {
//            h = h ^ nodeValue.hashValue
//        }
//        
//        if let textContent = textContent {
//            h = h ^ textContent.hashValue
//        }
//        
//        h = h ^ length.hashValue
//        
//        h = h ^ index.hashValue
//        
//        return h
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////
    
public func ==(lhs: Node, rhs: Node) -> Bool {
    
    
    return lhs === rhs // lhs.isEqualNode(rhs) && lhs.hashValue == rhs.hashValue
}
    

