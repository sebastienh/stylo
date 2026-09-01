//
//  CSSDOMVisitable.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-08.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

public protocol CSSDOMVisitable: Visitable {
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    @discardableResult
    func accept<Visitor: CSSDOMVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType?
    
    @discardableResult
    func acceptSingle<Visitor: CSSDOMVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType?
}
