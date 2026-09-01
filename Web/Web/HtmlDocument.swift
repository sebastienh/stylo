//
//  HtmlDocument.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-08.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

public final class HtmlDocument: Document, HtmlDomVisitable {
    
    public static func Create(_ title: DOMString? = nil) -> HtmlDocument! {
    
        var exception = Exception()
        
        let document = DOMImplementation.createHTMLDocument(title, exception: &exception)
        
        if exception.isError() {
            
            exception.logIfError()
            assert(false, "Error creating document.")
        }
        
        return document
    }
    
    public var body: HTMLBodyElement!
    
    public var htmlElement: HTMLHtmlElement? {
        assert(self.documentElement! is HTMLHtmlElement)
        return self.documentElement as? HTMLHtmlElement
    }
    
    public var head: HTMLHeadElement?
    
    public override var styleRoot: Element {
        
        // default is documentElement
        return body
    }
    
    /// This variable returns the elements that are on top
    /// of the styleRootChildElements.
    public override var styleRoots: ContiguousArray<Element> {
        
        return ContiguousArray<Element>(arrayLiteral: documentElement, head!, body)
    }
    
    /// Returns the child elements.
    /// [SameObject] readonly attribute HTMLCollection children;
    /// see https://dom.spec.whatwg.org/#dom-parentnode-children
    public var leafElements: HTMLCollection {
        
        let filter = LeafElementsFilter(root: body)
        return HTMLCollection(root: body, filter: filter)
    }
    
    public override init() {
        
        super.init()
    }
    
    /// Replaces all childs in the specified range with the new nodes
    /// in the order they are in the array.
    /// NOT A DOM OFFICIAL METHOD: should not be made available to javascript.
    public func replaceBodyChilds(_ deletedDomTopNodes: ContiguousArray<Node>, withDocumentFragment documentFragment: DocumentFragment) -> (Node?, ContiguousArray<Element>) {
        
        var exception = Exception()
        var nodeToInsertBefore: Node? = nil
        var rootElements = ContiguousArray<Element>()
        
        // keep a reference to body since it is a computed value
        let body = self.body!
        
        // delete the range and keep a pointer to the last Node
        // in order to insert the DocumentFragment using insertBefore.
        if body.hasChildNodes() {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("number of childs before removing: %d", log: Log.Web.all, type: .info, body.length)
        
            os_log("number of childs to delete: %d", log: Log.Web.all, type: .info, deletedDomTopNodes.count)
            #endif
            
            for nodeToDelete in deletedDomTopNodes {
                
                nodeToInsertBefore = nodeToDelete.nextSibling
                body.remove(nodeToDelete, exception: &exception)
                exception.logIfError()
            }
            
            //
            let nodes = body.insertBefore(documentFragment, before: nodeToInsertBefore, exception: &exception)
            
            if let nodes = nodes {
                for node in nodes {
                    if let element = node as? Element {
                        rootElements.append(element)
                    }
                }
            }
            exception.logIfError()
        }
        exception.logIfError()
        
        return (nodeToInsertBefore, rootElements)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HtmlDocument
    
    // Its encoding, content type, URL, its mode (quirks mode, limited quirks mode, or no-quirks mode),
    // and its type (XML document or HTML document).
    // see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HtmlDocument) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
    
    override public func createInstance() -> HtmlDocument {
        
        let instance = HtmlDocument()
        
        // If copy is a document, set its node document and document to copy.
        instance.document = instance
        
        return instance
    }
    
    public override func cloneNode(_ deep: Bool = false) -> HtmlDocument {
        
        // The super.cloneNode() function is supposed to call
        // our implementations of cloneFields and createInstance.
        let htmlDocument = super.cloneNode(deep) as! HtmlDocument
        
        return htmlDocument
    }

    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: HtmlDomVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    public func accept<Visitor: HtmlDomVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        let nodeInfo = visitor.visit(self)
        
        if let nodeInfo = nodeInfo {
        
            if nodeInfo.visitChildren {
            
                visitor.push(nodeInfo)
            
                // for the moment there is only one children the "markdown-text" document element
            
                let htmlDomVisitableElement = self.documentElement as! HtmlDomVisitable
            
                htmlDomVisitableElement.accept(visitor)
            
                visitor.pop()
            }
        }
            
        return nodeInfo
    }
    
    @discardableResult
    public func acceptSingle<Visitor: HtmlDomVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
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
