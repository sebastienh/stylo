//
//  HtmlRenderable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-01-12.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation

public protocol DomRenderableResourceModel {
    
    var domRenderingComponent: DomRenderingComponent! { get set }
    
    func removeElementHighlight()
}
