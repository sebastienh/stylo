//
//  NodeTreePositionIdentity.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-02-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

class NodeTreePositionIdentity: CustomStringConvertible {
    
    var description: String {
        
        return self.identity
    }
    
    let identity: String
    
    init(identity: String) {
        
        self.identity = identity
    }
    
}
