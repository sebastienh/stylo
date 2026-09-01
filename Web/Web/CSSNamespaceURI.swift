//
//  CSSNamespaceURI.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-01-27.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation
import Common
import os

enum NamespaceURIValue: Equatable {
    
    case stringValue(String)
    case uriValue(String)
    case none
    
    public static func ==(lhs: NamespaceURIValue, rhs: NamespaceURIValue) -> Bool {
        
        switch lhs {
            
        case .none:
            
            switch rhs {
            case .none:
                return true
                
            case .stringValue(_):
                return false
                
            case .uriValue(_):
                return false
            }
            
        case .stringValue(let string):
            switch rhs {
            case .none:
                return false
                
            case .stringValue(let otherSring):
                return string == otherSring
                
            case .uriValue(_):
                return false
            }
            
        case .uriValue(let string):
            
            switch rhs {
            case .none:
                return false
                
            case .stringValue(_):
                return false
                
            case .uriValue(let otherSring):
                return string == otherSring
            }
        }
        return true
    }
}

public final class CSSNamespaceURI: CSSOMLanguageObject, CustomStringConvertible {
    
    public var description: String {
        
        return stringValue
    }
    
    var uriValue: NamespaceURIValue
    
    var stringValue: String {
        
        switch uriValue {
            
        case .stringValue(let string):
            
            return string
            
        case .uriValue(let uri):
            
            return uri
            
        case .none:
            
            return "<none>"
        }
    }
    
    var tokenValue: Token?
    
    init(sourceStringSegment: SourceStringSegment?, uriValue: NamespaceURIValue, tokenValue: CSSToken? = nil) {
        
        self.uriValue = uriValue
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
        self.tokenValue?.move(count)
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
            
            if let other = other as? CSSNamespaceURI {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if uriValue != other.uriValue {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: uriValue are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CSSNamespaceURI.", log: Log.Web.all, type: .debug)
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
