//
//  RenderDocumentFragment.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-12-23.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// The RenderDocumentFragment is not associated with a
/// DocumentFragment, is it simply the same concept in the RenderTree
/// because in the RenderTree we need to have a top document element.
class RenderDocumentFragment: RenderObject {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: RenderTreeVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    override func accept<Visitor: RenderTreeVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        fatalError("Missing subl")
    }
}
