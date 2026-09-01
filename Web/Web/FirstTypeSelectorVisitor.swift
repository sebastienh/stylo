//
//  FirstTypeSelectorVisitor.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-05-14.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import Common

struct FirstTypeSelectorVisitorNodeInfo: NodeInfo {
    
    var visitChildren: Bool
    
    init(visitChildren: Bool = true) {
        
        self.visitChildren = visitChildren
    }
}

class FirstTypeSelectorVisitor: CSSSelectorListVisitor {

    var typeSelector: TypeSelector?
    
    let typeName: String
    
    init(typeName: String) {
        
        self.typeName = typeName
    }
    
    
    //                             complex-selector
    //                                    |
    //             _______________________|_______________________________________________________________
    //            /                       |                                              |                \
    //           /                        |                                              |                 \
    // compound-selector           [ <selector-combinator>                        compound-selector ]       *
    //
    func process(_ selectorList: SelectorList) {
        
        selectorList.accept(self)
    }
    
    func visit(_ node: ComplexSelector) -> NodeInfo? {
        
        return FirstTypeSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: InvalidComplexSelector) -> NodeInfo? {
        
        return FirstTypeSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: TypeSelector) -> NodeInfo? {
        
        if let _ = typeSelector {
            
            return FirstTypeSelectorVisitorNodeInfo(visitChildren: false)
        }
        
        if node.elementName.ident?.identString == typeName {
            
            self.typeSelector = node
            
            return FirstTypeSelectorVisitorNodeInfo(visitChildren: false)
        }
        
        return FirstTypeSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: CompoundSelector) -> NodeInfo? {
        
        if let _ = typeSelector {
            
            return FirstTypeSelectorVisitorNodeInfo(visitChildren: false)
        }

        return FirstTypeSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: InvalidCompoundSelector) -> NodeInfo? {
        
        return FirstTypeSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: SelectorCombinator) -> NodeInfo? {
        
        if let _ = typeSelector {
            
            return FirstTypeSelectorVisitorNodeInfo(visitChildren: false)
        }
        
        return FirstTypeSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: PseudoElementSelector) -> NodeInfo? {
        
        if let _ = typeSelector {
            
            return FirstTypeSelectorVisitorNodeInfo(visitChildren: false)
        }
        
        return FirstTypeSelectorVisitorNodeInfo()
    }

    
    func visit(_ node: IdentPseudoClass) -> NodeInfo? {
        
        if let _ = typeSelector {
            
            return FirstTypeSelectorVisitorNodeInfo(visitChildren: false)
        }
        
        return FirstTypeSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: SelectorList) -> NodeInfo? {
        
        if let _ = typeSelector {
            
            return FirstTypeSelectorVisitorNodeInfo(visitChildren: false)
        }
        
        return FirstTypeSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: FunctionalPseudoClass) -> NodeInfo? {
        
        if let _ = typeSelector {
            
            return FirstTypeSelectorVisitorNodeInfo(visitChildren: false)
        }
        
        return FirstTypeSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: AttribValue) -> NodeInfo? {
        
        if let _ = typeSelector {
            
            return FirstTypeSelectorVisitorNodeInfo(visitChildren: false)
        }
        
        return FirstTypeSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: WQNamePrefix) -> NodeInfo? {
        
        if let _ = typeSelector {
            
            return FirstTypeSelectorVisitorNodeInfo(visitChildren: false)
        }
        
        return FirstTypeSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: AttribSelector) -> NodeInfo? {
        
        if let _ = typeSelector {
            
            return FirstTypeSelectorVisitorNodeInfo(visitChildren: false)
        }
        
        return FirstTypeSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: AttribName) -> NodeInfo? {
        
        if let _ = typeSelector {
            
            return FirstTypeSelectorVisitorNodeInfo(visitChildren: false)
        }
        
        return FirstTypeSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: AttribMatch) -> NodeInfo? {
        
        if let _ = typeSelector {
            
            return FirstTypeSelectorVisitorNodeInfo(visitChildren: false)
        }
        
        return FirstTypeSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: AttribFlags) -> NodeInfo? {
        
        if let _ = typeSelector {
            
            return FirstTypeSelectorVisitorNodeInfo(visitChildren: false)
        }
        
        return FirstTypeSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: ClassSelector) -> NodeInfo? {
        
        if let _ = typeSelector {
            
            return FirstTypeSelectorVisitorNodeInfo(visitChildren: false)
        }
        
        return FirstTypeSelectorVisitorNodeInfo()
    }
    
    func visit(_ node: IdSelector) -> NodeInfo? {
        
        if let _ = typeSelector {
            
            return FirstTypeSelectorVisitorNodeInfo(visitChildren: false)
        }
        
        return FirstTypeSelectorVisitorNodeInfo()
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
