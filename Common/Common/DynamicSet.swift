//
//  DynamicSet.swift
//  Common
//
//  Created by Sebastien hamel on 2019-07-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

public final class DynamicSet<T: Hashable>: NSObject, Observable, Observer {
    
    public var priority: ObserverPriority {
        return .background
    }
    
    public let lock = ReadWriteLock()
    
    public let listenersQueue = DispatchQueue(label: "net.textually.DynamicSet.Listeners", attributes: .concurrent)
    
    public enum SetChange {
        
        case inserts(values: [T], updatedSet: Set<T>)
        case deletes(values: [T], updatedSet: Set<T>)
        
        public var updatedValues: Set<T> {
            switch self {
            case .inserts(_, let updatedSet):
                return updatedSet
            case .deletes(_, let updatedSet):
                return updatedSet
            }
        }
    }
    
    public typealias SetClosure = (SetChange) -> Void
    
    fileprivate var closures: [SetClosure]
    
    public var values: Set<T>
    
    public var count: Int {
        
        return values.count
    }
    
    public override init() {
        
        self.values = Set<T>()
        self.closures = [SetClosure]()
        self.listeners = [WeakListener: SetClosure]()
        super.init()
    }
    
    public convenience init(_ a: Array<T>) {
        
        self.init(Set<T>(a))
    }
        
    public init(_ v: Set<T>) {
        
        self.values = v
        self.closures = [SetClosure]()
        self.listeners = [WeakListener: SetClosure]()
    }
    
    public func contains(_ member: T) -> Bool {
        
        return self.values.contains(member)
    }
    
    public func bind(to other: DynamicSet<T>) {
        
        other.subscribe({ [weak self](change) in
            self?.applyChange(change)
        }, observer: self)
    }
    
    public func unbind(from other: DynamicSet<T>) {
        other.unsubscribe(observer: self)
    }
    
    public func remove(_ member: T, notify: Bool = true, sameExecutionStack: Bool = false) {
        
        guard self.values.remove(member) != nil else {
            return
        }
        guard notify else {
            return
        }
        if sameExecutionStack {
            notifySubscribersOnSameExecutionStack(.deletes(values: [member], updatedSet: values))
        }
        else {
            notifySubscribers(.deletes(values: [member], updatedSet: values))
        }
    }
    
    public func removeAll(notify: Bool = true, sameExecutionStack: Bool = false) {
        
        self.remove(Array(self.values), notify: notify, sameExecutionStack: sameExecutionStack)
    }
    
    public func remove(_ members: [T], notify: Bool = true, sameExecutionStack: Bool = false) {
        
        let existingMembers = members.filter { (member) -> Bool in
            return self.values.contains(member)
        }
        
        guard !existingMembers.isEmpty else {
            return
        }
        
        for existingMember in existingMembers {
            self.values.remove(existingMember)
        }
        guard notify else {
            return
        }
        if sameExecutionStack {
            notifySubscribersOnSameExecutionStack(.deletes(values: existingMembers, updatedSet: values))
        }
        else {
            notifySubscribers(.deletes(values: existingMembers, updatedSet: values))
        }
    }
    
    public func insert(_ member: T, notify: Bool = true, sameExecutionStack: Bool = false) {
        
        guard !self.values.contains(member) else {
            return
        }
        self.values.insert(member)
        guard notify else {
            return
        }
        if sameExecutionStack {
            notifySubscribersOnSameExecutionStack(.inserts(values: [member], updatedSet: values))
        }
        else {
            notifySubscribers(.inserts(values: [member], updatedSet: values))
        }
    }

    public func insert(_ members: Set<T>, notify: Bool = true, sameExecutionStack: Bool = false) {
        
        let absentMembers = members.filter { (member) -> Bool in
            return !self.values.contains(member)
        }.map { (value) -> T in
            return value
        }
        
        guard !absentMembers.isEmpty else {
            return
        }
        
        for absentMember in absentMembers {
            self.values.insert(absentMember)
        }
        guard notify else {
            return
        }
        let change = DynamicSet<T>.SetChange.inserts(values: absentMembers, updatedSet: values)
        if sameExecutionStack {
            notifySubscribersOnSameExecutionStack(change)
        }
        else {
            notifySubscribers(change)
        }
    }
    
    public func insert(_ members: [T], notify: Bool = true, sameExecutionStack: Bool = false) {
        
        let absentMembers = members.filter { (member) -> Bool in
            return !self.values.contains(member)
        }
        
        guard !absentMembers.isEmpty else {
            return
        }
        
        for absentMember in absentMembers {
            self.values.insert(absentMember)
        }
        guard notify else {
            return
        }
        let change = DynamicSet<T>.SetChange.inserts(values: absentMembers, updatedSet: values)
        if sameExecutionStack {
            notifySubscribersOnSameExecutionStack(change)
        }
        else {
            notifySubscribers(change)
        }
    }
    
    private func applyChange(_ change: SetChange) {
        switch change {
        case .deletes(let values, _):
            self.remove(values)
        case .inserts(let values, _):
            self.insert(values)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Observable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public typealias ChangeNotificationType = SetChange
    
    public var listeners: [WeakListener : (DynamicSet<T>.SetChange) -> Void]
    
}
