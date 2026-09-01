//
//  UpdateDocumentResult.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2018-11-01.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Igloo
import Markdown

struct UpdateDocumentResult: ActionResult {
    
    enum UpdateType {
        case partial
        case complete
    }
    
    let type: UpdateType
    
    let document: Document
    
    let rootElements: ContiguousArray<Element>?
    
    let deletedNodes: ContiguousArray<Node>?
    
    let attributesBlocsChange: AttributesBlocsChange?
    
    init(type: UpdateType, document: Document, rootElements: ContiguousArray<Element>?, deletedNodes: ContiguousArray<Node>?, attributesBlocsChange: AttributesBlocsChange?) {
        
        self.type = type
        self.document  = document
        self.rootElements = rootElements
        self.deletedNodes = deletedNodes
        self.attributesBlocsChange = attributesBlocsChange
    }
    
}
