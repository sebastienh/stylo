//
//  StylesheetStyleReducer+StylableReducerType.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-15.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import PromiseKit
import Common
import Web
import os

extension StylesheetStyleReducer: StylableReducerType {
    
    typealias DocumentType = CSSDOMDocument
    
    typealias RendererType = CssRenderer
    
    func getNewRenderer(resourceComputedStyle: ResourceComputedStyle, renderingContext: RenderingContext, document: CSSDOMDocument) -> CssRenderer {
        
        return CssRenderer(resourceComputedStyle: resourceComputedStyle, renderingContext: renderingContext, document: document)
    }
}

