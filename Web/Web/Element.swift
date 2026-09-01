//
//  WebElement.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-17.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

//
//https://dom.spec.whatwg.org/#element
//interface Element : Node {
//    readonly attribute DOMString? namespaceURI;
//    readonly attribute DOMString? prefix;
//    readonly attribute DOMString localName;
//    readonly attribute DOMString tagName;
//    
//    attribute DOMString id;
//    attribute DOMString className;
//    [SameObject] readonly attribute DOMTokenList classList;
//    
//    boolean hasAttributes();
//    [SameObject] readonly attribute NamedNodeMap attributes;
//    DOMString? getAttribute(DOMString name);
//    DOMString? getAttributeNS(DOMString? namespace, DOMString localName);
//    void setAttribute(DOMString name, DOMString value);
//    void setAttributeNS(DOMString? namespace, DOMString name, DOMString value);
//    void removeAttribute(DOMString name);
//    void removeAttributeNS(DOMString? namespace, DOMString localName);
//    boolean hasAttribute(DOMString name);
//    boolean hasAttributeNS(DOMString? namespace, DOMString localName);
//    
//    Attr? getAttributeNode(DOMString name);
//    Attr? getAttributeNodeNS(DOMString? namespace, DOMString localName);
//    Attr? setAttributeNode(Attr attr);
//    Attr? setAttributeNodeNS(Attr attr);
//    Attr removeAttributeNode(Attr attr);
//    
//    Element? closest(DOMString selectors);
//    boolean matches(DOMString selectors);
//    
//    HTMLCollection getElementsByTagName(DOMString localName);
//    HTMLCollection getElementsByTagNameNS(DOMString? namespace, DOMString localName);
//    HTMLCollection getElementsByClassName(DOMString classNames);
//};

//partial interface Element {
//    [TreatNullAs=EmptyString]
//    attribute DOMString innerHTML;
//    [TreatNullAs=EmptyString]
//    attribute DOMString outerHTML;
//    void insertAdjacentHTML (DOMString position, DOMString text);
//};

//Element implements ParentNode;
open class Element: ContainerNode, CSSElementProperties, ScopingElement, PseudoElementsFragmentsContainer {
    
    /// readonly attribute DOMString? namespaceURI;
    open var namespaceURI: DOMString?
    
    /// readonly attribute DOMString? prefix;
    var prefix: DOMString?
    
    /// readonly attribute DOMString localName;
    open var localName: DOMString
    
    /// readonly attribute DOMString tagName;
    /// see https://dom.spec.whatwg.org/#dom-element-tagname
    var tagName: DOMString {
        
        // 1. If context object's namespace prefix is not null, 
        // let qualified name be its namespace prefix, followed by a ":" (U+003A), 
        // followed by its local name. 
        // Otherwise, let qualified name be its local name.
        var qualifiedName: DOMString = ""
        
        if let prefix = prefix {
            
            qualifiedName = prefix + ":" + localName
        }
        else {
            qualifiedName = localName
        }
        
        // 2. If the context object is in the HTML namespace and its node document 
        // is an HTML document, let qualified name be converted to ASCII uppercase.
        if let namespaceURI = namespaceURI {
            
            if let doctype = document.doctype
                , doctype.name == §DocumentTypeName.HTML {
            
                if namespaceURI == §Namespace.HTML {
                
                    qualifiedName = qualifiedName.uppercased()
                }
            }
        }
        // 3. Return qualified name.
        return qualifiedName
    }
    
    /// Property that refers to the :root document element
    /// which is the HTMLHtmlElement in HTML case
    /// and CSSDOMStyleSheetElement is CSS case.
    public var isRoot: Bool {
        return false
    }
    
    /// attribute DOMString id;
    /// FIXME: make sure id can be optional
    public var id: DOMString? {
        
        get {
            return getAttribute("id")
        }
        set {
            if let newValue = newValue {
                setAttributeValue("id", value: newValue)
            }
        }
    }
    
    /// attribute DOMString className;
    /// FIXME: make sure className can be optional
    var className: DOMString?
    
    
    /// The DOMTokenList object's associated attribute's local name is class and 
    //// its associated ordered set of tokens is called the element's classes.
    /// see https://dom.spec.whatwg.org/#concept-class
    var classes: DOMTokenList!
    
    /// The classList attribute must return the associated DOMTokenList object 
    /// representing the context object's classes.
    /// [SameObject] readonly attribute DOMTokenList classList;
    /// see https://dom.spec.whatwg.org/#dom-element-classlist
    open var classList: DOMTokenList {
        
        return classes
    }
    
    public var hasAttributesOrClasses: Bool {
        
        return self.hasAttributesOtherThanNwElementId || !self.classes.isEmpty
    }
    
    public var hasAttributesOtherThanNwElementId: Bool {
        
        if !self.hasAttributes() {
            return false
        }
        else if attributeList.count == 1 && attributeList.first?.localName == §DomAttributeString.ElementId {
            return false
        }
        return true
    }
    
    /// The classListString attribute returns the associated DOMTokenList object
    /// converted to a coma separated list of class values.
    public var classListString: String {
        
        var _classListString = ""
        
        let sortedClassList = classList.sorted { (class1, class2) -> Bool in
            return class1 < class2
        }
        
        for _class in sortedClassList {
            _classListString += " " + _class
        }
        return _classListString.isEmpty ? "" : _classListString
    }
    
    /// [SameObject] readonly attribute NamedNodeMap attributes;
    /// see https://dom.spec.whatwg.org/#namednodemap
    var attributes: NameNodeMap
    
    /// Elements also have an ordered attribute list exposed through a NamedNodeMap. 
    /// Unless explicitly given when an element is created, its attribute list is empty. 
    /// An element has an attribute A if A is in its attribute list.
    /// see https://dom.spec.whatwg.org/#concept-element-attribute
    open internal(set) var attributeList: [Attr]
    
    /// The classListString attribute returns the associated DOMTokenList object
    /// converted to a coma separated list of class values.
    public var attributesListString: String {
        
        var attributesListString = ""
        
        let sortedAttributes = self.attributeList.sorted { (attr1, attr2) -> Bool in
            return attr1.localName < attr2.localName
        }
        
        for attribute in sortedAttributes {
            
            // since class is included in the attributes list we should
            // ignore it if we see it.
            if attribute.localName == §DomAttributeString.Class {
                continue
            }
            
            if !attributesListString.isEmpty {
                attributesListString += ","
            }
            
            attributesListString += "\"" + attribute.localName
            if let namespaceURI = attribute.namespaceURI {
                attributesListString += "@" + namespaceURI
            }
            
            attributesListString += "=" + attribute.value + "\""
        }
        return attributesListString
    }
    
    /// Return the next sibling element ignoring all Node that are not 
    /// of type Element.
    /// Mainly used in the next sibling selector (+)
    /// see http://dev.w3.org/csswg/selectors/#adjacent-sibling-combinators
    open var nextSiblingElement: Element? {
    
        var nextSiblingNode: Node? = nextSibling
        
        while let _nextSiblingNode = nextSiblingNode {
        
            if let nextSiblingElement = _nextSiblingNode as? Element {
                
                return nextSiblingElement
            }
            nextSiblingNode = _nextSiblingNode.nextSibling
        }
        return nil
    }
    
    /// Return the previous sibling element ignoring all Nodes that are
    /// not of type Element. 
    /// Mainly used for the next sibling selector (+)
    open var previousSiblingElement: Element? {
        
        var previousSiblingNode: Node? = previousSibling
        
        while let _previousSiblingNode = previousSiblingNode {
            
            if let previousSiblingElement = _previousSiblingNode as? Element {
                
                return previousSiblingElement
            }
            previousSiblingNode = _previousSiblingNode.previousSibling
        }
        return nil
    }
    
