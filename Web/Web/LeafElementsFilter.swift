//
//  LeafElementsFilter.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-06-24.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import Common

struct LeafElementsFilter : NodeFilter, ElementNodeFilter {

    let root: Node
    
    init(root: Node) {
        
        self.root = root
    }
    
    func acceptNode(_ node: Node) -> Int {
        
        if let element = node as? Element, element.children.length == 0, element.sourceStringFragment != nil {
            
            return §AcceptNode.filter_ACCEPT
            
        }
        return §AcceptNode.filter_SKIP
    }
}
