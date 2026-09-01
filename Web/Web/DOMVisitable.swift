//
//  DOMVisitable.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-07-03.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

protocol DOMVisitable: Visitable {
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    func accept<Visitor: DOMVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType?
    
}
