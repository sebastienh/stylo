//
//  CssDomResourceModel.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-01-17.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation

public final class CssDomResourceModel {
    
    var cssDomRenderable: CssDomRenderable
    
    init(cssDomRenderable: CssDomRenderable) {
        
        self.cssDomRenderable = cssDomRenderable
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: DomRenderable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var domRenderingComponent: DomRenderingComponent! {
        
        set {
            
            cssDomRenderable.cssDomRenderingComponent = newValue
        }
        get {
            
            return cssDomRenderable.cssDomRenderingComponent
        }
    }
    
}
