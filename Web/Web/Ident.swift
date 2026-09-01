//
//  Ident.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-02.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

public final class Ident: BaseSelector {
    
    let preservedToken: CSPreservedTokenComponentValue
    let rawIdent: String
    let formattedIdent: String?
    
    /// Return the best available string representation
    /// of this ident. If the formatted ident is available
    /// it will return it, otherwise it will return the
    /// rawIdent.
    public var identString: String {
        
        if let formattedIdent = formattedIdent {
            
            return formattedIdent
        }
        return  rawIdent
    }
    
    init(preservedIdentToken: CSPreservedTokenComponentValue) {
        
        self.preservedToken = preservedIdentToken.clone()
        self.formattedIdent = preservedIdentToken.value.formattedStringValue
        self.rawIdent = preservedIdentToken.value.rawStringValue
        
        // we don't to keep the position
        super.init(sourceStringSegment: preservedIdentToken.value.sourceStringSegment!)
    }
    
    func clone() -> Ident {
        
        return Ident(preservedIdentToken: preservedToken.clone())
    }
    
    override public func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Selector specificty shall not be called in Ident", log: Log.Web.all, type: .error)
        #endif
    }
    
    override public var selectorText: String {
        
        var selectorTextValue: String = ""
        
        selectorTextValue += rawIdent
        
        return selectorTextValue
    }
    
    override public func accept(_ visitor: CSSVisitor) {
        assert(false, "accept not implemented")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("error: accept(_ visitor: CSSVisitor) unimplemented", log: Log.Web.all, type: .error)
        #endif
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? Ident {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.rawIdent != other.rawIdent {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: rawIdent are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not Ident.", log: Log.Web.all, type: .debug)
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

func ==(lhs: Ident, rhs: Ident) -> Bool {
    
    return lhs.equals(to: rhs)
}

