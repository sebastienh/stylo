//
//  Log.swift
//  MacWriterCommon
//
//  Created by Sebastien Hamel on 2020-01-01.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import os

struct Log {
    struct StyloCore {
        static let all = OSLog(subsystem: "net.textually.mac.stylocore", category: "default")
    }
}
