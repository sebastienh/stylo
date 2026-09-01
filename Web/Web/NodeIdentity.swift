//
//  NodeIdentity.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-02-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common

fileprivate func UpdateCssDomNodeIdentity(from element: Element, identity: inout String) {
    
    // needed for handling single error and all errors styles.
    if !element.classes.isEmpty {
        identity += "class:\"" + element.classListString + "\"+"
    }
    if !element.attributes.isEmpty {
        
        var attributesListString = ""
        
        let sortedAttributes = element.attributeList.sorted { (attr1, attr2) -> Bool in
            return attr1.localName < attr2.localName
        }
        
        for attribute in sortedAttributes {
            
            // since class is included in the attributes list we should
            // ignore it if we see it.
            if attribute.localName == §DomAttributeString.Class {
                continue
            }
            
            if attribute.localName == §DomAttributeString.ElementId {
                continue
            }
            
            if !attributesListString.isEmpty {
                attributesListString += ","
            }
            
            attributesListString += "\"" + attribute.localName
            if let namespaceURI = attribute.namespaceURI {
                attributesListString += "@" + namespaceURI
            }
            
            attributesListString += "=" + attribute.value + "\""
        }
        
        identity += "attributes:\"" + attributesListString + "\"+"
    }
}

fileprivate func UpdateMarkdownDomNodeIdentity(from element: Element, identity: inout String) {
    
    // needed for handling single error and all errors styles.
    if !element.classes.isEmpty {
        identity += "class:\"" + element.classListString + "\","
    }
    if let id = element.id {
        identity += "id:\"" + id + "\","
    }
    if !element.attributes.isEmpty {
        
        var attributesListString = ""
        
        let sortedAttributes = element.attributeList.sorted { (attr1, attr2) -> Bool in
            return attr1.localName < attr2.localName
        }
        
        for attribute in sortedAttributes {
            
            // since class is included in the attributes list we should
            // ignore it if we see it.
            if attribute.localName == §DomAttributeString.Class {
                continue
            }
            
            if attribute.localName == §DomAttributeString.ElementId {
                continue
            }
            
            if !attributesListString.isEmpty {
                attributesListString += ","
            }
            
            attributesListString += "\"" + attribute.localName
            if let namespaceURI = attribute.namespaceURI {
                attributesListString += "@" + namespaceURI
            }
            attributesListString += "=" + attribute.value + "\""
        }
        
        identity += "attributes:" + attributesListString
    }
}

class NodeIdentity: CustomStringConvertible {
    
    var description: String {
        
        return identity
    }
    
    private let identity: String
    
    static func create(from node: Node) -> NodeIdentity {
        
        if let element = node as? Element {
            
            var identity = ""
            
            identity += "localName:\"" + element.localName + "\","
            
            if let namespaceURI = element.namespaceURI {
                identity += "namespace:\"" + namespaceURI + "\","
            }
            
            identity += "pseudos:\(element.pseudoElementsString)"
            
            if node.document is CSSDOMDocument {
            
                UpdateCssDomNodeIdentity(from: element, identity: &identity)
            }
            else if node.document is HtmlDocument {
                
                UpdateMarkdownDomNodeIdentity(from: element, identity: &identity)
            }
            
            return NodeIdentity(identity: identity)
        }
        else {
            
            return NodeIdentity(identity: String(describing: node.nodeType))
        }
    }
    
    init(identity: String) {
        
        self.identity = identity
    }
    
}
