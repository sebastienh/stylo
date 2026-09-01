//
//  RangeContainedChildNodesFilter.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-16.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

/// Let contained children be a list of all children of common ancestor 
/// that are contained in range, in tree order.
/// see https://dom.spec.whatwg.org/#concept-range-extract 14
final class RangeContainedChildrenFilter : NodeFilter {
    
    var range: DOMRange?
    var rangeRoot: Node?
    var root: Node
    var addedNodes: [Node]
    
    fileprivate var optional: NilOption
    
    init(_ range: DOMRange, root: Node) {
        self.range = range
        self.rangeRoot = range.root
        self.optional = NilOption.some
        self.addedNodes = [Node]()
        self.root = root
    }
    
    func acceptNode(_ node: Node) -> Int {
        
        if let _nodeParent = node.parentNode {
            
            if self.root != _nodeParent {
                return §AcceptNode.filter_REJECT
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("node is supposed to have a parent since it has a root.", log: Log.Web.all, type: .error)
            #endif
        }
        
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
        
        return §AcceptNode.filter_SKIP
    }
    
}
