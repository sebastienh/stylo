//
//  HTMLPreElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-06.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

///
/// "The pre element represents a block of preformatted text, in which structure 
/// is represented by typographic conventions rather than by elements."
/// see http://www.w3.org/TR/html5/grouping-content.html#the-pre-element
///
public final class HTMLPreElement: HTMLElement {
    
    public init(document: Document? = nil) {
        
        super.init(document: document, localName: "pre")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLPreElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLPreElement {
        
        return super.cloneNode(deep) as! HTMLPreElement
    }
    
    ///
    override public func createInstance() -> HTMLPreElement {
        
        return HTMLPreElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLPreElement) {
        
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
