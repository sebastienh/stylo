//
//  Observable.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-09-04.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import os

public protocol Observable: class {

    typealias Closure = (ChangeNotificationType) -> Void
    
    associatedtype ChangeNotificationType
    
    associatedtype ObserverClosure = Closure
    
    var listenersQueue: DispatchQueue { get }
    
    var lock: ReadWriteLock { get }
    
    var listeners: [WeakListener: ObserverClosure] { get set }
    
    var hasObservers: Bool { get }
    
    var observersCount: Int { get }
    
    func notifySubscribers(_ changeNotificationType: ChangeNotificationType, sameExecutionStack: Bool)
    
    func notifySubscribers(_ changeNotificationType: ChangeNotificationType)
    
    func subscribed(observer: Observer) -> Bool
    
    func subscribe(_ listener: ObserverClosure, observer: Observer)
    
    func unsubscribe(observer: Observer?)
    
    func unsubscribe(weakListener: WeakListener)
}

extension Observable {
    
    public var hasObservers: Bool {
        
        return self.observersCount > 0
    }
    
    public var observersCount: Int {
        return listeners.reduce(0) { (result, arg) -> Int in
            let (key, _) = arg
            return result + (key.observer != nil ? 1 : 0)
        }
    }
    
    private var __prioritySortedListeners: OrderedDictionary<WeakListener, ObserverClosure> {
        return self.listeners.sorted { (first, second) -> Bool in
            if let firstPriority = first.key.observer?.priority.rawValue {
                if let secondPriority = second.key.observer?.priority.rawValue {
                    return firstPriority > secondPriority
                }
                return true
            } else {
                if second.key.observer?.priority.rawValue != nil {
                    return false
                }
                return true
            }
        }
    }
    
    public func notifySubscribers(_ changeNotificationType: ChangeNotificationType, sameExecutionStack: Bool = false) {
    
        if sameExecutionStack {
            notifySubscribersOnSameExecutionStack(changeNotificationType)
        }
        else {
            notifySubscribers(changeNotificationType)
        }
    }
    
    public func notifySubscribersOnSameExecutionStack(_ changeNotificationType: ChangeNotificationType) {
        
        lock.withWriteLock { [weak self] in
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("start printing prioritySortedListener", log: Log.Common.stylableString, type: .info)
            for prioritySortedListener in self.prioritySortedListeners {
                os_log("prioritySortedListener: %@", log: Log.Common.stylableString, type: .info, %%prioritySortedListener.key.observer!.priority)
            }
            os_log("end printing prioritySortedListener", log: Log.Common.stylableString, type: .info)
            #endif
            
            guard let prioritySortedListeners = self?.__prioritySortedListeners else {
                assertionFailure("Error: self.prioritySortedListeners is nil")
                return
            }
            
            for (weakListener, listener) in prioritySortedListeners {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Handling subscriber with priority: %@.", log: Log.Common.stylableString, type: .info, %%weakListener.observer!.priority)
                #endif
                
                if weakListener.observer != nil {
                    if let closure = listener as? (ChangeNotificationType) -> Void {
                        closure(changeNotificationType)
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Notified subscriber %@ with notification: %@.", log: Log.Common.stylableString, type: .info, %%listener, %%changeNotificationType)
                        #endif
                    }
                }
                else {
                    
                    self?.listeners.removeValue(forKey: weakListener)
                }
            }
        }
    }
    
    public func notifySubscribers(_ changeNotificationType: ChangeNotificationType) {
        
        lock.withWriteLock { [weak self] in
            
            if let listeners = self?.__prioritySortedListeners {
            
                DispatchQueue.main.async {
                
                    for (weakListener, listener) in listeners {
                        
                        if weakListener.observer != nil {
                            
                            if let closure = listener as? (ChangeNotificationType) -> Void {
                                
                                closure(changeNotificationType)
                                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                os_log("Notified subscriber %@ with notification: %@.", log: Log.Common.stylableString, type: .info, %%listener, %%changeNotificationType)
                                #endif
                            }
                        }
                        else {
                            self?.listeners.removeValue(forKey: weakListener)
                        }
                    }
                }
            }
        }
    }
    
    public func subscribe(_ listener: ObserverClosure, observer: Observer) {
        
        if !subscribed(observer: observer) {
            
            let weakListener = WeakListener(observer: observer)
            lock.withWriteLock { [weak self] in
                self?.listeners[weakListener] = listener
            }
        }
        else {
            
//            assert(false, "already subscribed")
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("already subscribed", log: Log.Common.all, type: .debug)
            #endif
        }
    }
    
    /// Return true if the observer already observe this value.
    public func subscribed(observer: Observer) -> Bool {
        
        return lock.withReadLock { [weak self] in
            
            guard let listeners = self?.listeners else {
                assertionFailure("Error: listeners is nil")
                return false
            }
            
            for (weakListener, _) in listeners {
                if let _observer = weakListener.observer, _observer === observer {
                    return true
                }
            }
            return false
        }
    }
    
    public func unsubscribe(observer: Observer?) {
        
        let hash = observer?.hash
        
        lock.withWriteLock { [weak self] in
            if let hash = hash {
                self?.listeners.removeValue(forKey: WeakListener(key: hash))
            }
        }
    }
    
    public func unsubscribe(weakListener: WeakListener) {
        
        lock.withWriteLock { [weak self] in
            self?.listeners.removeValue(forKey: weakListener)
        }
    }
}
