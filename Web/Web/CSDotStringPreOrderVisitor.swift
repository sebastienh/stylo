//
//  CSDotStringVisitor.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-03.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

final class CSDotStringPreOrderVisitor : CSVisitor {
    
    var parentStack: Stack<String>

    var dotString: String = ""
    var nbrNode: Int = 0
    
    init() {
        parentStack = Stack<String>()
    }
    
    func pop() {
        parentStack.pop()
    }

    func push(_ nodeInfo: NodeInfo) {
        
        parentStack.push(nodeInfo as! String)
    }
    
    func process(_ node: CSVisitable) {
        
        node.accept(self)
        dotString = "digraph stella {\n\(dotString)\n}"
    }
    
    func visitChild(_ node: DotStringNode) -> NodeInfo {
        
        let nodeName = createNode(node)
        createLink(nodeName)
        return nodeName
    }
    
    func visitRoot(_ node: DotStringNode) -> NodeInfo {
        
        return createNode(node)
    }
    
    func visit(_ node: CSStyleSheet) -> NodeInfo {
        
        return visitRoot(node)
    }
    
    func visit(_ node: CSAtRule) -> NodeInfo {
        
        return visitChild(node)
    }
    
    func visit(_ node: CSQualifiedRule) -> NodeInfo {
        
        // create prelude node
        let preludeName = createPreludeNode()
        
        for tokenValue in node.prelude {
            
            if let preservedTokenValue = tokenValue as? CSPreservedTokenComponentValue {

                let nodeName = createNode(preservedTokenValue)
                
                createLink(nodeName, toParent: preludeName)
            }
        }
        
        let qualifiedRuleNodeInfo = visitChild(node)
        
        createLink(preludeName, toParent: qualifiedRuleNodeInfo)
        
        return qualifiedRuleNodeInfo
    }
    
    func visit(_ node: CSSimpleBlock) -> NodeInfo {
        
       return visitChild(node)
    }
    
    func visit(_ node: CSDeclaration) -> NodeInfo {
        
        return visitChild(node)
    }
    
    func visit(_ node: CSPreservedTokenComponentValue) -> NodeInfo {
        
        return visitChild(node)
    }
    
    func visit(_ node: CSFunctionComponentValue) -> NodeInfo {
        
        return visitChild(node)
    }
    
    func visit(_ node: CSSimpleBlockComponentValue) -> NodeInfo {
        
        return visitChild(node)
    }
    
    func visit(_ node: CSFunction) -> NodeInfo {
        
        return visitChild(node)
    }
    
    func createLink(_ nodeName: NodeInfo) {
        
        if let top = parentStack.top {
            
            createLink(nodeName, toParent: top)
        }
    }
    
    func createLink(_ nodeName: NodeInfo, toParent parent: NodeInfo) {
        
        self.dotString = dotString + "\(parent)->\(nodeName)\n"
    }
    
    func createPreludeNode() -> NodeInfo {
        
        let nodeName = "node\(nbrNode)"
        
        nbrNode += 1
        
        self.dotString = dotString + "Prelude"
        
        return nodeName
    }
    
    func createNode(_ node: DotStringNode) -> NodeInfo {
        
        let nodeName = "node\(nbrNode)"
        
        nbrNode += 1
        
        self.dotString = dotString + node.dotString(nodeName)
        
        return nodeName
    }

}

extension String : NodeInfo {
    // nothing  to do
    
    public var visitChildren: Bool {
    
        return true
    }
}
