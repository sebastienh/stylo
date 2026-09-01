//
//  CSSOMInvalidatedNodesCollectorVisitor.swift
//  WriterCommon
//
//  Created by Sebastien hamel on 2016-01-14.
//  Copyright © 2016 Nebula Media. All rights reserved.
//

import Foundation
import Common
import Web

final class CSSOMInvalidatedNodesCollectorVisitor : CSSVisitor {
    
    var invalidatedNodes: [CSSOMLanguageObject]
    
    init() {
        
        invalidatedNodes = [CSSOMLanguageObject]()
    }
    
    func process(_ node: CSSVisitable) -> [CSSOMLanguageObject] {
        
        node.accept(self)
        
        return invalidatedNodes
    }
    
    func push(_ nodeInfo: NodeInfo) {
        
        // nothing to do
    }
    
    func pop() {
        
        // nothing to do
    }
    
    func visit(_ node: CSSStyleSheet) -> NodeInfo? {
        
        // nothing to
        
        return nil
    }
    
    /// A CSSStyleRule contains a SelectorList and
    /// a style (CSSStyleDeclaration).
    func visit(_ node: CSSStyleRule) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: SelectorList) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: ComplexSelector) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: CompoundSelector) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: SelectorCombinator) -> NodeInfo? {
        
        if let valid = node.sourceStringSegment?.isInvalid() , !valid{
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }
    
    func visit(_ node: TypeSelector) -> NodeInfo? {
        
        if let valid = node.sourceStringSegment?.isInvalid() , !valid{
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }
    
    func visit(_ node: WQNamePrefix) -> NodeInfo? {
        
        if let valid = node.sourceStringSegment?.isInvalid() , !valid{
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }
    
    func visit(_ node: CSSNamespaceRule) -> NodeInfo? {
        
        if let valid = node.sourceStringSegment?.isInvalid() , !valid{
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }

    func visit(_ node: CSSNamespaceURI) -> NodeInfo? {
        
        if let valid = node.sourceStringSegment?.isInvalid() , !valid{
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }
    
    func visit(_ node: CSSNamespacePrefix) -> NodeInfo? {
        
        if let valid = node.sourceStringSegment?.isInvalid() , !valid{
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }
    
    func visit(_ node: IdentPseudoClass) -> NodeInfo? {
        
        if let valid = node.sourceStringSegment?.isInvalid() , !valid{
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }
    
    
    func visit(_ node: FunctionalPseudoClass) -> NodeInfo? {
        
        if let valid = node.sourceStringSegment?.isInvalid() , !valid{
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }
    
    func visit(_ node: PseudoElementSelector) -> NodeInfo? {
        
        if let valid = node.sourceStringSegment?.isInvalid() , !valid{
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }
    
    func visit(_ node: ClassSelector) -> NodeInfo? {
        
        if let valid = node.sourceStringSegment?.isInvalid() , !valid{
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }
    
    func visit(_ node: IdSelector) -> NodeInfo? {
        
        if let valid = node.sourceStringSegment?.isInvalid() , !valid{
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }
    
    func visit(_ node: AttribSelector) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: AttribName) -> NodeInfo? {
        
        if let valid = node.sourceStringSegment?.isInvalid() , !valid{
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }
    
    func visit(_ node: AttribMatch) -> NodeInfo? {
        
        if let valid = node.sourceStringSegment?.isInvalid() , !valid{
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }
    
    func visit(_ node: AttribValue) -> NodeInfo? {
        
        if let valid = node.sourceStringSegment?.isInvalid() , !valid{
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }
    
    func visit(_ node: AttribFlags) -> NodeInfo? {
        
        if let valid = node.sourceStringSegment?.isInvalid() , !valid{
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }
    
    func visit(_ node: CSSStyleDeclaration) -> NodeInfo? {
        
        return nil
    }
    
    func visit(_ node: CSDeclaration) -> NodeInfo? {
        
        if node.containsInvalidPositionObject() {
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }
    
    func visit(_ node: CSImportantDeclaration) -> NodeInfo? {
        
        if let valid = node.sourceStringSegment?.isInvalid() , !valid{
            
            invalidatedNodes.append(node)
        }
        
        return nil
    }
}
