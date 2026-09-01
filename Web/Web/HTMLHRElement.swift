//
//  HTMLHRElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-06.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

public final class HTMLHRElement: HTMLElement {
    
    public init(document: Document?) {
        
        super.init(document: document, localName: "hr")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLHRElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLHRElement {
        
        return super.cloneNode(deep) as! HTMLHRElement
    }
    
    ///
    override public func createInstance() -> HTMLHRElement {
        
        return HTMLHRElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLHRElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
}
