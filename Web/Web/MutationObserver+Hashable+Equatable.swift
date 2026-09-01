//
//  MutationObserver+Hashable.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-12.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation

extension MutationObserver : Hashable {
    
    public var hashValue: Int {
        
        var h: Int = 0
        
        for record in recordQueue {
            h = h ^ record.hashValue
        }
        
        for node in nodes {
            h = h ^ node.hashValue
        }
        
        return (31 &* h.hashValue)
    }
}

public func ==(lhs: MutationObserver, rhs: MutationObserver) -> Bool {
    
    // same amount of record queue in both MutationObserver
    if lhs.recordQueue.count != rhs.recordQueue.count {
        return false
    }
    
    // for each node in lhs record, make sure there
    // is one record equal in rhs.
    // FIXME: A same record can be present two
    // times in recordQueue on both sides.
    for lhsRecord in lhs.recordQueue {
        
        var foundEqualRecord = false
        
        for rhsRecord in rhs.recordQueue {
            
            if rhsRecord == lhsRecord {
                foundEqualRecord = true
            }
        }
        if !foundEqualRecord {
            return false
        }
    }
    
    // same amount of nodes in both MutationObservers
    if lhs.nodes.count != rhs.nodes.count {
        return false
    }
    
    // for each node in lhs nodes, make sure there
    // is one node equal in rhs.
    // FIXME: A same node can be present two
    // times in nodes on both sides.
    for lhsNode in lhs.nodes {
        
        var foundEqualNode = false
        
        for rhsNode in rhs.nodes {
            
            if rhsNode == lhsNode {
                foundEqualNode = true
            }
        }
        if !foundEqualNode {
            return false
        }
    }
    
    // FIXME: find a way to compare callbacks
    
    return true
}
