//
//  InvalidComplexSelector.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-06-30.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

// http://dev.w3.org/csswg/selectors4/#id-selector
public final class InvalidComplexSelector: ComplexSelector {
    
    var invalidComponentValues: [CSComponentValue]
    
    init(sourceStringSegment: SourceStringSegment?, parent: SelectorList?, invalidComponentValues: [CSComponentValue]) {
        
        self.invalidComponentValues = [CSComponentValue]()
        
        super.init(sourceStringSegment: sourceStringSegment, parent: parent)
        
        self.invalidComponentValues = invalidComponentValues
//        
//        for invalidComponentValue in invalidComponentValues {
//            self.invalidComponentValues.append(invalidComponentValue.clone())
//        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Selector protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
        
        selectorSpecificity.A += 1000
    }
    
    override public var selectorText: String {
        
        var selectorTextValue: String = ""
        
        for invalidComponentValue in invalidComponentValues {
            selectorTextValue += invalidComponentValue.cssText()
        }
        
        return selectorTextValue
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public override func move(_ count: Int) {
        
        self.sourceStringFragment?.move(count)
        
        for i in 0..<invalidComponentValues.count {
            
            invalidComponentValues[i].move(count)
        }
        
        self.precedingCommaToken?.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? InvalidComplexSelector {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if invalidComponentValues.count != other.invalidComponentValues.count {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: invalidComponentValues.count are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                for i in 0..<invalidComponentValues.count {
                    
                    let selfComponent = invalidComponentValues[i]
                    let otherComponent = invalidComponentValues[i]
                    
                    if !selfComponent.equals(to: otherComponent, comparePositions: comparePositions) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: invalidComponentValues element are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not InvalidCompoundSelector.", log: Log.Web.all, type: .debug)
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
    //                                  MARK: EvaluableSelector protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func constructReverseEvaluatorChain(_ selectorEvaluatorChain: inout SelectorEvaluatorChain) {
        
        // do nothing
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
    
    public override func accept(_ visitor: CSSVisitor) {
        
        if let nodeInfo = visitor.visit(self) {
            
            visitor.push(nodeInfo)
            // here we handle the invalid component values
            visitor.postVisit(self)
            visitor.pop()
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func ==(lhs: InvalidComplexSelector, rhs: InvalidComplexSelector) -> Bool {
    
    return lhs.equals(to: rhs)
}

