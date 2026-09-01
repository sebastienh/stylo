//
//  Poolable.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-09-05.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

public protocol Poolable: class, Creatable {

    func returnToPool()
}
