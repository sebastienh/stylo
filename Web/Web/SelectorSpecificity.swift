//
//  SelectorSpecificity.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-06.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation

// see http://dev.w3.org/csswg/selectors-4/#specificity
public final class SelectorSpecificity : Comparable, Equatable, CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        return "A:\(A), B:\(B), C:\(C)"
    }
    
    var A: Int
    var B: Int
    var C: Int
    
    init() {
        self.A = 0
        self.B = 0
        self.C = 0
    }
    
    func incrementA() {
        self.A += 1
    }
    
    func incrementB() {
        self.B += 1
    }
    
    func incrementC() {
        self.C += 1
    }
    
    func copyTo(_ selectorSpecificity: SelectorSpecificity) {
        
        selectorSpecificity.A = self.A
        selectorSpecificity.B = self.B
        selectorSpecificity.C = self.C
    }
    
    func add(_ selectorSpecificity: SelectorSpecificity) {
        
        self.A += selectorSpecificity.A
        self.B += selectorSpecificity.B
        self.C += selectorSpecificity.C
    }
}

public func == (lhs:SelectorSpecificity, rhs:SelectorSpecificity) -> Bool {
    
    return lhs.A == rhs.A && lhs.B == rhs.B && lhs.C == rhs.C
}

public func <(lhs: SelectorSpecificity, rhs: SelectorSpecificity) -> Bool {
    
    if lhs.A != rhs.A {
        
        return lhs.A < rhs.A
    }
    else {
        if lhs.B != rhs.B {
            
            return lhs.B < rhs.B
        }
        else {
            if lhs.C != rhs.C {
                
                return lhs.C < rhs.C
            }
            else {
                
                return false
            }
        }
    }
}
