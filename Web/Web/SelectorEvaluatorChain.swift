//
//  SelectorEvaluator.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-10.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public struct SelectorEvaluatorChain {
    
    typealias ScopingRootFilter = (SelectorSelection) -> Bool
    
    var evaluators: [ReverseFilter]
    let scopingRootFilter: ScopingRootFilter?
    
    let scopingMethod: ScopingMethod?

    init(scopingRootFilter: ScopingRootFilter?, scopingMethod: ScopingMethod?) {
        
        self.scopingRootFilter = scopingRootFilter
        self.evaluators = [ReverseFilter]()
        self.scopingMethod = scopingMethod
    }
    
    mutating func pushSelectorEvaluator(_ selectorEvaluator: ReverseFilter) {
        
        evaluators.append(selectorEvaluator)
    }
    
    /// Method that iterates over all filters returned by each selector,
    /// and applying those filters to find all the elements. This method is
    /// run for each ComplexeSelector.
    func reverseEvaluate(selections: [SelectorSelection], stylesheet: CSSStyleSheet?, filterContext: FilterContext) -> [SelectorSelection] {
        
        var selections = selections
        
        // If the selector is scope-contained, the selector match list is immediately filtered
        // to contain only elements that are either the scoping root or descendants of the scoping root.
        if let filter = scopingRootFilter, let scopingMethod = scopingMethod, scopingMethod == ScopingMethod.scopeContained {
            selections = scopeFilterElements(selections, filter: filter)
        }
        
        var options: SelectionFilterOptions? = nil
        
        for evaluator in evaluators {
            
            var nextOptions: SelectionFilterOptions?
            
            // The selector is processed from left to right in order,
            // with simple selectors filtering the selector match list,
            // and combinators and pseudo-elements changing the selector match list into something new.
            (selections, nextOptions) = evaluator.filterSelections(selections, stylesheet, filterContext, options)
            
            // If the selector is scope-contained then after each combinator
            // the selector match list must be filtered to contain
            // only elements that are either the scoping root or descendants of the scoping root.
            
            if let nextOptions = nextOptions {
                
                if !nextOptions.contains(.pendingFollowingSiblingSelector) && evaluator.isCombinator {
                
                    if let scopingRootFilter = scopingRootFilter, let scopingMethod = scopingMethod, scopingMethod == ScopingMethod.scopeContained {
                        selections = self.scopeFilterElements(selections, filter: scopingRootFilter)
                    }
                }
                else if nextOptions.contains(.forceScoping) {

                    if let scopingRootFilter = scopingRootFilter, let scopingMethod = scopingMethod, scopingMethod == ScopingMethod.scopeContained {
                        selections = self.scopeFilterElements(selections, filter: scopingRootFilter)
                    }
                }
            }
            else if evaluator.isCombinator {
                
                if let scopingRootFilter = scopingRootFilter, let scopingMethod = scopingMethod, scopingMethod == ScopingMethod.scopeContained{
                    selections = self.scopeFilterElements(selections, filter: scopingRootFilter)
                }
            }
            
            // If the selector is scope-filtered, then after the selector is finished processing,
            // the selector match list must be filtered to contain only elements
            // that are either the scoping root or descendants of the scoping root.
            if let scopingRootFilter = scopingRootFilter, let scopingMethod = scopingMethod, scopingMethod == ScopingMethod.scopeFiltered {
                selections = self.scopeFilterElements(selections, filter: scopingRootFilter)
            }
            
            // After the selector is finished matching, the selector match list must be filtered
            // to only contain elements and pseudo-elements allowed by the invoker of this algorithm.
            // TODO: Must apply
            
            
            // Replace the local options
            options = nextOptions
        }
        
        // for each element that are pseudo-elements it's possible that
        // pseudo elements were returned instead of real element so we must
        // ask them to evaluate to the real elements before returning.
        
        return selections
    }
    
    
    func scopeFilterElements(_ selections: [SelectorSelection], filter: ((SelectorSelection) -> Bool)) -> [SelectorSelection] {
        
        return selections.filter(filter)
    }
    
}



