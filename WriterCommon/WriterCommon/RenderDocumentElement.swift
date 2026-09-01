//
//  RenderDocumentElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-10-01.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common
import Web

/// RenderDocumentElement will be used to render whole document attributes
/// like background color and other attributes associated with the document
/// as defined by apple document attributes:
/// [Document Attributes](https://developer.apple.com/library/ios/documentation/UIKit/Reference/NSAttributedString_UIKit_Additions/index.html#//apple_ref/c/data/NSDocumentTypeDocumentAttribute)
final class RenderDocumentElement: RenderObject {
    
    override func paintTemporary(contentString: StylableString, resourceComputedStyle: ResourceComputedStyle) {
        
        //        fatalError("Missing subclass implementation.")
    }
    
    override func paint(contentString: StylableString, resourceComputedStyle: ResourceComputedStyle) {

        // only executes if the element for which we want to layout
        // still exists. We need this because once the render tree is
        // created the DOM cleanup and DOM update could still run and
        // delete elements in the DOM tree.
        if let _ = element {
            
            if documentAttributesElement {
                
                layoutDocumentAttributes(resourceComputedStyle: resourceComputedStyle)
                paintDocumentAttributes(contentString: contentString)
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: RenderTreeVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    override func accept<Visitor: RenderTreeVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        let nodeInfo = visitor.visit(self)
        
        // it's possible for a RenderText to have a child
        if let _nodeInfo = nodeInfo {
            
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
