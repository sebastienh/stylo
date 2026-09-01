//
//  GetStyleUtils.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-04.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

//[NoInterfaceObject]interface GetStyleUtils {
//    [SameObject] readonly attribute CSSStyleDeclaration cascadedStyle;
//    [SameObject] readonly attribute CSSStyleDeclaration defaultStyle;
//    [SameObject] readonly attribute CSSStyleDeclaration rawComputedStyle;
//    [SameObject] readonly attribute CSSStyleDeclaration usedStyle;
//};

/// see http://dev.w3.org/csswg/cssom/#getstyleutils
public protocol GetStyleUtils {
    
    /// [SameObject] readonly attribute CSSStyleDeclaration cascadedStyle;
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-cascadedstyle
    var cascadedStyle: RawComputedStyle { get }
    
    /// [SameObject] readonly attribute CSSStyleDeclaration defaultStyle;
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-defaultstyle
    var defaultStyle: RawComputedStyle { get }
    
    /// [SameObject] readonly attribute CSSStyleDeclaration rawComputedStyle;
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-rawcomputedstyle
    var rawComputedStyle: RawComputedStyle { get }
    
    /// [SameObject] readonly attribute CSSStyleDeclaration usedStyle;
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-usedstyle
    var usedStyle: RawComputedStyle { get }
}
