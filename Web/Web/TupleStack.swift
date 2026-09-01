//
//  TupleStack.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-05-27.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

public struct TupleStack<T: Equatable> {
    
    var items: [T]
    
    public var isEmpty: Bool {
        
        return items.isEmpty
    }
    
    public var length: Int {
        
        return items.count
    }
    
    internal init() {
        items = [T]()
    }
    
    public mutating func reverse() {
        
        self.items = items.reversed()
    }
    
    public var top: T? {
        
        return items.last
    }
    
    mutating public func push(_ item: T) {
        
        if items.count == 2 {
            
            items.removeFirst()
        }
        
        items.append(item)
    }
    
    mutating public func pop() -> T {
        
        return items.removeLast()
    }
    
    func isSuite(_ firstItem: T, secondItem: T) -> Bool {
        
        if items.count != 2 {
         
            return false
        }
        
        if items.first! != firstItem {
            
            return false
        }
        
        if items[1] != secondItem {
            
            return false
        }
        
        return true
    }
    
}
