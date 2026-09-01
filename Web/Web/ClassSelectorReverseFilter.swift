//
//  ClassSelectorReverseFilter.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-09-10.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

struct ClassSelectorReverseFilter: ReverseFilter {

    let className: String
    
    func filterSelection(_ selection: SelectorSelection, styleSheet: CSSStyleSheet?, filterContext: FilterContext) -> [SelectorSelection]? {
     
        // since we could be evaluating MirrorPseudoElement we should
        // get the real element
        for elementClassName in selection.elementToEvaluate.classList {
            
            if className == elementClassName {
            
                return [selection.create(fromNewElementToEvaluate: selection.elementToEvaluate)]
            }
        }
        return nil
    }

}
