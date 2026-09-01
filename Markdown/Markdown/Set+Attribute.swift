//
//  Set+Attribute.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-05-13.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

extension Set where Element == Attribute {
    
    func symmetricDifferenceWithIntersectingRanges(_ other: Set<Attribute>) -> Set<Attribute> {
        
        var attrs1 = Array(self)
        var attrs2 = Array(other)
        
        return attrs1.symmetricDifferenceWithIntersectingRanges(attrs2)
    }
}
