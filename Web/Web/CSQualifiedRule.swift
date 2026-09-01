//
//  QualifiedRule.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-30.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

// http://dev.w3.org/csswg/css-syntax/#qualified-rule
public final class CSQualifiedRule: CSRule {
    
    // TODO : make sure it could not be CSPreservedTokenComponentValue instead
    var prelude: [CSComponentValue]
    var block: CSSimpleBlock?
    
    init(sourceStringSegment: SourceStringSegment?, prelude: [CSComponentValue], block: CSSimpleBlock? = nil) {

        self.prelude = prelude
        self.block = block
        
        super.init(sourceStringSegment: sourceStringSegment)
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Visit the root.
    // 2. Traverse the left subtree.
    // 3. Traverse the right subtree.
    override public func accept(_ visitor: CSVisitor) -> NodeInfo {
        
        let nodeInfo = visitor.visit(self)
        
        visitor.push(nodeInfo)
        
        // the prelude is visited by the selector parser
        // while visiting this node in the upper call to "let nodeInfo = visitor.visit(self)"
        // BUT : in the DotStringVisitor we want to print out the prelude : 
        
        if let _ =  visitor as? CSDotStringPreOrderVisitor  {
        
            for componentValue in prelude {
            
                _ = componentValue.accept(visitor)
            }
        }
        
        _ = block?.accept(visitor)
        
        visitor.pop()
        
        return nodeInfo
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSTextNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override func cssText() -> DOMString {
        
        var cssTextValue = DOMString()
        
        for componentValue in prelude {
            cssTextValue = cssTextValue + componentValue.cssText()
        }
        
        if let unwrappedBlock = block {
            cssTextValue = cssTextValue + unwrappedBlock.cssText()
        }
        
        return cssTextValue
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: DotStringNode protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

extension CSQualifiedRule : DotStringNode {
    
    func dotString(_ nodeName: String) -> String {
        
        return "\(nodeName) [shape=record, label=\"CSQualifiedRule\"];\n"
    }
}


