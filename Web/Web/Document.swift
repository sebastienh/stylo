//
//  DocumentImpl.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-20.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

// https://dom.spec.whatwg.org/#document

//interface Document : Node {
//    [SameObject] readonly attribute DOMImplementation implementation;
//    readonly attribute DOMString URL;
//    readonly attribute DOMString documentURI;
//    readonly attribute DOMString origin;
//    readonly attribute DOMString compatMode;
//    readonly attribute DOMString characterSet;
//    readonly attribute DOMString contentType;
//
//    readonly attribute DocumentType? doctype;
//    readonly attribute Element? documentElement;
//    HTMLCollection getElementsByTagName(DOMString localName);
//    HTMLCollection getElementsByTagNameNS(DOMString? namespace, DOMString localName);
//    HTMLCollection getElementsByClassName(DOMString classNames);
//
//    [NewObject] Element createElement(DOMString localName);
//    [NewObject] Element createElementNS(DOMString? namespace, DOMString qualifiedName);
//    [NewObject] DocumentFragment createDocumentFragment();
//    [NewObject] Text createTextNode(DOMString data);
//    [NewObject] Comment createComment(DOMString data);
//    [NewObject] ProcessingInstruction createProcessingInstruction(DOMString target, DOMString data);
//
//    Node importNode(Node node, optional boolean deep = false);
//    Node adoptNode(Node node);
//
//    [NewObject] Attr createAttribute(DOMString localName);
//    [NewObject] Attr createAttributeNS(DOMString? namespace, DOMString name);
//
//    [NewObject] Event createEvent(DOMString interface);
//
//    [NewObject] Range createRange();
//
//    // NodeFilter.SHOW_ALL = 0xFFFFFFFF
//    [NewObject] NodeIterator createNodeIterator(Node root, optional unsigned long whatToShow = 0xFFFFFFFF, optional NodeFilter? filter = null);
//    [NewObject] TreeWalker createTreeWalker(Node root, optional unsigned long whatToShow = 0xFFFFFFFF, optional NodeFilter? filter = null);
//};
//Document implements ParentNode;
open class Document: ContainerNode {
    
    /// [SameObject] readonly attribute DOMImplementation implementation;
    internal(set) var implementation: DOMImplementation?
    
    /// readonly attribute DOMString URL;
    internal(set) var URL: DOMString
    
    /// readonly attribute DOMString documentURI;
    internal(set) var documentURI: DOMString
    
    /// readonly attribute DOMString origin;
    internal(set) var origin: DOMString
    
    /// readonly attribute DOMString compatMode;
    internal(set) var compatMode: DOMString
    
    /// readonly attribute DOMString characterSet;
    internal(set) var characterSet: DOMString
    
    /// readonly attribute DOMString inputEncoding; // legacy alias of .characterSet
    internal(set) var inputEncoding: DOMString
    
    /// readonly attribute DOMString contentType;
    open var contentType: DOMString
    
    /// Return the child of the document that is a doctype,
    /// and null otherwise.
    /// readonly attribute DocumentType? doctype;
    /// see https://dom.spec.whatwg.org/#dom-document-doctype
    open var doctype: DocumentType? {
        
        let childs = childNodes!
        
        for child in childs {
            if let childElement = child as? DocumentType {
                return childElement
            }
        }
        assert(false, "Missing document element.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing document element.", log: Log.Web.all, type: .error)
        #endif
        return nil
    }
    
    var _documentElement: Element?
    
    ///
    /// > The document element of a document is the element whose parent is that document, 
    /// > if it exists, and null otherwise.
    ///
    /// readonly attribute Element? documentElement;
    /// see https://dom.spec.whatwg.org/#document-element
    open var documentElement: Element! {
        
        if let _documentElement = _documentElement {
            return _documentElement
        }
        
        let childs = children
        
        for child in childs {
            
            if let childElement = child as? Element {
                
                _documentElement = childElement
                return childElement
            }
        }
        assert(false, "Missing document element.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing document element.", log: Log.Web.all, type: .error)
        #endif
        return nil
    }
    
    /// mutation record manager
    /// FIXME: Make sure this is the best place to put it.
    var mutationRecordManager: MutationRecordManager?
    
