//
//  SimpleSelector.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-30.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

// http://dev.w3.org/csswg/selectors4/#simple
// A simple selector represents an aspect of an element to be 
// matched against. A simple selector is either a 
//  type selector, 
//  universal selector, 
//  attribute selector, 
//  class selector, 
//  ID selector, or 
//  pseudo-class.
open class SimpleSelector: BaseSelector {
    
    /// Variable that returns the pseudo under the specified
    /// selector.
    var associatedPseudoSelectors: [Pseudo]? {
        
        let parentCompoundSelector = parent as! CompoundSelector
        
        var returnNextIfValid = false
        
        var pseudos: [Pseudo] = []
        
        for simpleSelector in parentCompoundSelector.simpleSelectorSequence {
            if simpleSelector == self {
                returnNextIfValid = true
            }
            else if returnNextIfValid {
                
                if let pseudo = simpleSelector as? Pseudo {
                    pseudos.append(pseudo)
                }
            }
        }
        return pseudos
    }
    
    var ephemeralPseudoClass: PseudoClassesOptions? {
        return nil
    }
    
    init(sourceStringSegment: SourceStringSegment?, parentCompoundSelector: CompoundSelector?) {
        
        super.init(sourceStringSegment: sourceStringSegment)
        
        self.parent = parentCompoundSelector
    }
    
    func clone(_ parent: CompoundSelector) -> SimpleSelector {
        
        fatalError("Missing subclass implementation.")
    }
    
    override open var selectorText: String {

        assert(false, "Missing subclass implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("selectorText(...) missing subclass implementation.", log: Log.Web.all, type: .error)
        #endif
        return ""
    }
    
    override open var selectorTextWithPositions: String {
        
        assert(false, "Missing subclass implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("selectorTextWithPositions missing subclass implementation.", log: Log.Web.all, type: .error)
        #endif
        return ""
    }
    
    override open func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
    
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing subclass implementation.", log: Log.Web.all, type: .fault)
        #endif
    }
    
    var selectorType: RightmostSelectorType {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("ERROR: THIS METHOD SHOULD NOT BE CALLED!!!", log: Log.Web.all, type: .fault)
        #endif
        
        return RightmostSelectorType.generic
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public func move(_ count: Int) {
        
        self.sourceStringFragment?.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? SimpleSelector {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not SimpleSelector.", log: Log.Web.all, type: .debug)
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
    //                                  MARK: Serializable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open func serialize() -> String {
        
        return selectorText
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Compilable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override open var minimalCompilationUnit: CSSOMLanguageObject {
        
        return self.parent!.minimalCompilationUnit
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSSelectorListVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override func accept(_ visitor: CSSSelectorListVisitor) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing subclass implementation!", log: Log.Web.all, type: .fault)
        #endif
        assert(false, "Missing subclass implementation.")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override open func accept(_ visitor: CSSVisitor) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing subclass implementation!", log: Log.Web.all, type: .fault)
        #endif
        assert(false, "Missing subclass implementation.")
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func ==(lhs: SimpleSelector, rhs: SimpleSelector) -> Bool {
    
    // When the two selectors are not of the same type (that's why we are here...)
    // they cant be equal.
    return lhs.equals(to: rhs)
}
