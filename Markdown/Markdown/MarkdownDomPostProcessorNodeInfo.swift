//
//  MarkdownDomPostProcessorNodeInfo.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-05-28.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web

final class MarkdownDomPostProcessorNodeInfo: NodeInfo {
    
    let visitChildren: Bool
    
    let element: Element?
    
    init(element: Element?, visitChildren: Bool = true) {
    
        self.element = element
        self.visitChildren = visitChildren
    }
}
