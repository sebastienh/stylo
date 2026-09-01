//
//  Visitor.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-21.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public protocol Visitor: class {
    
    associatedtype NodeInfoType: NodeInfo
    
    var parentStack: Stack<NodeInfoType> { get set }
    
    func push(_ nodeInfo: NodeInfoType)
    
    // in pre order traversal, only the root node
    // knows when to remove itself from the possible
    // Visitor stack
    func pop()
    
    //
    func top() -> NodeInfoType?
}

extension Visitor {
    
    public func pop() {
        
        parentStack.pop()
    }
    
    public func push(_ nodeInfo: NodeInfoType) {
        
        parentStack.push(nodeInfo)
    }
    
    public func top() -> NodeInfoType? {
        
        return parentStack.top
    }
    
}
