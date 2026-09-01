//
//  HTMLBRElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-07.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

//interface HTMLBRElement : HTMLElement {};

///
/// > The br element represents a line break.
///
/// see http://www.w3.org/TR/html5/text-level-semantics.html#the-br-element
///
public final class HTMLBRElement: HTMLElement {
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "br")
    }
    
    public override func intersectsRange(_ range: NSRange) -> Bool {
        
        return false
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLBRElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLBRElement {
        
        return super.cloneNode(deep) as! HTMLBRElement
    }
    
    ///
    override public func createInstance() -> HTMLBRElement {
        
        return HTMLBRElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLBRElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
}
