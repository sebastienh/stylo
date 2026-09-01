//
//  RevealInDomInspectorMenuItem.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-06-05.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Web
import WriterCommon

public class RevealInDomInspectorMenuItem: NSMenuItem, NodeContainer {
    
    public let node: Node
    
    public weak var domRenderable: DomRenderable?
    
    public init(title string: String, action selector: ObjectiveC.Selector?, keyEquivalent charCode: String, node: Node, domRenderable: DomRenderable) {
        
        self.node = node
        self.domRenderable = domRenderable
        
        super.init(title: string, action: selector, keyEquivalent: charCode)
    }
    
    required init(coder decoder: NSCoder) {
        
        self.node = Node(document: nil, sourceStringFragment: nil)
        super.init(coder: decoder)
    }
    
    
}
