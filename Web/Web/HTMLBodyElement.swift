//
//  HTMLBodyElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-21.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

// interface HTMLBodyElement : HTMLElement {
// };
//
// HTMLBodyElement implements WindowEventHandlers;

///
/// > The body element represents the content of the document.
///
/// see http://www.w3.org/TR/html5/sections.html#the-body-element
///
public final class HTMLBodyElement: HTMLElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "body")
    }

    /// Method that returns a string value of a simple
    /// selector that can be used to select this element.
    /// The sourceLocation parameter is used to know if we are
    /// in a pseudo element region.
    /// TODO: add support for pseudo elements (NW-908)
    override public func selector(for sourceLocation: Int, allowedPseudo: Bool = true) -> String {
        
        return self.localName
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        return super.equals(to: other, comparePositions: false)
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLBodyElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLBodyElement {
        
        return super.cloneNode(deep) as! HTMLBodyElement
    }
    
    ///
    override public func createInstance() -> HTMLBodyElement {
        
        return HTMLBodyElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLBodyElement) {
        
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
                    
                        if let childCSSDOMVisitableElement = child as? HtmlDomVisitable {
                    
                            childCSSDOMVisitableElement.accept(visitor)
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
