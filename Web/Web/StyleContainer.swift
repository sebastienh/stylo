//
//  StyleContainer.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-07-18.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

protocol StyleContainer: class {
    
    /// [SameObject] readonly attribute CSSStyleDeclaration cascadedStyle;
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-cascadedstyle
    func cascadedStyleForElement(_ element: Element) -> ComputedStyleDeclaration
    
    /// [SameObject] readonly attribute CSSStyleDeclaration defaultStyle;
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-defaultstyle
    func defaultStyleForElement(_ element: Element) ->  ComputedStyleDeclaration
    
    /// [SameObject] readonly attribute CSSStyleDeclaration rawComputedStyle;
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-rawcomputedstyle
    func rawComputedStyleForElement(_ element: Element) ->  ComputedStyleDeclaration
    
    /// [SameObject] readonly attribute CSSStyleDeclaration usedStyle;
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-usedstyle
    func usedStyleForElement(_ element: Element) ->  ComputedStyleDeclaration
    
    func computedStyle(forElement element: Element) -> ComputedStyleDeclaration?
}
