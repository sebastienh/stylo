//
//  CSSDOMNodeInfo.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-16.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common

final class CSSDOMNodeInfo : NodeInfo {

    let node: Node!
    
    var visitChildren: Bool
    
    init(node: Node?, visitChildren: Bool = true) {
        
        self.node = node
        self.visitChildren = visitChildren
    }
    
}
