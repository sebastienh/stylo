//
//  DynamicOrderedSet.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-03-24.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public final class DynamicOrderedSet<T: Hashable>: NSObject, Observable, Observer {

    public var priority: ObserverPriority {
        return .background
    }
    
    public let lock = ReadWriteLock()
    
    public let listenersQueue = DispatchQueue(label: "net.textually.DynamicOrderedSet.Listeners", attributes: .concurrent)
    
    public enum Change {
        
        case insert(newElement: T, index: Int, updatedOrderedSet: OrderedSet<T>)
        case inserts(newElements: OrderedSet<T>, indexes: [Int], updatedOrderedSet: OrderedSet<T>)
        case deletes(indexes: [Int], deletedValues: [T], updatedOrderedSet: OrderedSet<T>)
        case move(element: T, sourceIndex: Int, targetIndex: Int, updatedOrderedSet: OrderedSet<T>)
        case start(sourceOrderedSet: OrderedSet<T>, destinationOrderedSet: OrderedSet<T>)
        case end(updatedOrderedSet: OrderedSet<T>)
        
        public var updatedOrderedSet: OrderedSet<T>? {
            switch self {
            case .deletes(_, _, let updatedOrderedSet):
                return updatedOrderedSet
            case .insert(_, _, let updatedOrderedSet):
                return updatedOrderedSet
            case .inserts(_, _, let updatedOrderedSet):
                return updatedOrderedSet
            case .move(_, _, _, let updatedOrderedSet):
                return updatedOrderedSet
            case .end(let updatedOrderedSet):
                return updatedOrderedSet
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
    
    public var values: OrderedSet<T>
    
    public var first: T? {
        
        return values.first
    }
    
    public subscript(safe index: Int) -> T? {
        return values.indices.contains(index) ? values[index] : nil
    }
    
    public convenience init(_ a: Array<T>) {
        
        var orderedSet = OrderedSet<T>()
        for item in a {
            orderedSet.append(item)
        }
        
        self.init(orderedSet)
    }
    
    public override init() {
        
        values = OrderedSet<T>()
        listeners = [WeakListener : (DynamicOrderedSet<T>.Change) -> Void]()
        super.init()
    }
    
    public init(_ v: OrderedSet<T>) {
        
        values = v
        listeners = [WeakListener : (DynamicOrderedSet<T>.Change) -> Void]()
    }
    
    public func bind(to other: DynamicOrderedSet<T>) {

        other.subscribe({ [weak self](change) in
            self?.applyChange(change)
        }, observer: self)
    }

    public func unbind(from other: DynamicOrderedSet<T>) {
        other.unsubscribe(observer: self)
    }
    
    public func replaceItems(withItems items: OrderedSet<T>, notify: Bool = true, sameExecutionStack: Bool = false) {
        
        guard notify else {
            return
        }
        
        self.sendStartNotification(sourceOrderedSet: self.values, destinationOrderedSet: items, sameExecutionStack: sameExecutionStack)
        self.values = items
        self.sendEndNotification(updatedOrderedSet: self.values, sameExecutionStack: sameExecutionStack)
    }
    
    /// The new index is before the removal of the target element,
    /// since we can only know the target index after having removed it...
    public func move(elementAt index: Int, to targetIndex: Int, notify: Bool = true, sameExecutionStack: Bool = false) {
        
        guard index != targetIndex else {
            return
        }
        
        guard let value = self.values.remove(at: index) else {
            assertionFailure("Error: value is nil at index: \(index)")
            return
        }
        
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
        
        notifySubscribers(.move(element: value, sourceIndex: index, targetIndex: targetIndex, updatedOrderedSet: self.values), sameExecutionStack: sameExecutionStack)
    }
    
    public func insert(newElements: OrderedSet<T>, at indexes: [Int], notify: Bool = true, sameExecutionStack: Bool = false) {

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
        
        notifySubscribers(.inserts(newElements: newElements, indexes: indexes, updatedOrderedSet: self.values), sameExecutionStack: sameExecutionStack)
    }
    
    public func insert(_ newElement: T, at i: Int, notify: Bool = true, sameExecutionStack: Bool = false, withStartAndEndEvents: Bool = false) {
        
        let sourceOrderedSet: OrderedSet<T> = self.values
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
            self.sendStartNotification(sourceOrderedSet: sourceOrderedSet, destinationOrderedSet: self.values, sameExecutionStack: sameExecutionStack)
        }
        
        notifySubscribers(.insert(newElement: newElement, index: i, updatedOrderedSet: self.values), sameExecutionStack: sameExecutionStack)
        
        if withStartAndEndEvents {
            self.sendEndNotification(updatedOrderedSet: self.values, sameExecutionStack: sameExecutionStack)
        }
    }
    
    
    
    public func replaceAll(withItem item: T, notify: Bool = true, sameExecutionStack: Bool = false, withStartAndEndEvents: Bool = false) {
        
        let sourceOrderedSet: OrderedSet<T> = self.values
        
        values.removeAll(keepingCapacity: true)
        values.append(item)
        
        if withStartAndEndEvents {
            self.sendStartNotification(sourceOrderedSet: sourceOrderedSet, destinationOrderedSet: self.values, sameExecutionStack: sameExecutionStack)
        }
        
        notifySubscribers(.deletes(indexes: Array(0..<sourceOrderedSet.count), deletedValues: sourceOrderedSet.contents, updatedOrderedSet: self.values), sameExecutionStack: sameExecutionStack)
        
        notifySubscribers(.insert(newElement: item, index: values.count-1, updatedOrderedSet: self.values), sameExecutionStack: sameExecutionStack)
        
        if withStartAndEndEvents {
            self.sendEndNotification(updatedOrderedSet: self.values, sameExecutionStack: sameExecutionStack)
        }
    }
    
    
    public func removeAll(notify: Bool = true, sameExecutionStack: Bool = false, withStartAndEndEvents: Bool = false) {
        
        let sourceOrderedSet: OrderedSet<T> = self.values
        let oldCount = self.values.count
        let deletedValued = values.contents
        values.removeAll(keepingCapacity: true)
        
        guard notify else {
            return
        }
        
        if withStartAndEndEvents {
            self.sendStartNotification(sourceOrderedSet: sourceOrderedSet, destinationOrderedSet: self.values, sameExecutionStack: sameExecutionStack)
        }
        
        notifySubscribers(.deletes(indexes: Array(0..<oldCount), deletedValues: deletedValued, updatedOrderedSet: self.values), sameExecutionStack: sameExecutionStack)
        
        if withStartAndEndEvents {
            self.sendEndNotification(updatedOrderedSet: self.values, sameExecutionStack: sameExecutionStack)
        }
    }
    
    public func append(_ item: T, notify: Bool = true, sameExecutionStack: Bool = false, withStartAndEndEvents: Bool = false) {
        
        let sourceOrderedSet = self.values
        values.append(item)
        
        guard notify else {
            return
        }
        
        if withStartAndEndEvents {
            self.sendStartNotification(sourceOrderedSet: sourceOrderedSet, destinationOrderedSet: self.values, sameExecutionStack: sameExecutionStack)
        }
        
        let arrayChange: DynamicOrderedSet<T>.Change = .insert(newElement: item, index: values.count-1, updatedOrderedSet: self.values)
        notifySubscribers(arrayChange, sameExecutionStack: sameExecutionStack)
        
        if withStartAndEndEvents {
            self.sendEndNotification(updatedOrderedSet: self.values, sameExecutionStack: sameExecutionStack)
        }
    }
    
    public func append<S>(contentsOf newElements: S, notify: Bool = true) where S : Sequence, T == S.Element {
    
        let firstInsertIndex = values.count
        values.append(contentsOf: newElements)
        
        guard notify else {
            return
        }
        
        notifySubscribers(.inserts(newElements: self.values, indexes: Array(firstInsertIndex..<values.count), updatedOrderedSet: self.values))
    }
    
    public func remove(atIndex index: Int, notify: Bool = true, sameExecutionStack: Bool = false) {
        
        guard let deletedValue = values.remove(at: index) else {
            assertionFailure("Error: no value at index: \(index)")
            return
        }
        
        guard notify else {
            return
        }
        
        notifySubscribers(.deletes(indexes: [index], deletedValues: [deletedValue], updatedOrderedSet: self.values), sameExecutionStack: sameExecutionStack)
    }
    
    public func remove(atIndexes indexes: [Int], notify: Bool = true, sameExecutionStack: Bool = false) {
        
        assert(indexes.sorted() == indexes, "indexes should be sorted in ascending order")
        var deletedIndexes = [Int]()
        var deletedValues = [T]()
        
        // start from the end
        for index in indexes.reversed() {
            if index < self.values.count {
                guard let value = self.values.remove(at: index) else {
                    assertionFailure("Error: value did not exist in the ordered set")
                    continue
                }
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
        
        let arrayChange: DynamicOrderedSet<T>.Change = .deletes(indexes: deletedIndexes.sorted(), deletedValues: deletedValues, updatedOrderedSet: self.values)
        notifySubscribers(arrayChange, sameExecutionStack: sameExecutionStack)
    }
    
    func applyChange(_ change: DynamicOrderedSet<T>.Change, sameExecutionStack: Bool = false) {
        
        switch change {
        case .deletes(let indexes, _, _):
            self.remove(atIndexes: indexes.sorted(), sameExecutionStack: true)
        case .insert(let newElement, let index, _):
            self.insert(newElement, at: index, sameExecutionStack: true)
        case .inserts(let newElements, let indexes, _):
            self.insert(newElements: newElements, at: indexes.sorted(), sameExecutionStack: true)
        case .move(_, let sourceIndex, let targetIndex, _):
            self.move(elementAt: sourceIndex, to: targetIndex)
        case .start(let sourceOrderedSet, let destinationOrderedSet):
            notifySubscribersOnSameExecutionStack(.start(sourceOrderedSet: sourceOrderedSet, destinationOrderedSet: destinationOrderedSet))
        case .end(let updatedOrderedSet):
            notifySubscribersOnSameExecutionStack(.end(updatedOrderedSet: updatedOrderedSet))
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Observable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var listeners: [WeakListener : (DynamicOrderedSet<T>.Change) -> Void]
    
    private func sendStartNotification(sourceOrderedSet: OrderedSet<T>, destinationOrderedSet: OrderedSet<T>,  sameExecutionStack: Bool = false) {
        
        notifySubscribers(.start(sourceOrderedSet: sourceOrderedSet, destinationOrderedSet: destinationOrderedSet) , sameExecutionStack: sameExecutionStack)
    }
    
    private func sendEndNotification(updatedOrderedSet: OrderedSet<T>,  sameExecutionStack: Bool = false) {
        
        notifySubscribers(.end(updatedOrderedSet: updatedOrderedSet) , sameExecutionStack: sameExecutionStack)
    }
    
    public typealias ChangeNotificationType = Change
}

extension DynamicOrderedSet where T: Equatable {
    
    public func applyArrayEdits(_ edits: [ArrayEdit<T>], to orderedSet: OrderedSet<T>, notify: Bool = true, sameExecutionStack: Bool = false) {
        
        if sameExecutionStack {
            notifySubscribersOnSameExecutionStack(.start(sourceOrderedSet: self.values, destinationOrderedSet: orderedSet))
        }
        else {
            notifySubscribers(.start(sourceOrderedSet: self.values, destinationOrderedSet: orderedSet))
        }
        var factor = 0
        
        // delete pass
        for edit in edits {
            switch edit {
            case .delete(let index):
                self.remove(atIndex: index+factor, notify: notify, sameExecutionStack: sameExecutionStack)
                factor -= 1
            default:
                break
            }
        }
        factor = 0
        
        // addition pass
        for edit in edits {
            switch edit {
            case .add(let index, let value):
                self.insert(value, at: index+factor, notify: notify, sameExecutionStack: sameExecutionStack)
                factor += 1
            case .delete:
                factor -= 1
            case .replace(let index, let value):
                self.remove(atIndex: index+factor, notify: notify, sameExecutionStack: sameExecutionStack)
                self.insert(value, at: index+factor, notify: notify, sameExecutionStack: sameExecutionStack)
            }
        }
        
        if sameExecutionStack {
            notifySubscribersOnSameExecutionStack(.end(updatedOrderedSet: self.values))
        }
        else {
            notifySubscribers(.end(updatedOrderedSet: self.values))
        }
    }
}
