//
//  HTMLAnchorElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-07.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common
//
//interface HTMLAnchorElement : HTMLElement {
//    attribute DOMString target;
//    attribute DOMString download;
//    
//    attribute DOMString rel;
//    attribute DOMString rev;
//    readonly attribute DOMTokenList relList;
//    attribute DOMString hreflang;
//    attribute DOMString type;
//    
//    attribute DOMString text;
//};
//HTMLAnchorElement implements URLUtils;

///
/// > If the a element has an href attribute, then it represents a hyperlink 
/// > (a hypertext anchor) labeled by its contents.
///
/// [see](http://www.w3.org/TR/html5/text-level-semantics.html#the-a-element)
///
public final class HTMLAnchorElement: HTMLElement, URLUtils {
    
    //    attribute DOMString target;
    public lazy var target: DOMString = ""
    
    //    attribute DOMString download;
    public lazy var download: DOMString = ""
    
    //    attribute DOMString rel;
    public var rel: DOMString = "" {
        didSet {
            self.setAttributeValue("rel", value: self.rel)
        }
    }
    
    //    attribute DOMString rev;
    public lazy var rev: DOMString = ""
    
    //    readonly attribute DOMTokenList relList;
    public internal(set) var relList: DOMTokenList!
    
    //    attribute DOMString hreflang;
    public lazy var hreflang: DOMString = ""
    
    //    attribute DOMString type;
    public lazy var type: DOMString = ""
    
    //    attribute DOMString text;
    public lazy var text: DOMString = ""
    
    // attribute DOMString href;
    public var href: DOMString = "" {
        didSet {
            self.setAttributeValue("href", value: self.href)
        }
    }
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "a")
        self.relList = DOMTokenList(element: self, attributeLocalName: "")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLAnchorElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLAnchorElement {
        
        return super.cloneNode(deep) as! HTMLAnchorElement
    }
    
    ///
    override public func createInstance() -> HTMLAnchorElement {
        
        return HTMLAnchorElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLAnchorElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
        
        copy.target = self.target
        copy.download = self.download
        copy.rel = self.rel
        copy.rev = self.rev
        
        copy.hreflang = self.hreflang
        copy.type = self.type
        copy.text = self.text
    }
}
