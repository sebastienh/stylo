
//
//  Syncable.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-10-23.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

/// This does not work
public protocol Syncable {
    
    func synced(_ lock: AnyObject, closure: () -> ())
    
    func syncedGetter<T>(_ lock: AnyObject, closure: () -> T) -> T
    
    func syncedSetter<T>(_ lock: AnyObject, newValue: T, closure: (T) -> ())
    
}

// http://stackoverflow.com/questions/24045895/what-is-the-swift-equivalent-to-objective-cs-synchronized
extension Syncable {
    
    public func synced(_ lock: AnyObject, closure: () -> ()) {
        objc_sync_enter(lock)
        defer {
            objc_sync_exit(lock)
        }
        closure()
    }
    
    public func syncedGetter<T>(_ lock: AnyObject, closure: () -> T) -> T {
        objc_sync_enter(lock)
        defer {
            objc_sync_exit(lock)
        }
        return closure()
    }
    
    public func syncedSetter<T>(_ lock: AnyObject, newValue: T, closure: (T) -> ()) {
        
        objc_sync_enter(lock)
        defer {
            objc_sync_exit(lock)
        }
        closure(newValue)
    }
    
}
