

//
//  RenderTreeCreatorCSSDOMVisitor.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-08.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import Web

/// The RenderTreeCreatorVisitor models both RenderTreeCreator and Visitor. Each 
/// new kind of document must define 
final class RenderTreeCreatorVisitor: RenderTreeCreator, Visitor, CSSDOMVisitor, HtmlDomVisitor {

    fileprivate let resourceComputedStyle: ResourceComputedStyle
    
    fileprivate var resourceStyleRenderTree: ResourceStyleRenderTree?

    init(resourceComputedStyle: ResourceComputedStyle) {
        
        self.resourceComputedStyle = resourceComputedStyle
        self.parentStack = Stack<RenderObjectNodeInfo>()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: RenderTreeCreator protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// Create a RenderDocumentFragment from the nodes parameter
    /// creating each RenderObject to point to the resourceStyleRenderTree
    /// parameter.
    func processSubtree(fromNodes nodes: ContiguousArray<Node>?, inResourceStyleRenderTree resourceStyleRenderTree: ResourceStyleRenderTree) -> RenderDocumentFragment {
        
        self.resourceStyleRenderTree = resourceStyleRenderTree
        let renderDocumentFragment = RenderDocumentFragment(parentResourceStyleRenderTree: resourceStyleRenderTree)
        
        // all nodes will go under the renderDocumentFragment.
        let parentNodeInfo = RenderObjectNodeInfo(node: renderDocumentFragment)
        
        push(parentNodeInfo)
        
        if let nodes = nodes {
            
            // simulate the "children" iteration normally done in the accept method.
            for node in nodes {
                
                // compute the render tree starting from the right
                // FIXME: this visitor should be generalised
                if let visitiableDocumentElement = node as? CSSDOMVisitable {
                    
                    _ = visitiableDocumentElement.accept(self)
                }
                else if let visitiableDocumentElement = node as? HtmlDomVisitable {
                    
                    _ = visitiableDocumentElement.accept(self)
                }
            }
        }
        
        return renderDocumentFragment
    }
    
    /// This is the method to call from outside to create a render tree 
    /// from the top of a Document using a ResourceComputedStyle
    func process(_ document: Document, stylableStringContainer: StylableStringContainer?, resourceStyleRenderTree: ResourceStyleRenderTree?) -> ResourceStyleRenderTree {
        
        assert(document.rootDocumentElement is Visitable, "")
        
        if let resourceStyleRenderTree = resourceStyleRenderTree {
            
            self.resourceStyleRenderTree = resourceStyleRenderTree
        }
        else {
            
            assert(stylableStringContainer != nil, "stylableResource must not be nil when resourceStyleRenderTree is nil.")
            
            // the ResourceStyleRenderTree needs to point to the StylableResource
            self.resourceStyleRenderTree = ResourceStyleRenderTree()
        }
        
        // FIXME: this visitor should be generalised
        if let visitiableDocumentElement = document.rootDocumentElement as? CSSDOMVisitable {
        
            _ = visitiableDocumentElement.accept(self)
        }
        else if let visitiableDocumentElement = document.rootDocumentElement as? HtmlDomVisitable {
        
            _ = visitiableDocumentElement.accept(self)
        }
        
        let renderTree = self.resourceStyleRenderTree!
        
        self.resourceStyleRenderTree = nil
        
        return renderTree
    }

    /// Method that is suposed to render inline for elements that 
    /// require it: <span>, <b>, <i>
    func createRenderInline(_ element: Element) -> RenderObjectNodeInfo {
        
        let renderInline = RenderInline(element: element, parentResourceStyleRenderTree: self.resourceStyleRenderTree!)
        if let topRenderObject = top()?.node {
            
            topRenderObject.append(renderInline)
        }
        return RenderObjectNodeInfo(node: renderInline)
    }
    
    /// simple text
    func createRenderText(_ element: Element) -> RenderObjectNodeInfo {
    
        let renderText = RenderText(element: element, parentResourceStyleRenderTree: self.resourceStyleRenderTree!)
        if let topRenderObject = top()?.node {
    
            topRenderObject.append(renderText)
        }
        return RenderObjectNodeInfo(node: renderText)
    }
    
    /// document element, which supports to be completly defined using document properties. 
    func createRenderDocumentElement(_ element: Element) -> RenderObjectNodeInfo {

        let renderDocument = RenderDocumentElement(element: element, parentResourceStyleRenderTree: self.resourceStyleRenderTree!)
        resourceStyleRenderTree!.parentRenderObject = renderDocument
        return RenderObjectNodeInfo(node: renderDocument)
    }
    
    /// <div>, <p>...
    func createRenderBlock(_ element: Element) -> RenderObjectNodeInfo {
        
        let renderBlock = RenderBlock(element: element, parentResourceStyleRenderTree: self.resourceStyleRenderTree!)
        
        if let topRenderObject = top()?.node {
            
            topRenderObject.append(renderBlock)
        }
        return RenderObjectNodeInfo(node: renderBlock)
    }

    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Visitor protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias NodeInfoType = RenderObjectNodeInfo
    
    var parentStack: Stack<RenderObjectNodeInfo>
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSDOMVisitor protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func visit(_ node: CSSDOMDocument) -> RenderObjectNodeInfo? {
        
        // nothing to do
        return nil
    }
    
    func visit(_ node: CSSDOMElement) -> RenderObjectNodeInfo? {
        
        return createRenderBlock(node)
    }
    
    func visit(_ node: CSSDOMStyleSheetElement) -> RenderObjectNodeInfo? {
        
        let renderNodeInfo = createRenderDocumentElement(node)
        
        (renderNodeInfo.node as! RenderDocumentElement).documentAttributesElement = true
        
        return renderNodeInfo
    }
    
    func visit(_ node: CSSDOMTokenElement) -> RenderObjectNodeInfo? {
        
        return createRenderText(node)
    }
    
    func visit(_ node: Element) -> RenderObjectNodeInfo? {
        
        return createRenderText(node)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: HtmlDomVisitor protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func visit(_ node: HtmlDocument) -> RenderObjectNodeInfo? {
        
        return nil
    }
    
    func visit(_ node: HTMLPreElement) -> RenderObjectNodeInfo? {
     
        return createRenderText(node)
    }
    
    func visit(_ node: HTMLHtmlElement) -> RenderObjectNodeInfo? {
        
        return createRenderDocumentElement(node)
    }
    
    func visit(_ node: HTMLBodyElement) -> RenderObjectNodeInfo? {

        let bodyRenderBlockNodeInfo = createRenderBlock(node)
        (bodyRenderBlockNodeInfo.node as! RenderBlock).documentAttributesElement = true
        resourceStyleRenderTree?.topRenderableRenderObject = bodyRenderBlockNodeInfo.node!
        return bodyRenderBlockNodeInfo
    }
    
    func visit(_ node: HTMLHeadElement) -> RenderObjectNodeInfo? {
        
        return createRenderBlock(node)
    }
    
    func visit(_ node: HTMLTitleElement) -> RenderObjectNodeInfo? {

        return nil
    }
    
    func visit(_ node: HTMLStyleElement) -> RenderObjectNodeInfo? {
    
        return nil
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: MarkdownDomVisitor protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func visit(_ node: MarkdownElement) -> RenderObjectNodeInfo? {
        
        return createRenderText(node)
    }
    
    func visit(_ node: HTMLElement) -> RenderObjectNodeInfo? {
        
        return createRenderText(node)
    }
    
    /// we do nothing whe visiting the Text node since it is not the element
    /// that contains the source string segment value.
    func visit(_ node: Text) -> RenderObjectNodeInfo? {
        
        return nil
    }
    
}
