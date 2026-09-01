//
//  HTMLTableHeaderCellElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-07.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

//interface HTMLTableHeaderCellElement : HTMLTableCellElement {
//    attribute DOMString scope;
//    attribute DOMString abbr;
//};


///
/// > The th element represents a header cell in a table.
///
/// see http://www.w3.org/TR/html5/tabular-data.html#the-th-element
///
public final class HTMLTableHeaderCellElement: HTMLElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    //    attribute DOMString scope;
    var scope: DOMString = "auto"
    
    //    attribute DOMString abbr;
    var abbr: DOMString = ""
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "th")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLTableHeaderCellElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLTableHeaderCellElement {
        
        return super.cloneNode(deep) as! HTMLTableHeaderCellElement
    }
    
    ///
    override public func createInstance() -> HTMLTableHeaderCellElement {
        
        return HTMLTableHeaderCellElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLTableHeaderCellElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
        
        copy.scope = self.scope
        copy.abbr = self.abbr
    }
}
