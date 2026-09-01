//
//  RenderTreeVisitor.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-10.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import Web

protocol RenderTreeVisitor: Visitor {
    
    func visit(_ node: RenderBlock) -> NodeInfoType?
    
    func visit(_ node: RenderText) -> NodeInfoType?
    
    func visit(_ node: RenderInline) -> NodeInfoType?
    
    func visit(_ node: RenderDocumentElement) -> NodeInfoType?
}
