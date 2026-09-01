//
//  CSSVisitable.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-15.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation

public protocol CSSVisitable {
    
    // 1. Visit the root.
    // 2. Traverse the left subtree.
    // 3. Traverse the right subtree.
    func accept(_ visitor: CSSVisitor)
    
}
