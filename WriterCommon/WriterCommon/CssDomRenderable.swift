//
//  CssDomRenderable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-01-17.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation

public protocol CssDomRenderable: DomInspectableResource {
    
    var cssDomRenderingComponent: DomRenderingComponent! { get set }
    
    func renderCssDom()

}

