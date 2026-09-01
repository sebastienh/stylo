//
//  MarkdownPartialCompilationResult.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-09-29.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Markdown
import Web
import Common

struct MarkdownPartialCompilationResult {
    
    let tokens: Tokens
    
    let deletedTopDomNodes: ContiguousArray<Node>
    
    let changeDescription: SourceStringChangeDescription?
    
    var recompileRequiredRanges: [NSRange]?
    
    var affectedReferencesKeys: Set<String>
    
    /// This variable is used in the case where the user has change
    /// the attributes of an element and there is following sibling
    /// selector in the curent style. We might think of some way to reduce
    /// the number of times this is called as much as possible.
    var attributesBlocsChange: AttributesBlocsChange
    
    init(tokens: Tokens, deletedTopDomNodes: ContiguousArray<Node>, changeDescription: SourceStringChangeDescription?, affectedReferencesKeys:  Set<String>, recompileRequiredRanges: [NSRange]? = nil, attributesBlocsChange: AttributesBlocsChange) {
        
        self.tokens = tokens
        self.deletedTopDomNodes =  deletedTopDomNodes
        self.changeDescription = changeDescription
        self.affectedReferencesKeys = affectedReferencesKeys
        self.recompileRequiredRanges = recompileRequiredRanges
        self.attributesBlocsChange = attributesBlocsChange
    }
}
