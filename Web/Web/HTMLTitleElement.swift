//
//  HTMLTitleElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-21.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

//interface HTMLTitleElement : HTMLElement {
//    attribute DOMString text;
//};

///
/// > The title element represents the document's title or name. Authors should use titles that identify 
/// > their documents even when they are used out of context, for example in a user's history or bookmarks, 
/// > or in search results. The document's title is often different from its first heading, since the first 
/// > heading does not have to stand alone when taken out of context.
///
/// see http://www.w3.org/TR/html5/document-metadata.html#the-title-element
///
public final class HTMLTitleElement: HTMLElement {
    
    /// DOMString text;
    var text: DOMString {
        
        if let childNodes = childNodes {
        
            for child in childNodes {
            
                if let textElement = child as? Text {
                
                    return textElement.data
                }
            }
        }
        assert(false, "HTMLTitleElement has no Text children!")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("HTMLTitleElement has no Text children!.", log: Log.Web.all, type: .error)
        #endif
        return ""
    }
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "title")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLTitleElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLTitleElement {
        
        return super.cloneNode(deep) as! HTMLTitleElement
    }
    
    ///
    override public func createInstance() -> HTMLTitleElement {
        
        return HTMLTitleElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLTitleElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
}
