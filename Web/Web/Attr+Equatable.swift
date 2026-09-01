//
//  Attr+Equatable.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-19.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation

extension Attr : Equatable {
    
}

public func == (lhs: Attr, rhs: Attr) -> Bool {
    
    // readonly attribute DOMString? namespaceURI;
    if lhs.namespaceURI != rhs.namespaceURI {
        
        return false
    }
    
    // readonly attribute DOMString? prefix;
    if lhs.prefix != rhs.prefix {
        
        return false
    }
    
    // readonly attribute DOMString localName;
    if lhs.localName != rhs.localName {
        
        return false
    }
    
    // readonly attribute DOMString name;
    if lhs.name != rhs.name {
        
        return false
    }
    
    // attribute DOMString value;
    if lhs.value != rhs.value {
        
        return false
    }
    
    // attribute DOMString nodeValue;
    if lhs.nodeValue != rhs.nodeValue {
        
        return false
    }
    
    // attribute DOMString textContent;
    if lhs.textContent != rhs.textContent {
        
        return false
    }
    
    // readonly attribute Element? ownerElement;
    if lhs.ownerElement != rhs.ownerElement {
        
        return false
    }
    
    // readonly attribute boolean specified;
    if lhs.specified != rhs.specified {
        
        return false
    }
    
    return true
}
