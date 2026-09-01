//
//  MarkdownCompilationResult.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-06-25.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import Markdown

enum MarkdownCompilationResult {
    
    case complete(tokens: Tokens)
    
    /// updatedStoppedCompilationRuleIndex: contains the value of the stoppedCompilationIndex + numberOfInsertedRules
    /// value. It is used to know from where we should start to update the positions in the current stylesheet.
    case partial(MarkdownPartialCompilationResult)
    
    var markdownPartialCompilationResult: MarkdownPartialCompilationResult? {
        switch self {
        case .partial(let result):
            return result
        default:
            return nil
        }
    }
        
    var deletedTopNodes: ContiguousArray<Node>? {
        
        switch self {
            
        case .complete(_):
            return nil
            
        case .partial(let partial):
            
            return partial.deletedTopDomNodes
        }
    }
    
    var recompileRequiredRanges: [NSRange]? {
        
        switch self {
            
        case .complete(_):
            return nil
            
        case .partial(let partial):
            
            return partial.recompileRequiredRanges
        }
        
    }
    
}
