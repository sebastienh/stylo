//
//  ClassSelector.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-12-01.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

// http://dev.w3.org/csswg/selectors4/#class-selector
//  class
//      : '.' IDENT
//      ;
public final class ClassSelector: SimpleSelector, EvaluableSelector, SelectionFilter {
    
    var dotDelimToken: Token
    var ident: Ident
    
    var className: String {
        
        if let formattedClassName = ident.formattedIdent {
            
            return formattedClassName
        }
        return ident.rawIdent
    }
    
    override var selectorType: RightmostSelectorType {
        
        return RightmostSelectorType.class(ident.identString)
    }
    
    init(sourceStringSegment: SourceStringSegment?, ident: Ident, dotDelimToken: Token, parentCompoundSelector: CompoundSelector) {
        
        self.dotDelimToken = dotDelimToken
        self.ident = ident
        super.init(sourceStringSegment: sourceStringSegment, parentCompoundSelector: parentCompoundSelector)
    }
    
    override func clone(_ parent: CompoundSelector) -> SimpleSelector {
        
        return ClassSelector(sourceStringSegment: self.sourceStringSegment!, ident: self.ident, dotDelimToken: self.dotDelimToken, parentCompoundSelector: parent)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Selector protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
        
        selectorSpecificity.B += 1
    }
    
    override public var selectorText: String {
        
        var selectorTextValue: String = "."
        selectorTextValue += ident.selectorText
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
        self.dotDelimToken.move(count)
        self.ident.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? ClassSelector {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            
                if !self.ident.equals(to: other.ident, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {

                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not ClassSelector.", log: Log.Web.all, type: .debug)
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
        
        return ClassSelectorReverseFilter(className: self.className)
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func ==(lhs: ClassSelector, rhs: ClassSelector) -> Bool {

    return lhs.equals(to: rhs)
}
