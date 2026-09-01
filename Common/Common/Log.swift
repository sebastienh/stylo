//
//  Log.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-07-24.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import os

struct Log {
    
    struct Common {
        
        static let all = OSLog(subsystem: "net.textually.common", category: "all")
        
        static let stylableString = OSLog(subsystem: "net.textually.common", category: "stylable-string")
        
        static let sourceStringChangeDecription = OSLog(subsystem: "net.textually.common", category: "string-change-description")
    }
}
