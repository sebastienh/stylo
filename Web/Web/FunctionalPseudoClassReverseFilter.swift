//
//  FunctionalPseudoClassReverseFilter.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-09-10.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

struct FunctionalPseudoClassReverseFilter: ReverseFilter {
    
    func filterSelection(_ selection: SelectorSelection, styleSheet: CSSStyleSheet?, filterContext: FilterContext) -> [SelectorSelection]? {
        
        return [selection]
    }
}
