//
//  RulesFilter.swift
//  Web
//
//  Created by Sebastien Hamel on 2021-01-19.
//  Copyright © 2021 Textually Inc. All rights reserved.
//

import Foundation
import Common

struct RulesFilter: NodeFilter, ElementNodeFilter {
    
    let root: Node
    
    init(root: Node) {
        self.root = root
    }
    
    func acceptNode(_ node: Node) -> Int {
        
        if let element = node as? CSSDOMElement, let _nodeParent = node.parentNode,
           element.localName == §CSSElementType.StyleRule
            || element.localName == §CSSElementType.UnrecognizedAtRule
            || element.localName == §CSSElementType.InvalidNamespaceRule
            || element.localName == §CSSElementType.NamespaceRule {
            
            if self.root === _nodeParent {
                
                return §AcceptNode.filter_ACCEPT
            }
            else {
                return §AcceptNode.filter_REJECT
            }
        }
        return §AcceptNode.filter_REJECT
    }
}
