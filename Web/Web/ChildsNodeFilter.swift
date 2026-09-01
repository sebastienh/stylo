//
//  NodeFilter.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-19.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

final class ChildNodeFilter : NodeFilter {
    
    let root: Node
    
    init(root: Node) {
        self.root = root
    }
    
    func acceptNode(_ node: Node) -> Int {
        
        if let _nodeParent = node.parentNode {
        
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
