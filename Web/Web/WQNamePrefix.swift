//
//  WQNamePrefix.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-01-29.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation
import Common
import os

public final class WQNamePrefix: SelectorLanguageObject, CSSSelectorListVisitable {
    
    var prefixValue: String? {
        return namespacePrefix?.stringRepresentation
    }
    
    var universal: Bool {
        return prefixValue == "*"
    }
    
    var empty: Bool {
        return namespacePrefix == nil
    }
    
    var namespacePrefix: Token?
    var endSeparator: Token
    let explicitlyEmpty: Bool
    
    var wqNamePrefixValue: WQNamePrefixValue {
        
        return WQNamePrefixValue(prefixValue: prefixValue, universal: universal, empty: empty)
    }
    
    init(sourceStringSegment: SourceStringSegment?, namespacePrefix: Token?, endSeparator: Token, explicitlyEmpty: Bool = false) {
     
        self.namespacePrefix = namespacePrefix
        self.endSeparator = endSeparator
        self.explicitlyEmpty = explicitlyEmpty
        super.init(sourceStringSegment: sourceStringSegment)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public func move(_ count: Int) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("before move sourceStringFragment: %@, sourceStringSegment: %@", log: Log.Web.all, type: .info, %%sourceStringSegment)
        #endif
        
        self.sourceStringSegment?.move(count)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("after move sourceStringSegment: %@", log: Log.Web.all, type: .info, %%String(describing: sourceStringSegment))
        #endif

        self.namespacePrefix?.move(count)
        endSeparator.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func clone() -> WQNamePrefix {
        
        return WQNamePrefix(sourceStringSegment: sourceStringSegment, namespacePrefix: namespacePrefix, endSeparator: endSeparator, explicitlyEmpty: explicitlyEmpty)

    }
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
        
            if let other = other as? WQNamePrefix{
                
                if let selfPrefixValue = self.prefixValue {
                    
                    if let otherPrefixValue = other.prefixValue {
                        
                        if selfPrefixValue != otherPrefixValue {
                            return false
                        }
                    }
                    else {
                        return false
                    }
                }
                else {
                    
                    if other.prefixValue != nil {
                        return false
                    }
                }
                
                if self.universal != other.universal {
                    return false
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not WQNamePrefix.", log: Log.Web.all, type: .debug)
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
    //                                  MARK: CSSSelectorListVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func accept(_ visitor: CSSSelectorListVisitor) {
        
        visitor.visit(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {
        
        visitor.visit(self)
    }
    
}
