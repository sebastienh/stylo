//
//  DynamicArray.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-07-16.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation

public final class DynamicArray<T>: NSObject, Observable, Observer {

    public var priority: ObserverPriority {
        return .background
    }
    
    public let lock = ReadWriteLock()
    
    public let listenersQueue = DispatchQueue(label: "net.textually.DynamicArray.Listeners", attributes: .concurrent)
    
    public enum Change {
        
        case insert(newElement: T, index: Int, updatedArray: [T])
        case inserts(newElements: [T], indexes: [Int], updatedArray: [T])
        case deletes(indexes: [Int], deletedValues: [T], updatedArray: [T])
        case move(element: T, sourceIndex: Int, targetIndex: Int, updatedArray: [T])
        case start(sourceArray: [T], destinationArray: [T])
        case end(updatedArray: [T])
        
        public var updatedArray: Array<T>? {
            switch self {
            case .deletes(_, _, let updatedArray):
                return updatedArray
            case .insert(_, _, let updatedArray):
                return updatedArray
            case .inserts(_, _, let updatedArray):
                return updatedArray
            case .move(_, _, _, let updatedArray):
                return updatedArray
            case .end(let updatedArray):
                return updatedArray
            case .start:
                return nil
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
    
    public var values: Array<T>
    
    public var first: T? {
        
        return values.first
    }
    
    public subscript(safe index: Int) -> T? {
    
        get {
            return values.indices.contains(index) ? values[index] : nil
        }
        set {
            if let newValue = newValue {
                values[index] = newValue
            }
        }
    }
    
    public override init() {
        
        values = Array<T>()
        listeners = [WeakListener : (DynamicArray<T>.Change) -> Void]()
        super.init()
    }
    
    public convenience init(_ a: Array<T>) {
        
        self.init(a, selectedIndexes: [])
    }
    
    public init(_ v: Array<T>, selectedIndexes: [Int]) {
        
        values = v
        listeners = [WeakListener : (DynamicArray<T>.Change) -> Void]()
    }
    
    public func bind(to other: DynamicArray<T>) {

        other.subscribe({ [weak self](change) in
            self?.applyChange(change)
        }, observer: self)
    }

    public func unbind(from other: DynamicArray<T>) {
        other.unsubscribe(observer: self)
    }
    
    public func replaceItems(withItems items: [T], notify: Bool = true, sameExecutionStack: Bool = false) {
        
        guard notify else {
            return
        }
        
        self.sendStartNotification(sourceArray: self.values, destinationArray: items, sameExecutionStack: sameExecutionStack)
        self.values = items
        self.sendEndNotification(updatedArray: self.values, sameExecutionStack: sameExecutionStack)
    }
    
    /// The new index is before the removal of the target element,
    /// since we can only know the target index after having removed it...
    public func move(elementAt index: Int, to targetIndex: Int, notify: Bool = true, sameExecutionStack: Bool = false) {
        
        guard index != targetIndex else {
            return
        }
        
        let value = self.values.remove(at: index)
        
        let adjustedTargetIndex: Int = targetIndex > index ? targetIndex-1 : targetIndex
        
        if adjustedTargetIndex < self.values.count {
        
            // now target index is one less
            self.values.insert(value, at: adjustedTargetIndex)
        }
        else {
            self.values.append(value)
        }
        
        guard notify else {
            return
        }
        
        notifySubscribers(.move(element: value, sourceIndex: index, targetIndex: targetIndex, updatedArray: self.values), sameExecutionStack: sameExecutionStack)
    }
    
    public func insert(newElements: [T], at indexes: [Int], notify: Bool = true, sameExecutionStack: Bool = false) {

        assert(newElements.count == indexes.count, "Error: newElements count: \(newElements.count) is not equal to indexes count: \(indexes)")
        assert(indexes.sorted() == indexes, "Error: indexes must be sorted")

        for (index, insertionIndex) in indexes.enumerated() {
            let newElement = newElements[index]
            if insertionIndex == self.values.count {
                self.values.append(newElement)
                assert(insertionIndex == self.values.count-1)
            }
            else {
                self.values.insert(newElement, at: insertionIndex)
            }
        }

        guard notify else {
            return
        }
        
        notifySubscribers(.inserts(newElements: newElements, indexes: indexes, updatedArray: self.values), sameExecutionStack: sameExecutionStack)
    }
    
    public func insert(_ newElement: T, at i: Int, notify: Bool = true, sameExecutionStack: Bool = false, withStartAndEndEvents: Bool = false) {
        
        let sourceArray: [T] = self.values
        if i < self.values.count {
            self.values.insert(newElement, at: i)
        }
        else {
            self.values.append(newElement)
        }
        
        guard notify else {
            return
        }
        
        if withStartAndEndEvents {
            self.sendStartNotification(sourceArray: sourceArray, destinationArray: self.values, sameExecutionStack: sameExecutionStack)
        }
        
        notifySubscribers(.insert(newElement: newElement, index: i, updatedArray: self.values), sameExecutionStack: sameExecutionStack)
        
        if withStartAndEndEvents {
            self.sendEndNotification(updatedArray: self.values, sameExecutionStack: sameExecutionStack)
        }
    }
    
    
    
    public func replaceAll(withItem item: T, notify: Bool = true, sameExecutionStack: Bool = false, withStartAndEndEvents: Bool = false) {
        
        let sourceArray: [T] = self.values
        
        values.removeAll(keepingCapacity: true)
        values.append(item)
        
        if withStartAndEndEvents {
            self.sendStartNotification(sourceArray: sourceArray, destinationArray: self.values, sameExecutionStack: sameExecutionStack)
        }
        
        notifySubscribers(.deletes(indexes: Array(0..<sourceArray.count), deletedValues: sourceArray, updatedArray: self.values), sameExecutionStack: sameExecutionStack)
        
        notifySubscribers(.insert(newElement: item, index: values.count-1, updatedArray: self.values), sameExecutionStack: sameExecutionStack)
        
        if withStartAndEndEvents {
            self.sendEndNotification(updatedArray: self.values, sameExecutionStack: sameExecutionStack)
        }
    }
    
    
    public func removeAll(notify: Bool = true, sameExecutionStack: Bool = false, withStartAndEndEvents: Bool = false) {
        
        let sourceArray: [T] = self.values
        let oldCount = self.values.count
        let deletedValued = values
        values.removeAll(keepingCapacity: true)
        
        guard notify else {
            return
        }
        
        if withStartAndEndEvents {
            self.sendStartNotification(sourceArray: sourceArray, destinationArray: self.values, sameExecutionStack: sameExecutionStack)
        }
        
        notifySubscribers(.deletes(indexes: Array(0..<oldCount), deletedValues: deletedValued, updatedArray: self.values), sameExecutionStack: sameExecutionStack)
        
        if withStartAndEndEvents {
            self.sendEndNotification(updatedArray: self.values, sameExecutionStack: sameExecutionStack)
        }
    }
    
    public func append(_ item: T, notify: Bool = true, sameExecutionStack: Bool = false, withStartAndEndEvents: Bool = false) {
        
        let sourceArray = self.values 
        values.append(item)
        
        guard notify else {
            return
        }
        
        if withStartAndEndEvents {
            self.sendStartNotification(sourceArray: sourceArray, destinationArray: self.values, sameExecutionStack: sameExecutionStack)
        }
        
        let arrayChange: DynamicArray<T>.Change = .insert(newElement: item, index: values.count-1, updatedArray: self.values)
        notifySubscribers(arrayChange, sameExecutionStack: sameExecutionStack)
        
        if withStartAndEndEvents {
            self.sendEndNotification(updatedArray: self.values, sameExecutionStack: sameExecutionStack)
        }
    }
    
    public func append<S>(contentsOf newElements: S, notify: Bool = true) where S : Sequence, Element == S.Element {
    
        let firstInsertIndex = values.count
        values.append(contentsOf: newElements)
        
        guard notify else {
            return
        }
        
        notifySubscribers(.inserts(newElements: self.values, indexes: Array(firstInsertIndex..<values.count), updatedArray: self.values))
    }
    
    public func remove(atIndex index: Int, notify: Bool = true, sameExecutionStack: Bool = false) {
        
        let deletedValue = values.remove(at: index)
        
        guard notify else {
            return
        }
        
        notifySubscribers(.deletes(indexes: [index], deletedValues: [deletedValue], updatedArray: self.values), sameExecutionStack: sameExecutionStack)
    }
    
    public func remove(atIndexes indexes: [Int], notify: Bool = true, sameExecutionStack: Bool = false) {
        
        assert(indexes.sorted() == indexes, "indexes should be sorted in ascending order")
        var deletedIndexes = [Int]()
        var deletedValues = [T]()
        
        // start from the end
        for index in indexes.reversed() {
            if index < self.values.count {
                let value = self.values.remove(at: index)
                deletedValues.append(value)
                deletedIndexes.append(index)
            }
        }
        
        guard !deletedIndexes.isEmpty else {
            return
        }
        
        guard notify else {
            return
        }
        
        let arrayChange: DynamicArray<T>.Change = .deletes(indexes: deletedIndexes.sorted(), deletedValues: deletedValues, updatedArray: self.values)
        notifySubscribers(arrayChange, sameExecutionStack: sameExecutionStack)
    }
    
    func applyChange(_ change: DynamicArray<T>.Change, sameExecutionStack: Bool = false) {
        
        switch change {
        case .deletes(let indexes, _, _):
            self.remove(atIndexes: indexes.sorted(), sameExecutionStack: true)
        case .insert(let newElement, let index, _):
            self.insert(newElement, at: index, sameExecutionStack: true)
        case .inserts(let newElements, let indexes, _):
            self.insert(newElements: newElements, at: indexes.sorted(), sameExecutionStack: true)
        case .move(_, let sourceIndex, let targetIndex, _):
            self.move(elementAt: sourceIndex, to: targetIndex)
        case .start(let sourceArray, let destinationArray):
            notifySubscribersOnSameExecutionStack(.start(sourceArray: sourceArray, destinationArray: destinationArray))
        case .end(let updatedArray):
            notifySubscribersOnSameExecutionStack(.end(updatedArray: updatedArray))
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Observable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var listeners: [WeakListener : (DynamicArray<T>.Change) -> Void]
    
    private func sendStartNotification(sourceArray: [T], destinationArray: [T],  sameExecutionStack: Bool = false) {
        
        notifySubscribers(.start(sourceArray: sourceArray, destinationArray: destinationArray) , sameExecutionStack: sameExecutionStack)
    }
    
    private func sendEndNotification(updatedArray: [T],  sameExecutionStack: Bool = false) {
        
        notifySubscribers(.end(updatedArray: updatedArray) , sameExecutionStack: sameExecutionStack)
    }
    
    public typealias ChangeNotificationType = Change
}

extension DynamicArray where T: Equatable {
    
    public func applyArrayEdits(_ edits: [ArrayEdit<T>], to array: [T], notify: Bool = true, sameExecutionStack: Bool = false) {
        
        if sameExecutionStack {
            notifySubscribersOnSameExecutionStack(.start(sourceArray: self.values, destinationArray: array))
        }
        else {
            notifySubscribers(.start(sourceArray: self.values, destinationArray: array))
        }
        var factor = 0
        for edit in edits {
            switch edit {
            case .add(let index, let value):
                self.insert(value, at: index+factor, notify: notify, sameExecutionStack: sameExecutionStack)
                factor += 1
            case .delete(let index):
                self.remove(atIndex: index+factor, notify: notify, sameExecutionStack: sameExecutionStack)
                factor -= 1
            case .replace(let index, let value):

                self.remove(atIndex: index+factor, notify: notify, sameExecutionStack: sameExecutionStack)
                self.insert(value, at: index+factor, notify: notify, sameExecutionStack: sameExecutionStack)
            }
        }
        if sameExecutionStack {
            notifySubscribersOnSameExecutionStack(.end(updatedArray: self.values))
        }
        else {
            notifySubscribers(.end(updatedArray: self.values))
        }
    }
    
}
