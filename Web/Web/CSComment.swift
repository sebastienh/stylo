//
//  CSComment.swift
//  Web
//
//  Created by Sebastien hamel on 2017-05-04.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import Common

public class CSComment: CSLanguageObject, CSSVisitable, DotStringNode {

    let comment: Token
    
    init(comment: Token) {
        
        self.comment = comment
        
        super.init(sourceStringSegment: comment.sourceStringSegment)
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: DotStringNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func dotString(_ nodeName: String) -> String {
        
        return "\(nodeName) [shape=record, label=\"CSComment\"];\n"
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func accept(_ visitor: CSSVisitor) {
        
        _ = visitor.visit(self)
    }
}
