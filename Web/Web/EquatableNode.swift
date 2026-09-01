//
//  EquatableNode.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-08.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

protocol EquatableNode: class {
    
    /// boolean isEqualNode(Node? node);
    /// see https://dom.spec.whatwg.org/#dom-node-isequalnode
    func isEqualNode(_ other: Node?) -> Bool

}
