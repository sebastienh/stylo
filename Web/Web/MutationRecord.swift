//
//  MutationRecord.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-25.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation

// https://dom.spec.whatwg.org/#mutationrecord
//interface MutationRecord {
//    readonly attribute DOMString type;
//    readonly attribute Node target;
//    [SameObject] readonly attribute NodeList addedNodes;
//    [SameObject] readonly attribute NodeList removedNodes;
//    readonly attribute Node? previousSibling;
//    readonly attribute Node? nextSibling;
//    readonly attribute DOMString? attributeName
//    readonly attribute DOMString? attributeNamespace;
//    readonly attribute DOMString? oldValue;
//};

public struct MutationRecord {
    
    // readonly attribute DOMString type;
    internal(set) var type: DOMString
    
    // readonly attribute Node target;
    internal(set) var target: Node
    
    // [SameObject] readonly attribute NodeList addedNodes;
    internal(set) var addedNodes: NodeList?
    
    // [SameObject] readonly attribute NodeList removedNodes;
    internal(set) var removedNodes: NodeList?
    
    // readonly attribute Node? previousSibling;
    internal(set) var previousSibling: Node?
    
    // readonly attribute Node? nextSibling;
    internal(set) var nextSibling: Node?
    
    // readonly attribute DOMString? attributeName;
    internal(set) var attributeName: DOMString?
    
    // readonly attribute DOMString? attributeNamespace;
    internal(set) var attributeNamespace: DOMString?
    
    // readonly attribute DOMString? oldValue;
    internal(set) var oldValue: DOMString?
    
    init(type: DOMString, target: Node) {
        self.type = type
        self.target = target
    }
}
