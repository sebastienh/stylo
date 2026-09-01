//
//  StylesheetManager+DomRenderable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-03-09.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common

extension StylesheetManager: DomRenderable {
    
    public var document: Dynamic<Document?> {
        
        return stylesheetDocumentStore.document
    }
    
    public var domRenderingComponent: DomRenderingComponent! {
        
        get {
            
            return self.domResourceModel.domRenderingComponent
        }
        set {
            
            self.domResourceModel.domRenderingComponent = newValue
        }
    }
}
