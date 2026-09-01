//
//  CombinatorReverseFilter.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-09-10.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

struct CombinatorReverseFilter: ReverseFilter {
    
    var isCombinator: Bool {
        return true
    }
    
    let combinatorType: CombinatorType
    
    func filterSelections(_ selections: [SelectorSelection], styleSheet: CSSStyleSheet?, filterContext: FilterContext, _ options: SelectionFilterOptions?) -> (selections: [SelectorSelection], nextOptions: SelectionFilterOptions?) {
    
        var filteredSelections = [SelectorSelection]()
        
        for selection in selections {
            
            if let fileteredSelection = filterSelection(selection, styleSheet: styleSheet, filterContext: filterContext) {
                
                filteredSelections.append(contentsOf: fileteredSelection)
            }
        }
        return (filteredSelections, nil)
    }
    
    func filterSelection(_ selection: SelectorSelection, styleSheet: CSSStyleSheet?, filterContext: FilterContext) -> [SelectorSelection]? {
        
        switch combinatorType {
            
            // Child combinator
        // see http://dev.w3.org/csswg/selectors/#child-combinators
        case .GreaterThanSign:
            
            if let parent = selection.elementToEvaluate.parentElement {
                
                // It's is a pure pseudo element
                return [selection.create(fromNewElementToEvaluate: parent)]
            }
            
            // Next sibling combinator
            // The elements represented by the two compound selectors share the same parent in
            // the document tree and the element represented by the first compound selector
            // immediately precedes the element represented by the second one.
            // Non-element nodes (e.g. text between elements) are ignored when considering the adjacency of elements.
        // see http://dev.w3.org/csswg/selectors/#adjacent-sibling-combinators
        case .PlusSign:
            
            if let previousSiblingElement = selection.elementToEvaluate.previousSiblingElement {
                
                return [selection.create(fromNewElementToEvaluate: previousSiblingElement)]
            }
            
            // Following-sibling combinator
            // The elements represented by the two compound selectors share the same parent in
            // the document tree and the element represented by the first compound selector precedes
            // (not necessarily immediately) the element represented by the second one.
        // see http://dev.w3.org/csswg/selectors/#general-sibling-combinators
        case .Tilde:

            var filteredSelection = [SelectorSelection]()

            for previousSiblingElement in selection.elementToEvaluate.previousSiblingsElements {

                filteredSelection.append(selection.create(fromNewElementToEvaluate: previousSiblingElement))
            }
            return filteredSelection
            
            // Descendants combinator
            // A selector of the form A B or A >> B' represents an element B that is an arbitrary descendant
            // of some ancestor element A.
        // see http://dev.w3.org/csswg/selectors/#descendant-combinators
        case .Whitespace:
            
            fallthrough
            
        case .DoubleGreaterSign:
            
            var filteredSelection = [SelectorSelection]()
            
            for ancestor in selection.elementToEvaluate.ancestors() {
                
                if let ancestorElement = ancestor as? Element {
                    
                    // It's is a pure pseudo element
                    filteredSelection.append(selection.create(fromNewElementToEvaluate: ancestorElement))
                }
            }
            
            return filteredSelection
        }
        return nil
    }
    
}
