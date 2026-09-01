//
//  CSSOMNilNodeInfo.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-02.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common

final class CSSOMNilNodeInfo : NodeInfo {
    
    var visitChildren: Bool
    
    init(visitChildren: Bool = true) {
        
        self.visitChildren = visitChildren
    }
    
}
