//
//  RangeContainedNodesFilter.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-09.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common

// A node "node" is contained in a range "range" if node's root
// is the same as range's root, and (node, 0) is after range's start, 
// and (node, length of node) is before range's end.
// see https://dom.spec.whatwg.org/#contained
final class RangeContainedNodesFilter : NodeFilter {
    
    var range: DOMRange?
    var rangeRoot: Node?
    
    var addedNodes: [Node]
    
    fileprivate var optional: NilOption
    
    init(_ range: DOMRange) {
        self.range = range
        self.rangeRoot = range.root
        self.optional = NilOption.some
        self.addedNodes = [Node]()
    }
    
    required init(nilLiteral: ()) {
        self.optional = NilOption.none
        self.range = nil
        self.addedNodes = [Node]()
    }
    
    func acceptNode(_ node: Node) -> Int {
       
        if let _range = range {
            
            if let _rangeRoot = rangeRoot {
             
                if _rangeRoot == node.root {
                    
                    if DomRangeRelativePosition.after == _range.relativePosition(of: (node, 0), relativeTo: (_range.startContainer, _range.startOffset)) {
                    
                        if DomRangeRelativePosition.before == _range.relativePosition(of: (node, node.length), relativeTo: (_range.endContainer, _range.endOffset)) {

                            //  omitting any node whose parent is also contained in the context object.
                            // see https://dom.spec.whatwg.org/#dom-range-deletecontents
                            for addedNode in addedNodes {
                            
                                if let _nodeParent = node.parentNode {
                                    
                                    if _nodeParent == addedNode {
                                        
                                        return §AcceptNode.filter_REJECT
                                    }
                                }
                            }
                            
                            return §AcceptNode.filter_ACCEPT
                        }
                    }
                }
            }
        }
        
        return AcceptNode.filter_SKIP.rawValue
    }
    
}
