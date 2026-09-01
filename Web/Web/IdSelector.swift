//
//  IdSelector.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-12-01.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

// http://dev.w3.org/csswg/selectors4/#id-selector
public final class IdSelector: SimpleSelector, EvaluableSelector, SelectionFilter {
    
    var hashToken: Token
    let rawHash: String
    var formattedHash: String?
    
    override var selectorType: RightmostSelectorType {
        
        return RightmostSelectorType.id(hashString)
    }
    
    /// Return the best available string representation
    /// of this hash id. If the formatted hash is available
    /// it will return it, otherwise it will return the
    /// raw hash.
    var hashString: String {
        
        if let formattedHash = formattedHash {
            
            return formattedHash
        }
        return  rawHash
    }
    
    init(sourceStringSegment: SourceStringSegment?, rawHash: String, formattedHash: String?, hashToken: Token, parentCompoundSelector: CompoundSelector) {
        
        self.hashToken = hashToken
        self.rawHash = rawHash
        self.formattedHash = formattedHash
        super.init(sourceStringSegment: sourceStringSegment, parentCompoundSelector: parentCompoundSelector)
    }
    
    init(sourceStringSegment: SourceStringSegment?, rawHash: String, hashToken: Token, parentCompoundSelector: CompoundSelector) {
        
        self.hashToken = hashToken
        self.rawHash = rawHash
        super.init(sourceStringSegment: sourceStringSegment, parentCompoundSelector: parentCompoundSelector)
    }
    
    override func clone(_ parent: CompoundSelector) -> SimpleSelector {
        
        return IdSelector(sourceStringSegment: self.sourceStringSegment, rawHash: self.rawHash, formattedHash: self.formattedHash, hashToken: self.hashToken, parentCompoundSelector: parent)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Selector protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
        
        selectorSpecificity.A += 1
    }
    
    override public var selectorText: String {
        
        var selectorTextValue: String = ""
        selectorTextValue += rawHash
        return selectorTextValue
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public override func move(_ count: Int) {
        
        self.sourceStringSegment?.move(count)
        self.hashToken.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
        
            if let other = other as? IdSelector {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.rawHash != other.rawHash {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: rawHash are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if self.formattedHash != other.formattedHash {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: formattedHash are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not IdSelector.", log: Log.Web.all, type: .debug)
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
    
    public override func accept(_ visitor: CSSSelectorListVisitor) {
        
        visitor.visit(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {
        
        visitor.visit(self)
    }
 
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: SelectionFilter protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var reverseFilter: ReverseFilter {
        
        return IdSelectorReverseFilter(hashString: self.hashString)
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func ==(lhs: IdSelector, rhs: IdSelector) -> Bool {
    
    return lhs.equals(to: rhs)
}
