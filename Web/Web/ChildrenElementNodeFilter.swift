//
//  ChildrenElementNodeFilter.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-02-28.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

struct ChildrenElementNodeFilter: NodeFilter, ElementNodeFilter {
    
    let root: Node
    
    init(root: Node) {
        self.root = root
    }
    
    func acceptNode(_ node: Node) -> Int {
        
        if let _nodeParent = node.parentNode, node.nodeType == NodeType.element_node {
            
            if self.root === _nodeParent {
                
                return §AcceptNode.filter_ACCEPT
            }
            else {
                return §AcceptNode.filter_REJECT
            }
        }
        return §AcceptNode.filter_REJECT
    }
}
