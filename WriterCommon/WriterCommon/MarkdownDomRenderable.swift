//
//  MarkdownDomRenderable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-01-17.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation

public protocol MarkdownDomRenderable {
    
    var markdownDomRenderingComponent: DomRenderingComponent! { get set }
    
    func renderMarkdownDom()
}

