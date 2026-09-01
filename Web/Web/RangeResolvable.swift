//
//  RangeResolvable.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-05-10.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation

public protocol RangeResolvable {
    
    func resolveRange(for string: String, withElement element: Element) -> [NSRange]?
}
