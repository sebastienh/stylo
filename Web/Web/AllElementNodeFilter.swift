//
//  AllElementNodeFilter.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-09.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

/// see https://dom.spec.whatwg.org/#concept-getelementsbytagname
struct AllElementNodeFilter : ElementNodeFilter {
    
    init() {

    }
    
    func acceptNode(_ node: Node) -> Int {
        
        if node.nodeType == NodeType.element_node {
            
            if let _ = node as? Element {
                
                return §AcceptNode.filter_ACCEPT
            }
        }
        
        return §AcceptNode.filter_SKIP
    }
    
}
