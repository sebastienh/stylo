//
//  Element+FilterContext.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-08-24.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension Element {
    
    public func isHighlighted(fromFilterContext filterContext: FilterContext?) -> Bool {
        
        guard let filterContext = filterContext else {
            return false
        }
        
        guard self.hasAttributesOrClasses else {
            return false
        }
        
        guard let highlightSelectors = filterContext.highlightSelectors else {
            assertionFailure("Error: highlightSelectors is nil")
            return false
        }
        
        if self is HTMLBodyElement {
            return true
        }
        
        let selection = SelectorSelection(elementToEvaluate: self)
        if highlightSelectors.filterHighlightedSelection(selection, stylesheet: nil) != nil {
            return true
        }
        return false
    }
    
    /// This method return .fade or .highlight for the element depending if it is highlighted
    /// or not by the highlightSelectors.
    ///
    public func filterHighlightPseudoClass(from pseudoClassesOptions: PseudoClassesOptions, filterContext: FilterContext?) -> PseudoClassesOptions {
        
        guard pseudoClassesOptions.contains(.highlight) && pseudoClassesOptions.contains(.fade) else {
            return pseudoClassesOptions
        }
        
        guard !self.hasAttributesOrClasses else {
            return .fade
        }
        
        guard let highlightSelectors = filterContext?.highlightSelectors else {
            assertionFailure("Error: highlightSelectors is nil")
            return .fade
        }
        
        if self is HTMLBodyElement {
            return .highlight
        }
        else {
            let selection = SelectorSelection(elementToEvaluate: self)
            if highlightSelectors.filterHighlightedSelection(selection, stylesheet: nil) != nil {
                return .highlight
            }
            return .fade
        }
    }
    

}
