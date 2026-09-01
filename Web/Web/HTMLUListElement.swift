//
//  HTMLUListElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-07.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

//interface HTMLUListElement : HTMLElement {};

/// see http://www.w3.org/TR/html5/grouping-content.html#the-ul-element
public final class HTMLUListElement: HTMLElement {
    
    public override var isBlock: Bool {
        
        return true
    }
    
    public init(document: Document? = nil) {
        
        super.init(document: document, localName: "ul")
    }
    
    public override func whitespacesExtendedIntersectionRange(_ range: NSRange, inString string: String) -> NSRange? {
        
        for child in self.children.elements {
        
            guard let li = child as? HTMLLIElement else {
                continue
            }
            
            guard let liRange = li.range else {
                return nil
            }

            if liRange.lowerBound <= range.lowerBound {

                let whitespacesExtendedElementRange = string.extendsWithLastSpaces(liRange)

                if range.upperBound <= whitespacesExtendedElementRange.upperBound {
                    return whitespacesExtendedElementRange
                }
            }
        }
        return nil
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = HTMLUListElement
    
    override public func cloneNode(_ deep: Bool = false) -> HTMLUListElement {
        
        return super.cloneNode(deep) as! HTMLUListElement
    }
    
    ///
    override public func createInstance() -> HTMLUListElement {
        
        return HTMLUListElement(document: nil)
    }
    
    /// see https://dom.spec.whatwg.org/#dom-node-clonenode
    func cloneFields(_ copy: inout HTMLUListElement) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
}
