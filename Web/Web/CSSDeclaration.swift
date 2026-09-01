//
//  CSSDeclaration.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-16.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation

// http://dev.w3.org/csswg/cssom/#css-declaration

//  A CSS declaration is an abstract concept that is not exposed as an object in the DOM.
//  A CSS declaration has the following associated properties:
//  property name
//      The property name of the declaration.
//
//  value
//      The value of the declaration represented as a list of component values.
//
//  important flag
//      Either set or unset. Can be changed.
//
//  case-sensitive flag
//      Set if the property name is defined to be case-sensitive according to its specification, otherwise unset.
//
//public class CSSDeclaration : CSSNode {
//    
//    var propertyName: String
//    var value: [CSComponentValue]
//    var importantFlag: Bool = false
//    var caseSensitiveFlag: Bool = false
//    
//    init(propertyName: String) {
//        self.propertyName = propertyName
//        self.value = [CSComponentValue]()
//    }
//}