    /// see http://dev.w3.org/csswg/cssom/#document-css-style-sheets
    var documentCSSStyleSheets: DocumentStyleSheetCollection
    
    /// Root document element. It will be the documentElement. 
    open var rootDocumentElement: Element {
        
        return documentElement
    }
    
    public var styleRoot: Element {
        
        // default is documentElement
        return documentElement
    }
    
    /// This variable returns the elements that are on top
    /// of the styleRootChildElements.
    public var styleRoots: ContiguousArray<Element> {
        
        return ContiguousArray<Element>(arrayLiteral: documentElement)
    }
    
    /// The style container is used by any node to know it's 
    /// current style values : defaultStyle, computedStyle, etc....
    /// This value is assigned in the ResourceStyleUpdateOperation.
//    open weak var styleContainer: StyleContainer?
    
    // Variable containing all the ranges associated with this
    // document.
    var ranges: [DOMRange]
    
    public init() {
        
        self.URL = ""
        self.documentURI = ""
        self.origin = ""
        self.compatMode = ""
        self.characterSet = ""
        self.inputEncoding = ""
        self.contentType = §Language.HTML
        // Reenable to support mutation record manager
        
        #if MUTATION_RECORDS
        self.mutationRecordManager = MutationRecordManager()
        #endif
        
        self.ranges = [DOMRange]()
        self.documentCSSStyleSheets = DocumentStyleSheetCollection()
        
        super.init(document: nil, sourceStringFragment: nil)
        
        // FIXME : finish this initialiser
        self.implementation = DOMImplementation(self)
        self.nodeName = "#document"
        self.nodeType = NodeType.document_node
        self.document = self
    }
    
    /// Function that returns the smallest node that 
    /// contains the index.
    open func node(at index: Int) -> Node? {
        
        var node: Node? = documentElement
        
        while let _node = node {
        
            if let containingChild = child(of: _node, containing: index) {
                
                node = containingChild
            }
            else {
                
                return _node
            }
        }
        return nil
    }
    
    open func elementContaining(index: Int) -> Element? {
        
        var element: Element? = documentElement
        
        while let _element = element {
            
            if let containingChild = elementChild(of: _element, containing: index) {
                
                element = containingChild
            }
            else {
                
                return _element
            }
        }
        return nil
    }
    
    open func elementContainingOrEnding(index: Int) -> Element? {
        
        var element: Element? = documentElement
        
        while let _element = element {
            
            if let containingChild = elementChild(of: _element, containingOrEnding: index) {
                
                element = containingChild
            }
            else {
                
                return _element
            }
        }
        return nil
    }

    private func elementChild(of element: Element, containingOrEnding index: Int) -> Element? {
        
        let array = element.children.elements
            
        if let index = array.elementIndex(containingOrEnding: index) {
            
            return array[index]
        }
        return nil
    }
    
    private func elementChild(of element: Element, containing index: Int) -> Element? {
        
        let array = element.children.elements
        
        if let index = array.elementIndex(containing: index) {
            
            return array[index]
        }
        return nil
    }
    
    private func child(of node: Node, containing index: Int) -> Node? {
        
        if let childs = node.childNodes {
            
            let array = childs.asArray()
            
            if let index = array.elementIndex(containing: NSMakeRange(index, 0)) {
                
                return array[index]
            }
        }
        return nil
    }
    
    /// Return the [list of elements with local name localName]
    /// (https://dom.spec.whatwg.org/#concept-getelementsbytagname ) for the context object.
    ///
    /// Note : Thus, in an HTML document, document.getElementsByTagName("FOO") will match FOO elements 
    /// that are not in the HTML namespace, and foo elements that are in the HTML namespace, 
    /// but not FOO elements that are in the HTML namespace.
    ///
    /// HTMLCollection getElementsByTagName(DOMString localName);
    /// see
    open func getElementsByTagName(_ localName: DOMString, inclusive: Bool = false) -> HTMLCollection {
        
        // FIXME: we need to consider the Html case eventually.
        let filter = LocalnameElementNodeFilter(htmlDocument: false, localname: localName)
        
        return HTMLCollection(root: documentElement!, filter: filter, inclusive: inclusive)
    }
    
