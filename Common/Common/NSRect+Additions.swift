//
//  NSRect+Additions.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-03-06.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

extension NSRect {
    
    public func intersectBefore(other: NSRect) -> Bool {
        
        if self.minY < other.minY {
            return true
        }
        return false
    }
    
}
