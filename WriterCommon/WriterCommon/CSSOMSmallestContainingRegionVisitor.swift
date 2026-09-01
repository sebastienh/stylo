//
//  CSSOMSmallestContainingRegionVisitor.swift
//  WriterCommon
//
//  Created by Sebastien hamel on 2016-01-14.
//  Copyright © 2016 Nebula Media. All rights reserved.
//

import Foundation
import Common
import Web

final class CSSOMSmallestContainingRegionVisitor : CSSVisitor {
    
    let startCharaterIndex: CodePointIndex
    let endCodePointIndex: CodePointIndex
    
    var smallestContainingRegionObject: CSSOMLanguageObject?
    
    init(startCharaterIndex: CodePointIndex, endCodePointIndex: CodePointIndex) {
        
        self.startCharaterIndex = startCharaterIndex
        self.endCodePointIndex = endCodePointIndex
    }
    
    func process(_ node: CSSVisitable) -> CSSOMLanguageObject? {
        
        node.accept(self)
        
        return smallestContainingRegionObject
    }
    
    func push(_ nodeInfo: NodeInfo) {
        
        // nothing to do
    }
    
    func pop() {
        
        // nothing to do
    }
    
    func visit(_ node: CSSStyleSheet) -> NodeInfo? {
        
        // by default the styleSheet is the default smallest containing region
        // it will be overiden when visiting the other nodes
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: WQNamePrefix) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: CSSNamespaceRule) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }

    func visit(_ node: CSSNamespaceURI) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: CSSNamespacePrefix) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    /// A CSSStyleRule contains a SelectorList and
    /// a style (CSSStyleDeclaration).
    func visit(_ node: CSSStyleRule) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: SelectorList) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: ComplexSelector) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: CompoundSelector) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: SelectorCombinator) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: TypeSelector) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: IdentPseudoClass) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    
    func visit(_ node: FunctionalPseudoClass) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: PseudoElementSelector) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: ClassSelector) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: IdSelector) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: AttribSelector) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: AttribName) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: AttribMatch) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: AttribValue) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: AttribFlags) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: CSSStyleDeclaration) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: CSDeclaration) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    func visit(_ node: CSImportantDeclaration) -> NodeInfo? {
        
        recordIfSmallest(node)
        
        return nil
    }
    
    fileprivate func recordIfSmallest(_ node: CSSOMLanguageObject) {
        
        assert(node.sourceStringSegment != nil, "node.sourceStringSegment is nil")
        assert(node.sourceStringSegment?.startIndex != nil, "node.sourceStringSegment.startIndex is nil")
        assert(node.sourceStringSegment?.endIndex != nil, "node.sourceStringSegment.endIndex is nil")
        
        let nodeSourceStringSegment = node.sourceStringSegment!
        
        if nodeSourceStringSegment.strictlyContainsIndexes(startCharaterIndex, endCodePointIndex) {
            
            // is it closer to the indexes than the known smallestContainingRegionObject
            // if there is one
            if let smallestContainingRegionObject = self.smallestContainingRegionObject {
                
                assert(smallestContainingRegionObject.sourceStringSegment != nil, "segment is nil.")
                
                let smallestSourceStringSegment = smallestContainingRegionObject.sourceStringSegment!
                
                if smallestSourceStringSegment.strictlyContainsSegment(nodeSourceStringSegment) {
                    
                    self.smallestContainingRegionObject = node
                }
            }
            else {
                
                self.smallestContainingRegionObject = node
            }
        }
        
    }
    
    
    
    
    
}
