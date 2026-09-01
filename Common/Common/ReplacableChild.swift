//
//  ReplacableChild.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-07.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public protocol ReplacableChild: class {
    
    associatedtype ReplacableChildNodeType
    
    func replaceOldChildWithNewChild(_ oldChild: ReplacableChildNodeType, newChild: ReplacableChildNodeType)
    
}
