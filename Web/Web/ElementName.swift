//
//  ElementName.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-12-30.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os 

//  element_name
//      :   IDENT | '*'
//      ;
final class ElementName: BaseSelector {
    
    let ident: Ident?
    let delimToken: Token?
    
    var universalIdent: Bool = false
    
    init(delimToken: Token) {
        
        assert(delimToken.rawStringValue == "*")
            
        universalIdent = true
        
        self.delimToken = delimToken
        self.ident = nil
        
        super.init(sourceStringSegment: delimToken.sourceStringSegment!)
        
    }
    
    init(ident: Ident) {
        
        universalIdent = false
        
        self.ident = ident
        self.delimToken = nil
        
        super.init(sourceStringSegment: ident.sourceStringSegment!)
    }
    
    func clone() -> ElementName {
        
        if let ident = ident {
            
            return ElementName(ident: ident.clone())
        }
        else {
            
            #if DEBUG
            assert(delimToken != nil)
            #endif
                
            return ElementName(delimToken: delimToken!)
        }
    }
    
    override func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing subclass implementation!", log: Log.Web.all, type: .fault)
        #endif
        assert(false, "Missing subclass implementation.")
    }
    
    override var selectorText: String {
        
        if let ident = ident {
        
            return ident.selectorText
        }
        else {
            
            assert(delimToken != nil)
            
            return "*"
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? ElementName {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
    
                // universalIdent
                if self.universalIdent != other.universalIdent {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: universalIdent are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                // ident
                if let ident = self.ident {
                    
                    if !ident.equals(to: other.ident, comparePositions: comparePositions) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: ident are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.ident != nil {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other ident is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                // delimToken
                if let delimToken = self.delimToken {
                    
                    if !delimToken.equals(to: other.delimToken, comparePositions: comparePositions) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: delimToken are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.delimToken != nil {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other delimToken is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not ElementName.", log: Log.Web.all, type: .debug)
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

func ==(lhs: ElementName, rhs: ElementName) -> Bool {
    
    return lhs.equals(to: rhs)
}
