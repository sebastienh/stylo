//
//  RangeElementsAdjacency.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-06-06.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

public enum RangeElementsAdjacency {
    
    case start
    
    case between(low: Int, up: Int)
    
    case covering(indexes: [Int])
    
    case exclusivelyInside(index: Int)
    
    case end 
}

extension RangeElementsAdjacency: Equatable {
    
    public static func ==(lhs: RangeElementsAdjacency, rhs: RangeElementsAdjacency) -> Bool {
        switch (lhs, rhs) {
        case (.start, .start):
            return true
        case (.end, .end):
            return true
        case (.between(let low1, let up1), .between(let low2, let up2)):
            return low1 == low2 && up1 == up2
        case (.covering(let indexes1), .covering(let indexes2)):
            return indexes1 == indexes2
        case (.exclusivelyInside(let index1), .exclusivelyInside(let index2)):
            return index1 == index2
        default:
            return false
        }
    }
}
