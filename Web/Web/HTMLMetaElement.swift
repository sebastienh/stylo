//
//  HTMLMetaElement.swift
//  Web
//
//  Created by Sebastien hamel on 2018-11-09.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

//interface HTMLMetaElement : HTMLElement {
//    attribute DOMString name;
//    attribute DOMString httpEquiv;
//    attribute DOMString content;
//};


public final class HTMLMetaElement: HTMLElement, URLUtils {
    
    //    attribute DOMString name;
//    public var name: DOMString {
//
//        didSet {
//            self.setAttributeValue("name", value: self.name)
//        }
//    }
    
//    //    attribute DOMString httpEquiv;
//    public var httpEquiv: DOMString {
//
//        didSet {
//            self.setAttributeValue("httpEquiv", value: self.httpEquiv)
//        }
//    }
//
    //    attribute DOMString content;
//    public var content: DOMString {
//
//        didSet {
//            self.setAttributeValue("content", value: self.content)
//        }
//    }
//
 
    
    public init(document: Document?, charset: DOMString) {
        
        super.init(document: document, localName: "meta")
        
        // since they are not called at initialisation time
        self.setAttributeValue("charset", value: charset)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: HtmlDomVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    // 1. Traverse the left subtree.
    // 2. Visit the root.
    // 3. Traverse the right subtree.
    public override func accept<Visitor: HtmlDomVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
    
        return nil
    }
    
    @discardableResult
    public override func acceptSingle<Visitor: HtmlDomVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        return nil
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: HtmlRendererVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @discardableResult
    public override func acceptRenderer<Visitor: HtmlRendererVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        return nil
    }
    
}
