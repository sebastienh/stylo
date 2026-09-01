//
//  NextSiblingNodeInfo.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-11-23.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation
import Common

struct NextSiblingNodeInfo: NodeInfo {
    
    let visitChildren: Bool
    
    init(visitChildren: Bool) {
        self.visitChildren = visitChildren
    }
    
}
