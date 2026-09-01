//
//  SingleNodeList.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-17.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common

final class SingleNodeList: NodeList {

    public override var length: Int {
        
        return 1
    }
    
    init(node: Node) {
        
        let filter = OneNodeFilter(root: node)
        
        super.init(root: node, filter: filter, inclusive: true)
    }
    
    public override func asArray() -> ContiguousArray<Node> {
        
        return ContiguousArray<Node>(arrayLiteral: root)
    }
    
    override func filteredDescendants() -> ContiguousArray<Node> {
        return ContiguousArray<Node>()
    }    
}
