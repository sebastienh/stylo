//
//  HTMLTemplateElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-05-23.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

/// interface HTMLTemplateElement : HTMLElement {
///     readonly attribute DocumentFragment content;
/// };


///
/// https://www.w3.org/TR/html5/single-page.html#template-contents
///
public final class HTMLTemplateElement : HTMLElement {
    
    let content: DocumentFragment
    
    public init(document: Document?, content: DocumentFragment) {
        
        self.content = content
        
        super.init(document: document, localName: "template")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLTemplateElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLTemplateElement {
        
        return super.cloneNode(deep) as! HTMLTemplateElement
    }
    
    ///
    override public func createInstance() -> HTMLTemplateElement {
        
        return HTMLTemplateElement(document: nil, content: self.content)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLTemplateElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
}
