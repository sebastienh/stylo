//
//  IdentifiableNode.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-15.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

protocol IdentifiableNode {
    
    var _nodeIdentity: NodeIdentity? { get set }
    
    var _treePositionIdentity: TreePositionIdentity? { get set }
    
    var nodeIdentity: NodeIdentity { get }
    
    func treePositionIdentity(withElement element: Element?) -> TreePositionIdentity
    
}
