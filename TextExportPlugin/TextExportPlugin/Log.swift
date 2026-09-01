//
//  Log.swift
//  TextExportPlugin
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import os

struct Log {
    struct TextExport {
        static let all = OSLog(subsystem: "net.textually.mac.text-export-plugin", category: "default")
    }
}
