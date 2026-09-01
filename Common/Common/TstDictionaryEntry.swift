//
//  TstDictionaryEntry.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-02-06.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

enum TstDictionaryEntryType {
    
    case lowChild
    case highChild
    case eqChild
}

///
/// Defines a Ternary Search Tree node pair that can be set or retrieved.
///
public final class TstDictionaryEntry<T: CompletionValueType>: Equatable {
    
    ///
    fileprivate(set) var splitChar: UnicodeScalar
    
    ///
    public internal(set) var key: String?
    
    ///
    public internal(set) var data: T?
    
    ///
    var parent: TstDictionaryEntry<T>?
    
    ///
    var lowChild: TstDictionaryEntry<T>?
    
    ///
    var eqChild: TstDictionaryEntry<T>?
    
    ///
    var highChild: TstDictionaryEntry<T>?
    
    var isEqChild: Bool {
        
        if let parent = parent {
            
            if self == parent.eqChild {
                
                return true
            }
        }
        
        return false
    }
    
    var isLowChild: Bool {
        
        if let parent = parent {
            
            if self == parent.lowChild {
                
                return true
            }
        }
        
        return false
    }
    
    var isHighChild: Bool {
        
        if let parent = parent {
            
            if self == parent.highChild {
                
                return true
            }
        }
        
        return false
    }
    
    var hasChildren: Bool {
        
        if let _ = lowChild {
            
            return true
        }
        
        if let _ = highChild {
            
            return true
        }
        
        if let _ = eqChild {
            
            return true
        }
        
        return false
    }
    
    var length: Int {
        
        if let key = key {
            
            return key.count
        }
        
        return 0
    }
    
    init(parent: TstDictionaryEntry<T>? = nil, splitChar: UnicodeScalar) {
        
        self.parent = parent
        self.splitChar = splitChar
    }
    
    func deleteChildType(_ type: TstDictionaryEntryType) {
        
        switch type {
            
        case .lowChild:
            
            self.lowChild = nil
            
        case .highChild:
            
            self.highChild = nil
            
        case .eqChild:
            
            self.eqChild = nil
        }
    }
    
    func setChildType(_ child: TstDictionaryEntry<T>, type: TstDictionaryEntryType) {
        
        switch type {
            
        case .lowChild:
            
            self.lowChild = child
            
        case .highChild:
            
            self.highChild = child
            
        case .eqChild:
            
            self.eqChild = child
        }
    }
    
    func getChildType(_ type: TstDictionaryEntryType) -> TstDictionaryEntry<T>? {
        
        switch type {
            
        case .lowChild:
            
            return self.lowChild
            
        case .highChild:
            
            return self.highChild
            
        case .eqChild:
            
            return self.eqChild
        }
    }
    
    func isEqual(to other: TstDictionaryEntry<T>) -> Bool {
        
        if splitChar != other.splitChar {
            
            return false
        }
        
        if let key = key {
            
            if let otherKey = other.key {
                
                if key != otherKey {
                    
                    return false
                }
            }
            else {
                
                return false
            }
        }
        else {
            
            // the other should not have a key to be
            if let _ = other.key {
                
                return false
            }
        }
        
        return true
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Implementation of == required by Equatable
public func ==<T>(lhs: TstDictionaryEntry<T>, rhs: TstDictionaryEntry<T>) -> Bool {
    
    return lhs.isEqual(to: rhs)
}
