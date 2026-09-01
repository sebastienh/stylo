//
//  UnrecognizedAtRule.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-07-06.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os 

final public class UnrecognizedAtRule: CSSRule {

    public override var description: String {
        
        return "UnrecognizedAtRule"
    }
    
    var componentValuesList: [CSComponentValue]
    
    var endSemiColon: Token?
    
    init(sourceStringSegment: SourceStringSegment?, endSemiColon: Token? = nil, componentValuesList: [CSComponentValue], cssText: DOMString, parentStyleSheet: CSSStyleSheet? = nil, parentRule: CSSRule? = nil) {
        
        self.endSemiColon = endSemiColon
        self.componentValuesList = componentValuesList
        
        super.init(cssText: cssText, type: CSSRuleType.invalid_at_rule, parentStyleSheet: parentStyleSheet, parentRule: parentRule)
        
        self.sourceStringSegment = sourceStringSegment
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {
        
        visitor.visit(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public override func move(_ count: Int) {
        
        self.sourceStringFragment?.move(count)
        
        for i in 0..<componentValuesList.count {
            
            componentValuesList[i].move(count)
        }
        
        self.endSemiColon?.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? UnrecognizedAtRule {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not UnrecognizedAtRule.", log: Log.Web.all, type: .debug)
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
