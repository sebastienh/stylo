//
//  SelectorEvaluator.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-10.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

typealias SelectorEvaluator = (_ elements: [Element]) -> [Element]

/// The algorythm starts from
/// the last selector of the complex selector, first it looks at if the element is a
/// match if the match is empty we will fill it with all elements that satifies this 
/// first selector. If the selector is a pseudo selector it will simply take all input 
/// elements (the currentElements should contain all the candidate elements and the 
/// match should be empty since pseudo elements are only allowed at the end of a selector),
/// associated them with the desired pseudo element type and associate the current 
/// elements with this pseudo. While moving up in the combinator chain, each selector 
/// change the currents elements, at the end we keep the match elements and create the 
/// PseudoElements if necessary and associate them with the host element (the match).
protocol ReverseFilter {
    
    var isCombinator: Bool { get }
    
    func filterSelections(_ selections: [SelectorSelection], _ styleSheet: CSSStyleSheet?, _ filterContext: FilterContext, _ options: SelectionFilterOptions?) -> (selections: [SelectorSelection], nextOptions: SelectionFilterOptions?)
    
    func filterSelection(_ selection: SelectorSelection, styleSheet: CSSStyleSheet?, filterContext: FilterContext) -> [SelectorSelection]?
}

extension ReverseFilter where Self: SelectionFilter {
    
}
    
extension ReverseFilter {
    
    var isCombinator: Bool {
        return false
    }
    
    ///
    /// Note: in this case we don't need the styleSheet parameter,
    /// it is used for namespaces resolving.
    func filterSelections(_ selections: [SelectorSelection], _ styleSheet: CSSStyleSheet?, _ filterContext: FilterContext, _ options: SelectionFilterOptions?) -> (selections: [SelectorSelection], nextOptions: SelectionFilterOptions?) {
        
        var filteredSelections = [SelectorSelection]()
        
//        if let options = options, options.contains(.pendingFollowingSiblingSelector) {
//
//            assertionFailure("Error: this optimization is not supported anymore")
//            let parentsSelectionLists = makeParentsSelectionLists(selections)
//            filterParentsSelectionLists(parentsSelectionLists, filteredSelections: &filteredSelections, stylesheet: styleSheet, filterContext: filterContext)
//            return (filteredSelections, SelectionFilterOptions.forceScoping)
//        }
//        else {
        
        let lock = NSLock()

        DispatchQueue.concurrentPerform(iterations: selections.count) { (index) in

            let selection = selections[index]
            if let fileteredSelection = filterSelection(selection, styleSheet: styleSheet, filterContext: filterContext) {

                lock.withCriticalSection {
                    filteredSelections.append(contentsOf: fileteredSelection)
                }
            }
        }

        return (filteredSelections, nil)
        
        
//            for selection in selections {
//
//                if let fileteredSelection = filterSelection(selection, styleSheet: styleSheet, filterContext: filterContext) {
//
//                    filteredSelections.append(contentsOf: fileteredSelection)
//                }
//            }
//            return (filteredSelections, nil)
//        }
    }
    
    private func filterParentsSelectionLists(_ parentsSelectionLists: [Element: [SelectorSelection]], filteredSelections: inout [SelectorSelection], stylesheet: CSSStyleSheet?, filterContext: FilterContext) {
        
        // and for each parent we create a list of elements for which
        // we want to create selections.
        // the lowest child, then we append the previousSiblingsElements to the selection
        for parentSelectionList in parentsSelectionLists {
            
            var selectionValues: [SelectorSelection] = parentSelectionList.value
            let lastSelection = selectionValues.last
            
            assert(lastSelection != nil)
            if let lastSelection = lastSelection {
                
                // create a list of accepting selection elements
                var acceptingSelectionElements: [SelectorSelection] = [lastSelection]
                selectionValues.removeLast()
                
                for previousSiblingsElement in lastSelection.elementToEvaluate.previousSiblingsElements {
                    
                    let selection = SelectorSelection(elementToEvaluate: previousSiblingsElement)
                    if filterSelection(selection, styleSheet: stylesheet,  filterContext: filterContext) != nil {
                    
                        for acceptingSelectionElement in acceptingSelectionElements {
                        
                            filteredSelections.append(acceptingSelectionElement.create(fromNewElementToEvaluate: previousSiblingsElement))
                        }
                        acceptingSelectionElements.removeAll()
                    }
                    
                    if let lastSelectionValue = selectionValues.last, lastSelectionValue.elementToEvaluate === previousSiblingsElement {
                        
                        acceptingSelectionElements.append(lastSelectionValue)
                        selectionValues.removeLast()
                    }
                }
                
                assert(selectionValues.isEmpty)
            }
        }
    }
    
    private func makeParentsSelectionLists(_ selections: [SelectorSelection]) -> [Element: [SelectorSelection]] {
        
        // first we identify the parents, the elements are already in order
        // so we just need to keep the last with a certain parent
        var parentsSelectionLists = [Element: [SelectorSelection]]()
        
        for selection in selections {
            
            let parentElement = selection.elementToEvaluate.parentElement
            
            if let parentElement = parentElement {
                
                #if DEBUG
                // just make sure that we are really selecting the last element
                // in the list of childs
                if let existingSelections = parentsSelectionLists[parentElement] {
                    for existingSelection in existingSelections {
                        assert(existingSelection.elementToEvaluate.index < selection.elementToEvaluate.index)
                    }
                }
                #endif
                
                if parentsSelectionLists[parentElement] == nil {
                    parentsSelectionLists[parentElement] = [SelectorSelection]()
                }
                
                parentsSelectionLists[parentElement]!.append(selection)
            }
        }
        return parentsSelectionLists
    }
    
    
}
