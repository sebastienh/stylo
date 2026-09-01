//
//  Serializable.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-01-27.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

public protocol Serializable: class {
    
    func serialize() -> String
}
