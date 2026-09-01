//
//  TstDictionary.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-02-04.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

enum TstDictionaryError: Error {
    
    case emptyKey
    case keyAlreadyInDictionary(String)
    case tryingToModifyReadOnlyDictionary
    case notSupportedException(String)
    case argumentNullException(String)
    case argumentException(String)
}


///
/// Ternary Search Tree Dictionary
///
/// This dictionary is an implementation of the <b>Ternary Search Tree</b>
/// data structure proposed by J. L. Bentley and R. Sedgewick in their
/// paper:  Fast algorithms for sorting and searching strings
/// in Proceedings of the Eighth Annual ACM-SIAM Symposium on Discrete Algorithms,
/// New Orleans Louisiana, January 5-7, 1997.
///
///
/// This dictionary acts as a symbol table: the keys must be string. It
/// is generally faster to find symbol than the <see cref="Hashtable"/> or
/// <see cref="SortedList"/> classes. It can also perform more complex search
/// such as neighbor search.
///
///
/// Please read the paper to get some insight on the stucture used below.
///
public final class TstDictionary<T: CompletionValueType>: Sequence {

    ///
    ///
    ///
    public  var root: TstDictionaryEntry<T>?
    
    ///
    ///
    ///
    public var version: Int
    
    ///
    /// Constructor
    ///
    /// Construct an empty ternary search tree.
    ///
    public init() {
        
        self.version = 0
    }
    
    ///
    /// Create a dictionary with a specified root.
    ///
    /// @param root: Root of the new dictionary
    public convenience init(root: TstDictionaryEntry<T>) {

        self.init()
        self.root = root
    }
    
    ///
    /// Gets the number of key-and-value pairs contained in the <see cref="TstDictionary"/>.
    ///
    /// The number of key-and-value pairs contained in the <see cref="TstDictionary"/>.
    ///
    /// Complexity: O(N)
    ///
    /// FIXME: Try to keep the count of elements in sync with 
    /// actual content in the TST 
    ///
    public var count: Int {
        
        get {
            
            var internalCount = 0
            
            for _ in self {
                
                internalCount += 1
            }
            
            return internalCount
        }
    }
    
    ///
    /// Get a value indicating whether access to the <see cref="TstDictionary"/> is synchronized (thread-safe).
    ///
    /// true if access to the <see cref="TstDictionary"/> is synchronized (thread-safe);
    /// otherwise, false. The default is false.
    ///
    public var synchronized: Bool {
        
        get {
				
            return false
        }
    }
    
    ///
    /// Gets an object that can be used to synchronize access to the <see cref="TstDictionary"/>.
    /// </summary>
    /// <value>
    /// An object that can be used to synchronize access to the <see cref="TstDictionary"/>.
    /// </value>
    public var syncRoot: TstDictionary<T> {

        get {
				
            return self
        }
    }
    
    ///
    /// Gets a value indicating whether the <see cref="TstDictionary"/> has a fixed size.
    ///
    /// true if the <see cref="TstDictionary"/> has a fixed size; otherwise, false.
    /// The default is false.
    ///
    public var fixedSize: Bool {
    
        get {

            return false
        }
    }
    
    ///
    /// Gets a value indicating whether the <see cref="TstDictionary"/> is read-only.
    ///
    /// true if the <see cref="TstDictionary"/> is read-only; otherwise, false.
    /// The default is false.
    ///
    public var readOnly: Bool {
    
        get {
            
            return false
        }
    }
    
    ///
    /// Gets an <see cref="StringCollection"/> containing the keys in the <see cref="TstDictionary"/>.
    ///
    /// An <see cref="StringCollection"/> containing the keys in the <see cref="TstDictionary"/>.
    /// </returns>
    public var keys: [String] {
    
        var keysArray = [String]()
            
        for entry in self {
                
            keysArray.append(entry.key!)
        }
        
        return keysArray
    }
    
