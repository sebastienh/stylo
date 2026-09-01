//
//  HTMLCollection.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-18.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

//https://dom.spec.whatwg.org/#htmlcollection
//interface HTMLCollection {
//    readonly attribute unsigned long length;
//    getter Element? item(unsigned long index);
//    getter Element? namedItem(DOMString name);
//};

protocol IHTMLCollection: class {
    
    var length: Int { get }
    
    func item(_ index: Int) -> Node?
    func namedItem(_ name: DOMString) -> Web.Element?
}

/// An HTMLCollection object is a collection of elements.
/// see https://dom.spec.whatwg.org/#htmlcollection
public final class HTMLCollection: LiveNodeList, IHTMLCollection {
    
    subscript(name: DOMString) -> Web.Element? {
        
        get {
            return namedItem(name)
        }
    }
    
    public var elements: ContiguousArray<Web.Element> {

        return ContiguousArray<Web.Element>(nodes.compactMap({$0 as! Web.Element}))
    }
    
    public var last: Web.Element? {
        
        if let last = item(length - 1) {
            
            return (last  as! Web.Element)
        }
        return nil
    }
    
    init(root: Node, filter: ElementNodeFilter, inclusive: Bool = false) {
        
        super.init(root: root, filter: filter, inclusive: inclusive)
    }
    
    override func item(_ index: Int) -> Node? {
        
        if let node = super.item(index) {
            
            assert(node is Web.Element, "node is not Element!")
            
            if let element = node as? Web.Element {
                
                return element
            }
        }
        return nil
    }
    
    public func addLastElementNextSiblingToCollection() {
        
        if let last = last, let lastNextSiblingElement = last.nextSiblingElement {
            
            self.nodes.append(lastNextSiblingElement)
        }
        else {
            assert(false, "last element is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("last element is nil", log: Log.Web.all, type: .error)
            #endif
        }
    }
    
    /// Returns the first element with ID or name name from the collection.
    /// see https://dom.spec.whatwg.org/#dom-htmlcollection-nameditem
    public func namedItem(_ key: DOMString) -> Web.Element? {

        // 1. If key is the empty string, return null.
        if key.isEmpty {
            return nil
        }
        
        // 2. Return the first element in the collection for which at 
        // least one of the following is true:
        
        for item in self {
            
            if let element = item as? Web.Element {
                
                // it has an ID which is key.
                if let id = element.id, id == key {
                    
                    return element
                }
                if element.localName == key {
                    
                    return element
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Expecting Element type in HTMLCollection.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        
        // or null if there is no such element.
        return nil
    }
    
}


