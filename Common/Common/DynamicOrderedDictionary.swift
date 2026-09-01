//
//  DynamicOrderedDictionary.swift
//  Common-mac
//
//  Created by Sebastien hamel on 2019-08-28.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation


open class DynamicOrderedDictionary<K: Hashable, V>: Observable {
    
    public let listenersQueue = DispatchQueue(label: "net.textually.DynamicOrderedDictionary.Listeners", attributes: .concurrent)
    
    public let lock = ReadWriteLock()
    
    public enum Change {
        
        case deletes(removedValues: OrderedDictionary<K, V>, udpatedValues: OrderedDictionary<K, V>)
        case updates(keys: [K], udpatedValues: OrderedDictionary<K, V>)
        case insert(element: (K, V), index: Int, udpatedValues: OrderedDictionary<K, V>)
        case move(element: (K, V), sourceIndex: Int, targetIndex: Int, udpatedValues: OrderedDictionary<K, V>)
        case start(source: OrderedDictionary<K, V>, destination: OrderedDictionary<K, V>)
        case end(updatedDictionary: OrderedDictionary<K, V>)
    }
    
    
    public typealias ObserverClosure = (Change) -> Void
    
    public var values: OrderedDictionary<K, V>
    
    public var count: Int {
        
        return values.count
    }
    
    public init() {
        
        self.values = OrderedDictionary<K, V>()
        listeners = [WeakListener : (DynamicOrderedDictionary<K, V>.Change) -> Void]()
    }
    
    public init(_ v: OrderedDictionary<K, V>, selectedKeys: [K]) {
        
        self.values = v
        listeners = [WeakListener : (DynamicOrderedDictionary<K, V>.Change) -> Void]()
    }
    
    /// The new index is before the removal of the target element,
    /// since we can only know the target index after having removed it...
    public func move(elementAt index: Int, to targetIndex: Int, notify: Bool = true, sameExecutionStack: Bool = false) {
        
        guard index != targetIndex else {
            return
        }
        
        guard let value = self.values.remove(at: index) else {
            assertionFailure("Error: value is nil")
            return
        }
        
        let adjustedTargetIndex: Int = targetIndex > index ? targetIndex-1 : targetIndex
        
        // now target index is one less
        self.values.insert(value, at: adjustedTargetIndex)
        
        guard notify else {
            return
        }
        
        notifySubscribers(.move(element: value, sourceIndex: index, targetIndex: targetIndex, udpatedValues: self.values), sameExecutionStack: sameExecutionStack)
    }
    
    public func removeAll(notify: Bool = true, sameExecutionStack: Bool = false) {
        
        let removedValues = self.values
        self.values.removeAll()
        
        let change: DynamicOrderedDictionary<K, V>.Change = .deletes(removedValues: removedValues, udpatedValues: self.values)
        
        guard notify else {
            return
        }
        
        if sameExecutionStack {
            notifySubscribersOnSameExecutionStack(change)
        }
        else {
            notifySubscribers(change)
        }
    }
    
    @discardableResult
    public func removeValue(forKey key: K, notify: Bool = true, sameExecutionStack: Bool = false) -> V? {
        
        if let value = self.values.removeValue(forKey: key) {
            
            let change: DynamicOrderedDictionary<K, V>.Change = .deletes(removedValues: [key: value], udpatedValues: self.values)
            
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

    @discardableResult
    public func removeValue(atIndex index: Int, notify: Bool = true, sameExecutionStack: Bool = false) -> V? {

        if let (key, value) = self.values.remove(at: index) {
            
            let change: DynamicOrderedDictionary<K, V>.Change = .deletes(removedValues: [key: value], udpatedValues: self.values)
            
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
    
    public func insertValue(_ value: V, forKey key: K, at index: Int, notify: Bool = true, sameExecutionStack: Bool = false) {

        self.values.insert(OrderedDictionary.Element(key: key, value: value), at: index)
        
        let change: DynamicOrderedDictionary<K, V>.Change = .insert(element: (key, value), index: index, udpatedValues: self.values)
        
        guard notify else {
            return
        }
        
        if sameExecutionStack {
            notifySubscribersOnSameExecutionStack(change)
        }
        else {
            notifySubscribers(change)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Edits
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func applyMoves(to destination: OrderedDictionary<K, V>, notify: Bool = true, sameExecutionStack: Bool = false, withStartAndEndEvents: Bool = false) {
        
        let source = self.values
        let moves = source.movesOperations(to: destination)
        
        
        if withStartAndEndEvents && notify {
            self.sendStartNotification(source: source, destination: destination, sameExecutionStack: sameExecutionStack)
        }
        
        for move in moves {
            self.move(elementAt: move.source, to: move.destination, notify: notify, sameExecutionStack: sameExecutionStack)
        }
        
        if withStartAndEndEvents && notify {
            self.sendEndNotification(updatedDictionary: self.values, sameExecutionStack: sameExecutionStack)
        }
    }
    
    public func applyEdits(to destination: OrderedDictionary<K, V>, notify: Bool = true, sameExecutionStack: Bool = false, withStartAndEndEvents: Bool = false) {
        
        let source = self.values
        let edits = source.editOperations(to: destination)
        
        
        if withStartAndEndEvents && notify {
            self.sendStartNotification(source: source, destination: destination, sameExecutionStack: sameExecutionStack)
        }
        
        var factor = 0
        
        // delete pass
        for edit in edits {
            switch edit {
            case .delete(let index):
                self.removeValue(atIndex: index+factor, notify: notify, sameExecutionStack: sameExecutionStack)
                factor -= 1
            default:
                break
            }
        }
        
        factor = 0
        
        // addition pass
        for edit in edits {
            switch edit {
            case .add(let index, let key, let value):
                self.insertValue(value, forKey: key, at: index+factor, notify: notify, sameExecutionStack: sameExecutionStack)
                factor += 1
            case .delete:
                factor -= 1
            }
        }
        
        if withStartAndEndEvents && notify {
            self.sendEndNotification(updatedDictionary: self.values, sameExecutionStack: sameExecutionStack)
        }
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Observable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var listeners: [WeakListener : (Change) -> Void]
    
    private func sendStartNotification(source: OrderedDictionary<K, V>, destination: OrderedDictionary<K, V>,  sameExecutionStack: Bool = false) {
        
        notifySubscribers(.start(source: source, destination: destination) , sameExecutionStack: sameExecutionStack)
    }
    
    private func sendEndNotification(updatedDictionary: OrderedDictionary<K, V>,  sameExecutionStack: Bool = false) {
        
        notifySubscribers(.end(updatedDictionary: updatedDictionary) , sameExecutionStack: sameExecutionStack)
    }
    
    public typealias ChangeNotificationType = Change
    
}
