//
//  AttribMatch.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-01.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

enum MatchType: String {
    
    case PrefixMatch = "^="
    case SuffixMatch = "$="
    case SubstringMatch = "*="
    case IncludeMatch = "~="
    case DashMatch = "|="
    case EqualMatch = "="
    
    var tokenClassTypeValue: TokenClassType {
        
        switch self {
            
        case .DashMatch:
            
            return TokenClassType.DashMatchToken
            
        case .EqualMatch:
            
            return TokenClassType.EqualMatchToken
            
        case .IncludeMatch:
            
            return TokenClassType.IncludeMatchToken
            
        case .PrefixMatch:
            
            return TokenClassType.PrefixMatchToken
            
        case .SubstringMatch:
            
            return TokenClassType.SubstringMatchToken
            
        case .SuffixMatch:
            
            return TokenClassType.SuffixMatchToken
        }
    }
}



// For more info see https://developer.mozilla.org/en-US/docs/Web/CSS/Attribute_selectors
//  attrib_match
//      :   [ '=' | PREFIX-MATCH | SUFFIX-MATCH | SUBSTRING-MATCH | INCLUDE-MATCH | DASH-MATCH ] S*
public final class AttribMatch: BaseSelector {
    
    let matchType: MatchType
    
    init(sourceStringSegment: SourceStringSegment?, matchType: MatchType, parentAttribSelector: AttribSelector) {
        
        self.matchType = matchType
        super.init(sourceStringSegment: sourceStringSegment)
        
        self.parent = parentAttribSelector
    }
 
    func clone(_ parent: AttribSelector?) -> AttribMatch {
        
        return AttribMatch(sourceStringSegment: nil, matchType: self.matchType, parentAttribSelector: parent!)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Selector protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Selector specificty shall not be called in AttribMatch", log: Log.Web.all, type: .error)
        #endif
    }
    
    override public var selectorText: String {
        
        return §matchType
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
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? AttribMatch {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.matchType != other.matchType {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: matchType are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not AttribMatch.", log: Log.Web.all, type: .debug)
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
    //                                  MARK: Compilable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public var minimalCompilationUnit: CSSOMLanguageObject {
        
        return parent!.minimalCompilationUnit
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSSelectorListVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func accept(_ visitor: CSSSelectorListVisitor) {
        
        visitor.visit(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {
        
        visitor.visit(self)
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func ==(lhs: AttribMatch, rhs: AttribMatch) -> Bool {
    
    return lhs.equals(to: rhs)
}
