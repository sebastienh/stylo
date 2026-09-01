//
//  RenderStyle.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-09.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Web
import Common

final class RenderStyle: TreeNode {
    
    /// Used to keep the actual rendering value 
    var actualStyle: CSSActualStyleDeclaration
    
    /// Local reference to the computed style
    let computedStyle: CSSStyleDeclaration
    
    init(computedStyle: CSSStyleDeclaration) {
        
        self.computedStyle = computedStyle
        self.actualStyle = CSSActualStyleDeclaration()
    }
    
}
