//
//  HtmlDomNodeInfo.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-08.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

final class HtmlDomNodeInfo: NodeInfo {
    
    let visitableNode: HtmlDomVisitable?
    
    let visitChildren: Bool
    
    init(visitableNode: HtmlDomVisitable?, visitChildren: Bool = true) {
        
        self.visitableNode = visitableNode
        self.visitChildren = visitChildren
    }
    
}
