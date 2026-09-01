//
//  Stack.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-07-20.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation

public struct Queue<T: Equatable>  {
    
    var items: [T] {
        return lock.withReadLock {
            return self._items
        }
    }
    
    public var isEmpty: Bool {
        return lock.withReadLock {
            return items.isEmpty
        }
    }
    
    public var length: Int {
        return lock.withReadLock {
            return items.count
        }
    }
    
    private let lock = ReadWriteLock()
    
    private var _items: [T]
    
    public init() {
        _items = [T]()
    }
    
    public mutating func reverse() {
        
        lock.withWriteLock {
            self._items = _items.reversed()
        }
    }
    
    public var firstIn: T? {
        
        return lock.withReadLock {
            return _items.first
        }
    }
    
    public var lastIn: T? {
        return lock.withReadLock {
            return _items.last
        }
    }
    
    mutating public func enqueue(_ item: T) {
        lock.withWriteLock {
            _items.append(item)
        }
    }
    
    public func execute(_ closure: (T) -> Void) {
        
        lock.withWriteLock {
            for item in _items {
                closure(item)
            }
        }
    }
    
    mutating public func clear() {
        
        lock.withWriteLock {
            _items.removeAll()
        }
    }
    
    @discardableResult
    mutating public func dequeue() -> T? {
        return lock.withWriteLock {
            guard !_items.isEmpty else {return nil}
            return _items.removeFirst()
        }
    }
    
    mutating public func dequeueFromItem(_ item: T) {
        return lock.withWriteLock {
            if let itemIndex = itemIndex(item) {
                for _ in 0..<itemIndex {
                    _items.removeFirst()
                }
            }
        }
    }
    
    mutating public func executeOnOlderThanItem(_ item: T, closure: (T) -> Void) {
        lock.withWriteLock {
            var afterItem = false
            for _item in _items.reversed() {
                if afterItem {
                    closure(_item)
                }
                if _item == item {
                    afterItem = true
                }
            }
        }
    }
    
    fileprivate func itemIndex(_ item: T) -> Int? {
        return lock.withReadLock {
            for (index, _item) in _items.enumerated() {
                if _item == item {
                    return index
                }
            }
            return nil
        }
    }
}
