//
//  HTMLScriptElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-05-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common

public final class HTMLScriptElement: HTMLElement {

    public enum Attribute: String {
        
        case src
    }
    
    public var src: String? {
        
        get {
            let srcValue = self.getAttribute(§Attribute.src)
            return srcValue
        }
        set {
            if let newValue = newValue {
                self.setAttributeValue(§Attribute.src, value: newValue)
            }
        }
    }
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "script")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLScriptElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLScriptElement {
        
        return super.cloneNode(deep) as! HTMLScriptElement
    }
    
    ///
    override public func createInstance() -> HTMLScriptElement {
        
        return HTMLScriptElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLScriptElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
    
}
