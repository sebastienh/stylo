//
//  Logs.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-07-24.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import os

struct Log {
    
    struct Web {
        
        static let all = OSLog(subsystem: "net.textually.web", category: "default")

    }
}
