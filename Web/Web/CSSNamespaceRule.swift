//
//  CSSNamespaceRule.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-21.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

/// interface CSSNamespaceRule : CSSRule {
///     readonly attribute DOMString namespaceURI;
///     readonly attribute DOMString prefix;
/// };

///
/// > The CSSNamespaceRule interface represents an @namespace at-rule.
///
/// [The CSSNamespaceRule Interface](https://drafts.csswg.org/cssom/#the-cssnamespacerule-interface)
///
public final class CSSNamespaceRule: CSSRule {
    
    public override var description: String {
        var representationString = ""
        representationString += prefix
        representationString += cssNamespaceURI?.description ?? ""
        return representationString
    }
    
    ///
    /// > The namespaceURI attribute must return the namespace of the @namespace at-rule.
    ///
    /// readonly attribute DOMString namespaceURI;
    ///
    final var namespaceURI: DOMString? {
        
        return cssNamespaceURI?.stringValue
    }
    
    final var cssNamespaceURI: CSSNamespaceURI?
    
    ///
    /// > The prefix attribute must return the prefix of the @namespace at-rule or 
    /// > the empty string if there is no prefix.
    ///
    /// readonly attribute DOMString prefix;
    ///
    final var prefix: DOMString {
        
        if let cssNamespacePrefix = cssNamespacePrefix {
            return cssNamespacePrefix.stringValue
        }
        return ""
    }
    
    var isDefault: Bool {
        
        return prefix.count == 0
    }
    
    final var cssNamespacePrefix: CSSNamespacePrefix?
    
    var atKeywordToken: Token?
    
    /// A namespace rule should not contain any suffix blocks
    /// We keep here for the CSSDOM renderer to render them in
    /// the CSSDOM.
    var unexpectedSuffixComponentsValues: [CSComponentValue]?
    
    var endSemiColon: Token? {
        
        didSet {
         
            let endSemiColonEndIndex = endSemiColon?.sourceStringSegment?.endIndex
            
            if let endSemiColonEndIndex = endSemiColonEndIndex {
                self.sourceStringSegment?.endIndex = endSemiColonEndIndex
            }
        }
    }
    
    init(cssNamespaceURI: CSSNamespaceURI? = nil, cssNamespacePrefix: CSSNamespacePrefix? = nil, endSemiColon: Token? = nil, cssText: DOMString, parentStyleSheet: CSSStyleSheet? = nil, parentRule: CSSRule? = nil) {
        
        self.cssNamespaceURI = cssNamespaceURI
        self.cssNamespacePrefix = cssNamespacePrefix
        self.endSemiColon = endSemiColon
        
        super.init(cssText: cssText, type: CSSRuleType.namespace_rule, parentStyleSheet: parentStyleSheet, parentRule: parentRule)
    }

    override func clone(_ parentStyleSheet: CSSStyleSheet? = nil, parentRule: CSSRule? = nil) -> CSSRule {
        
        let namespaceRuleClone = CSSNamespaceRule(cssNamespaceURI: self.cssNamespaceURI, cssNamespacePrefix: self.cssNamespacePrefix, endSemiColon: self.endSemiColon, cssText: self.cssText, parentStyleSheet: parentStyleSheet, parentRule: parentRule)
        
        namespaceRuleClone.atKeywordToken = self.atKeywordToken
        namespaceRuleClone.sourceStringFragment = self.sourceStringFragment
        
        if let unexpectedSuffixComponentsValues = self.unexpectedSuffixComponentsValues {
        
            var unexpectedSuffixComponentsValuesClone = [CSComponentValue]()
            for unexpectedSuffixComponentsValue in unexpectedSuffixComponentsValues {
                unexpectedSuffixComponentsValuesClone.append(unexpectedSuffixComponentsValue.clone())
            }
            namespaceRuleClone.unexpectedSuffixComponentsValues = unexpectedSuffixComponentsValuesClone
        }
        
        return namespaceRuleClone
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////override
    
    override public func accept(_ visitor: CSSVisitor) {
        
        if let nodeInfo = visitor.visit(self) , nodeInfo.visitChildren {
            
            visitor.push(nodeInfo)
            
            if let cssNamespacePrefix = cssNamespacePrefix {
                
                cssNamespacePrefix.accept(visitor)
            }
            if let cssNamespaceURI = cssNamespaceURI {
            
                cssNamespaceURI.accept(visitor)
            }
            if unexpectedSuffixComponentsValues != nil {
                
                visitor.postVisit(self)
            }
            visitor.pop()
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public override func move(_ count: Int) {
        
        self.sourceStringFragment?.move(count)
        
        cssNamespaceURI?.move(count)
        cssNamespacePrefix?.move(count)
        
        atKeywordToken?.move(count)
        endSemiColon?.move(count)
        
        if unexpectedSuffixComponentsValues != nil {
            for i in 0..<unexpectedSuffixComponentsValues!.count {
                unexpectedSuffixComponentsValues![i].move(count)
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? CSSNamespaceRule {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if let cssNamespacePrefix = cssNamespacePrefix {
                    
                    if !cssNamespacePrefix.equals(to: other.cssNamespacePrefix, comparePositions: comparePositions) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: cssNamespacePrefix are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.cssNamespacePrefix != nil {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other cssNamespacePrefix is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if let cssNamespaceURI = cssNamespaceURI {
                    
                    if !cssNamespaceURI.equals(to: other.cssNamespaceURI, comparePositions: comparePositions) {
                     
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: cssNamespaceURI are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.cssNamespaceURI != nil {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other cssNamespaceURI is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if let unexpectedSuffixComponentsValues = unexpectedSuffixComponentsValues {
                
                    if let otherUnexpectedSuffixComponentsValues = other.unexpectedSuffixComponentsValues {
                    
                        if unexpectedSuffixComponentsValues.count != otherUnexpectedSuffixComponentsValues.count {
                            
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("Not equals: unexpectedSuffixComponentsValues count is different.", log: Log.Web.all, type: .debug)
                            #endif
                            return false
                        }
                        
                        for (index, component) in unexpectedSuffixComponentsValues.enumerated() {
                            
                            let otherComponent = otherUnexpectedSuffixComponentsValues[index]
                            
                            if !component.equals(to: otherComponent, comparePositions: comparePositions) {
                                
                                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                os_log("Not equals: componenta are different.", log: Log.Web.all, type: .debug)
                                #endif
                                return false
                            }
                        }
                    }
                    else {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: other unexpectedSuffixComponentsValues is nil.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.unexpectedSuffixComponentsValues != nil {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other unexpectedSuffixComponentsValues is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CSSNamespaceRule.", log: Log.Web.all, type: .debug)
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
