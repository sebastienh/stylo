//
//  SelectorChainLink.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-07-27.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

protocol SelectorChainLink {
    
    func constructReverseEvaluatorChain(_ selectorEvaluatorChain: inout SelectorEvaluatorChain)
}

extension SelectorChainLink where Self: SelectionFilter {
    
    /// The reverse evaluator in the type selector case is the same as the
    /// in order evaluator.
    func constructReverseEvaluatorChain(_ selectorEvaluatorChain: inout SelectorEvaluatorChain) {
        
        selectorEvaluatorChain.pushSelectorEvaluator(self.reverseFilter)
    }
    
}
