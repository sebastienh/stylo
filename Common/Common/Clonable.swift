//
//  Clonable.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-12-22.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation

public protocol Clonable {
    
    associatedtype ClonableType
    
    func clone() -> ClonableType
    
}
