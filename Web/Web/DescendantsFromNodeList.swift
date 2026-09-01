//
//  FollowingSiblingsDescendantsNodeList.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-11-12.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

class DescendantsFromNodeList: NodeList {
    
    let sourceNode: Node
    
    /// Init that takes the sourceNode from which to 
    /// start to compute descendants. It must be a child 
    /// of root.
    init(root: Node, filter: NodeFilter, inclusive: Bool, sourceNode: Node) {
        
        self.sourceNode = sourceNode
        
        super.init(root: root, filter: filter, inclusive: inclusive)
    }
    
    
    // def : An object A is called a descendant of an object B,
    // if either A is a child of B or A is a child of an object C
    // that is a descendant of B.
    override func filteredDescendants() -> ContiguousArray<Node> {
        
        if let _filteredDescendants = _filteredDescendants {
            
            return _filteredDescendants
        }
        
        var nodeArray = ContiguousArray<Node>()
        let node: Node? = self.sourceNode
        
        if let node = node {
            
            var result: (Node, AcceptNode)? = appendFilterResult(node)
            
            while let (node, accept) = result  {
                
                switch accept {
                    
                case .filter_ACCEPT:
                    
                    nodeArray.append(node)
                    result = treeOrderNextNode(node, root: root)
                    
                case .filter_REJECT:
                    
                    // skip all the subtree, and go to the sibling node
                    result = siblingNextNode(node, root: root)
                    
                case .filter_SKIP:
                    
                    result = treeOrderNextNode(node, root: root)
                }
            }
        }
        
        _filteredDescendants = nodeArray
        return _filteredDescendants!
    }
    
}
