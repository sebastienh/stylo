//
//  IntegerConvertible.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-08-29.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

public protocol IntegerConvertible {
    
    var integerValue: Int { get }
}

extension Int: IntegerConvertible {
    
    public var integerValue: Int {
        
        return self
    }
}

prefix operator ~

public prefix func ~<T: IntegerConvertible> (lhs: T) -> Int {
    return lhs.integerValue
}
