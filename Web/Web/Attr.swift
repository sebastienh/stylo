//
//  Attr.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-19.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation

//https://dom.spec.whatwg.org/#attr
//interface Attr {
//  readonly attribute DOMString? namespaceURI;
//  readonly attribute DOMString? prefix;
//  readonly attribute DOMString localName;
//  readonly attribute DOMString name;
//           attribute DOMString value;
//           attribute DOMString nodeValue; // legacy alias of .value
//           attribute DOMString textContent; // legacy alias of .value
//
//  readonly attribute Element? ownerElement;
//
//  readonly attribute boolean specified; // useless; always returns true
//};

public struct Attr {
    
    // readonly attribute DOMString? namespaceURI;
    public internal(set) var namespaceURI: DOMString?
    
    // readonly attribute DOMString? prefix;
    public internal(set) var prefix: DOMString?
    
    // readonly attribute DOMString localName;
    public internal(set) var localName: DOMString
    
    // readonly attribute DOMString name;
    public internal(set) var name: DOMString
    
    // var value: DOMString
    public var value: DOMString
    
    // var nodeValue: DOMString 
    // legacy alias of .value
    var nodeValue: DOMString {
        get {
            return self.value
        }
        set(value){
            
            self.value = value
        }
    }
    
    // var textContent: DOMString 
    // legacy alias of .value
    var textContent: DOMString {
        get {
            return self.value
        }
        set(value){
            self.value = value
        }
    }
    
    // readonly attribute var ownerElement: Element?
    internal(set) weak var ownerElement: Element?
    
    // readonly attribute var specified: Bool
    // useless; always returns true
    var specified: Bool {
        get {
            return true
        }
    }
    
    public init(localName: DOMString, value: String = "") {
        
        self.localName = localName
        self.name = localName
        self.value = value
    }
    
    init(localName: DOMString, name: DOMString?) {
        self.localName = localName
        
        if let name = name {
            self.name = name
        }
        else {
            self.name = localName
        }
        
        self.value = ""
    }
    
    mutating func removeOwnerElement() {
        
        self.ownerElement = nil
    }
    
}









