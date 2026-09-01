//
//  RenderObjectNodeIndo.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-08.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import Web

final class RenderNodeInfo: NodeInfo, AttributesOperationsNodeInfo {

    let node: Node?
    
    let visitChildren: Bool
    
    var attributesOperations: AttributesOperations?
    
    init(node: Node? = nil, visitChildren: Bool = true, attributesOperations: AttributesOperations? = nil) {
        self.node = node
        self.visitChildren = visitChildren
        self.attributesOperations = attributesOperations
    }
    
}