    /// return the [list of elements with namespace namespace and local name localName]
    /// (https://dom.spec.whatwg.org/#concept-getelementsbytagnamens) for the context object
    ///
    /// If namespace and localName are "*" returns a HTMLCollection of all descendant elements.
    /// If only namespace is "*" returns a HTMLCollection of all descendant elements whose local name is localName.
    /// If only localName is "*" returns a HTMLCollection of all descendant elements whose namespace is namespace.
    /// Otherwise, returns a HTMLCollection of all descendant elements whose namespace is namespace and local name is localName.
    ///
    /// HTMLCollection getElementsByTagNameNS(DOMString? namespace, DOMString localName);
    /// see https://dom.spec.whatwg.org/#dom-document-getelementsbytagnamens
    func getElementsByTagNameNS(_ namespace: DOMString, localName: DOMString) -> HTMLCollection {

        return listElementsWithLocalnameAndNamespace(localName, namespace: namespace)
    }
    
    /// Return the [list of elements with class names classNames]
    /// (https://dom.spec.whatwg.org/#concept-getelementsbyclassname) for the context object.
    /// HTMLCollection getElementsByClassName(DOMString classNames);
    /// see https://dom.spec.whatwg.org/#dom-document-getelementsbyclassname
    open func getElementsByClassName(_ classNames: DOMString) -> HTMLCollection {

        return listElementsWithClassnames(classNames)
    }
    
    /// Returns an element in the HTML namespace with localName as local name. (In an HTML document localName is lowercased.)
    /// If localName does not match the Name production an InvalidCharacterError exception will be thrown.
    ///
    /// [NewObject] Element createElement(DOMString localName);
    /// see https://dom.spec.whatwg.org/#dom-document-createelement
    func createElement(_ localName: DOMString, exception: inout Exception) -> Element? {

        // 1. If localName does not match the [Name](http://www.w3.org/TR/xml/#NT-Name )
        // production, throw an InvalidCharacterError exception.
        if !XMLValidator.validateNameProduction(localName) {
            
            exception.code = ExceptionCode.invalidCharacterError
            return nil
        }
        
        // 2. If the context object is an HTML document, let localName be converted to ASCII lowercase.
        // In our case, we condidere always being in an HTML document. We don't car about XML.
        let localname = localName.lowercased()
    
        // 3. Let interface be the element interface for localName and the HTML namespace.
        
        // 4. Return a new element that implements interface, with no attributes, 
        // namespace set to the HTML namespace, local name set to localName, 
        // and node document set to the context object.
        let element = Element(document: self, localName: localname)
        
        element.namespaceURI = §Namespace.HTML
        
        return element
    }
    
    /// Returns an element with namespace namespace. 
    /// Its namespace prefix will be everything before ":" (U+003E) in qualifiedName or null. 
    /// Its local name will be everything after ":" (U+003E) in qualifiedName or qualifiedName.
    ///
    /// [NewObject] Element createElementNS(DOMString? namespace, DOMString qualifiedName);
    /// see https://dom.spec.whatwg.org/#dom-document-createelementns
    func createElementNS(_ namespace: DOMString , qualifiedName: DOMString, exception: inout Exception) -> Element? {
        
        // 1. Let namespace, prefix, localName, and qualifiedName be the result of 
        // passing namespace and qualifiedName to validate and extract. Rethrow any exceptions.
        let result = Namespace.validateAndExtract(namespace, qualifiedName: qualifiedName, exception: &exception)
        
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return nil
        }
        
