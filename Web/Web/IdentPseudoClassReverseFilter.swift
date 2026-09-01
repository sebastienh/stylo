//
//  IdentPseudoClassReverseFilter.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-09-10.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import os

struct IdentPseudoClassReverseFilter: ReverseFilter {
    
    let pseudoOption: PseudoClassesOptions?
    
    let pseudoClassName: String
    
    func filterSelection(_ selection: SelectorSelection, styleSheet: CSSStyleSheet?, filterContext: FilterContext) -> [SelectorSelection]? {
        
        // Here we need to implement the logic for each
        let pseudoClassType = PseudoClassType.supportedPseudoClassType(pseudoClassName)
        
        switch pseudoClassType {
            
        case .root:
            if selection.elementToEvaluate.isRoot {
                return [selection.create(fromNewElementToEvaluate: selection.elementToEvaluate)]
            }
            return []
        case .unsupported:
            return [selection]
        case .highlight: fallthrough
        case .flash: fallthrough
        case .fade: fallthrough
        case .focus:
            let options = filterContext.pseudoClassesOptions(forElement: selection.elementToEvaluate)
            
            guard let pseudoOption = self.pseudoOption else {
                assertionFailure("Error: pseudoOption is nil")
                return []
            }
            
            if options.contains(pseudoOption) {
                return [selection.create(fromNewElementToEvaluate: selection.elementToEvaluate)]
            }
            return []
            
        case .active: fallthrough
        case .checked: fallthrough
        case .default: fallthrough
        case .dir: fallthrough
        case .disabled: fallthrough
        case .empty: fallthrough
        case .enabled: fallthrough
        case .first: fallthrough
        case .firstChild: fallthrough
        case .firstOfType: fallthrough
        case .fullscreen: fallthrough
        case .hover: fallthrough
        case .indeterminate: fallthrough
        case .inRange: fallthrough
        case .invalid: fallthrough
        case .lang: fallthrough
        case .lastChild: fallthrough
        case .lastOfType: fallthrough
        case .left: fallthrough
        case .link: fallthrough
        case .not: fallthrough
        case .nthChild: fallthrough
        case .nthLastChild: fallthrough
        case .nthLastOfType: fallthrough
        case .nthOfType: fallthrough
        case .onlyChild: fallthrough
        case .onlyOfType: fallthrough
        case .optional: fallthrough
        case .outOfRange: fallthrough
        case .readOnly: fallthrough
        case .readWrite: fallthrough
        case .required: fallthrough
        case .right: fallthrough
        case .scope: fallthrough
        case .target: fallthrough
        case .valid: fallthrough
        case .visited:
            assert(false, "Missing implementation.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Ident pseudo-class filterSelection() missing implementation.", log: Log.Web.all, type: .error)
            #endif
            return [selection]
        }
    }
}
