//
//  ElementStyle.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

final class ElementStyle {
    
    /// The associated element is a weak var because we don't want to retain it if
    /// the processor (mostly DocumentProcessor) has decided to remove it in consequence
    /// of a source document parsing.
    weak var associatedElement: Element?
    
    unowned let resourceComputedStyle: ResourceComputedStyle
    
    var inheritingElementStyle: ElementStyle?
    
    internal var userLevelStyle: RawComputedStyle {
        
        return evaluatedStyle.userLevelStyle
    }
    
    internal var userAgentLevelStyle: RawComputedStyle {
        
        return evaluatedStyle.userAgentLevelStyle
    }
    
    /// [SameObject] readonly attribute CSSStyleDeclaration cascadedStyle;
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-cascadedstyle
    var cascadedStyle: RawComputedStyle {
        
        return evaluatedStyle.cascadedStyle
    }
    
    /// [SameObject] readonly attribute CSSStyleDeclaration specified value
    /// see http://dev.w3.org/csswg/css-cascade-4/#specified-value
    internal var specifiedValues: RawComputedStyle {
        
        return evaluatedStyle.specifiedValues
    }
    
    /// [SameObject] readonly attribute CSSStyleDeclaration defaultStyle;
    /// The default style comes from the computed value
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-defaultstyle
    var defaultStyle: RawComputedStyle {

        return evaluatedStyle.defaultStyle
    }
    
    /// [SameObject] readonly attribute CSSStyleDeclaration rawComputedStyle;
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-rawcomputedstyle
    var rawComputedStyle: RawComputedStyle {
        
        return evaluatedStyle.rawComputedStyle
    }
    
    //    internal var _usedStyle: CSSStyleDeclaration?
    //
    //    /// [SameObject] readonly attribute CSSStyleDeclaration usedStyle;
    //    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-usedstyle
    var usedStyle: ComputedStyleDeclaration {
        
        assert(false, "missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Error: missing usedStyle implementation.", log: Log.Web.all, type: .error)
        #endif
        return evaluatedStyle.rawComputedStyle
    }
    
    var isStyleEvaluated: Bool = false
    
    @Atomic var evaluatedStyle: EvaluatedStyle
    
    // , inheritingElementStyle: ElementStyle?
    init(associatedElement: Element, resourceComputedStyle: ResourceComputedStyle, inheritingElementStyle: ElementStyle?) {
        
        assert(associatedElement.document != nil)
        self.associatedElement = associatedElement
        self.resourceComputedStyle = resourceComputedStyle
        self.inheritingElementStyle = inheritingElementStyle
        self.evaluatedStyle = EvaluatedStyle()
    }
    
    /// This constructor is used when we already
    /// know the evaluated style.
    init(associatedElement: Element, evaluatedStyle: EvaluatedStyle, resourceComputedStyle: ResourceComputedStyle, inheritingElementStyle: ElementStyle?) {

        assert(associatedElement.document != nil)
        self.associatedElement = associatedElement
        self.resourceComputedStyle = resourceComputedStyle
        self.evaluatedStyle = evaluatedStyle
        self.inheritingElementStyle = inheritingElementStyle
    }
    
    func evaluateStyle(filterContext: FilterContext) {
        
        if !isStyleEvaluated {
            
            // after this all inherited properties are filled
            // only (maybe) left some relative properties
            // inserted in the cascading process which we will
            // solve at the next step.
            computeSpecifiedValues(filterContext: filterContext)
            
            // resolve all remaining relative values.
            computeRawComputedStyle(filterContext: filterContext)
            
            // compute the used style
            //            computeUsedStyle()
            
            // compute actual style
            // the actual style should be computed by the render
            // object based on rendering and layout information.
            //            computeActualStyle()
            isStyleEvaluated = true
        }
    }
    
    /// Compute the default style.
    ///
    /// def: All longhand properties that are supported CSS properties, in lexicographical order,
    /// with the value being the computed value computed for the context object using the user-agent-level
    /// style rules and user-level style rules associated with the context object’s associated document,
    /// ignoring transitions, animations, author-level style rules, author-level presentational hints and
    /// override-level style rules.
    ///
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-defaultstyle
    func computeDefaultStyle() {
        
        assert(false, "Missing ")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("computeDefaultStyle() missing implementation.", log: Log.Web.all, type: .error)
        #endif
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Equals method
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func equals(_ other: Any?) -> Bool {
        
        if let other = other {
            
            if let other = other as? ElementStyle {
                
                if !rawComputedStyle.equals(to: other.rawComputedStyle) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: rawComputedStyle are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not ElementStyle.", log: Log.Web.all, type: .debug)
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
    //                                  MARK: Private methods
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
}

extension ElementStyle: Equatable {
    
    static func == (lhs: ElementStyle, rhs: ElementStyle) -> Bool {
    
        return lhs.equals(rhs)
    }
}
