//
//  CSSVisitor.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-15.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common

public protocol CSSVisitor {
    
    @discardableResult
    func visit(_ node: CSSStyleSheet) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: WQNamePrefix) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: CSSNamespaceRule) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: CSSNamespaceURI) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: CSSNamespacePrefix) -> NodeInfo?
    
    @discardableResult
    func postVisit(_ node: CSSNamespaceRule) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: UnrecognizedAtRule) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: CSSStyleRule) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: SelectorList) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: ComplexSelector) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: InvalidComplexSelector) -> NodeInfo?
    
    /// Error handling is done there
    func postVisit(_ node: InvalidComplexSelector)
    
    @discardableResult
    func visit(_ node: CSSStyleDeclaration) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: IgnoredSimpleBlock) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: CSDeclaration) -> NodeInfo?
    
    /// Error handling is done there 
    func postVisit(_ node: CSDeclaration)
    
    @discardableResult
    func visit(_ node: InvalidDeclaration) -> NodeInfo?
    
    @discardableResult
    func visit(_ node: CSImportantDeclaration) -> NodeInfo?
    
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
    func visit(_ node: InvalidCompoundSelector) -> NodeInfo?
    
    func postVisit(_ node: InvalidCompoundSelector)
    
    func push(_ nodeInfo: NodeInfo)
    
    // in pre order traversal, only the root node
    // knows when to remove itself from the possible
    // Visitor stack
    func pop()
    
}
