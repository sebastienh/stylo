//
//  CommonTreeOperable.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-05-29.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public protocol CommonTreeOperable: class {

    associatedtype CommonTreeNodeType
    
    func childIndexForChild(_ child: CommonTreeNodeType) -> Int?
    
    func deleteAllChildren()
}
