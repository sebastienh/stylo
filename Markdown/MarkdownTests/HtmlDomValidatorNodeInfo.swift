//
//  HtmlDomValidatorNodeInfo.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-03-13.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common

final class HtmlDomValidatorNodeInfo: NodeInfo {
    
    let visitChildren: Bool
    
    init(visitChildren: Bool = true) {
        
        self.visitChildren = visitChildren
    }
}