    ///
    /// Gets an array containing the values in the TstDictionary.
    ///
    /// An array containing the values in this TstDictionary.
    ///
    public var values: [T] {
        
        var valuesArray = [T]()
        
        for entry in self {
            
            valuesArray.append(entry.data!)
        }
        
        return valuesArray
    }
    
    ///
    /// Gets or sets the value associated with the specified key.
    ///
    /// @param key: The key whose value to get or set.
    ///
    /// @param value: The value associated with the specified key.
    ///
    public subscript(key: String) -> T?  {

        get {
            
            let _key = key.lowercased()
            
            if let p = find(_key) {
                
                return p.data
            }
            
            return nil
        }
        
        set(newValue)  {

            let _key = key.lowercased()
            
            if _key.isEmpty {
                
                /// FIXME: should be transformed to exception throwing
                /// when they will be supported in subscript.
                assert(false, "Key is empty.")
            }
            if readOnly {
                
                assert(false, "TstDictionary is readOnly.")
            }
            
        }
    }
    
    ///
    /// Adds an element with the specified key and value into the <see cref="TstDictionary"/>.
    ///
    /// @param key: The key of the element to add.
    /// @param value: The value of the element to add. The value can be a null reference (Nothing in Visual Basic).
    ///
    public func add(_ key: String, value: T) throws {
       
        let _key = key.lowercased()
        
        if _key.isEmpty {
        
            throw TstDictionaryError.emptyKey
        }
        if readOnly {
        
            throw TstDictionaryError.tryingToModifyReadOnlyDictionary
        }
        
        // updating version
        version += 1
        
        // creating root node if needed.
        if root == nil {

            root = TstDictionaryEntry<T>(parent: nil, splitChar: _key.unicodeScalars[_key.unicodeScalars.startIndex])
        }
        
        // adding key
        var p = root!
        
        var keyIndex = _key.unicodeScalars.startIndex
        
        while keyIndex != _key.unicodeScalars.endIndex {
            
            let c = _key.unicodeScalars[keyIndex]
            
            if c.value < p.splitChar.value {
                
                if p.lowChild == nil {
                    
                    p.lowChild = TstDictionaryEntry<T>(parent: p, splitChar: c)
                }
                
                p = p.lowChild!
                
                continue
            }
            if c.value > p.splitChar.value {
                
                if p.highChild == nil {
                    
                    p.highChild = TstDictionaryEntry<T>(parent: p, splitChar: c)
                }
                
                p = p.highChild!
                
                continue
            }
            else {
                
                keyIndex = _key.unicodeScalars.index(keyIndex, offsetBy: 1)
                
                if keyIndex == _key.unicodeScalars.endIndex {

                    if let key = p.key {
                     
                        assert(false, "key already in dictionary")
                        throw TstDictionaryError.keyAlreadyInDictionary(key)
                    }
                    break
                }
                if p.eqChild == nil {
                    
                    p.eqChild = TstDictionaryEntry(parent: p, splitChar: _key.unicodeScalars[keyIndex])
                }
                
                p = p.eqChild!
            }
        }

        p.key = _key
        p.data = value
    }
    
    ///
    /// Removes the element with the specified key from the <see cref="TstDictionary"/>.
    ///
    /// @param key: The key of the element to remove.
    ///
    public func remove(_ key: String) throws {
        
        let _key = key.lowercased()
        
        if _key.isEmpty {
            
            throw TstDictionaryError.emptyKey
        }
        if readOnly {
            
            throw TstDictionaryError.tryingToModifyReadOnlyDictionary
        }
        
        // updating version
        version += 1
        
        var p = find(_key)
        
        if p == nil {

            return
        }
        
        p!.key = nil
        
        while p!.key != nil && p!.hasChildren && p!.parent != nil {
            
            if p!.isLowChild {
                
                p!.parent!.lowChild = nil
            }
            else if p!.isHighChild {
            
                p!.parent!.highChild = nil
            }
            else {
            
                p!.parent!.eqChild = nil
            }
            
            p = p!.parent
        }
        
        if p!.key == nil && !p!.hasChildren && p == root {
        
            root = nil
        }
        
    }

