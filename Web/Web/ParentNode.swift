//
//  ParentNode.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-08.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation

//[NoInterfaceObject]
//interface ParentNode {
//    [SameObject] readonly attribute HTMLCollection children;
//    readonly attribute Element? firstElementChild;
//    readonly attribute Element? lastElementChild;
//    readonly attribute unsigned long childElementCount;
//    
//    [Unscopeable] void prepend((Node or DOMString)... nodes);
//    [Unscopeable] void append((Node or DOMString)... nodes);
//    
//    [Unscopeable] Element? query(DOMString relativeSelectors);
//    [NewObject, Unscopeable] Elements queryAll(DOMString relativeSelectors);
//    Element? querySelector(DOMString selectors);
//    [NewObject] NodeList querySelectorAll(DOMString selectors);
//};
//Document implements ParentNode;
//DocumentFragment implements ParentNode;
//Element implements ParentNode;

// see : https://dom.spec.whatwg.org/#parentnode
protocol ParentNode: class {
    
    //    [SameObject] readonly attribute HTMLCollection children;
    var children: HTMLCollection { get }
    
    //    readonly attribute Element? firstElementChild;
    var firstElementChild: Element? { get }
    
    //    readonly attribute Element? lastElementChild;
    var lastElementChild: Element? { get }
    
    //    readonly attribute unsigned long childElementCount;
    var childElementCount: Int { get }
    
    //    [Unscopeable] void prepend((Node or DOMString)... nodes);
    func prepend(_ nodes: [Node], stringNodes: [DOMString], exception: inout Exception)
    
    //    [Unscopeable] void append((Node or DOMString)... nodes);
    func append(_ nodes: [Node], stringNodes: [DOMString], exception: inout Exception)
    
    //    [Unscopeable] Element? query(DOMString relativeSelectors);
    func query(_ relativeSelectors: DOMString, exception: inout Exception) -> Element?
    
//    //    [NewObject, Unscopeable] Elements queryAll(DOMString relativeSelectors);
//    func queryAll(_ relativeSelectors: DOMString, exception: inout Exception) -> Elements
//    
//    //    Element? querySelector(DOMString selectors);
//    func querySelector(_ selectors: DOMString, exception: inout Exception) -> Element?
//    
//    //    [NewObject] NodeList querySelectorAll(DOMString selectors);
//    func querySelectorAll(_ selectors: DOMString, exception: inout Exception) -> Elements
}





