//
//  StringToken.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-10.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

final class StringToken: BaseSelector {
    
    let rawIdent: String
    var formattedIdent: String?
    
    init(preservedIdentToken: CSPreservedTokenComponentValue) {
        
        if let formattedString = preservedIdentToken.value.formattedStringValue {
            
            self.formattedIdent = formattedString
        }
        
        self.rawIdent = preservedIdentToken.value.rawStringValue
        
        super.init(sourceStringSegment: nil)
    }
    
    init(rawIdent: String, formattedIdent: String? = nil) {
        
        self.formattedIdent = formattedIdent
        self.rawIdent = rawIdent
        super.init(sourceStringSegment: nil)
    }
    
    init(rawIdent: String) {
        
        self.rawIdent = rawIdent
        super.init(sourceStringSegment: nil)
    }
    
    func clone() -> StringToken {
        
        return StringToken(rawIdent: self.rawIdent, formattedIdent: self.formattedIdent)
    }
    
    override func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Selector specificty shall not be called in StringToken", log: Log.Web.all, type: .error)
        #endif
    }
    
    override var selectorText: String {
        
        var selectorTextValue: String = ""
        
        selectorTextValue += rawIdent
        
        return selectorTextValue
    }
    
    override func accept(_ visitor: CSSVisitor) {
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
            
            if let other = other as? StringToken {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if rawIdent != other.rawIdent {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: rawIdent are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if formattedIdent != other.formattedIdent {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: formattedIdent are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not StringToken.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
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

func ==(lhs: StringToken, rhs: StringToken) -> Bool {
    
    return lhs.equals(to: rhs)
}
