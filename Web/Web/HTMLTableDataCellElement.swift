//
//  HTMLTableDataCellElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-07.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

//interface HTMLTableDataCellElement : HTMLTableCellElement {};

///
/// > The td element represents a data cell in a table.
///
/// see http://www.w3.org/TR/html5/tabular-data.html#the-td-element
///
public final class HTMLTableDataCellElement: HTMLTableCellElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "td")
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLTableDataCellElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLTableDataCellElement {
        
        return super.cloneNode(deep) as! HTMLTableDataCellElement
    }
    
    ///
    override public func createInstance() -> HTMLTableDataCellElement {
        
        return HTMLTableDataCellElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLTableDataCellElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
}
