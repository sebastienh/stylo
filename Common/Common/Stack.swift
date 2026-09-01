//
//  Stack.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-07-20.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation

public struct Stack<T>  {
    
    var items: [T]
    
    public var isEmpty: Bool {
        return items.isEmpty
    }
    
    public var count: Int {
        return items.count
    }
    
    public subscript(safe index: Int) -> T? {
        if index >= 0 && index < self.items.count {
            return self.items[index]
        }
        return nil
    }
    
    public init() {
        items = [T]()
    }
    
    public mutating func reverse() {
        
        self.items = items.reversed()
    }
    
    public func copy<C>(filter: (T) -> C?) -> Stack<C> {
        
        var result = Stack<C>()
        var copy = self
        copy.reverse()
        for item in copy.items {
            
            if let value = filter(item) {
                result.push(value)
            }
        }
        return result
    }
    
    public var top: T? {
        
        get {
            guard !self.isEmpty else {
                return nil
            }
            
            return items[items.count - 1]
        }
        set {
            
            if let newValue = newValue {
                
                if items.isEmpty {
                    
                    items.append(newValue)
                }
                else {
                    
                    items[items.count - 1] = newValue
                }
            }
        }
    }
    
    public var underTop: T? {
        
        guard self.items.count >= 2 else {
            return nil
        }
        
        return items[items.count - 2]
    }
    
    mutating public func push(_ item: T) {
        
        items.append(item)
    }
    
    mutating public func execute(_ closure: (T) -> Void) {
        
        for item in items {
            closure(item)
        }
    }
    
    mutating public func clear() {
        
        items.removeAll()
    }

    @discardableResult
    mutating public func safePop() -> T? {
        guard !items.isEmpty else {
            // assertionFailure("Error: items is empty")
            return nil
        }
        return items.removeLast()
    }
    
    @discardableResult
    mutating public func pop() -> T {
        
        return items.removeLast()
    }
    
    @discardableResult
    mutating public func popFront() -> T {
        
        return items.removeFirst()
    }
    
}
