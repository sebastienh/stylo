//
//  HTMLHeadingElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-06.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

public final class HTMLHeadingElement: HTMLElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    public var level: Int? {
        
        switch self.localName {
        case "h1":
            return 1
        case "h2":
            return 2
        case "h3":
            return 3
        case "h4":
            return 4
        case "h5":
            return 5
        case "h6":
            return 6
        default:
            assert(false)
            return nil
        }
    }
    
    override public init(document: Document?, localName: DOMString) {
        
        super.init(document: document, localName: localName)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLHeadingElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLHeadingElement {
        
        return super.cloneNode(deep) as! HTMLHeadingElement
    }
    
    ///
    override public func createInstance() -> HTMLHeadingElement {
        
        return HTMLHeadingElement(document: nil, localName: self.localName)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLHeadingElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
}
