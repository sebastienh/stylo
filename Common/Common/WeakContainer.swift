//
//  WeakContainer.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-05-23.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
/// http://stackoverflow.com/questions/24127587/how-do-i-declare-an-array-of-weak-references-in-swift
public struct WeakContainer<T: AnyObject> {
    
    public weak var value: T?
    
    public init(value: T) {
        
        self.value = value
    }
}

extension WeakContainer: Equatable where T: Equatable {
    
    public static func ==(lhs: WeakContainer, rhs: WeakContainer) -> Bool {
        
        return lhs.value == rhs.value
    }
}
