//
//  CSSSelectorListVisitor.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-05-14.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import Common

public protocol CSSSelectorListVisitor {
    
    @discardableResult
    func visit(_ node: SelectorList) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: ComplexSelector) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: InvalidComplexSelector) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: CompoundSelector) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: AttribSelector) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: AttribName) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: AttribMatch) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: AttribFlags) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: ClassSelector) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: IdSelector) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: IdentPseudoClass) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: FunctionalPseudoClass) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: PseudoElementSelector) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: SelectorCombinator) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: TypeSelector) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: AttribValue) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: WQNamePrefix) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: InvalidCompoundSelector) -> NodeInfo?
    
    func push(_ nodeInfo: NodeInfo)
    
    // in pre order traversal, only the root node
    // knows when to remove itself from the possible
    // Visitor stack
    func pop()
    
}
