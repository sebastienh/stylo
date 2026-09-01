//
//  PseudoElement.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-02.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

public final class PseudoElementSelector: Pseudo, EvaluableSelector, SelectionFilter, SelectorChainLink {
    
    override var name: String {
        return pseudoElementName
    }
    
    var firstColonToken: Token
    var secondColonToken: Token
    var ident: Ident
    
    var pseudoElementName: String {
        
        if let _pseudoElementName = ident.formattedIdent {
            
            return _pseudoElementName
        }
        return ident.rawIdent
    }
    
    override var selectorType: RightmostSelectorType {
    
        if let pseudoElementType = PseudoSelectorType(rawValue: ident.identString) {
            
            return pseudoElementType.selectorType
        }
        return RightmostSelectorType.generic
    }
    
    init(sourceStringSegment: SourceStringSegment, ident: Ident, parentCompoundSelector: CompoundSelector, firstColonToken: Token, secondColonToken: Token) {
        
        self.firstColonToken = firstColonToken
        self.secondColonToken = secondColonToken
        self.ident = ident
        super.init(sourceStringSegment: sourceStringSegment, parentCompoundSelector: parentCompoundSelector)
    }
    
    override func clone(_ parent: CompoundSelector) -> SimpleSelector {
        
        return PseudoElementSelector(sourceStringSegment: self.sourceStringSegment!, ident: self.ident.clone(), parentCompoundSelector: parent, firstColonToken: self.firstColonToken, secondColonToken: self.secondColonToken)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public override func move(_ count: Int) {
        
        self.sourceStringSegment?.move(count)
        self.firstColonToken.move(count)
        self.secondColonToken.move(count)
        self.ident.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Selector protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
        
        selectorSpecificity.C += 1
    }
    
    override public var selectorText: String {
        
        var selectorTextValue: String = "::"
        selectorTextValue += ident.selectorText
        return selectorTextValue
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
        
            if let other = other as? PseudoElementSelector {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if !self.ident.equals(to: other.ident, comparePositions: comparePositions ) {
                    return false
                }
            }
            else {

                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not PseudoElementSelector.", log: Log.Web.all, type: .debug)
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
        
        return PseudoElementSelectorReverseFilter(pseudoSelectorType: PseudoSelectorType(rawValue: pseudoElementName))
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func ==(lhs: PseudoElementSelector, rhs: PseudoElementSelector) -> Bool {
    
    return lhs.equals(to: rhs)
}
