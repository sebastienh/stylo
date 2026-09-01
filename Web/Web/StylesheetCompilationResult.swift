//
//  StylesheetCompilationResult.swift
//  Web
//
//  Created by Sebastien Hamel on 2021-01-08.
//  Copyright © 2021 Textually Inc. All rights reserved.
//

import Foundation
import Common

public enum StylesheetCompilationResult {
    
    case complete(stylesheet: CSSStyleSheet)
    
    /// updatedStoppedCompilationRuleIndex: contains the value of the stoppedCompilationIndex + numberOfInsertedRules
    /// value. It is used to know from where we should start to update the positions in the current stylesheet.
    case rules(deletedTopNodes: ContiguousArray<Node>?, partialStylesheet: CSSStyleSheet?, updatedStoppedCompilationRuleIndex: Int?)

    case replace(stylesheet: CSSStyleSheet, deletedTopNodes: ContiguousArray<Node>?)
    
    case selectorList(deletedTopNodes: ContiguousArray<Node>?, partialStylesheet: CSSStyleSheet, selectorList: SelectorList?, ruleIndex: Int)
    
    case declarations(deletedTopNodes: ContiguousArray<Node>?, partialStylesheet: CSSStyleSheet, ruleIndex: Int, declarationsRange: Range<Int>)
    
    var deletedTopNodes: ContiguousArray<Node>? {
        switch self {
        case .complete:
            return nil
        case .rules(let deletedTopNodes, _, _):
            return deletedTopNodes
        case .replace(_, let deletedTopNodes):
            return deletedTopNodes
        case .declarations(let deletedTopNodes, _, _, _):
            return deletedTopNodes
        case .selectorList(let deletedTopNodes, _, _, _):
            return deletedTopNodes
        }
    }

}
