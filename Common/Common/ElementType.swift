//
//  ElementType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-17.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public protocol ElementType {
    
    static func allValues() -> [ElementType]
    
    var name: String { get }
}
