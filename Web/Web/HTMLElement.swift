//
//  HTMLElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-06.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

//interface HTMLElement : Element {
//    // metadata attributes
//    attribute DOMString title;
//    attribute DOMString lang;
//    attribute boolean translate;
//    attribute DOMString dir;
//    readonly attribute DOMStringMap dataset;
//    
//    
//    // user interaction
//    attribute boolean hidden;
//    void click();
//    attribute long tabIndex;
//    void focus();
//    void blur();
//    attribute DOMString accessKey;
//    readonly attribute DOMString accessKeyLabel;
//    attribute DOMString contentEditable;
//    readonly attribute boolean isContentEditable;
//    attribute boolean spellcheck;
//};
//HTMLElement implements GlobalEventHandlers;
//
//interface HTMLUnknownElement : HTMLElement { };
//
// see <http://www.w3.org/TR/html5/dom.html#htmlelement>

open class HTMLElement: Element, HtmlDomVisitable, HtmlRendererVisitable {
    
    ///
    /// A block element can contain other elements
    ///
    public var isBlock: Bool {
        
        return false
    }
    
    
//    var title: DOMString
    
//    var lang: DOMString
//
//    var translate: Bool
//
//    var dir:  DOMString
//
//    fileprivate(set) var dataset: DOMStringMap
//
//    /// user interaction
//    var hidden: Bool
//
//    var tabIndex: Int
//
//    var accessKey: DOMString
//
//    // readonly attribute DOMString accessKeyLabel;
//    fileprivate(set) var accessKeyLabel: DOMString
//
//    //
//    //    attribute DOMString contentEditable;
//    var contentEditable: DOMString
//
//    //    readonly attribute boolean isContentEditable;
//    fileprivate(set) var isContentEditable: Bool
//
//    //    attribute boolean spellcheck;
//    var spellcheck: Bool
    
    public init(document: Document? = nil, localName: DOMString) {
        
//        self.title = ""
//        self.lang = ""
//        self.translate = false
//        self.dir = ""
//        self.dataset = DOMStringMap()
//
//        /// user interaction
//        self.hidden = false
//
//        self.tabIndex = 0
//
//        self.accessKey = ""
//
//        // readonly attribute DOMString accessKeyLabel;
//        self.accessKeyLabel = ""
//
//        //    attribute DOMString contentEditable;
//        self.contentEditable = ""
//
//        //    readonly attribute boolean isContentEditable;
//        self.isContentEditable = false
//
//        //    attribute boolean spellcheck;
//        self.spellcheck = false
        
        super.init(fragment: nil, document: document, localName: localName)
        
        self.namespaceURI = §Namespace.HTML
    }
    
    //    void click();
    func click() {
        
        assert(false, "Missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("click() missing implementation", log: Log.Web.all, type: .error)
        #endif
    }
    
    //    void focus();
    func focus() {
        
        assert(false, "Missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("focus() missing implementation", log: Log.Web.all, type: .error)
        #endif
    }
    
    //    void blur();
    func blur() {
        
        assert(false, "Missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("blur() missing implementation", log: Log.Web.all, type: .error)
        #endif
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLElement
    
    override open func cloneNode(_ deep: Bool = false) -> HTMLElement {
        
        return super.cloneNode(deep) as! HTMLElement
    }
    
    ///
    override open func createInstance() -> HTMLElement {
        
        return HTMLElement(document: nil, localName: self.localName)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
        
//        copy.title = self.title
//        copy.lang = self.lang
//        copy.translate = self.translate
//        copy.dir = self.dir
//        copy.dataset = self.dataset
//        copy.hidden = self.hidden
//        copy.tabIndex = self.tabIndex
//        copy.accessKey = self.accessKey
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: HtmlDomVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    @discardableResult
    open func accept<Visitor: HtmlDomVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        let nodeInfo = visitor.visit(self)
        
        if let nodeInfo = nodeInfo {

            if nodeInfo.visitChildren {
            
                visitor.push(nodeInfo)
            
                // we want to go through all child nodes including Text elements
                // so we can't use the children property since this property only
                // returns Elements.
                if let childNodes = childNodes {
            
                    for child in childNodes {
                        if let htmlDomVisitable = child as? HtmlDomVisitable {
                            htmlDomVisitable.accept(visitor)
                        }
                    }
                }
                visitor.pop()
            }
        }
        return nodeInfo
    }
    
    @discardableResult
    open func acceptSingle<Visitor: HtmlDomVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        return visitor.visit(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: HtmlRendererVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @discardableResult
    public func acceptRenderer<Visitor: HtmlRendererVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        let nodeInfo = visitor.visit(self)
        
        if var nodeInfo = nodeInfo {
            
            if nodeInfo.visitChildren {
                
                visitor.push(nodeInfo)

                // we want to go through all child nodes including Text elements
                // so we can't use the children property since this property only
                // returns Elements.
                if let childNodes = childNodes {
                    
                    for child in childNodes {
                        
                        if let htmlDomVisitable = child as? HtmlRendererVisitable {
                            
                            nodeInfo.merge(with: htmlDomVisitable.acceptRenderer(visitor))
                        }
                    }
                }
                visitor.pop()
            }
        }
        return nodeInfo
    }
    
}





