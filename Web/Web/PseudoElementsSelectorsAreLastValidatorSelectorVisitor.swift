//
//  PseudoElementsSelectorsAreLastValidatorSelectorVisitor.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-05-08.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import Common

struct PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo: NodeInfo {
    
    var visitChildren: Bool
    
    init(visitChildren: Bool = true) {
        
        self.visitChildren = visitChildren
    }
}

/// This visitor is used to validate that the pseudo element selectors
/// are place at the end of a selector. Because since they don't return 
/// an element they can not be chained.
///
/// The way it works is by recording an encounterd pseudo element
/// selector and when a node is found after we add the error to the 
/// pseudo elements and stop traversing the selector.
///
/// NW-136

class PseudoElementsSelectorsAreLastValidatorSelectorVisitor: CSSSelectorListVisitor {
    
    var pseudoElementSelectors: [PseudoElementSelector]
    
    var errorAdded: Bool = false
    
    init() {
        
        self.pseudoElementSelectors = [PseudoElementSelector]()
    }
    
    //                             complex-selector
    //                                    |
    //             _______________________|_______________________________________________________________
    //            /                       |                                              |                \
    //           /                        |                                              |                 \
    // compound-selector           [ <selector-combinator>                        compound-selector ]       *
    //
    func process(_ complexSelector: ComplexSelector) {
        
        complexSelector.accept(self)
    }

    func visit(_ node: ComplexSelector) -> NodeInfo? {
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: InvalidComplexSelector) -> NodeInfo? {
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: CompoundSelector) -> NodeInfo? {
        
        if !pseudoElementSelectors.isEmpty {
            addError()
        }
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: SelectorCombinator) -> NodeInfo? {
        
        if !pseudoElementSelectors.isEmpty {
            addError()
        }
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo(visitChildren: false)
    }
    
    func visit(_ node: PseudoElementSelector) -> NodeInfo? {
        
        pseudoElementSelectors.append(node)
        
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo(visitChildren: false)
    }
    
    fileprivate func addError() {
        
        if !errorAdded {
            
            for pseudoElementSelector in pseudoElementSelectors {
                
                // add the error
                pseudoElementSelector.messageHandler.addMessage(MessageCode.invalidPseudoElementSelectorPosition)
                
                errorAdded = true 
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    //// All the rest is not used in this validation.
    ////////////////////////////////////////////////////////////////////////////////////
    
    func visit(_ node: IdentPseudoClass) -> NodeInfo? {
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo(visitChildren: false)
    }

    func visit(_ node: SelectorList) -> NodeInfo? {
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo(visitChildren: false)
    }
    
    func visit(_ node: FunctionalPseudoClass) -> NodeInfo? {
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo(visitChildren: false)
    }
    
    func visit(_ node: TypeSelector) -> NodeInfo? {
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo(visitChildren: false)
    }
    
    func visit(_ node: AttribValue) -> NodeInfo? {
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo(visitChildren: false)
    }

    func visit(_ node: WQNamePrefix) -> NodeInfo? {
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo(visitChildren: false)
    }
    
    func visit(_ node: AttribSelector) -> NodeInfo? {
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo(visitChildren: false)
    }
    
    func visit(_ node: AttribName) -> NodeInfo? {
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo(visitChildren: false)
    }
    
    func visit(_ node: AttribMatch) -> NodeInfo? {
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo(visitChildren: false)
    }
    
    func visit(_ node: AttribFlags) -> NodeInfo? {
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo(visitChildren: false)
    }
    
    func visit(_ node: ClassSelector) -> NodeInfo? {
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo(visitChildren: false)
    }
    
    func visit(_ node: IdSelector) -> NodeInfo? {
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo(visitChildren: false)
    }
    
    func visit(_ node: InvalidCompoundSelector) -> NodeInfo? {
        return PseudoElementsSelectorsAreLastValidatorSelectorVisitorNodeInfo(visitChildren: false)
    }
    
    func push(_ nodeInfo: NodeInfo) {
        // nothing to do
    }
    
    // in pre order traversal, only the root node
    // knows when to remove itself from the possible
    // Visitor stack
    func pop(){
        // nothing to do
    }
}
