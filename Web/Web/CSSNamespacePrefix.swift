//
//  CSSNamespacePrefix.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-01-27.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation
import Common
import os

public final class CSSNamespacePrefix: CSSOMLanguageObject {
    
    var tokenValue: Token
    
    var stringValue: String {
        
        return tokenValue.stringRepresentation
    }
    
    init(sourceStringSegment: SourceStringSegment?, tokenValue: Token) {
        
        self.tokenValue = tokenValue
        
        super.init(sourceStringSegment: sourceStringSegment)
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public func move(_ count: Int) {
        
        self.sourceStringSegment?.move(count)
        self.tokenValue.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {
        
        visitor.visit(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? CSSNamespacePrefix {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if stringValue != other.stringValue {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: stringValue are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CSSNamespacePrefix.", log: Log.Web.all, type: .debug)
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
