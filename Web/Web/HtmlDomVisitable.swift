//
//  HtmlDomVisitable.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-08.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

public protocol HtmlDomVisitable: Visitable {
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    @discardableResult
    func accept<Visitor: HtmlDomVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType?

    @discardableResult
    func acceptSingle<Visitor: HtmlDomVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType?
    
}
