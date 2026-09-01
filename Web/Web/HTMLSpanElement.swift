//
//  HTMLSpanElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-07.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

//interface HTMLSpanElement : HTMLElement {};

///
/// see http://www.w3.org/TR/html5/text-level-semantics.html#the-span-element
///
public final class HTMLSpanElement: HTMLElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "span")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLSpanElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLSpanElement {
        
        return super.cloneNode(deep) as! HTMLSpanElement
    }
    
    ///
    override public func createInstance() -> HTMLSpanElement {
        
        return HTMLSpanElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLSpanElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
}
