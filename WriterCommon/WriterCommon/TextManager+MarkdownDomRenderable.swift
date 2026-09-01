//
//  TextManager+MarkdownDomRenderable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-21.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation

extension TextManager: MarkdownDomRenderable {
    
    public func renderMarkdownDom() {
        
        self.markdownDomRenderingComponent.reload()
    }
}
