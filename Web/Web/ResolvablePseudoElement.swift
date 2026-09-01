//
//  Resolvable.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-07.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

protocol ResolvablePseudoElement: class {
    
    func resolve() -> [Element]
    
}
