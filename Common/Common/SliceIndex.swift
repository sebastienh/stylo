//
//  SliceIndex.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-09-08.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

struct SliceIndex: IntegerConvertible {
    
    let localIndex: Int
    
    let originalIndex: Int
    
    var integerValue: Int {
    
        return localIndex
    }
    
    init(localIndex: Int, originalIndex: Int) {
        
        self.localIndex = localIndex
        self.originalIndex = originalIndex
    }
    
}