    /// Return all previous siblings elements ignoring all Nodes that are
    /// not of type Element.
    /// Mainly used for the next sibling selector (+) in the reverse 
    /// evaluation mode.
    internal var previousSiblingsElements: [Element] {
        
        var previousSiblingsElements = [Element]()
        var previousSiblingNode: Node? = previousSibling

        while let _previousSiblingNode = previousSiblingNode {

            if let previousSiblingElement = _previousSiblingNode as? Element {

                previousSiblingsElements.append(previousSiblingElement)
            }
            previousSiblingNode = _previousSiblingNode.previousSibling
        }
        return previousSiblingsElements
    }
    
    /// Return all following siblings elements ignoring all Node 
    /// node that are not of type Element.
    /// Mainly used in the General sibling combinator (~)
    /// see http://dev.w3.org/csswg/selectors/#general-sibling-combinators
    open var followingSiblingsElements: [Element] {
        
        var nextSiblingsElements = [Element]()
        var nextSiblingNode: Node? = nextSibling
        
        while let _nextSiblingNode = nextSiblingNode {
            
            if let nextSiblingElement = _nextSiblingNode as? Element {
                
                nextSiblingsElements.append(nextSiblingElement)
            }
            nextSiblingNode = _nextSiblingNode.nextSibling
        }
        return nextSiblingsElements
    }
    
    /// Return all descendants of the context object that are of type 
    /// Element. 
    open var descendantElements: HTMLCollection {
        
        let filter = AllElementNodeFilter()
        return HTMLCollection(root: self, filter: filter, inclusive: false)
    }
    
    
    ///
    /// Property that returns the ancestors of the element
    /// ordered from bottom to top resulting in the array.
    ///
    public var ascendantsElements: [Element] {
        
        var elements: [Element] = []
        var parent: Element? = self.parentElement
        while let _parent = parent {
            elements.append(_parent)
            parent = _parent.parentElement
        }
        return elements
    }
    
    ///
    /// Property that returns the ancestors of the element
    /// plus the element itself, orderer from top to bottom
    /// in the array.
    ///
    ///
    public var inclusiveAncestorsElements: [Element] {
        
        return ascendantsElements.reversed() + [self]
    }
    
    /// The root element of an element is the document element of
    /// the associated document.
    /// see http://dev.w3.org/csswg/selectors/#match-against-element
    var rootElement: Element {
        
        // rootDocumentElement is different depending on the type of 
        // Document : Document or MirroredDocument.
        return self.document.rootDocumentElement
    }
    
    /// Associated PseudoElements are ordered by their tag String (localName) 
    /// and are created at creation time by the MarkdownDomRenderer. They
    /// contain the information for Markdown related pseudo elements not the
    /// pseudo elements created when style is evaluated. Those are kept in
    /// the ResourceComputedStyle itself.
    public private(set) var markdownAssociatedPseudoElements: [String: SourceStringFragment]
    
    open var inheritingElement: Element? {
        
        return parentElement
    }
    
    public convenience init(document: Document?, localName: DOMString) {
     
        self.init(fragment: nil, document: document, localName: localName)
    }
    
    static var elementsCounter: UInt64 = 0
    
    /// Elements have an associated namespace, namespace prefix, and local name.
    /// When an element is created, its local name is always given.
    /// Unless explicitly given when an element is created,
    /// its namespace and namespace prefix are null.
    /// see https://dom.spec.whatwg.org/#element
    public init(fragment: SourceStringFragment?, document: Document?, localName: DOMString) {
        self.localName = localName
        self.attributes = NameNodeMap()
        self.attributeList = [Attr(localName: §DomAttributeString.ElementId, value: String(Element.elementsCounter))]
        
        self.markdownAssociatedPseudoElements = [String: SourceStringFragment]()
        super.init(document: document, sourceStringFragment: fragment)
        self.nodeType = NodeType.element_node
        self.attributes.element = self
        self.classes = DOMTokenList(element: self, attributeLocalName: "class")
        
        // add the nw-element-id attribute
        Element.elementsCounter += 1
    }
    
    public func whitespacesExtendedIntersectionRange(_ range: NSRange, inString string: String) -> NSRange? {
        
        guard let elementRange = self.range else {
            return nil
        }
        
        // remove the last line feeds from the range
        var finalLineFeedsTrimmedRange = elementRange
        
        while let lastChar = string.charAt(finalLineFeedsTrimmedRange.upperBound-1), lastChar == §UnicodeCharacter.lineFeed {
            finalLineFeedsTrimmedRange = NSMakeRange(finalLineFeedsTrimmedRange.location, finalLineFeedsTrimmedRange.length-1)
        }
        
        if finalLineFeedsTrimmedRange.lowerBound <= range.lowerBound {
            
            let whitespacesExtendedElementRange = string.extendsWithLastSpaces(finalLineFeedsTrimmedRange)
            
            if range.upperBound == whitespacesExtendedElementRange.upperBound, range.upperBound > 0 {
                // if the last charactet is a line feed we are technically outside the element
                if let lastChar = string.charAt(range.upperBound-1), lastChar == §UnicodeCharacter.lineFeed {
                    return nil
                }
                return whitespacesExtendedElementRange
            }
            else if range.upperBound < whitespacesExtendedElementRange.upperBound {
                return whitespacesExtendedElementRange
            }
        }
        return nil
    }
    
    ///
    /// Method that returns true if the current element
    /// range intersects the range parameter.
    ///
    public func intersectsRange(_ range: NSRange) -> Bool {
        
        guard let elementRange = self.range else {
            assertionFailure("Error: self.range is nil")
            return false
        }
        
        return min(range.upperBound, elementRange.upperBound) >= max(range.lowerBound, elementRange.lowerBound)
    }

    ///
    /// Method that returns true if the current element
    /// range intersects the range parameter.
    ///
    public func isContained(in range: NSRange) -> Bool {
        
        guard let elementRange = self.range else {
            if !(self is HTMLBRElement) {
                assertionFailure("Error: self.range is nil")
            }
            return false
        }
        
        return elementRange.lowerBound >= range.lowerBound && elementRange.upperBound <= range.upperBound
    }
    
    /// This method assumes there is no element at location
    /// so that there can be an element before and one after
    public func elements(beforeAndAfter location: Int) -> (Element?, Element?)? {
        
        let array = children.elements
        
        let indexBefore = array.nonIncludingIndex(before: NSMakeRange(location, 0))
        
        if indexBefore >= 0 {
        
            let before = array[indexBefore]
            let after = array[indexBefore+1]
            return (before, after)
        }
        else {
            
            let after = array[indexBefore+1]
            return (nil, after)
        }
    }
    
    /// Method that returns a string value of a simple
    /// selector that can be used to select this element.
    /// The sourceLocation parameter is used to know if we are
    /// in a pseudo element region.
    /// TODO: add support for pseudo elements (NW-908)
    public func selector(for sourceLocation: Int, allowedPseudo: Bool = true) -> String {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("selector for sourceLocation: %@", log: Log.Web.all, type: .debug, %%sourceLocation)
        #endif
        
        if let parentElement = parentElement {
        
            var selectorString = parentElement.selector(for: sourceLocation, allowedPseudo: false)
        
            if allowedPseudo {
                
                for (name, fragment) in markdownAssociatedPseudoElements {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("associated pseudo element: %@: %@", log: Log.Web.all, type: .debug, %%name, %%fragment)
                    #endif
                    
                    if let segment = fragment as? SourceStringSegment {
                    
                        let range = segment.range
                        
                        assert(range != nil)
                        if let range = range {
                            if range.lowerBound <= sourceLocation && sourceLocation < range.upperBound {
                                selectorString += " \(self.localName)::\(name)"
                                return selectorString
                            }
                        }
                    }
                    else if let region = fragment as? SourceStringRegion {
                     
                        for segment in region.sourceStringSegments {
                            
                            let range = segment.range
                            
                            assert(range != nil)
                            if let range = range {
                                if range.lowerBound <= sourceLocation && sourceLocation < range.upperBound {
                                    selectorString += " \(self.localName)::\(name)"
                                    return selectorString
                                }
                            }
                        }
                    }
                }
            }
            
            selectorString += " \(self.localName)"
            return selectorString
        }
        return ""
    }
    
