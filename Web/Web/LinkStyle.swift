//
//  LinkStyle.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-19.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation

// http://dev.w3.org/csswg/cssom/#linkstyle
//[NoInterfaceObject]
//interface LinkStyle {
//    readonly attribute StyleSheet? sheet;
//};

protocol LinkStyle: class {
    
    var sheet: StyleSheet? { get }
}
