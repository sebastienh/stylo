//
//  AncestorSetItem.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-05-29.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public struct AncestorSetItem<AncestorType : Hashable> : Hashable, Comparable {
    
    public let ancestor: AncestorType
    
    public var cumulatedOrder: Int = 0
    
    public var hashValue: Int {
        
        return ancestor.hashValue
    }
    
    public init(ancestor: AncestorType) {
        
        self.ancestor = ancestor
    }
    
    public mutating func increaseCumulatedOrder(_ increaseValue: Int) {
        
        self.cumulatedOrder += increaseValue
    }
}

public func ==<AncestorType>(lhs: AncestorSetItem<AncestorType>, rhs: AncestorSetItem<AncestorType>) -> Bool {
    
    return lhs.hashValue == rhs.hashValue
}

public func <<AncestorType>(lhs: AncestorSetItem<AncestorType>, rhs: AncestorSetItem<AncestorType>) -> Bool {
    
    return lhs.cumulatedOrder < rhs.cumulatedOrder
}
