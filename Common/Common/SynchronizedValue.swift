//
//  SynchronizedValue.swift
//  Common
//
//  Created by Sebastien hamel on 2019-02-24.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

/// A thread-safe array.
public class SynchronizedValue<Element> {
    
    fileprivate let queue = DispatchQueue(label: "net.textually.SynchronizedElement", attributes: .concurrent)
    
    private var _value: Element
    
    /// We should remove this... this is the backdoor we shouln't
    /// come from here to change this value. We should keep this when
    /// we want to modify the value without notifying subscribers.
    public internal(set) var value: Element {
        
        get {
            return queue.sync {
                return _value
            }
        }
        set {
            queue.async(flags: .barrier) {
                self._value = newValue
            }
        }
    }
    
    init(value: Element) {
        _value = value
    }
    
}
