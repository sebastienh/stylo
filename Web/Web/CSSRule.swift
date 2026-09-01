//
//  CSSRule.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-18.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

//http://dev.w3.org/csswg/cssom/#cssrule
//interface CSSRule {
//    const unsigned short STYLE_RULE = 1;
//    const unsigned short CHARSET_RULE = 2;
//    const unsigned short IMPORT_RULE = 3;
//    const unsigned short MEDIA_RULE = 4;
//    const unsigned short FONT_FACE_RULE = 5;
//    const unsigned short PAGE_RULE = 6;
//    const unsigned short MARGIN_RULE = 9;
//    const unsigned short NAMESPACE_RULE = 10;
//    readonly attribute unsigned short type;
//    attribute DOMString cssText;
//    readonly attribute CSSRule? parentRule;
//    readonly attribute CSSStyleSheet? parentStyleSheet;
//};

protocol ICSSRule: class, CustomStringConvertible {
    
    var type: CSSRuleType { get }
    var cssText: DOMString { get set }
    var parentRule: CSSRule? { get }
    var parentStyleSheet: CSSStyleSheet? { get }
}

open class CSSRule: CSSOMLanguageObject, ICSSRule {
    
    public var description: String {
        assertionFailure("Error: should not use CSSRule.description")
        return ""
    }
    
    public var descriptionWithPositions: String {
        assertionFailure("Error: should not use CSSRule.descriptionWithPositions")
        return ""
    }
    
    /// readonly attribute unsigned short type;
    /// see http://dev.w3.org/csswg/cssom/#dom-cssrule-type
    public internal(set) var type: CSSRuleType
    
    /// attribute DOMString cssText;
    /// see http://dev.w3.org/csswg/cssom/#dom-cssrule-csstext
    var cssText: DOMString
    
    /// readonly attribute CSSRule? parentRule;
    /// see http://dev.w3.org/csswg/cssom/#dom-cssrule-parentrule
    open weak var parentRule: CSSRule?
    
    /// readonly attribute CSSStyleSheet? parentStyleSheet;
    /// see http://dev.w3.org/csswg/cssom/#dom-cssrule-parentstylesheet
    open weak var parentStyleSheet: CSSStyleSheet?
    
    public var associatedDomNodes: ContiguousArray<Node>? {
        
        if let correspondingCssDomElement = correspondingCssDomElement {
        
            var nodes = ContiguousArray<Node>()
            nodes.append(correspondingCssDomElement)
            return nodes
        }
        return nil
    }
    
    init(cssText: DOMString, type: CSSRuleType, parentStyleSheet: CSSStyleSheet?, parentRule: CSSRule? = nil) {
        self.type = type
        self.cssText = cssText
        self.parentStyleSheet = parentStyleSheet
        super.init(sourceStringSegment: nil)
        self.parent = parentStyleSheet
        self.parentRule = parentRule
    }
    
    func clone(_ parentStyleSheet: CSSStyleSheet?, parentRule: CSSRule? = nil) -> CSSRule {
     
        let clone = CSSRule(cssText: self.cssText, type: self.type, parentStyleSheet: parentStyleSheet, parentRule: parentRule)
        
        clone.sourceStringSegment = self.sourceStringSegment
        return clone
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
        
            if let other = other as? CSSRule {
            
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.type != other.type {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: rule type are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CSSRule.", log: Log.Web.all, type: .debug)
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
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////override
    
    override open func accept(_ visitor: CSSVisitor) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing implementation!", log: Log.Web.all, type: .fault)
        #endif
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Implementation of == required by Equatable
public func ==(lhs: CSSRule, rhs: CSSRule) -> Bool {
    
    return lhs.equals(to: rhs)
}




