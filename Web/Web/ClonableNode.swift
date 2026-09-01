//
//  Cloneable.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-10.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation

public protocol ClonableNode: class {
    
    associatedtype ClonableNodeType
    
    func cloneNode(_ deep: Bool) -> ClonableNodeType
    
    func cloneFields(_ copy: inout ClonableNodeType)
    
    func createInstance() -> ClonableNodeType

}
