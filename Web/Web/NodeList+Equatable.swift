//
//  NodeList+Equatable.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-20.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation

extension NodeList : Equatable {
    
}

public func ==(lhs: NodeList, rhs: NodeList) -> Bool {

    let length: Int = lhs.length
    
    if rhs.length != length {
        
        return false
    }
    
    for i in 0..<length {

        let lhsNode = lhs[i]
        let rhsNode = rhs[i]
        
        if lhsNode != rhsNode {
            
            return false
        }
    }

    
    return true
}
