//
//  SelectorImpl.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-12-25.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

open class BaseSelector: SelectorLanguageObject, Selector  {

    override init(sourceStringSegment: SourceStringSegment?) {
        
        super.init(sourceStringSegment: sourceStringSegment)
    }

    open var selectorText: String {

        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing subclass implementation!", log: Log.Web.all, type: .fault)
        #endif
        assert(false, "Missing subclass implementation.")
        return ""
    }
    
    open var selectorTextWithPositions: String {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing subclass implementation!", log: Log.Web.all, type: .fault)
        #endif
        assert(false, "Missing subclass implementation.")
        return ""
    }
    
    open func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing subclass implementation!", log: Log.Web.all, type: .fault)
        #endif
        assert(false, "Missing subclass implementation.")
    }
    
    open func accept(_ visitor: CSSSelectorListVisitor) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing implementation!", log: Log.Web.all, type: .fault)
        #endif
        assert(false, "Missing subclass implementation.")
    }
    
    override open func accept(_ visitor: CSSVisitor) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing implementation!", log: Log.Web.all, type: .fault)
        #endif
        assert(false, "Missing subclass implementation.")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override func equals(to other: Any?, comparePositions: Bool) -> Bool {
        
        if let other = other {
            
            if let other = other as? BaseSelector {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not BaseSelector.", log: Log.Web.all, type: .debug)
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
