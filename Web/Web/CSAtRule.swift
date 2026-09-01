//
//  AtRule.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-30.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

// http://dev.w3.org/csswg/css-syntax/#at-rule
public final class CSAtRule: CSRule {

    var name: String
    var prelude: [CSComponentValue]
    var blocks: [CSSimpleBlock]?
    
    var endSemiColon: Token?
    
    init(name: String, sourceStringSegment: SourceStringSegment?, prelude: [CSComponentValue], blocks: [CSSimpleBlock]? = nil) {
        self.name = name
        self.prelude = prelude
        self.blocks = blocks
        super.init(sourceStringSegment: sourceStringSegment)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSTextNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override func cssText() -> DOMString {
        
        var cssTextValue = DOMString(name)
        
        for componentValue in prelude {
            cssTextValue = cssTextValue + componentValue.cssText()
        }
        
        if let blocks = blocks {
            for block in blocks {
                cssTextValue = cssTextValue + block.cssText()
            }
        }
        
        return cssTextValue
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Visit the root.
    // 2. Traverse the left subtree.
    // 3. Traverse the right subtree.
    override public func accept(_ visitor: CSVisitor) -> NodeInfo {
        
        return visitor.visit(self)
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: DotStringNode protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

extension CSAtRule : DotStringNode {
    
    func dotString(_ nodeName: String) -> String {
        
        return "\(nodeName) [shape=record, label=\"CSAtRule: \(name)\"];\n"
    }
}



