//
//  MarkdownStyleReducer+StylableReducerType.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-02-10.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import PromiseKit
import Common
import Web
import os

extension MarkdownStyleReducer: StylableReducerType {

    typealias DocumentType = HtmlDocument
    
    #if CONCURENT_RENDERING
    typealias RendererType = MarkdownConcurentRenderer
    
    func getNewRenderer(resourceComputedStyle: ResourceComputedStyle, renderingContext: RenderingContext, document: HtmlDocument) -> MarkdownConcurentRenderer {
        
        return MarkdownConcurentRenderer(resourceComputedStyle: resourceComputedStyle, renderingContext: renderingContext, document: document)
    }
    #else
    typealias RendererType = MarkdownRenderer
    
    func getNewRenderer(resourceComputedStyle: ResourceComputedStyle, renderingContext: RenderingContext, document: HtmlDocument) -> MarkdownRenderer {
        
        return MarkdownRenderer(resourceComputedStyle: resourceComputedStyle, renderingContext: renderingContext, document: document)
    }
    #endif
}

