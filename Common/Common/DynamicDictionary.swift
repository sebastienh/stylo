//
//  DynamicDictionary.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-09-03.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation

open class DynamicDictionary<K: Hashable, V>: Observable {

    public let lock = ReadWriteLock()
    
    public let listenersQueue = DispatchQueue(label: "net.textually.DynamicDictionary.Listeners", attributes: .concurrent)
    
    public enum DictionaryChange {
        case start(sourceDict: [K:V], destinationDict: [K:V])
        case end(updatedDict: [K:V])
        case deletes(removedValues: Dictionary<K, V>, updatedValues: Dictionary<K, V>)
        case updates(keys: [K], updatedValues: Dictionary<K, V>)
        
        public var udpatedValues: Dictionary<K, V> {
            switch self {
            case .start(_, let destinationDict):
                return destinationDict
            case .end(let updatedDict):
                return updatedDict
            case .deletes(_, let updatedValues):
                return updatedValues
            case .updates(_, let updatedValues):
                return updatedValues
            }
        }
    }
    
    public typealias ObserverClosure = (DictionaryChange) -> Void
    
    public var values: Dictionary<K, V>
    
    public var count: Int {
        
        return values.count
    }
    
    public init() {
        
        self.values = Dictionary<K, V>()
        listeners = [WeakListener : (DynamicDictionary<K, V>.DictionaryChange) -> Void]()
    }
    
    public init(_ v: Dictionary<K, V>, selectedKeys: [K] = []) {
        
        self.values = v
        listeners = [WeakListener : (DynamicDictionary<K, V>.DictionaryChange) -> Void]()
    }

    public func update(withValues values: [K:V], notify: Bool = true, sameExecutionStack: Bool = false, withStartAndEndEvents: Bool = false) {
        
        let sourceDict: [K: V] = self.values
        for (key, value) in values {
            self.values[key] = value
        }
        
        guard notify else {
            return
        }
        
        if withStartAndEndEvents {
            self.sendStartNotification(sourceDict: sourceDict, destinationDict: self.values, sameExecutionStack: sameExecutionStack)
        }
        
        notifySubscribers(.updates(keys: Array<K>(values.keys), updatedValues: self.values), sameExecutionStack: sameExecutionStack)
        
        if withStartAndEndEvents {
            self.sendEndNotification(updatedDict: self.values, sameExecutionStack: sameExecutionStack)
        }
    }
    
    
    public func removeAll(notify: Bool = true, sameExecutionStack: Bool = false, withStartAndEndEvents: Bool = false) {
        
        let sourceDict: [K: V] = self.values
        let deletedValues = values
        values.removeAll(keepingCapacity: true)
        
        guard notify else {
            return
        }
        
        if withStartAndEndEvents {
            self.sendStartNotification(sourceDict: sourceDict, destinationDict: self.values, sameExecutionStack: sameExecutionStack)
        }
        
        notifySubscribers(.deletes(removedValues: deletedValues, updatedValues: self.values), sameExecutionStack: sameExecutionStack)
        
        if withStartAndEndEvents {
            self.sendEndNotification(updatedDict: self.values, sameExecutionStack: sameExecutionStack)
        }
    }
    
    @discardableResult
    public func removeValue(forKey key: K, notify: Bool = true, sameExecutionStack: Bool = false) -> V? {
        
        if let value = self.values.removeValue(forKey: key) {
        
            let change: DynamicDictionary<K, V>.DictionaryChange = .deletes(removedValues: [key: value], updatedValues: self.values)
            
            guard notify else {
                return value
            }
            
            if sameExecutionStack {
                notifySubscribersOnSameExecutionStack(change)
            }
            else {
                notifySubscribers(change)
            }

            return value
        }
        return nil
    }

    public func updateValue(_ value: V, forKey key: K, notify: Bool = true, sameExecutionStack: Bool = false) {
        
        self.values.updateValue(value, forKey: key)
        
        let change: DynamicDictionary<K, V>.DictionaryChange = .updates(keys: [key], updatedValues: self.values)
        
        guard notify else {
            return
        }
        
        if sameExecutionStack {
            notifySubscribersOnSameExecutionStack(change)
        }
        else {
            notifySubscribers(change)
        }
    } //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Observable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var listeners: [WeakListener : (DictionaryChange) -> Void]
    
    private func sendStartNotification(sourceDict: [K:V], destinationDict: [K:V],  sameExecutionStack: Bool = false) {
        
        notifySubscribers(.start(sourceDict: sourceDict, destinationDict: destinationDict) , sameExecutionStack: sameExecutionStack)
    }
    
    private func sendEndNotification(updatedDict: [K:V],  sameExecutionStack: Bool = false) {
        
        notifySubscribers(.end(updatedDict: updatedDict) , sameExecutionStack: sameExecutionStack)
    }
    
    public typealias ChangeNotificationType = DictionaryChange
    
}
