//
//  HTMLTableSectionElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-07.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

public enum TableSectionType: String {
    
    case TBody = "tbody"
    case THead = "thead"
    case TFoot = "tfoot"
}

//interface HTMLTableSectionElement : HTMLElement {
//    readonly attribute HTMLCollection rows;
//    HTMLElement insertRow(optional long index = -1);
//    void deleteRow(long index);
//};


///
/// > The tbody element represents a block of rows that consist of a body of data 
/// > for the parent table element, if the tbody element has a parent and it is a table.
///
/// see http://www.w3.org/TR/html5/tabular-data.html#htmltablesectionelement
///
public final class HTMLTableSectionElement: HTMLElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    //    readonly attribute HTMLCollection rows;
    fileprivate(set) var rows: HTMLCollection!
    
    public init(document: Document?, type: TableSectionType) {
        
        super.init(document: document, localName: §type)
        
        self.rows = HTMLCollection(root: self, filter: LocalnameElementNodeFilter(htmlDocument: true, localname: "tr"))
    }
    
    //    HTMLElement insertRow(optional long index = -1);
    func insertRow(_ index: Int? = nil) {
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("insertRow(...) missing implementation.", log: Log.Web.all, type: .error)
        #endif
    }
    
    //    void deleteRow(long index);
    func deleteRow(_ index: Int) {
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("deleteRow(...) missing implementation.", log: Log.Web.all, type: .error)
        #endif
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLTableSectionElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLTableSectionElement {
        
        return super.cloneNode(deep) as! HTMLTableSectionElement
    }
    
    ///
    override public func createInstance() -> HTMLTableSectionElement {
        
        return HTMLTableSectionElement(document: nil, type: TableSectionType(rawValue: self.localName)!)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLTableSectionElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
}
