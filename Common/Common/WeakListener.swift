//
//  WeakListener.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-09-04.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation

public struct WeakListener {
    
    // use NSObject because it implements a default Equatable
    // that impose less retriction than the Equatable protocol
    // which would impose the type to be used as a generic constraint
    // only.
    weak var observer: Observer?
    let hash: Int
    
    public init(observer: Observer) {
        self.observer = observer
        self.hash = observer.hash
    }
    
    public init(key: Int) {
        self.hash = key 
    }
}

extension WeakListener: Equatable {
    
    public static func ==(lhs: WeakListener, rhs: WeakListener) -> Bool {
        
        return lhs.hash == rhs.hash
    }
}

extension WeakListener: Hashable {
    
    public var hashValue: Int {
        return hash
    }
}
