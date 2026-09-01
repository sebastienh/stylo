//
//  PStyleSheet.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-01.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

public final class CSStyleSheet: CSLanguageObject, CSVisitable {
    
    let comments: [CSSToken]?
    
    var cssRules: [CSRule]
    
    init(sourceStringSegment: SourceStringSegment?, rules: [CSRule], comments: [CSSToken]?){
        self.comments = comments
        self.cssRules = rules
        super.init(sourceStringSegment: sourceStringSegment)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Visit the root.
    // 2. Traverse the left subtree.
    // 3. Traverse the right subtree.
    public func accept(_ visitor: CSVisitor) -> NodeInfo {
        
        let nodeInfo = visitor.visit(self)
        
        visitor.push(nodeInfo)
        
        for csRule in cssRules {
            _ = csRule.accept(visitor)
        }
        
        visitor.pop()
        
        return nodeInfo
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: CSTextNode protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

extension CSStyleSheet : CSTextNode {
    
    func cssText() -> DOMString {
        
        var cssTextValue = DOMString()
        
        for rule in cssRules {
            cssTextValue = cssTextValue + rule.cssText()
        }
        
        return cssTextValue
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: DotStringNode protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

extension CSStyleSheet : DotStringNode {
    
    func dotString(_ nodeName: String) -> String {
        return "\(nodeName) [shape=record, label=\"CSStyleSheet\"];\n"
    }
}









