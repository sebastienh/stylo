//
//  ClassnamesElementNodeFilter.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-02-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

/// see https://dom.spec.whatwg.org/#concept-getelementsbyclassname
struct ClassnamesElementNodeFilter : ElementNodeFilter {
    
    let classnames: [DOMString]
    
    init(classnames: [DOMString]) {
        
        self.classnames = classnames
    }
    
    func acceptNode(_ node: Node) -> Int {
        
        if classnames.isEmpty {
            
            return §AcceptNode.filter_REJECT
        }
        
        if node.nodeType == NodeType.element_node {
            
            if let element = node as? Element {
                
                let classList = element.classList
                
                for elementClass in classList {
                 
                    var partOf: Bool = false
                    
                    for classname in classnames {
                        
                        if classname == elementClass {
                            
                            partOf = true
                            break
                        }
                    }
                    if !partOf {
                        
                        return §AcceptNode.filter_SKIP
                    }
                }
                // We have been throug all the classes and they are all 
                // part of the classnames array. So, we can confidently 
                // return accept.
                return §AcceptNode.filter_ACCEPT
            }
            else {
                
                assert(false, "NodeType ELEMENT_NODE not Element.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("NodeType ELEMENT_NODE not Element.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        
        return §AcceptNode.filter_SKIP
    }
    
}
