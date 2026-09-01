//
//  NameNodeMap.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-18.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import os

//interface NamedNodeMap {
//    readonly attribute unsigned long length;
//    getter Attr? item(unsigned long index);
//    getter Attr? getNamedItem(DOMString name);
//    Attr? getNamedItemNS(DOMString? namespace, DOMString localName);
//    Attr? setNamedItem(Attr attr);
//    Attr? setNamedItemNS(Attr attr);
//    Attr removeNamedItem(DOMString name);
//    Attr removeNamedItemNS(DOMString? namespace, DOMString localName);
//};

/// see https://dom.spec.whatwg.org/#namednodemap
struct NameNodeMap {
    
    
    /// A NamedNodeMap has an associated element (an element).
    /// see https://dom.spec.whatwg.org/#concept-namednodemap-element
    weak var element: Element?
    
    
    /// readonly attribute unsigned long length;
    /// see https://dom.spec.whatwg.org/#dom-namednodemap-length
    var length: Int {
        
        if let element = self.element {
            return element.attributeList.count
        }
        else {
            assert(false, "element stored property in NameNodeMap is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("element stored property in NameNodeMap is nil", log: Log.Web.all, type: .error)
            #endif
        }
        return 0
    }
    
    public var isEmpty: Bool {
        return length == 0
    }
    
    /// Empty constructor
    /// With this constructor, the NameNodeMap is initialized 
    /// without element, but this element must be set later.
    init() {
        /// Nothing to do
    }
    
    /// Constructor with element
    init(element: Element) {
        self.element = element
    }
    
    /// Subscripting support
    subscript(index: Int) -> Attr? {
     
        get {
         
            return item(index)
        }
    }
    
    /// getter Attr? item(unsigned long index);
    /// The item(index) method
    func item(_ index: Int) -> Attr? {
        
        // 1. If index is equal to or greater than the number of
        // attributes in the attribute list, return null
        if index >= length {
            return nil
        }
        
        // 2. Otherwise, return the indexth attribute in the attribute list.
        if let element = element {
            return element.attributeList[index]
        }
        else {
            assert(false, "element stored property in NameNodeMap is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("element stored property in NameNodeMap is nil", log: Log.Web.all, type: .error)
            #endif
        }
        return nil
    }
    
    
    
    /// getter Attr? getNamedItem(DOMString name);
    /// The getNamedItem(name) method, when invoked, must return the result of 
    /// getting an attribute given name and element.
    ///
    /// see https://dom.spec.whatwg.org/#dom-namednodemap-getnameditem
    func getNamedItem(_ name: DOMString) -> Attr? {
        
        if let element = element {
            
            return element.getAttributeNode(name)
        }
        else {
            assert(false, "element stored property in NameNodeMap is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("element stored property in NameNodeMap is nil", log: Log.Web.all, type: .error)
            #endif
        }
        return nil
    }
    
    /// Return the result of getting an attribute given namespace, localName, and element.
    /// Attr? getNamedItemNS(DOMString? namespace, DOMString localName);
    /// see https://dom.spec.whatwg.org/#dom-namednodemap-getnameditemns
    func getNamedItemNS(_ namespace: DOMString?, localName: DOMString) -> Attr? {
        
        if let element = element {
            
            return element.getAttributeNodeNS(namespace, localName: localName)
        }
        else {
            assert(false, "element stored property in NameNodeMap is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("element stored property in NameNodeMap is nil", log: Log.Web.all, type: .error)
            #endif
        }
        return nil
    }
    
    /// Return the result of setting an attribute given attr and element.
    /// Attr? setNamedItem(Attr attr);
    /// see https://dom.spec.whatwg.org/#dom-namednodemap-setnameditem
    @discardableResult
    func setNamedItem(_ attr: Attr, exception: inout Exception) -> Attr? {
        
        if let element = element {
            
            return element.setAttribute(attr, exception: &exception)
        }
        else {
            assert(false, "element stored property in NameNodeMap is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("element stored property in NameNodeMap is nil", log: Log.Web.all, type: .error)
            #endif
        }
        return nil
    }
    
    
    /// Return the result of setting an attribute given attr, element, and namespace and local name flag set.
    /// Attr? setNamedItemNS(Attr attr);
    /// see https://dom.spec.whatwg.org/#dom-namednodemap-setnameditemns
    func setNamedItemNS(_ attr: Attr, exception: inout Exception) -> Attr? {
        
        if let element = element {
            
            return element.setAttribute(attr, namespaceAndlocalnameFlag: true, exception: &exception)
        }
        else {
            assert(false, "element stored property in NameNodeMap is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("element stored property in NameNodeMap is nil", log: Log.Web.all, type: .error)
            #endif
        }
        return nil
    }
    
    /// Remove named item.
    /// Attr removeNamedItem(DOMString name);
    /// see https://dom.spec.whatwg.org/#dom-namednodemap-removenameditem
    func removeNamedItem(_ name: DOMString, exception: inout Exception) -> Attr? {
    
        // 1. Let attr be the result of removing an attribute given name and element.
        if let element = element {
            
            let attr = element.removeAttribute(name)
            
            // 3. Return attr.
            if let attr = attr {
                
                return attr
            }
            // 2. If attr is null, throw a NotFoundError exception.
            else {
                
                exception.code = ExceptionCode.notFoundError
                return nil
            }
        }
        else {
            assert(false, "element stored property in NameNodeMap is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("element stored property in NameNodeMap is nil", log: Log.Web.all, type: .error)
            #endif
        }
        return nil
    }
    
    /// Removed named item with namespace.
    /// Attr removeNamedItemNS(DOMString? namespace, DOMString localName);
    /// see https://dom.spec.whatwg.org/#dom-namednodemap-removenameditemns
    func removeNamedItemNS(_ namespace: DOMString?, localname: DOMString, exception: inout Exception) -> Attr? {
        
        if let element = element {
            
            // 1. Let attr be the result of removing an attribute given namespace, localName, and element.
            let attr = element.removeAttributeByNamespaceAndLocalName(namespace, localName: localname)
            
            // 3. Return attr.
            if let attr = attr {
                
                return attr
            }
            // 2. If attr is null, throw a NotFoundError exception.
            else {
                
                exception.code = ExceptionCode.notFoundError
                return nil
            }
        }
        else {
            assert(false, "element stored property in NameNodeMap is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("element stored property in NameNodeMap is nil", log: Log.Web.all, type: .error)
            #endif
        }
        return nil
    }
    
}









