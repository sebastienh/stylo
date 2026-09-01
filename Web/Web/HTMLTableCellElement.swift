//
//  HTMLTableCellElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-07.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

//interface HTMLTableCellElement : HTMLElement {
//    attribute unsigned long colSpan;
//    attribute unsigned long rowSpan;
//    [PutForwards=value] readonly attribute DOMSettableTokenList headers;
//    readonly attribute long cellIndex;
//};

///
/// >
///
/// see http://www.w3.org/TR/html5/tabular-data.html#htmltablecellelement
///
open class HTMLTableCellElement: HTMLElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    //    attribute unsigned long colSpan;
    var colSpan: Int = 1
    
    //    attribute unsigned long rowSpan;
    var rowSpan: Int = 1 
    
    //    [PutForwards=value] readonly attribute DOMSettableTokenList headers;
    fileprivate(set) var headers: DOMSettableTokenList!
    
    //    readonly attribute long cellIndex;
    fileprivate(set) var cellIndex: Int = -1
    
    public override init(document: Document?, localName: DOMString) {
        
        super.init(document: document, localName: localName)
        
        self.headers = DOMSettableTokenList(element: self)
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLTableCellElement
    
    override open func cloneNode(_ deep: Bool = false) -> HTMLTableCellElement {
        
        return super.cloneNode(deep) as! HTMLTableCellElement
    }
    
    ///
    override open func createInstance() -> HTMLTableCellElement {
        
        return HTMLTableCellElement(document: nil, localName: self.localName)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLTableCellElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
}
