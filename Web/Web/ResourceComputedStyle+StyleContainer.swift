//
//  ResourceComputedStyle+StyleContainer.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-21.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension ResourceComputedStyle: StyleContainer {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: StyleContainer protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// [SameObject] readonly attribute CSSStyleDeclaration cascadedStyle;
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-cascadedstyle
    public func cascadedStyleForElement(_ element: Element) -> ComputedStyleDeclaration {
        
        let elementStyle = self.elementStyle(forElement: element, filterContext: FilterContext())
        
        return elementStyle!.cascadedStyle
    }
    
    /// [SameObject] readonly attribute CSSStyleDeclaration defaultStyle;
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-defaultstyle
    public func defaultStyleForElement(_ element: Element) ->  ComputedStyleDeclaration {
        
        let elementStyle = self.elementStyle(forElement: element, filterContext: FilterContext())
        
        return elementStyle!.defaultStyle
    }
    
    /// [SameObject] readonly attribute CSSStyleDeclaration rawComputedStyle;
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-rawcomputedstyle
    public func rawComputedStyleForElement(_ element: Element) ->  ComputedStyleDeclaration {
        
        let elementStyle = self.elementStyle(forElement: element, filterContext: FilterContext())
        
        return elementStyle!.rawComputedStyle
    }
    
    /// [SameObject] readonly attribute CSSStyleDeclaration usedStyle;
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-usedstyle
    public func usedStyleForElement(_ element: Element) ->  ComputedStyleDeclaration {
        
        let elementStyle = self.elementStyle(forElement: element, filterContext: FilterContext())
        
        return elementStyle!.usedStyle
    }
    
    
    
}
