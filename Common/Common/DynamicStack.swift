//
//  DynamicStack.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-03-23.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public final class DynamicStack<T>: NSObject, Observable, Observer {

    public let lock = ReadWriteLock()
    
    public var priority: ObserverPriority {
        return .background
    }
    
    public let listenersQueue = DispatchQueue(label: "net.textually.DynamicStack.Listeners", attributes: .concurrent)
    
    public enum Change {
        
        case push(newElement: T, updatedStack: Stack<T>)
        case pop(popedElement: T, updatedStack: Stack<T>)
        case popFront(popedElement: T, updatedStack: Stack<T>)
        case start(sourceStack: Stack<T>, destinationStack: Stack<T>)
        case end(updatedStack: Stack<T>)
        
        public var updatedStack: Stack<T>? {
            switch self {
            case .pop(_, let updatedStack):
                return updatedStack
            case .push(_, let updatedStack):
                return updatedStack
            case .end(let updatedStack):
                return updatedStack
            case .start:
                return nil
            case .popFront(_, let updatedStack):
                return updatedStack
            }
        }
    }
    
    public typealias ObserverClosure = (Change) -> Void
    
    public var isEmpty: Bool {
        
        return values.isEmpty
    }
    
    public var count: Int {
        
        return values.count
    }
    
    public var values: Stack<T>
    
    public var top: T? {
        return values.top
    }
    
    public var items: [T] {
        return self.values.items
    }
    
    public subscript(safe index: Int) -> T? {
    
        get {
            if index >= 0 && index < self.values.count {
                return values[safe: index]
            }
            return nil
        }
    }
    
    public override init() {
        
        values = Stack<T>()
        listeners = [WeakListener : (DynamicStack<T>.Change) -> Void]()
        super.init()
    }
    
    public convenience init(_ s: Stack<T>) {
        
        self.init(s, selectedIndexes: [])
    }
    
    public init(_ s: Stack<T>, selectedIndexes: [Int]) {
        
        values = s
        listeners = [WeakListener : (DynamicStack<T>.Change) -> Void]()
    }
    
    public func bind(to other: DynamicStack<T>) {

        other.subscribe({ [weak self](change) in
            self?.applyChange(change)
        }, observer: self)
    }

    public func unbind(from other: DynamicStack<T>) {
        other.unsubscribe(observer: self)
    }
    
    public func push(_ newElement: T, notify: Bool = true, sameExecutionStack: Bool = false, withStartAndEndEvents: Bool = false) {
        
        let sourceStack: Stack<T> = self.values
        self.values.push(newElement)
        
        guard notify else {
            return
        }
        
        if withStartAndEndEvents {
            self.sendStartNotification(sourceStack: sourceStack, destinationStack: self.values, sameExecutionStack: sameExecutionStack)
        }
        
        notifySubscribers(.push(newElement: newElement, updatedStack: self.values), sameExecutionStack: sameExecutionStack)
        
        if withStartAndEndEvents {
            self.sendEndNotification(updatedStack: self.values, sameExecutionStack: sameExecutionStack)
        }
    }
    
    public func clear(notify: Bool = true, sameExecutionStack: Bool = false) {
        while !self.isEmpty {
            self.pop(notify: notify, sameExecutionStack: sameExecutionStack)
        }
    }
    
    public func popFront(notify: Bool = true, sameExecutionStack: Bool = false) {
        
        let deletedValue = values.popFront()
        
        guard notify else {
            return
        }
        
        notifySubscribers(.popFront(popedElement: deletedValue, updatedStack: self.values), sameExecutionStack: sameExecutionStack)
    }
    
    public func pop(notify: Bool = true, sameExecutionStack: Bool = false) {
        
        guard let deletedValue = values.safePop() else {
//             assertionFailure("Error: deletedValue is nil")
            return
        }
        
        guard notify else {
            return
        }

        notifySubscribers(.pop(popedElement: deletedValue, updatedStack: self.values), sameExecutionStack: sameExecutionStack)
    }
    
    func applyChange(_ change: DynamicStack<T>.Change, sameExecutionStack: Bool = false) {
        
        switch change {
        case .push(let newElement, _):
            self.push(newElement, notify: true, sameExecutionStack: sameExecutionStack, withStartAndEndEvents: false)
        case .pop(_, _):
            self.pop(notify: true, sameExecutionStack: sameExecutionStack)
        case .start(let sourceStack, let destinationStack):
            notifySubscribersOnSameExecutionStack(.start(sourceStack: sourceStack, destinationStack: destinationStack))
        case .end(let updatedStack):
            notifySubscribersOnSameExecutionStack(.end(updatedStack: updatedStack))
        case .popFront(_, _):
            self.popFront(notify: true, sameExecutionStack: sameExecutionStack)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Observable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var listeners: [WeakListener : (DynamicStack<T>.Change) -> Void]
    
    private func sendStartNotification(sourceStack: Stack<T>, destinationStack: Stack<T>,  sameExecutionStack: Bool = false) {
        
        notifySubscribers(.start(sourceStack: sourceStack, destinationStack: destinationStack) , sameExecutionStack: sameExecutionStack)
    }
    
    private func sendEndNotification(updatedStack: Stack<T>, sameExecutionStack: Bool = false) {
        
        notifySubscribers(.end(updatedStack: updatedStack), sameExecutionStack: sameExecutionStack)
    }
    
    public typealias ChangeNotificationType = Change
}
