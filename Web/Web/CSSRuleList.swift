//
//  CSSRuleList.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-18.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

// http://dev.w3.org/csswg/cssom/#cssrulelist
//[ArrayClass]
//interface CSSRuleList {
//    getter CSSRule? item(unsigned long index);
//    readonly attribute unsigned long length;
//};

private protocol ICSSRuleList {
    
    var length: Int { get }
    
    func item(_ index:Int) -> CSSRule?
}

public final class CSSRuleList: CSSOMLanguageObject, ICSSRuleList {
    
    var rules: [CSSRule]
    
    public var length: Int {
        
        get {
            return rules.count
        }
    }
    
    public var isEmpty: Bool {
        
        return rules.isEmpty
    }
    
    public var first: CSSRule? {
        
        return rules.first
    }
    
    public var last: CSSRule? {
        
        return rules.last
    }
    
    public var range: Range<Int>? {
        
        if let firstRule = rules.first {
        
            let lastRule = rules.last
            
            assert(lastRule != nil)
            if let lastRule = lastRule {
            
                let firstIndex = firstRule.sourceStringSegment?.startIndex
                let endIndex = lastRule.sourceStringSegment?.endIndex
                
                assert(firstIndex != nil)
                assert(endIndex != nil)
                if let firstIndex = firstIndex, let endIndex = endIndex {
                
                    return Range<Int>(uncheckedBounds: (lower: firstIndex, upper: endIndex))
                }
            }
        }
        return nil
    }
    
    public subscript(index: Int) -> CSSRule? {
    
        get {
            if index < rules.count {
                return rules[index]
            }
            return nil
        }
        set {
            
            if let newValue = newValue {
                rules[index] = newValue
            }
        }
    }
    
    init() {
        
        rules = [CSSRule]()
        
        super.init(sourceStringSegment: nil)
    }
    
    func item(_ index: Int) -> CSSRule? {
    
        if index < rules.count {
            
            return rules[index]
        }
        return nil
    }
    
    @discardableResult
    func addItemAtIndex(_ item: CSSRule, index: Int) -> Int {
        
        rules.insert(item, at: index)
        
        updateSourceStringRegion()
        
        return index
    }
    
    public func addItem(_ item: CSSRule, updateSourceString: Bool = true) {
        
        rules.append(item)
        
        if updateSourceString {
            updateSourceStringRegion()
        }
    }
    
    func deleteRuleAtIndex(_ index: Int) {
        
        if index < rules.count {
            
            rules.remove(at: index)
            updateSourceStringRegion()
        }
        else {
            NSException(
                name: NSExceptionName(rawValue: "Error: Index out of bound!"),
                reason: "No rule at index : \(index)!",
                userInfo: nil).raise()
        }
    }
    
    func deleteAllRules() {
        
        rules.removeAll(keepingCapacity: true)
        updateSourceStringRegion()
    }
    
    fileprivate func updateSourceStringRegion() {
        
    
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        for rule in rules {
            os_log("rule: %@, sourceStringSegment: %@", log: Log.Web.all, type: .info, %%rule.type, %%String(describing: rule.sourceStringSegment))
        }
        #endif
        
        let firstRulePosition = rules.first?.sourceStringSegment
        let lastRulePosition = rules.last?.sourceStringSegment
        
        if let firstRulePosition = firstRulePosition, let lastRulePosition = lastRulePosition {

            self.sourceStringSegment = SourceStringSegment(startIndex: firstRulePosition.startIndex, endIndex: lastRulePosition.endIndex)
        }
        else {
            
            assert(rules.isEmpty)
            self.sourceStringSegment = nil
        }
    }
    
    func clone(_ parentStyleSheet: CSSStyleSheet) -> CSSRuleList {
    
        let clone = CSSRuleList()
        
        for rule in rules {
            
            clone.addItem(rule.clone(parentStyleSheet))
        }
        
        return clone
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
        
            if let other = other as? CSSRuleList {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.length != other.length {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: rules length are different: self length: %d, other length: %d,", log: Log.Web.all, type: .debug, self.length, other.length)
                    #endif
                    return false
                }
                
                for index in 0..<self.length {
                    
                    let rule = self.rules[index]
                    let otherRule = other.rules[index]
                    
                    if !rule.equals(to: otherRule, comparePositions: comparePositions) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: rule are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CSSRuleList.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other is nil.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("missing implementation", log: Log.Web.all, type: .error)
        #endif
    }
    
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Implementation of == required by Equatable
func ==(lhs: CSSRuleList, rhs: CSSRuleList) -> Bool {

    return lhs.equals(to: rhs)
}
