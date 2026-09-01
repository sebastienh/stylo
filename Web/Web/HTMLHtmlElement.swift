//
//  HTMLHtmlElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-21.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

// interface HTMLHtmlElement : HTMLElement {};

///
/// > The html element represents the root of an HTML document.
///
/// see http://www.w3.org/TR/html5/semantics.html#the-html-element
///
public final class HTMLHtmlElement: HTMLElement {
    
    override public var isRoot: Bool {
        return true
    }
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "html")
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: DomInspectable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public var expandable: Bool {
        
        return false
    }
    
    override public var expandedOpenElementString: String {
        
        return self.localName
    }
    
    override public var unexpandedElementString: String {
        
        return self.localName
    }
    
    /// This method returns true is the current ContainerNode
    /// has only text nodes.
    override public func hasOnlyChildTextNodes() -> Bool {
        
        // we assume the HTMLHtmlElement has at least a head and body element.
        return false
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLHtmlElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLHtmlElement {
        
        return super.cloneNode(deep) as! HTMLHtmlElement
    }
    
    ///
    override public func createInstance() -> HTMLHtmlElement {
        
        return HTMLHtmlElement(document: nil)
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
