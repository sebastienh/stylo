//
//  HTMLDListElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-07.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

// interface HTMLDListElement : HTMLElement {};

///
/// > The dl element represents an association list consisting of zero or more
/// > name-value groups (a description list). A name-value group consists of one
/// > or more names (dt elements) followed by one or more values (dd elements),
/// > ignoring any nodes other than dt and dd elements. Within a single dl element,
/// > there should not be more than one dt element for each name.
///
/// see http://www.w3.org/TR/html5/grouping-content.html#the-dl-element
///
public final class HTMLDListElement: HTMLElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "dl")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLDListElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLDListElement {
        
        return super.cloneNode(deep) as! HTMLDListElement
    }
    
    ///
    override public func createInstance() -> HTMLDListElement {
        
        return HTMLDListElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLDListElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
}