    func resolveFirstLetterSourceStringSegment(in string: String) -> (SourceStringSegment, Element)? {
        
        if var leftMostChildElementDescendant = leftMostChildElementDescendant {
            
            if leftMostChildElementDescendant is HTMLBRElement {
                leftMostChildElementDescendant = leftMostChildElementDescendant.parentElement!
            }
            
            if let sourceStringSegment = leftMostChildElementDescendant.firstLetterSourceStringSegment(in: string) {
                return (sourceStringSegment, leftMostChildElementDescendant)
            }   
            return nil
        }
        
        if let sourceStringSegment = firstLetterSourceStringSegment(in: string) {
            
            return (sourceStringSegment, self)
        }
        return nil
    }
    
    func resolveFirstLineSourceStringSegment(in string: String) -> (SourceStringSegment, Element)? {
        
        if var leftMostChildElementDescendant = leftMostChildElementDescendant {
            
            if leftMostChildElementDescendant is HTMLBRElement {
                
                leftMostChildElementDescendant = leftMostChildElementDescendant.parentElement!
            }
            
            if let sourceStringSegment = leftMostChildElementDescendant.firstLineSourceStringSegment(in: string) {
                
                return (sourceStringSegment, leftMostChildElementDescendant)
            }
            return nil
        }
        
        if let sourceStringSegment = firstLineSourceStringSegment(in: string) {
            return (sourceStringSegment, self)
        }
        return nil
    }

    
    /// Add a class attribute value.
    open func addClassAttribute(_ classValue: DOMString) {
        
        var exception = Exception()
        
        self.classes.add([classValue], exception: &exception)
        
        if exception.isError() {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Exception while adding class value \"%@\": %@.", log: Log.Web.all, type: .error, %%classValue, %%exception.code)
            #endif
        }
        
        var clasAttribute = Attr(localName: "class")
        clasAttribute.nodeValue = classes.stringify()
        
        attributes.setNamedItem(clasAttribute, exception: &exception)
        
