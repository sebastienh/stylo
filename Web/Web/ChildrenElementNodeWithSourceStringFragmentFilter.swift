//
//  ChildrenElementNodeWithSourceStringFragmentFilter.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-10-25.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import Common

struct ChildrenElementNodeWithSourceStringFragmentFilter : NodeFilter, ElementNodeFilter {
    
    let root: Node
    
    init(root: Node) {
        self.root = root
    }
    
    func acceptNode(_ node: Node) -> Int {
        
        if let _nodeParent = node.parentNode, node.nodeType == NodeType.element_node, node.sourceStringFragment != nil {
            
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
