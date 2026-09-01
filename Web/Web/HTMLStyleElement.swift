//
//  HTMLStyleElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-21.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

// interface HTMLStyleElement : HTMLElement {
//    attribute boolean disabled;
//    attribute DOMString media;
//    attribute DOMString type;
// };
// HTMLStyleElement implements LinkStyle;

///
/// > The style element allows authors to embed style information in their documents.
/// > The style element is one of several inputs to the styling processing model. 
/// > The element does not represent content for the user.
///
/// [see](http://www.w3.org/TR/html5/document-metadata.html#the-style-element)
/// 
public final class HTMLStyleElement: HTMLElement {
    
    ///
    /// 
    ///
    // attribute boolean disabled;
    var disabled: Bool = false
    
    ///
    /// > The media attribute says which media the styles apply to.
    ///
    /// > The default, if the media attribute is omitted, is "all", meaning 
    /// > that by default styles apply to all media.
    ///
    // attribute DOMString media;
    var media: DOMString = "all"
    
    ///
    /// > The type attribute gives the styling language.
    ///
    // attribute DOMString type;
    var type: DOMString =  "text/css"
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "style")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLStyleElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLStyleElement {
        
        return super.cloneNode(deep) as! HTMLStyleElement
    }
    
    ///
    override public func createInstance() -> HTMLStyleElement {
        
        return HTMLStyleElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLStyleElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
        
        copy.disabled = self.disabled
        copy.media = self.media
        copy.type = self.type
    }
}
