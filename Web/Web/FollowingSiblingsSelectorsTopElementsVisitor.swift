//
//  FollowingSiblingsSelectorsTopElementsVisitor.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-11-23.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation
import Common

final class FollowingSiblingsSelectorsTopElementsVisitor : CSSVisitor {

    
    
    var followingSiblingsSelectorsTopCompoundSelector: [CompoundSelector]
    
    init() {
        
        self.followingSiblingsSelectorsTopCompoundSelector = [CompoundSelector]()
    }
    
    func process(_ node: CSSVisitable) -> [CompoundSelector] {
        
        node.accept(self)
        
        return followingSiblingsSelectorsTopCompoundSelector
    }
    
    func push(_ nodeInfo: NodeInfo) {
        
        // nothing to do
    }
    
    func pop() {
        
        // nothing to do
    }
    
    func visit(_ node: CSSStyleSheet) -> NodeInfo? {
        
            
        return FollowingSiblingsNodeInfo(visitChildren: true)
    }
    
    /// A CSSStyleRule contains a SelectorList and
    /// a style (CSSStyleDeclaration).
    func visit(_ node: CSSStyleRule) -> NodeInfo? {
            
        return FollowingSiblingsNodeInfo(visitChildren: true)
    }
    
    func visit(_ node: SelectorList) -> NodeInfo? {
        
        return FollowingSiblingsNodeInfo(visitChildren: true)
    }
    
    func visit(_ node: ComplexSelector) -> NodeInfo? {

        return FollowingSiblingsNodeInfo(visitChildren: true)
    }
    
    func visit(_ node: InvalidComplexSelector) -> NodeInfo? {
    
        return FollowingSiblingsNodeInfo(visitChildren: true)
    }
    
    func postVisit(_ node: InvalidComplexSelector) {
        // nothing to do
    }
    
    func visit(_ node: CompoundSelector) -> NodeInfo? {
            
        if let combinator = node.combinator {
            
            if combinator.combinatorType == CombinatorType.Tilde {
                
                self.followingSiblingsSelectorsTopCompoundSelector.append(node)
            }
        }
        
        return FollowingSiblingsNodeInfo(visitChildren: false)
    }
    
    func visit(_ node: InvalidCompoundSelector) -> NodeInfo? {
        
        return nil
    }
    
    func postVisit(_ node: InvalidCompoundSelector) {
        
        // nothing to do
    }
    
    func visit(_ node: SelectorCombinator) -> NodeInfo? {

        return FollowingSiblingsNodeInfo(visitChildren: true)
    }
    
    func visit(_ node: TypeSelector) -> NodeInfo? {
        
        return nil
    }
    
    func postVisit(_ node: CSSNamespaceRule) -> NodeInfo?{
        
        return nil
    }
    
    func visit(_ node: WQNamePrefix) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: UnrecognizedAtRule) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: CSSNamespaceRule) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: CSSNamespaceURI) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: CSSNamespacePrefix) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: IdentPseudoClass) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: FunctionalPseudoClass) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: PseudoElementSelector) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: ClassSelector) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: IdSelector) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: AttribSelector) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: AttribName) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: AttribMatch) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: AttribValue) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: AttribFlags) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: CSSStyleDeclaration) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: CSDeclaration) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: InvalidDeclaration) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: IgnoredSimpleBlock) -> NodeInfo? {
    
        return nil 
    }
    
    func postVisit(_ node: CSDeclaration) {
        // nothing to do
    }
    
    func visit(_ node: CSImportantDeclaration) -> NodeInfo? {
        
        return nil
    }
}
