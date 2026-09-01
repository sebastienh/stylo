//
//  EnumRawValueOperator.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-07-07.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

prefix operator §

public prefix func §<T: RawRepresentable> (lhs: T) -> T.RawValue {
    return lhs.rawValue
}

