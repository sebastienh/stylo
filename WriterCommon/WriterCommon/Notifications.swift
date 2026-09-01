//
//  Notifications.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-06.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common

public protocol Notifications {
    
    var name: NSNotification.Name { get }
    
    func sendNotification(_ object: AnyObject?)
    
    func sendNotification(_ object: AnyObject?, userInfo: [AnyHashable: Any])
    
}

extension Notifications where Self: RawRepresentable, Self.RawValue == String {
    
    public var name: NSNotification.Name {
        return NSNotification.Name(rawValue: self.rawValue)
    }
    
    public func sendNotification(_ object: AnyObject? = nil) {
        
        let defaultCenter: NotificationCenter = NotificationCenter.default
        
        defaultCenter.post(name: NSNotification.Name(rawValue: §self), object: object)
    }
    
    public func sendNotification(_ object: AnyObject?, userInfo: [AnyHashable: Any]) {
        
        let defaultCenter: NotificationCenter = NotificationCenter.default
        
        defaultCenter.post(name: NSNotification.Name(rawValue: §self), object: object, userInfo: userInfo)
    }
    
}
