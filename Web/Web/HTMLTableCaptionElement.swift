//
//  HTMLTableCaptionElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-07.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

//interface HTMLTableCaptionElement : HTMLElement {};


///
/// > The caption element represents the title of the table that is its parent, 
/// > if it has a parent and that is a table element.
///
/// see http://www.w3.org/TR/html5/tabular-data.html#htmltablecaptionelement
///
public final class HTMLTableCaptionElement: HTMLElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "caption")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLTableCaptionElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLTableCaptionElement {
        
        return super.cloneNode(deep) as! HTMLTableCaptionElement
    }
    
    ///
    override public func createInstance() -> HTMLTableCaptionElement {
        
        return HTMLTableCaptionElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLTableCaptionElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
}
