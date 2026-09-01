//
//  RenderInline.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-09.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import Web

final class RenderInline: RenderObject {

    override func paintTemporary(contentString: StylableString, resourceComputedStyle: ResourceComputedStyle) {
        
        // noting to do
    }
    
    override func paint(contentString: StylableString, resourceComputedStyle: ResourceComputedStyle) {
        
        // noting to do
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: RenderTreeVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    override func accept<Visitor: RenderTreeVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        let nodeInfo = visitor.visit(self)
        
        if let _nodeInfo = nodeInfo {
        
            // it's possible for a RenderText to have a child
            visitor.push(_nodeInfo)
        
            var child: RenderObject? = firstChild as? RenderObject
        
            while let _child = child {
            
                _ = _child.accept(visitor)
            
                child = _child.nextSibling as? RenderObject
            }
        
            visitor.pop()
            
        }
        
        return nodeInfo
    }
    
    
}
