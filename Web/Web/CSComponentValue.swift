//
//  CSSComponentValue.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-28.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

public protocol ComponentValue {
    
}

class CSComponentValue: CSLanguageObject, CSVisitable, CSTextNode, Equatable, CSBlockComponent, ComponentValue {
    
    var isWhitespace: Bool {
        
        return false
    }
    
    override init(sourceStringSegment: SourceStringSegment?) {
        
        super.init(sourceStringSegment: sourceStringSegment)
    }
    
    func clone() -> CSComponentValue {
    
        fatalError("Missing subclass implementation.")
    }
    
    func isTokenId(_ tokenId: Int) -> Bool {
        
        return false
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public func move(_ count: Int) {
        
        self.sourceStringSegment?.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSTextNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func cssText() -> DOMString {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Method cssText() -> String must be implemented by subclasses", log: Log.Web.all, type: .error)
        #endif
        
        return ""
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Visit the root.
    // 2. Traverse the left subtree.
    // 3. Traverse the right subtree.
    func accept(_ visitor: CSVisitor) -> NodeInfo  {
        
        fatalError("preOrderAccept should overriden by subclasses!!!!")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? CSComponentValue {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CSComponentValue.", log: Log.Web.all, type: .debug)
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

/// Implementation of == required by Equatable
func ==(lhs: CSComponentValue, rhs: CSComponentValue) -> Bool {
    
    return lhs.equals(to: rhs)
}
