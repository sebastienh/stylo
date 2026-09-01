//
//  OrderedSetSerializer.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-02-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

protocol OrderedSetSerializer: class {
    
    /// Method to support
    func stringify() -> DOMString
    
}
