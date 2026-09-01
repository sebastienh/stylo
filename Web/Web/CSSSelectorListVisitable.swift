//
//  CSSSelectorListVisitable.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-05-14.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation

public protocol CSSSelectorListVisitable {
    
    // 1. Visit the root.
    // 2. Traverse the left subtree.
    // 3. Traverse the right subtree.
    func accept(_ visitor: CSSSelectorListVisitor)
    
}
