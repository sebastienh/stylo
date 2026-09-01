//
//  Observer.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-09-25.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation

public enum ObserverPriority: Int {
    
    case ui // this is the lowest
    case background
}

public protocol Observer: NSObjectProtocol {

    var priority: ObserverPriority { get }
}
//
//extension NSObject: Observer {
//    
//    public var priority: ObserverPriority {
//        return .background
//    }
//}


