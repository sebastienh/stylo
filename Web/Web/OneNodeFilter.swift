//
//  SelfNodeFilter.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-16.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common

final class OneNodeFilter : NodeFilter {
    
    let root: Node
    
    init(root: Node) {
        self.root = root
    }
    
    func acceptNode(_ node: Node) -> Int {
        
        if node == self.root {
            
            return §AcceptNode.filter_ACCEPT
        }
        return §AcceptNode.filter_REJECT
    }
    
}
