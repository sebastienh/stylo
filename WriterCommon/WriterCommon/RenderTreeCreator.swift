//
//  RenderTreeCreator.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-21.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Web

protocol RenderTreeCreator: class {
    
    associatedtype RenderTreeDOMDocumentType : Document
    
    func process(_ document: RenderTreeDOMDocumentType, stylableStringContainer: StylableStringContainer?, resourceStyleRenderTree: ResourceStyleRenderTree?) -> ResourceStyleRenderTree
    
    func createRenderInline(_ element: Element) -> RenderObjectNodeInfo
    
    func createRenderText(_ element: Element) -> RenderObjectNodeInfo
    
    func createRenderBlock(_ element: Element) -> RenderObjectNodeInfo
 
    func createRenderDocumentElement(_ element: Element) -> RenderObjectNodeInfo
}
