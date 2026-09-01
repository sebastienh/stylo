//
//  DomRenderable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-03-08.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common

public protocol DomRenderable: class {
    
    var document: Dynamic<Document?> { get }
    
    var domRenderingComponent: DomRenderingComponent! { get set }
    
    func node(at index: Int) -> Node?
    
    func revealInDomInspector(node: Node)
}

extension DomRenderable {
    
    public func revealInDomInspector(node: Node) {
        
        domRenderingComponent.reveal(node: node)
    }
    
    public func node(at index: Int) -> Node? {
        
        if let document = document.value {
            
            return document.elementContaining(index: index)
        }
        return nil
    }
    
}
