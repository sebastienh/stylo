//
//  NamespaceAndLocalnameElementNodeFilter.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-02-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

/// see https://dom.spec.whatwg.org/#concept-getelementsbytagnamens
struct NamespaceAndLocalnameElementNodeFilter : ElementNodeFilter {
    
    let localname: DOMString
    
    var namespace: DOMString
    
    init(localname: DOMString, namespace: DOMString) {
        
        self.namespace = namespace
        self.localname = localname
    }
    
    func acceptNode(_ node: Node) -> Int {
        
        let _namespace: DOMString?
        
        // 1. If namespace is the empty string, set it to null.
        // We suppose that this requirement is for nil comparison.
        if namespace.isEmpty {
            
            _namespace = nil
        }
        else {
            
            _namespace = namespace
        }
        
        if node.nodeType == NodeType.element_node {
            
            if let element = node as? Element {
                
                // 2. If both namespace and localName are "*" (U+002A), 
                // return a HTMLCollection rooted at root, 
                // whose filter matches descendant elements
                if localname.trimmed() == "*" && namespace.trimmed() == "*" {
                    
                    return §AcceptNode.filter_ACCEPT
                }
                // 3. Otherwise, if namespace is "*" (U+002A), 
                // return a HTMLCollection rooted at root, whose filter matches descendant elements 
                // whose local name is localName.
                else if namespace.trimmed() == "*" {
                        
                    if localname == element.localName {
                        
                        return §AcceptNode.filter_ACCEPT
                    }
                    else {
                        
                        return §AcceptNode.filter_SKIP
                    }
                }
                // 4. Otherwise, if localName is "*" (U+002A), 
                // return a HTMLCollection rooted at root, 
                // whose filter matches descendant elements whose namespace is namespace.
                else if localname.trimmed() == "*" {
                    
                    if _namespace == element.namespaceURI {
                        
                        return §AcceptNode.filter_ACCEPT
                    }
                    else {
                        
                        return §AcceptNode.filter_SKIP
                    }
                }
                // 5.  Otherwise, return a HTMLCollection rooted at root, 
                // whose filter matches descendant elements whose namespace is namespace 
                // and local name is localName.
                else {
                    
                    if localname == element.localName && namespace == element.namespaceURI {
                        
                        return §AcceptNode.filter_ACCEPT
                    }
                    else {
                        
                        return §AcceptNode.filter_SKIP
                    }
                }
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
