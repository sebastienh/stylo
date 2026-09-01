//
//  NodeFilterType.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-19.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

//https://dom.spec.whatwg.org/#nodefilter
//    // Constants for acceptNode()
//    const unsigned short FILTER_ACCEPT = 1;
//    const unsigned short FILTER_REJECT = 2;
//    const unsigned short FILTER_SKIP = 3;
enum AcceptNode : Int {
    
    case filter_ACCEPT = 1
    case filter_REJECT = 2
    case filter_SKIP = 3
}
