//
//  Log.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-07-24.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import os

struct Log {
    
    struct WriterCommon {
        
        static let all = OSLog(subsystem: "net.textually.writercommon", category: "default")
        static let textStorage = OSLog(subsystem: "net.textually.writercommon", category: "text-storage")
    }
}
