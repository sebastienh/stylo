//
//  Visitable.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-07.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

public protocol CSVisitable {
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    func accept(_ visitor: CSVisitor) -> NodeInfo
    
}
