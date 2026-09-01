//
//  AtomicProperty.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-10-17.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Atomic<Value> {

    private let lock: ReadWriteLock
    private var value: Value

    public init(wrappedValue: Value) {
        self.value = wrappedValue
        self.lock = ReadWriteLock()
    }
    
    public var wrappedValue: Value {
        get {
            lock.readLock()
            let value = self.value
            lock.unlock()
            return value
        }
        set {
            lock.writeLock()
            self.value = newValue
            lock.unlock()
        }
    }
}
