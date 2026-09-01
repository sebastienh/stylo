//
//  TextChildsNodeFilter.swift
//  Web
//
//  Created by Sebastien hamel on 2018-11-05.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common

final class TextChildsNodeFilter: NodeFilter {
    
    let root: Node
    
    init(root: Node) {
        self.root = root
    }
    
    func acceptNode(_ node: Node) -> Int {
        
        if let _nodeParent = node.parentNode, node.nodeType == .text_node {
            
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