        if exception.isError() {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Exception while adding class value \"%@\": %@.", log: Log.Web.all, type: .error, %%classValue, %%exception.code)
            #endif
        }
    }

    /// Add a class attribute value.
    open func addClassAttributes(_ classesValue: DOMString) {
        
        let classArray = classesValue.split(separator: " ")
        for _class in classArray {
            addClassAttribute(String(_class))
        }
    }
    
    open func removeClassAttribute(_ classValue: DOMString) {
        
        var exception = Exception()
        
        self.classes.remove([classValue], exception: &exception)
        
        if self.classes.length == 0 {
            
            attributes.removeNamedItem("class", exception: &exception)
        }
        else {
            
            var clasAttribute = Attr(localName: "class")
            clasAttribute.nodeValue = classes.stringify()
            
            attributes.setNamedItem(clasAttribute, exception: &exception)
        }
        
        if exception.isError() {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Exception while adding class value : \"%@\".", log: Log.Web.all, type: .error, %%classValue)
            #endif
        }
    }
    
    /// boolean hasAttributes();
    /// see https://dom.spec.whatwg.org/#dom-element-hasattributes
    /// The hasAttributes() method, when invoked, must return false if 
    /// context object's attribute list is empty, and true otherwise.
    open func hasAttributes() -> Bool {
        
        if attributeList.count != 0 {
            return true
        }
        return false
    }
    
    /// DOMString? getAttribute(DOMString name);
    /// see https://dom.spec.whatwg.org/#dom-element-getattribute
    /// The getAttribute(name) method must run these steps
    open func getAttribute(_ name: DOMString) -> DOMString? {
        
        // 1. Let attr be the result of getting an attribute given name and the context object.
        let attr = getAttributeByName(name)
        
        // 3. Return attr's value.
        if let attr = attr {
            
            return attr.value
        }
        // 2. If attr is null, return null.
        return nil
    }
    
    /// DOMString? getAttributeNS(DOMString? namespace, DOMString localName);
    /// see https://dom.spec.whatwg.org/#dom-element-getattributens
    open func getAttributeNS(_ namespace: DOMString?, localName: DOMString) -> DOMString? {
        
        // 1. Let attr be the result of getting an attribute given namespace, localName, 
        // and the context object.
        let attr = getAttributeByNamespaceAndLocalName(namespace, localName: localName)
        
        // 3. Return attr's value.
        if let attr = attr {
            
            return attr.value
        }
        
        // 2. If attr is null, return null.
        return nil
    }
    
    /// void setAttribute(DOMString name, DOMString value);
    /// see https://dom.spec.whatwg.org/#dom-element-setattribute
    open func setAttribute(_ name: DOMString, value: DOMString, exception: inout Exception) {
        
        // 1. If name does not match the Name production in XML, 
        // throw an InvalidCharacterError exception.
        // FIXME: Should be implemented when XML is implemented 
        // see http://www.w3.org/TR/xml/#NT-Name
        // For the time being we will only validate that it does not 
        // start with a number
        if !XMLValidator.validateNameProduction(name) {
            
            exception.code = ExceptionCode.invalidCharacterError
            return
        }
        
        // 2. Let attribute be the result of getting an attribute 
        // given name and the context object.
        let attr = getAttributeByName(name)
        
        if var attr = attr {
            
            // 4. Change attribute from context object to value.
            changeAttributeValue(&attr, value: value)
            replaceAttribute(named: name, with: attr)
        }
        // 3. If attribute is null, create an attribute whose local name is name and value is value,
        // append this attribute to the context object's attribute list, and then terminate these steps.
        else {
            var attribute = Attr(localName: name)
            attribute.value = value
            
            appendAttribute(attribute)
            
            return
        }
    }
    
    /// void setAttributeNS(DOMString? namespace, DOMString name, DOMString value);
    /// see https://dom.spec.whatwg.org/#dom-element-setattributens
    open func setAttributeNS(_ namespace: DOMString? , name: DOMString, value: DOMString, exception: inout Exception) {
        
        // 1. Let namespace, prefix, localName, and name be the result of passing namespace and 
        // name to validate and extract. Rethrow any exceptions.
        let result = Namespace.validateAndExtract(namespace, qualifiedName: name, exception: &exception)
        
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return
        }

        if let result = result {
            
            let namespace = result.namespace
            let prefix = result.prefix
            let localName = result.localName
            let name = result.qualifiedName
            
            // 2. [Set an attribute value](https://dom.spec.whatwg.org/#concept-element-attributes-set-value)
            // for the context object using localName, value, and also name, prefix, and namespace.
            setAttributeValue(localName, value: value, name: name, prefix: prefix, namespace: namespace)
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("result is nil.", log: Log.Web.all, type: .error)
            #endif
        }
    }
    
    /// Remove an attribute given name and the context object, and then return undefined
    /// void removeAttribute(DOMString name);
    /// see https://dom.spec.whatwg.org/#dom-element-removeattribute
    open func removeAttribute(_ name: DOMString) -> Attr? {
        
        // must [remove an attribute](https://dom.spec.whatwg.org/#concept-element-attributes-remove-by-name) 
        // given name.
        return removeAttributeByName(name)
    }
    
    /// [remove an attribute](https://dom.spec.whatwg.org/#concept-element-attributes-remove-by-namespace) 
    /// given namespace, localName.
    /// void removeAttributeNS(DOMString? namespace, DOMString localName);
    /// see https://dom.spec.whatwg.org/#dom-element-removeattributens
    open func removeAttributeNS(_ namespace: DOMString?, localName: DOMString) -> Attr? {
        
        // remove an attribute given namespace, localName
        return removeAttributeByNamespaceAndLocalName(namespace, localName: localName)
    }
    
    open func hasClassAttribute(_ name: DOMString) -> Bool {
        
        var exception = Exception()
        
        if let bool = classList.contains(name, exception: &exception) {
            
            return bool
            
        }

        if exception.logIfError() {
            
            return false
        }
        return false
    }
    
    /// boolean hasAttribute(DOMString name);
    /// see https://dom.spec.whatwg.org/#dom-element-hasattribute
    open func hasAttribute(_ name: DOMString) -> Bool {
        
        // 1. If the context object is in the HTML namespace and its node document is an HTML document, 
        // let name be converted to ASCII lowercase.
        var _name: DOMString = name
        
        if let namespaceURI = namespaceURI {
            
            if namespaceURI == §Namespace.HTML {
                
                _name = name.lowercased()
            }
        }
        
        // 2. Return true if the context object has an attribute whose name is name, 
        // and false otherwise.
        for attribute in attributeList {
            
            if attribute.name == _name {
                return true
            }
        }
        return false
    }
    
    /// boolean hasAttributeNS(DOMString? namespace, DOMString localName);
    /// see https://dom.spec.whatwg.org/#dom-element-hasattributens
    open func hasAttributeNS(_ namespace: DOMString?, localName: DOMString) -> Bool {
        
        // 1. If namespace is the empty string, set it to null.
        // Note: implicitly done
        
        // 2. Return true if the context object has an attribute whose namespace is namespace 
        // and local name is localName, and false otherwise.
        for attribute in attributeList {
            
            if attribute.name == localName {
                
                if let namespace = namespace {
                    if namespace == attribute.namespaceURI {
                        return true
                    }
                }
                else {
                    return true
                }
            }
        }
        return false
    }
    
    /// Return the result of 
    /// [getting an attribute](https://dom.spec.whatwg.org/#concept-element-attributes-get-by-name) 
    /// given name.
    /// Attr? getAttributeNode(DOMString name);
    /// see https://dom.spec.whatwg.org/#dom-element-getattributenode
    open func getAttributeNode(_ name: DOMString) -> Attr? {
        
        return getAttributeByName(name)
    }
    
    /// Return the result of 
    /// [getting an attribute](https://dom.spec.whatwg.org/#concept-element-attributes-get-by-namespace) 
    /// given namespace, localName.
    /// Attr? getAttributeNodeNS(DOMString? namespace, DOMString localName);
    /// see https://dom.spec.whatwg.org/#dom-element-getattributenodens
    open func getAttributeNodeNS(_ namespace: DOMString?, localName: DOMString) -> Attr? {
    
        // Return the result of
        // [getting an attribute](https://dom.spec.whatwg.org/#concept-element-attributes-get-by-namespace)
        return getAttributeByNamespaceAndLocalName(namespace, localName: localName)
    }
    
    /// Return the result of [setting an attribute] 
    /// (https://dom.spec.whatwg.org/#concept-element-attributes-set )
    /// given attr.
    ///
    /// Attr? setAttributeNode(Attr attr);
    ///
    /// see https://dom.spec.whatwg.org/#dom-element-setattributenode
    open func setAttributeNode(_ attr: Attr, exception: inout Exception) -> Attr? {
    
        return setAttribute(attr, exception: &exception)
    }
    
    /// Return the result of 
    /// [setting an attribute](https://dom.spec.whatwg.org/#concept-element-attributes-set ) given attr, 
    /// and namespace and local name flag set.
    ///
    /// Attr? setAttributeNodeNS(Attr attr);
    ///
    /// see https://dom.spec.whatwg.org/#dom-element-setattributenodens
    open func setAttributeNodeNS(_ attr: Attr, exception: inout Exception) -> Attr? {
        
        return setAttribute(attr, namespaceAndlocalnameFlag: true, exception: &exception)
    }
    
    /// Remove an attribute from attribute list.
    /// Attr removeAttributeNode(Attr attr);
    /// see https://dom.spec.whatwg.org/#dom-element-removeattributenode
    open func removeAttributeNode(_ attr: inout Attr, exception: inout Exception) -> Attr? {
        
        // 1. If attr is not in context object's attribute list, 
        // throw a NotFoundError exception.
        if !hasAttribute(attr) {
            
            exception.code = ExceptionCode.notFoundError
            return nil
        }
        
        // 2. [Remove](https://dom.spec.whatwg.org/#concept-element-attributes-remove) 
        // attr from context object.
        removeAttribute(&attr)
        
        // 3. Return attr.
        return attr
    }
    
    /// Returns the first (starting at element) inclusive ancestor that matches selectors, 
    /// and null otherwise.
    /// Element? closest(DOMString selectors);
    /// see https://dom.spec.whatwg.org/#dom-element-closestselectors
    open func closest(_ selectors: DOMString, exception: inout Exception) -> Element? {
        
        // 1. Let s be the result of parse a selector from selectors.
        let selectorsModule = CSSSelectorsModule.shared
        
        let selectorList = selectorsModule.parse(selectors as NSString )
        
        // 2. If s is failure, throw a SyntaxError.
        if let selectorList = selectorList, selectorList.hasErrors() {
            
            exception.code = ExceptionCode.syntaxError
            return nil
        }
        
        // At this point we know selector list won't be null (since we have not returned with
        // an exception above) but the "above" code may change so we want to prevent
        // any errors.
        if let selectorList = selectorList {
        
            // 3. Let elements be context object's inclusive ancestors that are elements,
            // in reverse tree order.
            let elementInclusiveAncestors = Array(inclusiveAncestors().reversed())
        
            var elements = [Element]()
        
            for node in elementInclusiveAncestors {
         
                if node.nodeType == NodeType.element_node {
                    
                    if let element = node as? Element {
                    
                        elements.append(element)
                    }
                    else {
                        assert(false, "node with node type = element node is not node.")
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("node with node type = element node is not node.", log: Log.Web.all, type: .error)
                        #endif
                        return nil
                    }
                }
            }
        
            // 4. For each element in elements, if match a selector against an element,
            // using s, element, and :scope element context object, returns success, return element.
//            var scope = [Element]()
//            scope.append(self)
        
            for element in elements {
            
                if selectorsModule.match(selectorList, against: element, scopeElements: [self]) {
                
                    return element
                }
            }
        }
        else {
            // It is nil, we still have an error but we we have stoped
            // parsing for a reason
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("CSSSelectorsModule returned nil selectorList.", log: Log.Web.all, type: .error)
            #endif
            
            exception.code = ExceptionCode.syntaxError
            return nil
        }
        
        // 5. Return null.
        return nil
    }
    
    /// Returns true if matching selectors against element's root yields element, 
    /// and false otherwise.
    /// boolean matches(DOMString selectors);
    /// see https://dom.spec.whatwg.org/#dom-element-matchesselectors
    open func matches(_ selectors: DOMString, exception: inout Exception) -> Bool? {
        
        // 1. Let s be the result of parse a selector from selectors. [SELECTORS]
        // 1. Let s be the result of parse a selector from selectors.
        let selectorsModule = CSSSelectorsModule.shared
        
        let selectorList = selectorsModule.parse(selectors as NSString )
        
        // 2. If s is failure, throw a SyntaxError.
        if let selectorList = selectorList, selectorList.hasErrors() {
            
            exception.code = ExceptionCode.syntaxError
            return nil
        }
        
        // At this point we know selector list won't be null (since we have not returned with
        // an exception above) but the "above" code may change so we want to prevent
        // any errors.
        if let selectorList = selectorList {
        
            // 3. Return true if the result of match a selector against an element,
            // using s, element, and :scope element context object,
            // returns success, and false otherwise. [SELECTORS]
            return matches(selectorList)
        }
        else {
            // It is nil, we still have an error but we we have stoped
            // parsing for a reason
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("CSSSelectorsModule returned nil selectorList.", log: Log.Web.all, type: .error)
            #endif
            
            exception.code = ExceptionCode.syntaxError
            return nil
        }
    }
    
    /// Returns true if matching selectors against element's root yields element,
    /// and false otherwise.
    /// boolean matches(DOMString selectors);
    /// see https://dom.spec.whatwg.org/#dom-element-matchesselectors
    open func matches(_ selectorList: SelectorList) -> Bool {
    
        let selectorsModule = CSSSelectorsModule.shared
        
        // 3. Return true if the result of match a selector against an element,
        // using s, element, and :scope element context object,
        // returns success, and false otherwise. [SELECTORS]
        return selectorsModule.match(selectorList, against: self, scopeElements: [self])
    }
    
    /// HTMLCollection getElementsByTagName(DOMString localName);
    /// see https://dom.spec.whatwg.org/#dom-element-getelementsbytagname
    open func getElementsByTagName(_ localname: DOMString) -> HTMLCollection {
        
        return listElementsWithLocalname(localname)
    }
    
    /// HTMLCollection getElementsByTagNameNS(DOMString? namespace, DOMString localName);
    /// see https://dom.spec.whatwg.org/#dom-element-getelementsbytagnamens
    open func getElementsByTagNameNS(_ localname: DOMString, namespace: DOMString) -> HTMLCollection {
        
        return listElementsWithLocalnameAndNamespace(localname, namespace: namespace)
    }
    
    /// HTMLCollection getElementsByClassName(DOMString classNames);
    /// see https://dom.spec.whatwg.org/#dom-element-getelementsbyclassname
    open func getElementsByClassName(_ classnames: DOMString) -> HTMLCollection {
        
        return listElementsWithClassnames(classnames)
    }
    
    /// for node equality.
    func hasEquivalentAttributes(_ otherElement: Element) -> Bool {

        if otherElement == nil {
            
            return false
        }
        return self.attributes == otherElement.attributes
    }
    
    
    // MARK: Element high-level private functions
    
    /// change an attribute attribute from an element element to value
    /// see https://dom.spec.whatwg.org/#concept-element-attributes-change
    open func changeAttributeValue(_ attribute: inout Attr, value: DOMString) {
        
        #if MUTATION_RECORDS
        // 1. Queue a mutation record of "attributes" for element with
        // name attribute's local name, 
        // namespace attribute's namespace,
        // and oldValue attribute's value.
        if let recordManager = document.mutationRecordManager {
        
            var mutationRecord = MutationRecord(type: §MutationRecordType.Attributes , target: self)
            mutationRecord.attributeName = attribute.localName
            mutationRecord.attributeNamespace = attribute.namespaceURI
            mutationRecord.oldValue = attribute.value
        
            recordManager.queueMutationRecord(mutationRecord)
        }
        #endif
            
        // 2. Set attribute's value to value.
        attribute.value = value
        
        // 3. An attribute is set and an attribute is changed.
        // TODO: to finish.
    }
    
    
    /// remove an attribute attribute from an element element
    /// see https://dom.spec.whatwg.org/#concept-element-attributes-remove
    open func removeAttribute(_ attribute: inout Attr) {
        
        #if MUTATION_RECORDS
        // 1. Queue a mutation record of "attributes" for element with
        // name attribute's local name,
        // namespace attribute's namespace, 
        // and oldValue attribute's value.
        if let recordManager = document.mutationRecordManager {
        
            var mutationRecord = MutationRecord(type: §MutationRecordType.Attributes , target: self)
            mutationRecord.attributeName = attribute.localName
            mutationRecord.attributeNamespace = attribute.namespaceURI
            mutationRecord.oldValue = attribute.value
        
            recordManager.queueMutationRecord(mutationRecord)
        }
        #endif
            
        // 2. Remove attribute from the element's attribute list.
        var attributeToRemoveIndex: Int = -1
        
        for i in 0..<attributeList.count {
            
            let attr = attributeList[i]
            
            if attr == attribute {
                
                attributeToRemoveIndex = i
                break
            }
        }
        
        if attributeToRemoveIndex != -1 {
            
            attributeList.remove(at: attributeToRemoveIndex)
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("no attributeToRemoveIndex has been found.", log: Log.Web.all, type: .error)
            #endif
        }
        
        // 3. Set attribute's element to null.
        attribute.removeOwnerElement()
        
        // 4. An attribute is removed.
        // TODO: to implement.
    }
    
    
    /// append an attribute attribute to an element element
    /// seehttps://dom.spec.whatwg.org/#concept-element-attributes-append
    open func appendAttribute(_ attribute: Attr) {
        
//        #if MUTATION_RECORDS
//        // 1. Queue a mutation record of "attributes" for element with
//        // name attribute's local name, namespace attribute's namespace,
//        // and oldValue null.
//        if let recordManager = document.mutationRecordManager {
//        
//            var mutationRecord = MutationRecord(type: §MutationRecordType.Attributes , target: self)
//            mutationRecord.attributeName = attribute.localName
//            mutationRecord.attributeNamespace = attribute.namespaceURI
//            mutationRecord.oldValue = nil
//        
//            recordManager.queueMutationRecord(mutationRecord)
//        }
//        #endif
        
        // 2. Append the attribute to the element's attribute list.
        attributeList.append(attribute)
    }
    
    /// Get an attribute by name given a name and element element
    /// see https://dom.spec.whatwg.org/#dom-element-getattribute
    open func getAttributeByName(_ name: DOMString) -> Attr? {
        
        var _name: DOMString = name
        
        // 1. If element is in the HTML namespace and its node document is an HTML document, 
        // let name be converted to ASCII lowercase.
        if let namespaceURI = namespaceURI {
            
            if namespaceURI == §Namespace.HTML {
             
                _name = name.lowercased()
            }
        }
        
        // 2. Return the first attribute in element's attribute list 
        // whose name is name, and null otherwise.
        for attribute in attributeList {
            
            if attribute.name == _name {
                return attribute
            }
        }
        
        return nil
    }
    
    /// Get an attribute by namespace and local name given a namespace, localName, and element element
    /// see https://dom.spec.whatwg.org/#concept-element-attributes-get-by-namespace
    open func getAttributeByNamespaceAndLocalName(_ namespace: DOMString?, localName: DOMString) -> Attr? {
     
        // 1. If namespace is the empty string, set it to null.
        // Note: This case is managed below since the comparison
        // with namespace is not done if namespace is nil
        
        // 2. Return the attribute in element's attribute list whose namespace is 
        // namespace and local name is localName, if any, and null otherwise.
        for attribute in attributeList {
            
            if attribute.name == localName {
                
                if let namespace = namespace {
                    
                    if namespace == attribute.namespaceURI {
                        
                        return attribute
                    }
                }
                else {
                    return attribute
                }
                
            }
        }
        return nil
    }
    
    /// set an attribute given an attribute attr, element element, and optionally a namespace and local name flag
    /// https://dom.spec.whatwg.org/#concept-element-attributes-set
    open func setAttribute(_ attr: Attr, namespaceAndlocalnameFlag: Bool = false, exception: inout Exception) -> Attr? {
        
        // 1. If attr's element is neither null nor element, throw an InUseAttributeError.
        if let attributeElement = attr.ownerElement {
            
            if attributeElement != self {
                exception.code = ExceptionCode.inUseAttributeError
                return nil
            }
        }
        
        // 2. Let oldAttr be null.
        var oldAttr: Attr?
        
        // 3. If the namespace and local name flag is set, set oldAttr to the result of 
        // [getting an attribute](https://dom.spec.whatwg.org/#concept-element-attributes-get-by-namespace) 
        // given attr's namespace, attr's local name, and element.
        if namespaceAndlocalnameFlag  {
            
            oldAttr = getAttributeByNamespaceAndLocalName(attr.namespaceURI, localName: attr.localName)
        }
        // 4. Otherwise, set oldAttr to the result of 
        // [getting an attribute](https://dom.spec.whatwg.org/#concept-element-attributes-get-by-name) 
        // given attr's name and element.
        else {
            oldAttr = getAttributeByName(attr.name)
        }
        
        // 5. If oldAttr is attr, return attr.
        if let oldAttr = oldAttr , oldAttr == attr {

            return attr
        }
        
        // 6. If oldAttr is non-null, [remove](https://dom.spec.whatwg.org/#concept-element-attributes-remove) 
        // it from element.
        if oldAttr != nil {
            
            removeAttribute(&oldAttr!)
        }
        
        // 7. Append attr to element.
        appendAttribute(attr)
        
        // 8. Return oldAttr.
        return oldAttr
    }
    
    /// set an attribute value for an element element using a localName and value, and optionally a name, prefix, and namespace
    /// see https://dom.spec.whatwg.org/#concept-element-attributes-set-value
    open func setAttributeValue(_ localname: DOMString, value: DOMString, name: DOMString? = nil, prefix: DOMString? = nil, namespace: DOMString? = nil) {
        
        // 1. If name is not given, set it to localName.
        let _name: DOMString
        
        if let name = name {
            _name = name
        }
        else {
            _name = localname
        }
        
        // 2. If prefix is not given, set it to null.
        // Note : nothing to be done, prefix is already null
        
        // 3. If namespace is not given, set it to null.
        // Note: nothing to be done, namespace is already null
        
        // 4. Let attribute be the result of [getting an attribute]
        // (https://dom.spec.whatwg.org/#concept-element-attributes-get-by-namespace)
        // given namespace, localName, and element.
        var attribute = getAttributeByNamespaceAndLocalName(namespace, localName: _name)
        
        // 4. Change attribute from element to value.
        if attribute != nil {
            
            changeAttributeValue(&attribute!, value: value)
        }
        // 3. If attribute is null, create an attribute whose namespace is namespace, 
        // namespace prefix is prefix, local name is localName, name is name, and value is value, 
        // and then append this attribute to element and terminate these steps.
        else {
            
            var attribute = Attr(localName: localname, name: _name)
            
            attribute.namespaceURI = namespace
            attribute.prefix = prefix
            attribute.value = value
            
            appendAttribute(attribute)
        }
    }
    
    /// Remove an attribute by name given a name and element element
    /// see https://dom.spec.whatwg.org/#concept-element-attributes-remove-by-name
    @discardableResult
    open func removeAttributeByName(_ name: DOMString) -> Attr? {
    
        // 1. Let attr be the result of [getting an attribute]
        // (https://dom.spec.whatwg.org/#concept-element-attributes-get-by-name) given name and element.
        var attr = getAttributeByName(name)
    
        // 2. If attr is non-null, remove it from element.
        if attr != nil {
            
            removeAttribute(&attr!)
        }
        
        // 3. Return attr.
        return attr
    }
    
    /// Remove an attribute by namespace and local name given a namespace, localName, and element element
    /// see https://dom.spec.whatwg.org/#concept-element-attributes-remove-by-namespace
    open func removeAttributeByNamespaceAndLocalName(_ namespace: DOMString?, localName: DOMString) -> Attr? {
        
        // 1. Let attr be the result of getting an attribute given namespace, localName, and element.
        var attr = getAttributeByNamespaceAndLocalName(namespace, localName: localName)
        
        // 2. If attr is non-null, remove it from element.
        if attr != nil {
            
            removeAttribute(&attr!)
        }
        
        // 3. Return attr.
        return attr
    }
    
    /// Function that return true if this Element contains 
    /// an atrribute equal to the parameter Attr otherwise 
    /// it returns false.
    fileprivate func hasAttribute(_ attr: Attr) -> Bool {
        
        // 2. Return true if the context object has an attribute whose is equal to
        // parameter attribute and false otherwise.
        for attribute in attributeList {
            
            if attribute == attr {
                return true
            }
        }
        
        return false
    }
    
    // MARK: locate namespace
    
    /// Locate a namespace : default implementation
    /// see https://dom.spec.whatwg.org/#locate-a-namespace
    /// Overidden by Element, Document, DocumentType and DocumentFragment
    override open func locateNamespace(_ prefix: DOMString?) -> DOMString? {
    
        // 1. If its namespace is not null and its namespace prefix is prefix, 
        // return namespace.
        if let namespace = self.namespaceURI {
            
            if let prefix = self.prefix , prefix == prefix {
             
                return namespace
            }
        }
        
        // 2. If it has an attribute whose namespace is the XMLNS namespace, 
        // namespace prefix is "xmlns" and local name is prefix, 
        // or if prefix is null and it has an attribute whose namespace is the XMLNS namespace, 
        // namespace prefix is null and local name is "xmlns":
        // FIXME: finish this implementation
        
        
        // it has an attribute whose namespace is the XMLNS namespace, 
        // namespace prefix is "xmlns" and local name is prefix
        if let prefix = prefix {
            
            for attribute in attributeList {
                
                if let namespace = attribute.namespaceURI {
                    
                    // has an attribute whose namespace is the XMLNS namespace
                    if namespace == §Namespace.XMLNS {
                     
                        if let attributePrefix = attribute.prefix {
                            
                            // namespace prefix is "xmlns"
                            if attributePrefix == "xmlns" {
                         
                                // local name is prefix
                                if attribute.localName == prefix {
                                    
                                    // 1. Let value be its value if it is not the empty string, 
                                    // and null otherwise.
                                    if attribute.value.isEmpty {

                                        return nil
                                    }
                                    else {
                                        
                                        return attribute.value
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        // ... it has an attribute whose namespace is the XMLNS namespace,
        // namespace prefix is null and local name is "xmlns":
        else {
         
            for attribute in attributeList {
                
                if let namespace = attribute.namespaceURI {
                    
                    // has an attribute whose namespace is the XMLNS namespace
                    if namespace == §Namespace.XMLNS {
                        
                        // ... namespace prefix is null
                        if attribute.prefix == nil {
                         
                            // ... local name is "xmlns"
                            if attribute.localName == "xmlns" {
                                
                                // 1. Let value be its value if it is not the empty string,
                                // and null otherwise.
                                if attribute.value.isEmpty {
                                    
                                    return nil
                                }
                                else {
                                    
                                    return attribute.value
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // 4. Return the result of running locate a namespace on its parent element using prefix.
        if let parentElement = self.parentElement {
            
            return parentElement.locateNamespace(prefix)
        }
        
        // If its parent element is null, return null.
        return nil
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: DomInspectable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override var numberOfChildren: Int {
        
        if let childs = inspectableChilds {
            
            return childs.count
        }
        
        return 1
    }
    
    open override var expandable: Bool {
        
        if let childs = inspectableChilds {

            return childs.count > 0
        }
        
        return false
    }
    
    open override var expandedOpenElementString: String {
        
//        let domParsing = HTMLSerializer.shared
        return self.localName // domParsing.serializeOpenTag(fromElement: self)
    }
    
    open override var unexpandedElementString: String {
        
//        let domParsing = HTMLSerializer.shared
        return self.localName// domParsing.serializeOpenTag(fromElement: self) + "..." +  domParsing.serializeCloseTag(fromElement: self)
    }
    
    open override func childAtIndex(_ index: Int) -> DomInspectable? {
        
        return inspectableChilds![index]
    }
    
    /// This method returns true is the current ContainerNode
    /// has only text nodes.
    open override func hasOnlyChildTextNodes() -> Bool {
        
        for child in inspectableChilds! {
            
            if child.nodeType != NodeType.text_node {
                return false
            }
        }
        return true
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: PseudoElementsFragmentsContainer protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This value is used by the NodeIdentity since the available
    /// pseudo-elements for an element has an impact on the StyleApplication
    /// and associated StyleIdentity.
    public var pseudoElementsString: String {
        
        let sortedPseudoElements = markdownAssociatedPseudoElements.keys.sorted(by: { (pseudo1, pseudo2) -> Bool in
            guard let firstPseudoType = PseudoSelectorType(rawValue: pseudo1) else {
                assertionFailure("Error: firstPseudoType is nil")
                return true
            }
            guard let secondPseudoType = PseudoSelectorType(rawValue: pseudo2) else {
                assertionFailure("Error: secondPseudoType is nil")
                return true
            }
            return firstPseudoType.order < secondPseudoType.order
        })
        
        var pseudos = ""
        for (index, key) in sortedPseudoElements.enumerated() {
            
            if index != markdownAssociatedPseudoElements.count-1 {
                pseudos += "\(key),"
            }
            else {
                pseudos += key
            }
        }
        return pseudos
    }
    
    public var pseudoElementsFragments: [String: SourceStringFragment] {
        
        return markdownAssociatedPseudoElements
    }
    
    public func hasPseudoElement(with name: String) -> Bool {
        
        if self.markdownAssociatedPseudoElements[name] != nil {
            return true
        }
        return false
    }
    
    public func setPseudoElementSourceStringFragment(with name: String, to fragment: SourceStringFragment?) {
        
        if let fragment = fragment {
            self.markdownAssociatedPseudoElements[name] = fragment
        }
    }
    
    public func pseudoElementSourceStringFragment(with name: String) -> SourceStringFragment? {
        
        displaceSourceFragmentValues()
        return self.markdownAssociatedPseudoElements[name]
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private var displacement: Int = 0
    
    override open var sourceStringFragment: SourceStringFragment? {
        get {
            displaceSourceFragmentValues()
            return super.sourceStringFragment
        }
        set {
            super.sourceStringFragment = newValue
        }
    }
    
    public func moveEnd(_ count: Int) {
        
        super.sourceStringFragment?.moveEnd(count)
    }
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    open func move(_ count: Int) {
        
//        #if DEBUG
//        for textChild in textChilds {
//
//            let textChild = textChild as? Text
//
//            if let sourceStringFragment = textChild?.sourceStringFragment {
//
//                // start index
//                let textStartIndex = sourceStringFragment.startFragmentIndex!
//                let elementStartIndex = self.sourceStringFragment!.startFragmentIndex!
//                assert(textStartIndex >= elementStartIndex)
//
//                // end index
//                let textEndIndex = sourceStringFragment.endFragmentIndex!
//                let elementEndIndex = self.sourceStringFragment!.endFragmentIndex!
//                assert(textEndIndex <= elementEndIndex)
//            }
//        }
//        #endif
        
        displacement += count
        for textChild in textChilds {
            
            let textChild = textChild as? Text
            
            assert(textChild != nil)
            textChild?.move(count)
            
            #if DEBUG
            if let sourceStringFragment = textChild?.sourceStringFragment {
                
                // start index
                let textStartIndex = sourceStringFragment.startFragmentIndex!
                let elementStartIndex = self.sourceStringFragment!.startFragmentIndex!
                assert(textStartIndex >= elementStartIndex)
                
                // end index
                let textEndIndex = sourceStringFragment.endFragmentIndex!
                let elementEndIndex = self.sourceStringFragment!.endFragmentIndex!
                assert(textEndIndex <= elementEndIndex)
            }
            #endif
        }
        
    }
    
    private func displaceSourceFragmentValues() {
        
        if displacement != 0 {
        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("move element: %@ by count: %d", log: Log.Web.all, type: .info, %%self.localName, displacement)
            #endif
            for key in self.markdownAssociatedPseudoElements.keys {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("move element: pseudo element: %@ by count: %d", log: Log.Web.all, type: .info, %%key, displacement)
                #endif
                markdownAssociatedPseudoElements[key]!.move(displacement)
            }
            super.sourceStringFragment?.move(displacement)
            self.displacement = 0
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = Element
    
    override open func cloneNode(_ deep: Bool = false) -> Element {
        
        var copy = createInstance()
        
        cloneFields(&copy)
        
        if deep {
            
            cloneChildren(into: copy, deep: deep)
        }
        
        return copy
    }
    
    ///
    override open func createInstance() -> Element {
        
        return Element(document: nil, localName: self.localName)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout Element) {
    
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
        
        // Its namespace, namespace prefix, local name, and its attribute list.
        copy.localName = self.localName
        copy.namespaceURI = self.namespaceURI
        copy.prefix = self.prefix
        copy.attributes = self.attributes
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? Element {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
//                if !self.hasEquivalentAttributes(other) {
//                    
//                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                    os_log("Not equals: attributes are different.", log: Log.Web.all, type: .debug)
//                    #endif
//                    return false
//                }

                if let namespace = self.namespaceURI {
                    
                    if let otherNamespace = other.namespaceURI {
                        
                        if namespace != otherNamespace {
                            
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("Not equals: namespaceURI are different.", log: Log.Web.all, type: .debug)
                            #endif
                            return false
                        }
                    }
                    else {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: other namespaceURI is nil.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.namespaceURI != nil {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other namespaceURI is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if let prefix = self.prefix {
                    
                    if let otherPrefix = other.prefix {
                        
                        if prefix != otherPrefix {
                            
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("Not equals: prefix are different.", log: Log.Web.all, type: .debug)
                            #endif
                            return false
                        }
                    }
                    else {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: other prefix is nil.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.prefix != nil {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other prefix is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if localName != other.localName {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: localName are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not Element.", log: Log.Web.all, type: .debug)
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
        
        return self.equals(to: other, comparePositions: false)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Hashable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private var _hashValue: Int?
    
    /// We want the hashValue of an element to be the same if an element has been recalculated 
    /// more than one time, even if it has moved in the source code. Since CodePointIndex do stay the 
    /// same even if the value has moved in the source code
    override open var hashValue: Int {
        
        // FIXME: Test the proformance of this hash and make sure it is not
        // too slow in critical operations.

//        var hash =  localName.hashValue
//        
//        if let startIndex = sourceStringSegment?.startIndex {
//            
//            hash  = hash ^ startIndex.hashValue
//        }
//        
//        if let endIndex = sourceStringSegment?.endIndex {
//            
//            hash  = hash ^ endIndex.hashValue
//        }
        
//        if let _hashValue = _hashValue {
//            return _hashValue
//        }
        
        return UInt(bitPattern: ObjectIdentifier(self)).hashValue
//        return _hashValue!
        // Old implementation we keep in case
//        var h: Int = nodeType.hashValue ^ nodeName.hashValue ^ super.hashValue
//        
//        //    readonly attribute DOMString? namespaceURI;
//        //    readonly attribute DOMString? prefix;
//        //    readonly attribute DOMString localName;
//        //    readonly attribute DOMString tagName;
//        //
//        //    attribute DOMString? id;
//        //    attribute DOMString? className;
//        //    [SameObject] readonly attribute DOMTokenList classList;
//        
//        if let namespaceURI = namespaceURI {
//            h = h ^ namespaceURI.hashValue
//        }
//        
//        if let prefix = prefix {
//            h = h ^ prefix.hashValue
//        }
//        
//        h = h ^ localName.hashValue
//        
//        if let prefix = prefix {
//            h = h ^ prefix.hashValue
//        }
//        
//        h = h ^ tagName.hashValue
//        
//        
//        if let id = id {
//            h = h ^ id.hashValue
//        }
//
//        if let className = className {
//            h = h ^ className.hashValue
//        }
//        
//        return h
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                          MARK: CSSOM extension to Element protocol implementation
    //                          see  http://dev.w3.org/csswg/cssom/#extensions-to-the-element-interface
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    /// Support for pseudo-element
    /// see http://dev.w3.org/csswg/cssom/#dom-element-pseudo-pseudoelt
    /// func PseudoElement? pseudo(DOMString pseudoElt);
    func pseudo(_ pseudoElt: DOMString) -> PseudoElement? {
        
        assert(supportsPseudo(with: pseudoElt))
        
        return PseudoElement(fragment: nil, localName: pseudoElt, associatedElement: self)
    }
    
    func supportsPseudo(with localName: String) -> Bool {
        
        if let _ = markdownAssociatedPseudoElements.index(forKey: localName) {
            return true
        }
        
        // NW-1175
//        if localName == §PseudoElementType.FirstLine {
//            return false
//        }

        guard let pseudoSelectorType = PseudoSelectorType(rawValue: localName) else {
            assertionFailure("Error: pseudo selector type with name: \(localName) not defined.")
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            // It's not an error, it's really possible a type doesn't support a pseudo...
            os_log("Unknown peudo-element type: %@", log: Log.Web.all, type: .debug, %%localName)
            #endif
            return false
        }
        
        switch pseudoSelectorType {
        case .focus: fallthrough
        case .highlight: fallthrough
        case .FirstLetter:
            return true
        default:
            return false
        }
    }
    
    var firstLetter: PseudoElement? {
        
        return nil
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                          MARK: CSSElementProperties protocol support
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    ///
    /// Method that use the calculated CSSSupportedPropertyTable to get all
    /// the element supported properties.
    ///
    open var supportedProperties: Set<CSSProperty> {
        
        let supportedPropertiesTable = CSSSupportedPropertyTable.shared
        return supportedPropertiesTable.supportedPropertiesForElement(self.namespaceURI!, elementName: localName)
    }
    
    ///
    /// Method that use the calculated CSSSupportedPropertyTable to get all
    /// the element temporary supported properties.
    ///
    /// Note: temporary supported properties are properties that can be set using
    /// the addTemporaryAttribute of NSLayoutManager.
    ///
    open var temporarySupportedProperties: Set<CSSProperty> {
    
        let supportedPropertiesTable = CSSSupportedPropertyTable.shared
        let languageName = self.document.contentType
        
        return supportedPropertiesTable.temporarySupportedPropertiesForElement(languageName, elementName: localName)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: HTMLSerializer protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    ///
    /// > The innerHTML IDL attribute represents the markup of the Element's contents.
    ///
    /// [innerHTML](http://www.w3.org/TR/DOM-Parsing/#widl-Element-innerHTML)
    ///
    var innerHTML: String {
        
        get {

            assert(false, "Missing implementation.")
            return ""
        }
        set {
            
            assert(false, "Missing implementation.")
        }
    }
    
    ///
    /// > The outerHTML IDL attribute represents the markup of the Element and its contents.
    ///
    /// [outerHTML](http://www.w3.org/TR/DOM-Parsing/#widl-Element-outerHTML)
    ///
    var outerHTML: String {
        
        get {
            
            assert(false, "Missing implementation.")
            return ""
        }
        set {
            assert(false, "Missing implementation.")
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private func replaceAttribute(named name: String, with attr: Attr) {
        
        for i in 0..<attributeList.count {
            
            if attributeList[i].name == name {
                attributeList[i] = attr
                break
            }
        }
    }
    
    func firstLineSourceStringSegment(in string: String) -> SourceStringSegment? {
        
        if let _sourceStringFragment = self.sourceStringFragment {
            
            switch _sourceStringFragment {
                
            case let sourceStringSegment as SourceStringSegment:
                
                return firstLineSourceStringSegment(in: string, inside: sourceStringSegment)
                
            case let sourceStringRegion as SourceStringRegion:
                
                for _sourceStringSegment in sourceStringRegion.sourceStringSegments {
                    
                    if let _firstLineSourceStringSegment = firstLineSourceStringSegment(in: string, inside: _sourceStringSegment) {
                        
                        return _firstLineSourceStringSegment
                    }
                }
                
            default:
                
                assert(false, "Unsupported type of sourcestringfragment")
                break
            }
        }
        return nil
        
    }
    
    private func firstLineSourceStringSegment(in string: String, inside sourceStringSegment: SourceStringSegment) -> SourceStringSegment? {
        
        let _firstIndexAfterTag: Int = firstIndexAfterTag(in: sourceStringSegment)
        
        for index in _firstIndexAfterTag..<sourceStringSegment.endIndex.integerValue {
            
            if let _ = string.startWithNewLine(atPosition: index) {
                
                return SourceStringSegment.Get(sourceStringSegment.startIndex.integerValue, length: index - sourceStringSegment.startIndex.integerValue)
            }
        }
        
        if !sourceStringSegment.isEmpty {
            
            return sourceStringSegment
        }
        
        return nil
    }
    
    func firstLetterSourceStringSegment(in string: String) -> SourceStringSegment? {
        
        if let firstChild = self.firstChild, firstChild.nodeType == .text_node {
        
            if let sourceStringFragment = firstChild.sourceStringFragment {
            
                switch sourceStringFragment {
                    
                case let sourceStringSegment as SourceStringSegment:
                    
                    return firstLetterSourceStringSegment(in: string, inside: sourceStringSegment)
                    
                case let sourceStringRegion as SourceStringRegion:
                    
                    for sourceStringSegment in sourceStringRegion.sourceStringSegments {
                        if let firstLetterSourceStringSegment = self.firstLetterSourceStringSegment(in: string, inside: sourceStringSegment) {
                            return firstLetterSourceStringSegment
                        }
                    }
                    
                default:
                    
                    assert(false, "Unsupported type of sourcestringfragment")
                    break
                }
            }
        }
        return nil
    }
    
    private func firstLetterSourceStringSegment(in string: String, inside sourceStringSegment: SourceStringSegment) -> SourceStringSegment? {
        
        let _firstIndexAfterTag: Int = firstIndexAfterTag(in: sourceStringSegment)
        
        for i in _firstIndexAfterTag..<sourceStringSegment.endIndex.integerValue {
            
            if let character = string.charAt(i), !UnicodeWhitespace.isUnicodeWhitespace(character) {
                
                return SourceStringSegment.Get(i, length: 1)
            }
        }
        return nil
    }
    
    private func firstIndexAfterTag(in sourceStringSegment: SourceStringSegment) -> Int {
        
        if let tagFragment = self.markdownAssociatedPseudoElements["tag"] {
            
            switch tagFragment {
                
            case let sourceStringSegment as SourceStringSegment:
                
                return sourceStringSegment.endIndex.integerValue
                
            case let sourceStringRegion as SourceStringRegion:
                
                if let firstSegment = sourceStringRegion.sourceStringSegments.first {
                    
                    return firstSegment.endIndex.integerValue
                }
                
            default:
                
                assert(false, "Unsupported type of sourcestringfragment")
                break
            }
        }
        return sourceStringSegment.startIndex.integerValue
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func == (lhs: Element, rhs: Element) -> Bool {
    
    // FOR SPEED we will use the hash
    return lhs.equals(to: rhs, comparePositions: false)
    
}


