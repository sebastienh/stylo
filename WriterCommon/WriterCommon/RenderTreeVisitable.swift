//
//  RenderTreeVisitable.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-10.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

protocol RenderTreeVisitable: class {
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    func accept<Visitor: RenderTreeVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType?
    
}
