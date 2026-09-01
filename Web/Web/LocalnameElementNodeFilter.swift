//
//  LocalNameElementNodeFilter .swift
//  Web
//
//  Created by Sébastien Hamel on 2015-02-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

/// see https://dom.spec.whatwg.org/#concept-getelementsbytagname
struct LocalnameElementNodeFilter : ElementNodeFilter {
    
    let localnames: [DOMString]
    
    let htmlDocument: Bool
    
    init(htmlDocument: Bool, localname: DOMString...) {
        
        self.htmlDocument = htmlDocument
        self.localnames = localname
    }
    
    func acceptNode(_ node: Node) -> Int {
        
        if node.nodeType == NodeType.element_node {
            
            if let element = node as? Element {
                
                if localnames.first!.trimmed() == "*" {
                    
                    return §AcceptNode.filter_ACCEPT
                }
                else {
                    
                    if htmlDocument {
                    
                        for localname in localnames {
                        
                            // Whose namespace is the HTML namespace and
                            // whose local name is localName converted to ASCII lowercase.
                            if let namespace = element.namespaceURI , namespace == §Namespace.HTML{
                            
                                if localname.lowercased() == element.localName {
                                    
                                    return §AcceptNode.filter_ACCEPT
                                }
                            }
                            // Whose namespace is not the HTML namespace and 
                            // whose local name is localName.
                            else {
                            
                                if localname == element.localName {
                                    
                                    return §AcceptNode.filter_ACCEPT
                                }
                            }
                        }
                        
                        return §AcceptNode.filter_SKIP
                    }
                    else {
                    
                        for localname in localnames {
                            
                            // return only element with localname is localname
                            if localname == element.localName {
                            
                                return §AcceptNode.filter_ACCEPT
                            }
                        }
                        
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



