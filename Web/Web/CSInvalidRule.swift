//
//  CSInvalidRule.swift
//  Web
//
//  Created by Sebastien hamel on 2018-12-31.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common
//
//// http://dev.w3.org/csswg/css-syntax/#at-rule
//public final class CSInvalidRule: CSRule {
//    
//    var components: [CSComponentValue]
//    
//    init(sourceStringSegment: SourceStringSegment?, components: [CSComponentValue]) {
//        self.components = components
//        super.init(sourceStringSegment: sourceStringSegment)
//    }
//    
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    //                                  MARK: CSTextNode protocol implementation
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    
//    override func cssText() -> DOMString {
//        
//        var cssTextValue = DOMString(name)
//        
//        for componentValue in components {
//            cssTextValue = cssTextValue + componentValue.cssText()
//        }
//        return cssTextValue
//    }
//    
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    //                                  MARK: CSVisitable protocol implementation
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    
//    // 1. Visit the root.
//    // 2. Traverse the left subtree.
//    // 3. Traverse the right subtree.
//    override public func accept(_ visitor: CSVisitor) -> NodeInfo {
//        
//        return visitor.visit(self)
//    }
//}
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////                                  MARK: DotStringNode protocol implementation
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//extension CSInvalidRule : DotStringNode {
//    
//    func dotString(_ nodeName: String) -> String {
//        
//        return "\(nodeName) [shape=record, label=\"CSAtRule: \(name)\"];\n"
//    }
//}
