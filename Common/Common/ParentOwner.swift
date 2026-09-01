//
//  ParentOwner.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-05-28.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public protocol ParentOwner: class {
    
    associatedtype ParentType
    
    var parent: ParentType? { get }
    
}
