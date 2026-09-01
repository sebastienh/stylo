//
//  Pseudo.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-02.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

open class Pseudo: SimpleSelector {

    var name: String {
        assertionFailure("Error: missing subclass implementation")
        return ""
    }
    
    override init(sourceStringSegment: SourceStringSegment?, parentCompoundSelector: CompoundSelector?) {
        
        super.init(sourceStringSegment: sourceStringSegment, parentCompoundSelector: parentCompoundSelector)
    }
    
    override open func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Selector specificty shall not be called in Pseudo", log: Log.Web.all, type: .error)
        #endif
    }
    
    override open var selectorText: String {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Pseudo subclasses should override selectorText method.", log: Log.Web.all, type: .error)
        #endif
        return ""
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override open func accept(_ visitor: CSSVisitor) {
        
//        fatalError("Missing subclass implementation.")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
        
            if let other = other as? Pseudo {
            
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not Pseudo.", log: Log.Web.all, type: .debug)
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
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func ==(lhs: Pseudo, rhs: Pseudo) -> Bool {
    
    // When the two pseudo selectors are not of the same type (that's why we are here...)
    // they cant be equal.
    return lhs.equals(to: rhs)
}
