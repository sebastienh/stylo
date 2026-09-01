//
//  WebNotification.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-11-05.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

public enum WebNotification: String {
    
    case StyleWillChangeNotification = "StyleWillChangeNotification"
    
    public func sendNotification(_ object: AnyObject?) {
        
        let defaultCenter: NotificationCenter = NotificationCenter.default
        
        defaultCenter.post(name: Notification.Name(rawValue: §self), object: object)
    }
}
