//
//  HTMLTableElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-07.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

//interface HTMLTableElement : HTMLElement {
//    attribute HTMLTableCaptionElement? caption;
//    HTMLElement createCaption();
//    void deleteCaption();
//    attribute HTMLTableSectionElement? tHead;
//    HTMLElement createTHead();
//    void deleteTHead();
//    attribute HTMLTableSectionElement? tFoot;
//    HTMLElement createTFoot();
//    void deleteTFoot();
//    readonly attribute HTMLCollection tBodies;
//    HTMLElement createTBody();
//    readonly attribute HTMLCollection rows;
//    HTMLElement insertRow(optional long index = -1);
//    void deleteRow(long index);
//    attribute DOMString border;
//};

///
/// > The table element represents data with more than one dimension, 
/// > in the form of a table.
///
/// see http://www.w3.org/TR/html5/tabular-data.html#the-table-element
///
public final class HTMLTableElement: HTMLElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    //    attribute HTMLTableCaptionElement? caption;
    var caption: HTMLTableCaptionElement?
    
    //    attribute HTMLTableSectionElement? tHead;
    var tHead: HTMLTableSectionElement?

    //    attribute HTMLTableSectionElement? tFoot;
    var tFoot: HTMLTableSectionElement?
    
    ///
    /// > The tBodies attribute must return an HTMLCollection rooted at the table node, 
    /// > whose filter matches only tbody elements that are children of the table element.
    ///
    //    readonly attribute HTMLCollection tBodies;
    fileprivate(set) var tBodies: HTMLCollection!
    
    ///
    /// > The rows attribute must return an HTMLCollection rooted at the table node, 
    /// > whose filter matches only tr elements that are either children of the table element, 
    /// > or children of thead, tbody, or tfoot elements that are themselves children of 
    /// > the table element.
    ///
    //    readonly attribute HTMLCollection rows;
    fileprivate(set) var rows: HTMLCollection!
    
    //    attribute DOMString border;
    var border: DOMString
    
    public init(document: Document?) {
        
        self.border = "none"
        
        super.init(document: document, localName: "table")
        
        self.tBodies = HTMLCollection(root: self, filter: LocalnameElementNodeFilter(htmlDocument: true, localname: "tbody"))
        self.rows = HTMLCollection(root: self, filter: LocalnameElementNodeFilter(htmlDocument: true, localname: "tr"))
    }
    
//    //    HTMLElement createCaption();
//    func createCaption() -> HTMLElement {
//        
//        fatalError("Missing implementation.")
//    }
//    
//    //    void deleteCaption();
//    func deleteCaption() {
//        
//        fatalError("Missing implementation.")
//    }
//    
//    //    HTMLElement createTHead();
//    func createTHead() -> HTMLElement {
//        
//        fatalError("Missing implementation.")
//    }
//    
//    //    void deleteTHead();
//    func deleteTHead() {
//        
//        fatalError("Missing implementation.")
//    }
//    
//    //    HTMLElement createTFoot();
//    func createTFoot() -> HTMLElement {
//     
//        fatalError("Missing implementation.")
//    }
//    
//    //    void deleteTFoot();
//    func deleteTFoot() {
//        
//        fatalError("Missing implemntation.")
//    }
//    
//    //    HTMLElement createTBody();
//    func createTBody() -> HTMLElement {
//        
//        fatalError("Missing implemetation.")
//    }
//    
//    //    HTMLElement insertRow(optional long index = -1);
//    func insertRow(_ index: Int? = nil) {
//        
//        fatalError("Missing implemetation.")
//    }
//    
//    //    void deleteRow(long index);
//    func deleteRow(_ index: Int) {
//        
//        fatalError("Missing implemetation.")
//    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLTableElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLTableElement {
        
        return super.cloneNode(deep) as! HTMLTableElement
    }
    
    ///
    override public func createInstance() -> HTMLTableElement {
        
        return HTMLTableElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLTableElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
        
        copy.border = self.border
    }
}
