//
//  IdSelectorReverseFilter.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-09-10.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation


struct IdSelectorReverseFilter: ReverseFilter {
    
    var isCombinator: Bool {
        return false
    }
    
    let hashString: String
    
    func filterSelection(_ selection: SelectorSelection, styleSheet: CSSStyleSheet?, filterContext: FilterContext) -> [SelectorSelection]? {
        
        if let elementId = selection.elementToEvaluate.id, elementId == hashString {
            
            return [selection.create(fromNewElementToEvaluate: selection.elementToEvaluate)]
        }
        return nil
    }
}
