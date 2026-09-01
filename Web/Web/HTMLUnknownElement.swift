//
//  HTMLUnknownElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-06.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

/// see interface HTMLUnknownElement : HTMLElement { };
public final class HTMLUnknownElement: HTMLElement {
    
    override init(document: Document?, localName: DOMString) {
    
        super.init(document: document, localName: localName)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLUnknownElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLUnknownElement {
        
        return super.cloneNode(deep) as! HTMLUnknownElement
    }
    
    ///
    override public func createInstance() -> HTMLUnknownElement {
        
        return HTMLUnknownElement(document: nil, localName: self.localName)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLUnknownElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
}
