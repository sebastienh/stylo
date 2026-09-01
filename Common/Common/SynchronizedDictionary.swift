//
//  SynchronizedDictionary.swift
//  Common
//
//  Created by Sebastien hamel on 2019-02-24.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation


/// A thread-safe dictionary.
public class SynchronizedDictionary<Key, Value> where Key: Hashable {
    public typealias Element = (key: Key, value: Value)
    fileprivate let queue = DispatchQueue(label: "net.textually.SynchronizedDictionary")
    fileprivate var dictionary = [Key: Value]()
}

// MARK: - Properties
public extension SynchronizedDictionary {
    
    /// The number of elements in the array.
    var count: Int {
        var result = 0
        queue.sync { result = self.dictionary.count }
        return result
    }
    
    /// A Boolean value indicating whether the collection is empty.
    var isEmpty: Bool {
        var result = false
        queue.sync { result = self.dictionary.isEmpty }
        return result
    }
    
    /// A textual representation of the array and its elements.
    var description: String {
        var result = ""
        queue.sync { result = self.dictionary.description }
        return result
    }
    
    var keys: Dictionary<Key, Value>.Keys {
        
        return queue.sync {
            dictionary.keys
        }
    }
    
}

// MARK: - Immutable
public extension SynchronizedDictionary {
    
    /// Returns the first element of the sequence that satisfies the given predicate or nil if no such element is found.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and returns a Boolean value indicating whether the element is a match.
    /// - Returns: The first match or nil if there was no match.
    func first(where predicate: (Element) -> Bool) -> Element? {
        var result: Element?
        queue.sync { result = self.dictionary.first(where: predicate) }
        return result
    }
    
    /// Returns an array containing, in order, the elements of the sequence that satisfy the given predicate.
    ///
    /// - Parameter isIncluded: A closure that takes an element of the sequence as its argument and returns a Boolean value indicating whether the element should be included in the returned array.
    /// - Returns: An array of the elements that includeElement allowed.
    func filter(_ isIncluded: (Element) -> Bool) -> [Element] {
        var result = [Element]()
        queue.sync { result = self.dictionary.filter(isIncluded) }
        return result
    }
    
    /// Returns the first index in which an element of the collection satisfies the given predicate.
    ///
    /// - Parameter predicate: A closure that takes an element as its argument and returns a Boolean value that indicates whether the passed element represents a match.
    /// - Returns: The index of the first element for which predicate returns true. If no elements in the collection satisfy the given predicate, returns nil.
    func index(where predicate: (Element) -> Bool) -> Dictionary<Key, Value>.Index? {
        var result: Dictionary<Key, Value>.Index?
        queue.sync { result = self.dictionary.index(where: predicate) }
        return result
    }
    
    /// Returns the elements of the collection, sorted using the given predicate as the comparison between elements.
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns true if its first argument should be ordered before its second argument; otherwise, false.
    /// - Returns: A sorted array of the collection’s elements.
    func sorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        var result = [Element]()
        queue.sync { result = self.dictionary.sorted(by: areInIncreasingOrder) }
        return result
    }
    
    /// Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
    ///
    /// - Parameter transform: A closure that accepts an element of this sequence as its argument and returns an optional value.
    /// - Returns: An array of the non-nil results of calling transform with each element of the sequence.
    func compactMap<ElementOfResult>(_ transform: (Element) -> ElementOfResult?) -> [ElementOfResult] {
        var result = [ElementOfResult]()
        queue.sync { result = self.dictionary.compactMap(transform) }
        return result
    }
    
    /// Calls the given closure on each element in the sequence in the same order as a for-in loop.
    ///
    /// - Parameter body: A closure that takes an element of the sequence as a parameter.
    func forEach(_ body: (Element) -> Void) {
        queue.sync { self.dictionary.forEach(body) }
    }
    
    /// Returns a Boolean value indicating whether the sequence contains an element that satisfies the given predicate.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and returns a Boolean value that indicates whether the passed element represents a match.
    /// - Returns: true if the sequence contains an element that satisfies predicate; otherwise, false.
    func contains(where predicate: (Element) -> Bool) -> Bool {
        var result = false
        queue.sync { result = self.dictionary.contains(where: predicate) }
        return result
    }
}

// MARK: - Mutable
public extension SynchronizedDictionary {

    // Updates the value stored in the dictionary for the given key,
    // or adds a new key-value pair if the key does not exist.
    @discardableResult
    func updateValue(_ value: Value, forKey key: Key) -> Value? {
        // need to synchronize writes for consistent modifications
        return queue.sync {
            self.dictionary[key] = value
            return value
        }
    }

    @discardableResult
    func removeValue(forKey key: Key) -> Value? {
        // need to synchronize writes for consistent modifications
        return queue.sync {
            self.dictionary.removeValue(forKey: key)
        }
    }
}

public extension SynchronizedDictionary {
    
    /// Accesses the element at the specified position if it exists.
    ///
    /// - Parameter key: The position of the element to access.
    /// - Returns: optional element if it exists.
    subscript(key: Key) -> Value? {
        
        get {
            var value : Value?
            queue.sync {
                value = self.dictionary[key]
            }
            return value
        }
        set {
            
            guard let newValue = newValue else { return }
            updateValue(newValue, forKey: key)
        }
    }
}
