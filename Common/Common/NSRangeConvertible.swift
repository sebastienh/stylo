//
//  NSRangeConvertible.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-10.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public protocol NSRangeConvertible {
    
    var range: NSRange? { get }
    
    var ranges: [NSRange] { get }
}
