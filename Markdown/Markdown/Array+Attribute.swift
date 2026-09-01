//
//  Array+Attribute.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-05-13.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

extension Array where Element == Attribute {
    
    func symmetricDifferenceWithIntersectingRanges(_ other: [Attribute]) -> Set<Attribute> {
        
        var attrs1 = self
        var attrs2 = other
        
        var sameIndexes = [Int]()
        
        for i in 0..<attrs1.count {
            
            for y in 0..<attrs2.count {
                
                if attrs1[i].isEqualWithIntersectingRange(to: attrs2[y]) {
                    
                    sameIndexes.append(i)
                    attrs2.remove(at: y)
                    break
                }
            }
        }
        
        for index in sameIndexes.reversed() {
            attrs1.remove(at: index)
        }
        
        if !attrs1.isEmpty || !attrs2.isEmpty {
            attrs1.append(contentsOf: attrs2)
        }
        
        if attrs1.isEmpty && attrs2.isEmpty {
            return Set<Attribute>()
        }
        
        return Set<Attribute>(attrs1)
    }
    
    
}
