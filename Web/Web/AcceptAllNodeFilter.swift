//
//  AcceptAllNodeFilter.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-25.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common

final class AcceptAllNodeFilter : NodeFilter {
    
    func acceptNode(_ node: Node) -> Int {
        
        return §AcceptNode.filter_ACCEPT
    }
    
}
