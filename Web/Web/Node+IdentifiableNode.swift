//
//  Node+IdentifiableNode.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-15.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension Node: IdentifiableNode {
    
    var nodeIdentity: NodeIdentity {
        
        if let nodeIdentity = self._nodeIdentity {
            return nodeIdentity
        }
    
        let nodeIdentity = NodeIdentity.create(from: self)
        self._nodeIdentity = nodeIdentity
        return nodeIdentity
    }
    
    func treePositionIdentity(withElement element: Element? = nil) -> TreePositionIdentity {
        
        if let treeIdentity = self._treePositionIdentity {
            return treeIdentity
        }

        let nodeIdentity = self.nodeIdentity
        let nodeIdentityString = String(describing: nodeIdentity)

        if self is PseudoElement {
            
            guard let element = element else {
                assertionFailure("Error: element is nil")
                return nodeIdentityString
            }
            
            let treePositionIdentity = element.treePositionIdentity()
            let identity = treePositionIdentity + ":" + nodeIdentityString
            self._treePositionIdentity = identity
            return identity
        }
        else if let parent = self.parentNode {
            
            let treePositionIdentity = parent.treePositionIdentity()
            let identity = treePositionIdentity + "/" + nodeIdentityString
            self._treePositionIdentity = identity
            return identity
        }
        self._treePositionIdentity = nodeIdentityString
        return nodeIdentityString
    }
}
