//
//  AttributeSelector.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-12-01.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

//  attrib
//      :   '[' S* attrib_name ']'
//      |   '[' S* attrib_name attrib_match [ IDENT | STRING ] S* attrib_flags? ']'
//      ;
// http://dev.w3.org/csswg/selectors4/#attribute-selector
public final class AttribSelector: SimpleSelector, EvaluableSelector, SelectionFilter {
    
    var leftSquareBracketToken: Token!
    var rightSquareBraquetToken: Token!
    
    public internal(set) var attribName: AttribName?
    public internal(set) var attribMatch: AttribMatch?
    public internal(set) var attribValue: AttribValue?
    public internal(set) var attribFlags: AttribFlags?
    
    private var matchAttributeName: String {
        
        // FIXME: it's possible that this explodes, since it's possible to
        // have an attrib name without ident.
        let formattedName = attribName?.ident?.formattedIdent
        
        if let formattedName = formattedName {
            
            return formattedName
        }
        else if let ident = attribName?.ident {
            
            return ident.rawIdent
        }
        return ""
    }
    
    init() {
        
        super.init(sourceStringSegment: nil, parentCompoundSelector: nil)
    }
    
    init(sourceStringSegment: SourceStringSegment?, attribName: AttribName, parentCompoundSelector: CompoundSelector) {
        
        self.attribName = attribName
        super.init(sourceStringSegment: sourceStringSegment, parentCompoundSelector: parentCompoundSelector)
    }
    
    init(sourceStringSegment: SourceStringSegment?, attribName: AttribName, attribMatch: AttribMatch, parentCompoundSelector: CompoundSelector) {
        
        self.attribName = attribName
        self.attribMatch = attribMatch
        super.init(sourceStringSegment: sourceStringSegment, parentCompoundSelector: parentCompoundSelector)
    }
    
    init(sourceStringSegment: SourceStringSegment?, attribName: AttribName, attribMatch: AttribMatch, attribValue: AttribValue, attribFlags: AttribFlags, parentCompoundSelector: CompoundSelector) {
        
        self.attribValue = attribValue
        self.attribName = attribName
        self.attribMatch = attribMatch
        self.attribFlags = attribFlags
        super.init(sourceStringSegment: sourceStringSegment, parentCompoundSelector: parentCompoundSelector)
    }

    override func clone(_ parent: CompoundSelector) -> SimpleSelector {
        
        let cloneAttribSelector = AttribSelector()
        
        cloneAttribSelector.attribName = self.attribName?.clone(cloneAttribSelector)
        cloneAttribSelector.attribValue = self.attribValue?.clone(cloneAttribSelector)
        cloneAttribSelector.attribMatch = self.attribMatch?.clone(cloneAttribSelector)
        cloneAttribSelector.attribFlags = self.attribFlags?.clone(cloneAttribSelector)
        cloneAttribSelector.parent = parent
        
        return cloneAttribSelector
    }
    
    public func changeAttributeValueWith(_ newValue: String) {
    
        guard self.attribValue != nil else {
            assertionFailure("Error: trying to change a nil attribute value to string value: \(newValue)")
            return
        }
        
        guard self.attribMatch != nil else {
            assertionFailure("Error: trying to change a nil attribute match to string value: \(newValue)")
            return
        }
        
        let stringToken = StringToken(rawIdent: newValue, formattedIdent: newValue)
        
        self.attribValue = AttribValue(sourceStringSegment: nil, string: stringToken, parentAttribSelector: self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Selector protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
        
        selectorSpecificity.B += 1
    }
    
    override public var selectorText: String {
        
        var selectorTextValue: String = "["
        
        selectorTextValue += attribName!.selectorText
        
        if let attribMatchSelector = self.attribMatch {
            selectorTextValue += attribMatchSelector.selectorText
        }
        
        if let attribFlagsSelector = self.attribFlags {
            selectorTextValue += attribFlagsSelector.selectorText
        }

        if let attribValueSelector = self.attribValue {
            selectorTextValue += attribValueSelector.selectorText
        }
        
        return selectorTextValue + "]"
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public override func move(_ count: Int) {
        
        self.sourceStringSegment?.move(count)
        
        self.leftSquareBracketToken.move(count)
        self.rightSquareBraquetToken.move(count)
        
        self.attribName?.move(count)
        self.attribMatch?.move(count)
        self.attribValue?.move(count)
        self.attribFlags?.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
        
            if let other = other as? AttribSelector {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                // AttribName
                if let attribName = self.attribName {
                    
                    if !attribName.equals(to: other.attribName, comparePositions: comparePositions) {
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: attribName are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.attribName != nil {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other attribName is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                // AttribMatch
                if let attribMatch = self.attribMatch {
                    
                    if !attribMatch.equals(to: other.attribMatch, comparePositions: comparePositions) {
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: attribMatch are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.attribMatch != nil {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other attribMatch is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }

                // AttribValue
                if let attribValue = self.attribValue {
                    
                    if !attribValue.equals(to: other.attribValue, comparePositions: comparePositions) {
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: attribValue are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.attribValue != nil {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other attribValue is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                // AttribFlags
                if let attribFlags = self.attribFlags {
                    
                    if !attribFlags.equals(to: other.attribFlags, comparePositions: comparePositions) {
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: attribFlags are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.attribFlags != nil {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other attribFlags is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not AttribSelector.", log: Log.Web.all, type: .debug)
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
        
        if let nodeInfo = visitor.visit(self) , nodeInfo.visitChildren {
            
            visitor.push(nodeInfo)
            
            attribName!.accept(visitor)
            
            if let attribMatch = attribMatch {
                
                attribMatch.accept(visitor)
            }
            
            if let attribValue = attribValue {
                
                attribValue.accept(visitor)
            }
            if let attribFlags = attribFlags {
                
                attribFlags.accept(visitor)
            }
            visitor.pop()
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {
        
        if let nodeInfo = visitor.visit(self) , nodeInfo.visitChildren {
        
            visitor.push(nodeInfo)
            
            attribName!.accept(visitor)
            
            if let attribMatch = attribMatch {
                
                attribMatch.accept(visitor)
            }
            
            if let attribValue = attribValue {
                
                attribValue.accept(visitor)
            }
            if let attribFlags = attribFlags {
                
                attribFlags.accept(visitor)
            }
            visitor.pop()
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: SelectionFilter protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var reverseFilter: ReverseFilter {
        
        return AttribSelectorReverseFilter(attribFlags: self.attribFlags, attribName: self.attribName, attribMatch: self.attribMatch, attribValue: self.attribValue, matchAttributeName: self.matchAttributeName)
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func ==(lhs: AttribSelector, rhs: AttribSelector) -> Bool {
    
    return lhs.equals(to: rhs)
}