        if let result = result {
            
            let namespace = result.namespace
            let prefix = result.prefix
            let localname = result.localName
            
            // 2. Let interface be the element interface for localName and namespace
            let element = Element(document: self, localName: localname)
            element.namespaceURI = namespace
            element.prefix = prefix
            return element
        }
        return nil
    }
    
    /// Returns a DocumentFragment node.
    /// [NewObject] DocumentFragment createDocumentFragment();
    /// see https://dom.spec.whatwg.org/#dom-document-createdocumentfragment
    func createDocumentFragment() -> DocumentFragment {
        
        return DocumentFragment(document: self)
    }
    
    /// Returns a Text node whose data is data.
    /// [NewObject] Text createTextNode(DOMString data);
    /// see https://dom.spec.whatwg.org/#dom-document-createtextnode
    func createTextNode(_ data: DOMString) -> Text {

        return Text(document: self, data: data)
    }
    
    /// Returns a Comment node whose data is data.
    /// [NewObject] Comment createComment(DOMString data);
    /// see https://dom.spec.whatwg.org/#dom-document-createcomment
    func createComment(_ data: DOMString) -> Comment {
        
        return Comment(document: self, data: data)
    }
    
    /// Returns a ProcessingInstruction node whose target is target and data is data.
    /// [NewObject] ProcessingInstruction createProcessingInstruction(DOMString target, DOMString data);
    /// see https://dom.spec.whatwg.org/#dom-document-createprocessinginstruction
    func createProcessingInstruction(_ target: DOMString, data: DOMString, exception: inout Exception) -> ProcessingInstruction? {

        // 1. If target does not match the Name production, throw an InvalidCharacterError exception.
        if !XMLValidator.validateNameProduction(target) {
            
            exception.code = ExceptionCode.invalidCharacterError
            return nil
        }
        
        // 2. If data contains the string "?>", throw an InvalidCharacterError exception.
        if let _ = data.range(of: "?>", options: NSString.CompareOptions(), range: nil, locale: nil) {
            
            // 3. Return a new ProcessingInstruction node, with target set to target, data set to data,
            // and node document set to the context object.
            return ProcessingInstruction(document: self, data: data, target: target)
        }
        exception.code = ExceptionCode.invalidCharacterError
        return nil
    }
    
    /// Returns a copy of node. If deep is true, the copy also includes the node's descendants.
    /// Node importNode(Node node, optional boolean deep = false);
    /// see https://dom.spec.whatwg.org/#dom-document-importnode
    func importNode(_ node: Node, deep: Bool, exception: inout Exception) -> Node? {

        // 1. If node is a document, throw a NotSupportedError exception.
        if node.nodeType == NodeType.document_node {
            
            exception.code = ExceptionCode.notSupportedError
            return nil
        }
        
        // 2. Return a clone of node, with context object and the clone 
        // children flag set if deep is true.
        return node.cloneNode(deep)
    }
    
    /// Moves node from another document and returns it.
    /// If node is a document throws a NotSupportedError exception.
    ///
    /// Node adoptNode(Node node);
    ///
    /// see https://dom.spec.whatwg.org/#dom-document-adoptnode
    func adoptNode(_ node: Node, exception: inout Exception) -> Node? {
        
        // the later is not really possible but we may 
        // have  made an error in the programming so we
        // keep it as protection
        if node.nodeType == NodeType.document_node {
            
            exception.code = ExceptionCode.notSupportedError
            return nil
        }
        
        adopt(node, exception: &exception)
        
        return node
    }
    
    /// Return an attribute with localname lacolaname.
    ///
    /// Note: This method does not have its input converted to ASCII lowercase.
    ///
    /// [NewObject] Attr createAttribute(DOMString localName);
    /// see https://dom.spec.whatwg.org/#dom-document-createattribute
    func createAttribute(_ localName: DOMString, exception: inout Exception) -> Attr? {

        // 1. If localName does not match the Name production in XML, 
        // throw an InvalidCharacterError exception.
        if !XMLValidator.validateNameProduction(localName) {
            
            exception.code = ExceptionCode.invalidCharacterError
            return nil
        }
        
        // 2. Return a new attribute whose local name is localName.
        return Attr(localName: localName)
    }
    
    ///
    /// [NewObject] Attr createAttributeNS(DOMString? namespace, DOMString name);
    /// see https://dom.spec.whatwg.org/#dom-document-createattributens
    func createAttributeNS(_ namespace: DOMString, name: DOMString, exception: inout Exception) -> Attr? {

        // 1. Let namespace, prefix, localName, and name be the result of passing namespace 
        // and name to validate and extract. Rethrow any exceptions.
        let result = Namespace.validateAndExtract(namespace, qualifiedName: name, exception: &exception)
        
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return nil
        }
        
        if let result = result {
        
            let namespace = result.namespace
            let prefix = result.prefix
            let localname = result.localName
            let qualifiedName = result.qualifiedName
            
            // 2. Return a new attribute whose namespace is namespace, namespace prefix is prefix,
            // local name is localName, and name is name.
            var attr = Attr(localName: localname, name: qualifiedName)
            attr.prefix = prefix
            attr.namespaceURI = namespace
            
            return attr
        }
        
        return nil
    }
    
    /// Create event is not supported yet.
    /// [NewObject] Event createEvent(DOMString interface);
    /// TODO: Events are not supported yet.
    /// see https://dom.spec.whatwg.org/#dom-document-createevent
    func createEvent(_ interface: DOMString) -> Event {

        fatalError("Missing implementation")
    }
    
    /// Create and return a Range.
    /// [NewObject] Range createRange();
    /// see https://dom.spec.whatwg.org/#dom-document-createrange
    func createRange() -> DOMRange {

        // This constructor is equivalent to Range()
        // I prefer to pass reference directly a reference to the document 
        // instead of creating a global way to access this document...
        
        let range = DOMRange(document: self)
        
        ranges.append(range)
        
        return range
    }
    
    /// NodeFilter.SHOW_ALL = 0xFFFFFFFF
    /// [NewObject] NodeIterator createNodeIterator(Node root, optional unsigned long whatToShow = 0xFFFFFFFF, 
    /// optional NodeFilter? filter = null);
    ///
    /// see https://dom.spec.whatwg.org/#dom-document-createnodeiterator
    func createNodeIterator(_ root: Node, whatToShow: UInt64, filter: NodeFilter) -> NodeIterator? {

        if let _whatToShow = WhatToShow(rawValue: whatToShow) {
            
            // 1. Create a NodeIterator object.
            
            // All the following is done in the constructor init method of the NodeIterator
            //
            // 2. Set root and initialize the referenceNode attribute to the root argument.
            // 3. Initialize the pointerBeforeReferenceNode attribute to true.
            // 4. Set whatToShow to the whatToShow argument.
            // 5. Set filter to filter.
            let nodeIterator = NodeIterator(root: root, whatToShow: _whatToShow, filter: filter)
            
            return nodeIterator
        }
        else {
            assert(false, "whatToShow value is not supported.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("whatToShow value is not supported.", log: Log.Web.all, type: .error)
            #endif
        }
        return nil
    }
    
    /// Create and return a TreeWalker.
    /// [NewObject] TreeWalker createTreeWalker(Node root, optional unsigned long whatToShow = 0xFFFFFFFF, 
    /// optional NodeFilter? filter = null);
    ///
    /// see https://dom.spec.whatwg.org/#dom-document-createtreewalker
    func createTreeWalker(_ root: Node , whatToShow: UInt64, filter: NodeFilter) -> TreeWalker? {

        if let _whatToShow = WhatToShow(rawValue: whatToShow) {
        
            // 1. Create a TreeWalker object.
            // 2. Set root and initialize the currentNode attribute to the root argument.
            // 3. Set whatToShow to the whatToShow argument.
            // 4. Set filter to filter.
            let treeWalker = TreeWalker(root: root, whatToShow: _whatToShow, filter: filter)
            
            // 5. Return the newly created TreeWalker object.
            return treeWalker
        }
        else {
            assert(false, "whatToShow value is not supported.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("whatToShow value is not supported.", log: Log.Web.all, type: .error)
            #endif
        }
        return nil
    }
    
    /// see https://dom.spec.whatwg.org/#concept-node-adopt
    func adopt(_ node: Node, exception: inout Exception) {
        
        // 1. Let oldDocument be node's node document.
        let oldDocument = node.document
        
        // 2. If node's parent is not null, remove node from its parent.
        if let parentNode = node.parentNode {
            
            // parentNode of node is not nil
            // @see https://dom.spec.whatwg.org/#concept-node-remove
            parentNode.remove(node, exception: &exception)
            
            if exception.isError() {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
                #endif
                return
            }
        }
        
        if let documentFragment = node as? DocumentFragment {
            
            let descendants = documentFragment.descendants()
            for descendant in descendants {
                descendant.document = self
            }
        }
        
        // 3. Set node's inclusive descendants's node document to document.
        else if let containerNode = node as? ContainerNode {
            
            let inclusiveDescendants = containerNode.inclusiveDescendants()
        
            for inclusiveDescendant in inclusiveDescendants {
            
                inclusiveDescendant.document = self
            }
        }
        
        // Run any adopting steps defined for node in other applicable specifications 
        // and pass node and oldDocument as parameters.
        // TODO:
    }
    
    /// Locate a namespace : default implementation
    /// see https://dom.spec.whatwg.org/#locate-a-namespace
    /// Overidden by Element, Document, DocumentType and DocumentFragment
    override func locateNamespace(_ prefix: DOMString?) -> DOMString? {
        
        if let documentElement = self.documentElement {
            
            // Return the result of running locate a namespace on its 
            // document element using prefix.
            return documentElement.locateNamespace(prefix)
        }
        
        // If its document element is null, return null.
        return nil
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = Document
    
    // Its encoding, content type, URL, its mode (quirks mode, limited quirks mode, or no-quirks mode), 
    // and its type (XML document or HTML document).
    // see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout Document) {
        
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
        
        // [SameObject] readonly attribute DOMImplementation implementation;
        if let implementation = self.implementation {
            copy.implementation = implementation
        }

        // internal(set) var URL: DOMString
        copy.URL = self.URL
        
        // internal(set) var documentURI: DOMString
        copy.documentURI = self.documentURI
        
        // internal(set) var origin: DOMString
        copy.origin = self.origin
        
        // internal(set) var compatMode: DOMString
        copy.compatMode = self.compatMode

        // internal(set) var characterSet: DOMString
        copy.characterSet = self.characterSet

        // internal(set) var inputEncoding: DOMString
        copy.inputEncoding = self.inputEncoding

        // internal(set) var contentType: DOMString
        copy.contentType = self.contentType
        
        // Variable containing all the ranges associated with this
        // document.
        for range in self.ranges {
            
            var exception = Exception()
            exception.code = ExceptionCode.noError
            
            if let clone = range.cloneRange(&exception) {
            
                copy.ranges.append(clone)
            }
            else {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Error cloning range.", log: Log.Web.all, type: .error)
                #endif
            }
        }
    }
    
    override open func createInstance() -> Document {
        
        let instance = Document()
        
        // If copy is a document, set its node document and document to copy.
        instance.document = instance
        
        return instance
    }
    
    open override func cloneNode(_ deep: Bool = false) -> Document {
        
        // The super.cloneNode() function is supposed to call
        // our implementations of cloneFields and createInstance.
        return super.cloneNode(deep) as! Document
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: DocumentStyle protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// [SameObject] readonly attribute StyleSheetList styleSheets;
    /// see http://dev.w3.org/csswg/cssom/#dom-document-stylesheets
    var styleSheets: StyleSheetList {
        
        return documentCSSStyleSheets.styleSheets
    }
    
    /// attribute DOMString? selectedStyleSheetSet;
    /// see http://dev.w3.org/csswg/cssom/#dom-document-selectedstylesheetset
    var selectedStyleSheetSet: DOMString? {
        
        get {
            // 1. If there is a single enabled CSS style sheet set and no other document CSS style sheets
            // with a title that is not the empty string have the disabled flag unset,
            // return the CSS style sheet set name of the enabled CSS style sheet set and terminate these steps.
            if let singleEnabledStyleSheetSet = documentCSSStyleSheets.singleEnableStyleSheetSet() {
                
                var otherEnabledStyleSheet: Bool = false
                
                for styleSheet in documentCSSStyleSheets.styleSheets {
                    
                    if !singleEnabledStyleSheetSet.isStyleSheetInSet(styleSheet) {
                        
                        if let title = styleSheet.title , !title.isEmpty {
                            
                            if !styleSheet.disabled {
                                
                                otherEnabledStyleSheet = true
                            }
                        }
                    }
                }
                
                if !otherEnabledStyleSheet {
                    
                    return singleEnabledStyleSheetSet.name
                }
            }
            
            // 2. Otherwise, if CSS style sheets from different CSS style sheet sets have their disabled
            // flag unset, return null and terminate these steps.
            
            var styleSheetSetsWithEnabledStyleSheet = [DOMString]()
            
            for styleSheetSet in documentCSSStyleSheets.styleSheetSetsValues.values {
                
                for styleSheet in styleSheetSet {
                    
                    if !styleSheet.disabled {
                        
                        if styleSheetSetsWithEnabledStyleSheet.count > 0 {
                            
                            return nil
                        }
                        else {
                            
                            styleSheetSetsWithEnabledStyleSheet.append(styleSheetSet.name)
                            break
                        }
                    }
                }
            }
        
            // 3. Otherwise, return the empty string.
            return ""
        }
        set(newValue) {
            
            // 1. If the value is null terminate this set of steps.
            if let newValue = newValue {
            
                // 2. Otherwise, select a CSS style sheet set with the name being the value passed.
                documentCSSStyleSheets.selectStyleSheetSetWithName(newValue)
            }
        }
    }
    
    /// readonly attribute DOMString? lastStyleSheetSet;
    /// see http://dev.w3.org/csswg/cssom/#dom-document-laststylesheetset
    var lastStyleSheetSet: DOMString? {
        
        return documentCSSStyleSheets.lastStyleSheetSet
    }
    
    /// readonly attribute DOMString? preferredStyleSheetSet;
    /// see http://dev.w3.org/csswg/cssom/#dom-document-preferredstylesheetset
    var preferredStyleSheetSet: DOMString? {
        
        return documentCSSStyleSheets.preferredStyleSheetSet
    }
    
    /// readonly attribute DOMString[] styleSheetSets;
    /// see http://dev.w3.org/csswg/cssom/#dom-document-stylesheetsets
    var styleSheetSets: [DOMString] {
        
        // The styleSheetSets attribute must return a read only array of the CSS style sheet set names 
        // of the CSS style sheet sets, in order of the document CSS style sheets. 
        // The array is live; if the document CSS style sheets change, 
        // the array must be updated as appropriate.
        
        // TODO: since there is an implementation to be done to create a suitable
        // "live" array I pospond this development.
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("styleSheetSets missing implementation.", log: Log.Web.all, type: .error)
        #endif
        return []
    }
    
    /// void enableStyleSheetsForSet(DOMString? name);
    /// see http://dev.w3.org/csswg/cssom/#dom-document-enablestylesheetsforset
    func enableStyleSheetsForSet(_ name: DOMString?) {
        
        documentCSSStyleSheets.enableStyleSheetsForSet(name)
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? Document {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if URL != other.URL {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: URL are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if documentURI != other.documentURI {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: documentURI are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if origin != other.origin {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: origin are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if compatMode != other.compatMode {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: compatMode are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if characterSet != other.characterSet {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: characterSet are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if contentType != other.contentType {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: contentType are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not Document.", log: Log.Web.all, type: .debug)
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
    /// https://dom.spec.whatwg.org/#dom-node-isequalnode
    override func isEqualNode(_ other: Node?) -> Bool {
        
        if !super.isEqualNode(other) {
            return false
        }

        if let otherDocument = other as? Document {
        
            if URL != otherDocument.URL {
                
                return false
            }
            
            if documentURI != otherDocument.documentURI {
                
                return false
            }
            
            if origin != otherDocument.origin {
                
                return false
            }
            
            if compatMode != otherDocument.compatMode {
                
                return false
            }
            
            if characterSet != otherDocument.characterSet {
                
                return false
            }
            
            if contentType != otherDocument.contentType {
                
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
//
//        h = h ^ URL.hashValue
//
//        h = h ^ documentURI.hashValue
//        
//        h = h ^ origin.hashValue
//        
//        h = h ^ compatMode.hashValue
//        
//        h = h ^ characterSet.hashValue
//        
//        h = h ^ contentType.hashValue
//        
//        return h
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func == (lhs: Document, rhs: Document) -> Bool {
    
    return lhs.isEqualNode(rhs)
}
