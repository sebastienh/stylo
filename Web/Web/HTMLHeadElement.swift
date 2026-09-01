//
//  HTMLHeadElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-21.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

// interface HTMLHeadElement : HTMLElement {};

///
/// > The head element represents a collection of metadata for the Document.
///
/// see http://www.w3.org/TR/html5/document-metadata.html#the-head-element
///
public final class HTMLHeadElement: HTMLElement {
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "head")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLHeadElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLHeadElement {
        
        return super.cloneNode(deep) as! HTMLHeadElement
    }
    
    ///
    override public func createInstance() -> HTMLHeadElement {
        
        return HTMLHeadElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLHtmlElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: HtmlDomVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    public override func accept<Visitor: HtmlDomVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        let nodeInfo = visitor.visit(self)
        
        if let nodeInfo = nodeInfo {
            
            if nodeInfo.visitChildren {
            
                visitor.push(nodeInfo)
            
                // we want to go through all child nodes including Text elements
                // so we can't use the children property since this property only
                // returns Elements.
                if let childNodes = childNodes {
                
                    for child in childNodes {
                    
                        let childCSSDOMVisitableElement = child as! HtmlDomVisitable
                    
                        _ = childCSSDOMVisitableElement.accept(visitor)
                    }
                }
            
                visitor.pop()
            }
        }
        
        return nodeInfo
    }
    
    @discardableResult
    public override func acceptSingle<Visitor: HtmlDomVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        return visitor.visit(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: HtmlRendererVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @discardableResult
    public override func acceptRenderer<Visitor: HtmlRendererVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
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
