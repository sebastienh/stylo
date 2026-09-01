//
//  NameNodeMap+Equatable.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-02-27.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

extension NameNodeMap : Equatable {
    
}

func ==(lhs: NameNodeMap, rhs: NameNodeMap) -> Bool {
    
    let length: Int = lhs.length
    
    if rhs.length != length {
        
        return false
    }
    
    if length > 0 {
        
        for index in 0..<length {
            
            let lhsNode = lhs[index]
            let rhsNode = rhs[index]
            
            if lhsNode != rhsNode {
                
                return false
            }
        }
    }
    return true
}