    ///
    /// Removes all elements from the <see cref="TstDictionary"/>.
    ///
    func clear() throws {
        
        if readOnly {
         
            throw TstDictionaryError.notSupportedException("dictionary is read-only")
        }
        
        // updating version
        version += 1
        root = nil
    }
    
    
    ///
    /// Determines whether the <see cref="TstDictionary"/> contains a specific key.
    ///
    /// @param key: The key to locate in the TstDictionary.
    /// @return true if the TstDictionary contains an element with the specified key; otherwise, false.
    ///
    public func contains(_ key: String) -> Bool {

        let _key = key.lowercased()
        
        return containsKey(_key)
    }
    
    ///
    /// Determines whether the TstDictionary contains a specific key.
    ///
    /// @param key: The key to locate in the TstDictionary.
    /// @return true if the TstDictionary contains an element with the specified key; otherwise, false.
    /// Complexity: Uses a Ternary Search Tree (tst) to find the key.
    /// The method behaves exactly as TstDictionary.contains.
    ///
    public func containsKey(_ key: String) -> Bool {
        
        let _key = key.lowercased()
        
        if let de: TstDictionaryEntry<T> = find(_key) , de.key != nil {
            
            return true
        }
        
        return false
    }
    
    ///
    /// Determines whether the <see cref="TstDictionary"/> contains a specific value.
    ///
    /// @return true if the TstDictionary contains an element with the specified value;
    /// otherwise, false.
    ///
    public func containsValue(_ value: T) -> Bool {
        
        for entry in self {
            
            if value == entry.data {
            
                return true
            }
        }
        
        return false
    }
    
    ///
    /// Finds the tst node matching the key.
    ///
    /// @return the TstDictionaryEntry mathcing the key, null if not found.
    ///
    public func find(_ key: String) -> TstDictionaryEntry<T>? {
        
        let _key = key.lowercased()
        
        if _key.isEmpty {
				
            return nil
        }
        
        var p = root
     
        var index = _key.unicodeScalars.startIndex
        
        var c: UnicodeScalar
        
        while index != _key.unicodeScalars.endIndex && p != nil {
				
            c = _key.unicodeScalars[index]
            
            if c.value < p!.splitChar.value {

                p = p!.lowChild
            }
            else if c.value > p!.splitChar.value {

                p = p!.highChild
            }
            else {
                
                if index == _key.unicodeScalars.index(before: _key.unicodeScalars.endIndex) {
                
                    return p
                }
                else {

                    index = _key.unicodeScalars.index(after: index)
                    p = p!.eqChild
                }
            }
        }
        
        return nil
    }
    
    ///
    /// return subtrie corresponding to given key
    ///
    func find(_ node: TstDictionaryEntry<T>?, key: String, d: Int) -> TstDictionaryEntry<T>? {
        
        if node == nil {

            return nil
        }
        
        let _key = key.lowercased()
        
        let c: UnicodeScalar = key.unicodeScalars[_key.unicodeScalars.index(_key.unicodeScalars.startIndex, offsetBy: d)]
        
        if c.value < node!.splitChar.value {
         
            return find(node!.lowChild, key: _key, d: d)
        }
        else if c.value > node!.splitChar.value {
            
            return find(node!.highChild, key: _key, d: d)
        }
        else if d < key.length - 1 {
            
            return find(node!.eqChild, key: _key, d: d+1)
        }
        else {
            
            return node
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: SequenceType protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // SequenceType protocol implementation
    public func makeIterator() -> TstDictionaryEntriesGenerator<T> {
        
        return TstDictionaryEntriesGenerator<T>(tstDictionary: self)
    }

}
