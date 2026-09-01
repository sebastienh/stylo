//
//  MutationRecord+Hashable.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-12.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation

extension MutationRecord : Hashable {
    
    public var hashValue: Int {
        
        var h: Int = 0
        
        h = h ^ type.hashValue
        
        h = h ^ target.hashValue
        
        if let addedNodes = addedNodes {
            for node in addedNodes {
                h = h ^ node.hashValue
            }
        }
        
        if let removedNodes = removedNodes {
            for node in removedNodes {
                h = h ^ node.hashValue
            }
        }
        
        if let previousSibling = previousSibling {
            h = h ^ previousSibling.hashValue
        }
        
        if let nextSibling = nextSibling {
            h = h ^ nextSibling.hashValue
        }
        
        if let attributeName = attributeName {
            h = h ^ attributeName.hashValue
        }
        
        if let oldValue = oldValue {
            h = h ^ oldValue.hashValue
        }
        
        return h
    }
}

public func ==(lhs: MutationRecord, rhs: MutationRecord) -> Bool {
    
    if lhs.type != rhs.type {
        
        return false
    }
    
    if lhs.target != rhs.target {
        
        return false
    }
    
    if lhs.addedNodes != rhs.addedNodes {
        
        return false
    }
    
    if lhs.removedNodes != rhs.removedNodes {
        
        return false
    }
    
    // readonly attribute Node? previousSibling;
    if lhs.previousSibling != rhs.previousSibling {
        
        return false
    }
    
    // readonly attribute Node? nextSibling;
    if lhs.nextSibling != rhs.nextSibling {
        
        return false
    }
    
    // readonly attribute DOMString? attributeName;
    if lhs.attributeName != rhs.attributeName {
        
        return false
    }
    
    // readonly attribute DOMString? attributeNamespace;
    if lhs.attributeNamespace != rhs.attributeNamespace {
        
        return false
    }
    
    // readonly attribute DOMString? oldValue;
    if lhs.oldValue != rhs.oldValue {
        
        return false
    }
    
    return true
}
