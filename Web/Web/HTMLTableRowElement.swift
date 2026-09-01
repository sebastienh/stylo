//
//  HTMLTableRowElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-07.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

//interface HTMLTableRowElement : HTMLElement {
//    readonly attribute long rowIndex;
//    readonly attribute long sectionRowIndex;
//    readonly attribute HTMLCollection cells;
//    HTMLElement insertCell(optional long index = -1);
//    void deleteCell(long index);
//};


///
/// > The tr element represents a row of cells in a table.
///
/// see http://www.w3.org/TR/html5/tabular-data.html#the-tr-element
///
public final class HTMLTableRowElement: HTMLElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    //    readonly attribute long rowIndex;
    fileprivate(set) var rowIndex: Int = -1
    
    //    readonly attribute long sectionRowIndex;
    fileprivate(set) var sectionRowIndex: Int = -1
    
    //    readonly attribute HTMLCollection cells;
    fileprivate(set) var cells: HTMLCollection!
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "tr")
        
        self.cells = HTMLCollection(root: self, filter: LocalnameElementNodeFilter(htmlDocument: true, localname: "tr", "th"))
    }
    
    //    HTMLElement insertCell(optional long index = -1);
    func insertCell(_ index: Int? = nil) {
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("insertCell(...) missing implementation.", log: Log.Web.all, type: .error)
        #endif
    }
    
    //    void deleteCell(long index);
    func deleteCell(_ index: Int) {
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("deleteCell(...) missing implementation.", log: Log.Web.all, type: .error)
        #endif
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLTableRowElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLTableRowElement {
        
        return super.cloneNode(deep) as! HTMLTableRowElement
    }
    
    ///
    override public func createInstance() -> HTMLTableRowElement {
        
        return HTMLTableRowElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLTableRowElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
}
