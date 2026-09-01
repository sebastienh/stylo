//
//  PseudoElementSelectorReverseFilter.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-09-10.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

struct PseudoElementSelectorReverseFilter: ReverseFilter {

    let pseudoSelectorType: PseudoSelectorType?
    
    func filterSelection(_ selection: SelectorSelection, styleSheet: CSSStyleSheet?, filterContext: FilterContext) -> [SelectorSelection]? {
        
        guard let pseudoSelectorType = self.pseudoSelectorType else {
            assertionFailure("Error: pseudoSelectorType is nil")
            return nil
        }
        
        if pseudoSelectorType.filteringPseudo {
            if let filteredElement = pseudoSelectorType.filter(selection.elementToEvaluate) {
                return [selection.create(fromNewElementToEvaluate: filteredElement, erasePseudoElement: true)]
            }
        }
        else {
            return [selection.create(fromNewElementToEvaluate: selection.elementToEvaluate, pseudo: pseudoSelectorType)]
        }
        return nil
    }
}
