//
//  Dynamic.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-06-02.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import os

open class Dynamic<T>: NSObject, Observable, Observer {
    
    public var priority: ObserverPriority {
        return .background
    }
    
    public let lock = ReadWriteLock()
    
    public let listenersQueue = DispatchQueue(label: "net.textually.Dynamic.Listeners", qos: DispatchQoS.userInteractive, attributes: .concurrent)
    
    /// We should remove this... this is the backdoor we shouln't
    /// come from here to change this value. We should keep this when
    /// we want to modify the value without notifying subscribers.
    public var value: T
    
    public init(_ v: T) {
        
        value = v
        listeners = [WeakListener: ObserverClosure]()
    }
    
    public func setValue(_ newValue: T, notify: Bool = true, sameExecutionStack: Bool = false) {
        
        self.value = newValue
        guard notify else {
            return
        }
        
        if sameExecutionStack {
            notifySubscribersOnSameExecutionStack(newValue)
        }
        else {
            notifySubscribers(newValue)
        }
        
    }
   
    public func bind(to other: Dynamic<T>) {
        other.subscribe({ [weak self](newValue) in
            self?.setValue(newValue)
        }, observer: self)
    }
    
    public func unbind(from other: Dynamic<T>) {
        other.unsubscribe(observer: self)
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Observable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public typealias ChangeNotificationType = T
    
    public typealias ObserverClosure = (T) -> Void
    
    public var listeners: [WeakListener: ObserverClosure]

}
