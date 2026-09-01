//
//  StylesheetRecompilationType.swift
//  Web
//
//  Created by Sebastien Hamel on 2021-01-08.
//  Copyright © 2021 Textually Inc. All rights reserved.
//

import Foundation

public enum StylesheetRecompilationType {
    
    public var isRules: Bool {
        switch self {
        case .rules:
            return true
        default:
            return false
        }
    }
    
    case rules(stringExtract: String?, startCompilationRuleIndex: Int?, rulesStopIndex: Int?)
    case selectorList(stringExtract: String?, originalSelectorStringRange: Range<Int>, ruleIndex: Int, selectorStopIndex: Int?)
    case declarations(stringExtract: String?, compilationStringStartIndex: Int, ruleIndex: Int, declarationsRange: Range<Int>?, declarationStopIndex: DeclarationStopIndex, originalDeclarationsRangeEndIndex: Int)
}
