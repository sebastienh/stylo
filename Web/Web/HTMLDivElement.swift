//
//  HTMLDivElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-07.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

// interface HTMLDivElement : HTMLElement {};

///
/// > The div element has no special meaning at all. It represents its children. 
/// > It can be used with the class, lang, and title attributes to mark up semantics 
/// > common to a group of consecutive elements.
///
/// see http://www.w3.org/TR/html5/grouping-content.html#the-div-element
///
public final class HTMLDivElement: HTMLElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "div")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLDivElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLDivElement {
        
        return super.cloneNode(deep) as! HTMLDivElement
    }
    
    ///
    override public func createInstance() -> HTMLDivElement {
        
        return HTMLDivElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLDivElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
}
