//
//  Log.swift
//  HtmlExportPlugin
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import os

struct Log {
    struct HtmlExport {
        static let all = OSLog(subsystem: "net.textually.mac.html-export-plugin", category: "default")
    }
}
