//
//  IdentPseudoClass.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-06.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

public final class IdentPseudoClass: PseudoClass {
    
    override var name: String {
     
        return ident.identString
    }
    
    var ident: Ident
    
    var isEphemeral: Bool {
        
        guard let pseudoSelectorType = PseudoSelectorType(rawValue: self.name) else {
            assertionFailure("Error: pseudoSelectorType is nil")
            return false
        }
        
        return pseudoSelectorType.isEphemeral
    }
    
    override var ephemeralPseudoClass: PseudoClassesOptions? {
        if self.name == §PseudoSelectorType.focus {
            return [.focus]
        }
        else if self.name == §PseudoSelectorType.flash {
            return [.flash]
        }
        else if self.name == §PseudoSelectorType.fade {
            return [.fade]
        }
        return nil
    }
    
    private var pseudoOption: PseudoClassesOptions? {
        
        return PseudoClassesOptions.from(name: self.name)
    }
    
    private var pseudoClassName: String {
        if let formattedIdent = self.ident.formattedIdent {
            return formattedIdent
        }
        else {
            return self.ident.rawIdent
        }
    }
    
    override var selectorType: RightmostSelectorType {
        
        return RightmostSelectorType.pseudoClass(name)
    }
    
    init(sourceStringSegment: SourceStringSegment?, ident: Ident, parentCompoundSelector: CompoundSelector, firstColonToken: Token, classIdentToken: Token) {
        
        self.ident = ident
        
        super.init(sourceStringSegment: sourceStringSegment, parentCompoundSelector: parentCompoundSelector, firstColonToken: firstColonToken, classIdentToken: classIdentToken)
    }
    
    override func clone(_ parent: CompoundSelector) -> SimpleSelector {
        
        return IdentPseudoClass(sourceStringSegment: nil, ident: ident.clone(), parentCompoundSelector: parent, firstColonToken: self.firstColonToken, classIdentToken: self.classIdentToken)
    }
    
    override public var selectorText: String {
        
        var selectorTextValue: String = ":"
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
        
        super.move(count)
        self.ident.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
        
            if let other = other as? IdentPseudoClass {
            
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.ident != other.ident {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: ident are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not IdentPseudoClass.", log: Log.Web.all, type: .debug)
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
    
    override var reverseFilter: ReverseFilter {
        
        return IdentPseudoClassReverseFilter(pseudoOption: self.pseudoOption, pseudoClassName: self.pseudoClassName)
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func ==(lhs: IdentPseudoClass, rhs: IdentPseudoClass) -> Bool {
    
    return lhs.equals(to: rhs)
}
