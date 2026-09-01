//
//  CSSOMNodeInfo.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-19.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

final class CSSOMNodeInfo : NodeInfo {
    
    let cssomNode: CSSOMLanguageObject?
    
    let visitChildren: Bool
    
    init(_ cssomNode: CSSOMLanguageObject?, visitChildren: Bool = true) {
        
        self.cssomNode = cssomNode
        self.visitChildren = visitChildren
    }
}
