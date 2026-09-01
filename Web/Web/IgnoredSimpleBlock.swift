//
//  IgnoredSimpleBlock.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-07-02.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

public class IgnoredSimpleBlock: CSSOMLanguageObject {

    let value: CSSimpleBlockComponentValue
    
    override public var sourceStringSegment: SourceStringSegment? {
        get {
            return value.sourceStringSegment
        }
        set {
            value.sourceStringSegment = newValue
        }
    }
    
    init(value: CSSimpleBlockComponentValue) {
        
        self.value = value
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("value.sourceStringSegment: %@", log: Log.Web.all, type: .debug, String(describing: value.sourceStringSegment))
        #endif
        super.init(sourceStringSegment: value.sourceStringSegment)
    }
    
    public func clone() -> IgnoredSimpleBlock {
        
        return IgnoredSimpleBlock(value: self.value.clone() as! CSSimpleBlockComponentValue)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public func move(_ count: Int) {
        
//        self.sourceStringFragment?.move(count)
//        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//        os_log("sourceStringSegment: %@", log: Log.Web.all, type: .debug, %%String(describing: sourceStringSegment))
//        #endif
        
        self.value.move(count)
//        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//        os_log("value.sourceStringSegment: %@", log: Log.Web.all, type: .debug, String(describing: value.sourceStringSegment))
//        #endif
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? IgnoredSimpleBlock {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if !self.value.equals(to: other.value, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: value is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not IgnoredSimpleBlock.", log: Log.Web.all, type: .debug)
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
    
    override open func accept(_ visitor: CSSVisitor) {
        
        visitor.visit(self)
    }
    
}
