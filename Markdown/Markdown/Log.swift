//
//  Log.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2018-07-24.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import os

struct Log {
    
    struct Markdown {
        
        static let all = OSLog(subsystem: "net.textually.markdown", category: "all")
        
    }
}
