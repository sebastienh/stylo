//
//  TextManager+DomRenderable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-03-08.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common

extension TextManager: DomRenderable {
    
    public var document: Dynamic<Document?> {
        
        return markdownDocumentStore.document
    }
    
    public var domRenderingComponent: DomRenderingComponent! {
        get {
            return self.markdownDomResourceModel.domRenderingComponent
        }
        set {
            self.markdownDomResourceModel.domRenderingComponent = newValue
        }
    }
    
    public func removeElementHighlight() {
        
        self.markdownDomResourceModel.removeElementHighlight()
    }
    
}
